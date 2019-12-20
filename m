Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09DB9127D7D
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbfLTOen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:34:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:38798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbfLTOem (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:34:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36BB92467F;
        Fri, 20 Dec 2019 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852482;
        bh=nrf6JZB/QVnxN+WIXg+VNkA1Co1/9r7l+7ZvZLKSLlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZdjRrziWG4+z2PDUknEOy1CbIJaUuG16gJeQYvCNQLCUW0PmQ0655MThU3t2mVgO
         HVDLC8/YiuLzom+CEr9/tlfGZdyhF5XkhsLLOvWjAPJBGoQhPE5NpzWYJxegEwZKeA
         iiQYzYA5PYty7v12BUjDleCWfwIJAvabF7Y0ostM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/34] iio: adc: max9611: Fix too short conversion time delay
Date:   Fri, 20 Dec 2019 09:34:05 -0500
Message-Id: <20191220143433.9922-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220143433.9922-1-sashal@kernel.org>
References: <20191220143433.9922-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 9fd229c478fbf77c41c8528aa757ef14210365f6 ]

As of commit b9ddd5091160793e ("iio: adc: max9611: Fix temperature
reading in probe"), max9611 initialization sometimes fails on the
Salvator-X(S) development board with:

    max9611 4-007f: Invalid value received from ADC 0x8000: aborting
    max9611: probe of 4-007f failed with error -5

The max9611 driver tests communications with the chip by reading the die
temperature during the probe function, which returns an invalid value.

According to the datasheet, the typical ADC conversion time is 2 ms, but
no minimum or maximum values are provided.  Maxim Technical Support
confirmed this was tested with temperature Ta=25 degreeC, and promised
to inform me if a maximum/minimum value is available (they didn't get
back to me, so I assume it is not).

However, the driver assumes a 1 ms conversion time.  Usually the
usleep_range() call returns after more than 1.8 ms, hence it succeeds.
When it returns earlier, the data register may be read too early, and
the previous measurement value will be returned.  After boot, this is
the temperature POR (power-on reset) value, causing the failure above.

Fix this by increasing the delay from 1000-2000 µs to 3000-3300 µs.

Note that this issue has always been present, but it was exposed by the
aformentioned commit.

Fixes: 69780a3bbc0b1e7e ("iio: adc: Add Maxim max9611 ADC driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max9611.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/adc/max9611.c b/drivers/iio/adc/max9611.c
index 0884435eec68d..9f1a5ef0b444c 100644
--- a/drivers/iio/adc/max9611.c
+++ b/drivers/iio/adc/max9611.c
@@ -92,6 +92,12 @@
 #define MAX9611_TEMP_SCALE_NUM		1000000
 #define MAX9611_TEMP_SCALE_DIV		2083
 
+/*
+ * Conversion time is 2 ms (typically) at Ta=25 degreeC
+ * No maximum value is known, so play it safe.
+ */
+#define MAX9611_CONV_TIME_US_RANGE	3000, 3300
+
 struct max9611_dev {
 	struct device *dev;
 	struct i2c_client *i2c_client;
@@ -239,11 +245,9 @@ static int max9611_read_single(struct max9611_dev *max9611,
 		return ret;
 	}
 
-	/*
-	 * need a delay here to make register configuration
-	 * stabilize. 1 msec at least, from empirical testing.
-	 */
-	usleep_range(1000, 2000);
+	/* need a delay here to make register configuration stabilize. */
+
+	usleep_range(MAX9611_CONV_TIME_US_RANGE);
 
 	ret = i2c_smbus_read_word_swapped(max9611->i2c_client, reg_addr);
 	if (ret < 0) {
@@ -510,7 +514,7 @@ static int max9611_init(struct max9611_dev *max9611)
 			MAX9611_REG_CTRL2, 0);
 		return ret;
 	}
-	usleep_range(1000, 2000);
+	usleep_range(MAX9611_CONV_TIME_US_RANGE);
 
 	return 0;
 }
-- 
2.20.1

