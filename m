Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 880D32F0A9
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfE3EGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:06:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731184AbfE3DRi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:38 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC746246F8;
        Thu, 30 May 2019 03:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186256;
        bh=hP7Pn2TFsJ+M9ZcoamJ6klxsTa95U9lo4RWpMbOEv6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xX9JTsT2WMEsvKQKP+7+t5Rwii37JyfVjPD8dOnQPJKSDG6eKGbFdPwOwF7rlOHJH
         V1HQARbtHQxdFbFa3dcl217kNPbmV26lzN5EEcth0YjfVrBISLGaSMJ0GoSQlB4w7g
         4WRs9nCUG+WG64DwV1yw9+LgTR4NcDhI2AFro32M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Alexandru Ardelean <Alexandru.Ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 186/276] iio: ad_sigma_delta: Properly handle SPI bus locking vs CS assertion
Date:   Wed, 29 May 2019 20:05:44 -0700
Message-Id: <20190530030536.859176700@linuxfoundation.org>
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
index ae2a5097f4493..25af4c76b57fe 100644
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
@@ -218,6 +218,7 @@ static int ad_sd_calibrate(struct ad_sigma_delta *sigma_delta,
 
 	spi_bus_lock(sigma_delta->spi->master);
 	sigma_delta->bus_locked = true;
+	sigma_delta->keep_cs_asserted = true;
 	reinit_completion(&sigma_delta->completion);
 
 	ret = ad_sigma_delta_set_mode(sigma_delta, mode);
@@ -235,9 +236,10 @@ static int ad_sd_calibrate(struct ad_sigma_delta *sigma_delta,
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
@@ -289,6 +291,7 @@ int ad_sigma_delta_single_conversion(struct iio_dev *indio_dev,
 
 	spi_bus_lock(sigma_delta->spi->master);
 	sigma_delta->bus_locked = true;
+	sigma_delta->keep_cs_asserted = true;
 	reinit_completion(&sigma_delta->completion);
 
 	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_SINGLE);
@@ -298,9 +301,6 @@ int ad_sigma_delta_single_conversion(struct iio_dev *indio_dev,
 	ret = wait_for_completion_interruptible_timeout(
 			&sigma_delta->completion, HZ);
 
-	sigma_delta->bus_locked = false;
-	spi_bus_unlock(sigma_delta->spi->master);
-
 	if (ret == 0)
 		ret = -EIO;
 	if (ret < 0)
@@ -316,7 +316,10 @@ int ad_sigma_delta_single_conversion(struct iio_dev *indio_dev,
 		sigma_delta->irq_dis = true;
 	}
 
+	sigma_delta->keep_cs_asserted = false;
 	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_IDLE);
+	sigma_delta->bus_locked = false;
+	spi_bus_unlock(sigma_delta->spi->master);
 	mutex_unlock(&indio_dev->mlock);
 
 	if (ret)
@@ -353,6 +356,8 @@ static int ad_sd_buffer_postenable(struct iio_dev *indio_dev)
 
 	spi_bus_lock(sigma_delta->spi->master);
 	sigma_delta->bus_locked = true;
+	sigma_delta->keep_cs_asserted = true;
+
 	ret = ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_CONTINUOUS);
 	if (ret)
 		goto err_unlock;
@@ -381,6 +386,7 @@ static int ad_sd_buffer_postdisable(struct iio_dev *indio_dev)
 		sigma_delta->irq_dis = true;
 	}
 
+	sigma_delta->keep_cs_asserted = false;
 	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_IDLE);
 
 	sigma_delta->bus_locked = false;
diff --git a/include/linux/iio/adc/ad_sigma_delta.h b/include/linux/iio/adc/ad_sigma_delta.h
index 730ead1a46df6..57c122ae54523 100644
--- a/include/linux/iio/adc/ad_sigma_delta.h
+++ b/include/linux/iio/adc/ad_sigma_delta.h
@@ -66,6 +66,7 @@ struct ad_sigma_delta {
 	bool			irq_dis;
 
 	bool			bus_locked;
+	bool			keep_cs_asserted;
 
 	uint8_t			comm;
 
-- 
2.20.1



