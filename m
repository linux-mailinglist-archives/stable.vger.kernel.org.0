Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBB732F0A1
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfE3EFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:05:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730048AbfE3DRj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:39 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 412A52451F;
        Thu, 30 May 2019 03:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186258;
        bh=zZww19D8w+Co0braYY4yxmxni666sq+5iu7DrNYJe+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRNIe1MjnBp7u2XPq+z1UBtIJEzit9XAgDeq2wX/U8CVA185+DDsfhDcfeEd92qeI
         OeO8psrdxidB7b5nqRIHRckJeKeUebZig9U2hqz6x+2unhjeZ63NUveCFbJdpd4gdF
         dR/nG3xEnZ0FXKQUQx+896JIv3IsGKcrLjSgRqrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Chen <justinpopo6@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 189/276] iio: adc: ti-ads7950: Fix improper use of mlock
Date:   Wed, 29 May 2019 20:05:47 -0700
Message-Id: <20190530030537.017297326@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit abbde2792999c9ad3514dd25d7f8d9a96034fe16 ]

Indio->mlock is used for protecting the different iio device modes.
It is currently not being used in this way. Replace the lock with
an internal lock specifically used for protecting the SPI transfer
buffer.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-ads7950.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ti-ads7950.c b/drivers/iio/adc/ti-ads7950.c
index a5bd5944bc660..c9cd7e5c1b614 100644
--- a/drivers/iio/adc/ti-ads7950.c
+++ b/drivers/iio/adc/ti-ads7950.c
@@ -56,6 +56,9 @@ struct ti_ads7950_state {
 	struct spi_message	ring_msg;
 	struct spi_message	scan_single_msg;
 
+	/* Lock to protect the spi xfer buffers */
+	struct mutex		slock;
+
 	struct regulator	*reg;
 	unsigned int		vref_mv;
 
@@ -277,6 +280,7 @@ static irqreturn_t ti_ads7950_trigger_handler(int irq, void *p)
 	struct ti_ads7950_state *st = iio_priv(indio_dev);
 	int ret;
 
+	mutex_lock(&st->slock);
 	ret = spi_sync(st->spi, &st->ring_msg);
 	if (ret < 0)
 		goto out;
@@ -285,6 +289,7 @@ static irqreturn_t ti_ads7950_trigger_handler(int irq, void *p)
 					   iio_get_time_ns(indio_dev));
 
 out:
+	mutex_unlock(&st->slock);
 	iio_trigger_notify_done(indio_dev->trig);
 
 	return IRQ_HANDLED;
@@ -295,7 +300,7 @@ static int ti_ads7950_scan_direct(struct iio_dev *indio_dev, unsigned int ch)
 	struct ti_ads7950_state *st = iio_priv(indio_dev);
 	int ret, cmd;
 
-	mutex_lock(&indio_dev->mlock);
+	mutex_lock(&st->slock);
 
 	cmd = TI_ADS7950_CR_WRITE | TI_ADS7950_CR_CHAN(ch) | st->settings;
 	st->single_tx = cpu_to_be16(cmd);
@@ -307,7 +312,7 @@ static int ti_ads7950_scan_direct(struct iio_dev *indio_dev, unsigned int ch)
 	ret = be16_to_cpu(st->single_rx);
 
 out:
-	mutex_unlock(&indio_dev->mlock);
+	mutex_unlock(&st->slock);
 
 	return ret;
 }
@@ -423,16 +428,19 @@ static int ti_ads7950_probe(struct spi_device *spi)
 	if (ACPI_COMPANION(&spi->dev))
 		st->vref_mv = TI_ADS7950_VA_MV_ACPI_DEFAULT;
 
+	mutex_init(&st->slock);
+
 	st->reg = devm_regulator_get(&spi->dev, "vref");
 	if (IS_ERR(st->reg)) {
 		dev_err(&spi->dev, "Failed get get regulator \"vref\"\n");
-		return PTR_ERR(st->reg);
+		ret = PTR_ERR(st->reg);
+		goto error_destroy_mutex;
 	}
 
 	ret = regulator_enable(st->reg);
 	if (ret) {
 		dev_err(&spi->dev, "Failed to enable regulator \"vref\"\n");
-		return ret;
+		goto error_destroy_mutex;
 	}
 
 	ret = iio_triggered_buffer_setup(indio_dev, NULL,
@@ -454,6 +462,8 @@ static int ti_ads7950_probe(struct spi_device *spi)
 	iio_triggered_buffer_cleanup(indio_dev);
 error_disable_reg:
 	regulator_disable(st->reg);
+error_destroy_mutex:
+	mutex_destroy(&st->slock);
 
 	return ret;
 }
@@ -466,6 +476,7 @@ static int ti_ads7950_remove(struct spi_device *spi)
 	iio_device_unregister(indio_dev);
 	iio_triggered_buffer_cleanup(indio_dev);
 	regulator_disable(st->reg);
+	mutex_destroy(&st->slock);
 
 	return 0;
 }
-- 
2.20.1



