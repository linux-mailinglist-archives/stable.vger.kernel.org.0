Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFC93A89B
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388221AbfFIRCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388218AbfFIRCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:02:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FB63206DF;
        Sun,  9 Jun 2019 17:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099735;
        bh=IvgwJ6XGSDbU3rqlReAi6HLKslIfUouTVN+aS7Y6QcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEnzDim+OHn7maHn/8//98NsdrTySOuee17tyF4A7aPlWiYg85vPJtTR81PlrWDM8
         gT1ufdSlulxfzlq9EJxX+nRyOummzlqsk8jttYqHtoVGy4xQ8xKMGNEbjD1nW+i4Sv
         twU8/urS6EZpnDRHtoAW2+8s5/2GwWP0EEjqEMHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Alexandru Ardelean <Alexandru.Ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 148/241] iio: ad_sigma_delta: Properly handle SPI bus locking vs CS assertion
Date:   Sun,  9 Jun 2019 18:41:30 +0200
Message-Id: <20190609164152.050412849@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit df1d80aee963480c5c2938c64ec0ac3e4a0df2e0 ]

For devices from the SigmaDelta family we need to keep CS low when doing a
conversion, since the device will use the MISO line as a interrupt to
indicate that the conversion is complete.

This is why the driver locks the SPI bus and when the SPI bus is locked
keeps as long as a conversion is going on. The current implementation gets
one small detail wrong though. CS is only de-asserted after the SPI bus is
unlocked. This means it is possible for a different SPI device on the same
bus to send a message which would be wrongfully be addressed to the
SigmaDelta device as well. Make sure that the last SPI transfer that is
done while holding the SPI bus lock de-asserts the CS signal.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Alexandru Ardelean <Alexandru.Ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad_sigma_delta.c       | 16 +++++++++++-----
 include/linux/iio/adc/ad_sigma_delta.h |  1 +
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/adc/ad_sigma_delta.c b/drivers/iio/adc/ad_sigma_delta.c
index a1d072ecb7171..30f200ad6b978 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -62,7 +62,7 @@ int ad_sd_write_reg(struct ad_sigma_delta *sigma_delta, unsigned int reg,
 	struct spi_transfer t = {
 		.tx_buf		= data,
 		.len		= size + 1,
-		.cs_change	= sigma_delta->bus_locked,
+		.cs_change	= sigma_delta->keep_cs_asserted,
 	};
 	struct spi_message m;
 	int ret;
@@ -217,6 +217,7 @@ static int ad_sd_calibrate(struct ad_sigma_delta *sigma_delta,
 
 	spi_bus_lock(sigma_delta->spi->master);
 	sigma_delta->bus_locked = true;
+	sigma_delta->keep_cs_asserted = true;
 	reinit_completion(&sigma_delta->completion);
 
 	ret = ad_sigma_delta_set_mode(sigma_delta, mode);
@@ -234,9 +235,10 @@ static int ad_sd_calibrate(struct ad_sigma_delta *sigma_delta,
 		ret = 0;
 	}
 out:
+	sigma_delta->keep_cs_asserted = false;
+	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_IDLE);
 	sigma_delta->bus_locked = false;
 	spi_bus_unlock(sigma_delta->spi->master);
-	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_IDLE);
 
 	return ret;
 }
@@ -288,6 +290,7 @@ int ad_sigma_delta_single_conversion(struct iio_dev *indio_dev,
 
 	spi_bus_lock(sigma_delta->spi->master);
 	sigma_delta->bus_locked = true;
+	sigma_delta->keep_cs_asserted = true;
 	reinit_completion(&sigma_delta->completion);
 
 	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_SINGLE);
@@ -297,9 +300,6 @@ int ad_sigma_delta_single_conversion(struct iio_dev *indio_dev,
 	ret = wait_for_completion_interruptible_timeout(
 			&sigma_delta->completion, HZ);
 
-	sigma_delta->bus_locked = false;
-	spi_bus_unlock(sigma_delta->spi->master);
-
 	if (ret == 0)
 		ret = -EIO;
 	if (ret < 0)
@@ -315,7 +315,10 @@ int ad_sigma_delta_single_conversion(struct iio_dev *indio_dev,
 		sigma_delta->irq_dis = true;
 	}
 
+	sigma_delta->keep_cs_asserted = false;
 	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_IDLE);
+	sigma_delta->bus_locked = false;
+	spi_bus_unlock(sigma_delta->spi->master);
 	mutex_unlock(&indio_dev->mlock);
 
 	if (ret)
@@ -352,6 +355,8 @@ static int ad_sd_buffer_postenable(struct iio_dev *indio_dev)
 
 	spi_bus_lock(sigma_delta->spi->master);
 	sigma_delta->bus_locked = true;
+	sigma_delta->keep_cs_asserted = true;
+
 	ret = ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_CONTINUOUS);
 	if (ret)
 		goto err_unlock;
@@ -380,6 +385,7 @@ static int ad_sd_buffer_postdisable(struct iio_dev *indio_dev)
 		sigma_delta->irq_dis = true;
 	}
 
+	sigma_delta->keep_cs_asserted = false;
 	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_IDLE);
 
 	sigma_delta->bus_locked = false;
diff --git a/include/linux/iio/adc/ad_sigma_delta.h b/include/linux/iio/adc/ad_sigma_delta.h
index 6cc48ac55fd2a..40b14736c73de 100644
--- a/include/linux/iio/adc/ad_sigma_delta.h
+++ b/include/linux/iio/adc/ad_sigma_delta.h
@@ -66,6 +66,7 @@ struct ad_sigma_delta {
 	bool			irq_dis;
 
 	bool			bus_locked;
+	bool			keep_cs_asserted;
 
 	uint8_t			comm;
 
-- 
2.20.1



