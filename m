Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C572F53D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfE3Epf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728707AbfE3DLv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:51 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FF55244E8;
        Thu, 30 May 2019 03:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185910;
        bh=nqfYF8dUGO4hkuMbiBjfoewqvUHFBm1r8Wi5bynYi2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRH84d7Zm3kqRhSAd41DjoWPmtrDX4X7ZYHy6jIW9L63629K72OON3odCMWF+gnbk
         nEjTQHUz9J6bKKtD8wUosTJnZAi5fQhaNAKYxYvKTQC8WmZtX7VJVf6LQQ/zLWkaNu
         AoXTPoCftKTDHqWqUI2AxH1QZFl2OunY2Y87UI4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Chen <justinpopo6@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 243/405] iio: adc: ti-ads7950: Fix improper use of mlock
Date:   Wed, 29 May 2019 20:04:01 -0700
Message-Id: <20190530030553.280656819@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
index 0ad63592cc3c9..1e47bef72bb79 100644
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
 
@@ -268,6 +271,7 @@ static irqreturn_t ti_ads7950_trigger_handler(int irq, void *p)
 	struct ti_ads7950_state *st = iio_priv(indio_dev);
 	int ret;
 
+	mutex_lock(&st->slock);
 	ret = spi_sync(st->spi, &st->ring_msg);
 	if (ret < 0)
 		goto out;
@@ -276,6 +280,7 @@ static irqreturn_t ti_ads7950_trigger_handler(int irq, void *p)
 					   iio_get_time_ns(indio_dev));
 
 out:
+	mutex_unlock(&st->slock);
 	iio_trigger_notify_done(indio_dev->trig);
 
 	return IRQ_HANDLED;
@@ -286,7 +291,7 @@ static int ti_ads7950_scan_direct(struct iio_dev *indio_dev, unsigned int ch)
 	struct ti_ads7950_state *st = iio_priv(indio_dev);
 	int ret, cmd;
 
-	mutex_lock(&indio_dev->mlock);
+	mutex_lock(&st->slock);
 
 	cmd = TI_ADS7950_CR_WRITE | TI_ADS7950_CR_CHAN(ch) | st->settings;
 	st->single_tx = cmd;
@@ -298,7 +303,7 @@ static int ti_ads7950_scan_direct(struct iio_dev *indio_dev, unsigned int ch)
 	ret = st->single_rx;
 
 out:
-	mutex_unlock(&indio_dev->mlock);
+	mutex_unlock(&st->slock);
 
 	return ret;
 }
@@ -432,16 +437,19 @@ static int ti_ads7950_probe(struct spi_device *spi)
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
@@ -463,6 +471,8 @@ static int ti_ads7950_probe(struct spi_device *spi)
 	iio_triggered_buffer_cleanup(indio_dev);
 error_disable_reg:
 	regulator_disable(st->reg);
+error_destroy_mutex:
+	mutex_destroy(&st->slock);
 
 	return ret;
 }
@@ -475,6 +485,7 @@ static int ti_ads7950_remove(struct spi_device *spi)
 	iio_device_unregister(indio_dev);
 	iio_triggered_buffer_cleanup(indio_dev);
 	regulator_disable(st->reg);
+	mutex_destroy(&st->slock);
 
 	return 0;
 }
-- 
2.20.1



