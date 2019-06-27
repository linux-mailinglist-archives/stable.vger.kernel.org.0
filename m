Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C4E577AF
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfF0Aq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:46:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727150AbfF0Ajl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:39:41 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ADD621852;
        Thu, 27 Jun 2019 00:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595980;
        bh=ASAyQwDJn9ijxd0J2ft20g97IVewi6vMKx3OIQ4Trrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4bufO8dfzpP3oMeFpCNTLdtc737GcqYMpef47nPbHC5c8Y7BDk7IahaQ5qyHu9Qn
         g3sonQuMw0M8jE280GId1/mtahzXFhG7PlEMhjgFHYiry57xgE4h5crxxPQ1foeZ2I
         6hziOtDe/+Ss6ncZz08LYMKncKQc4F9Cz9SRv4YY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Melissa Wen <melissa.srw@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.14 04/35] staging:iio:ad7150: fix threshold mode config bit
Date:   Wed, 26 Jun 2019 20:38:52 -0400
Message-Id: <20190627003925.21330-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003925.21330-1-sashal@kernel.org>
References: <20190627003925.21330-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Melissa Wen <melissa.srw@gmail.com>

[ Upstream commit df4d737ee4d7205aaa6275158aeebff87fd14488 ]

According to the AD7150 configuration register description, bit 7 assumes
value 1 when the threshold mode is fixed and 0 when it is adaptive,
however, the operation that identifies this mode was considering the
opposite values.

This patch renames the boolean variable to describe it correctly and
properly replaces it in the places where it is used.

Fixes: 531efd6aa0991 ("staging:iio:adc:ad7150: chan_spec conv + i2c_smbus commands + drop unused poweroff timeout control.")
Signed-off-by: Melissa Wen <melissa.srw@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/cdc/ad7150.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/iio/cdc/ad7150.c b/drivers/staging/iio/cdc/ad7150.c
index a6f249e9c1e1..4d218d554878 100644
--- a/drivers/staging/iio/cdc/ad7150.c
+++ b/drivers/staging/iio/cdc/ad7150.c
@@ -6,6 +6,7 @@
  * Licensed under the GPL-2 or later.
  */
 
+#include <linux/bitfield.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -129,7 +130,7 @@ static int ad7150_read_event_config(struct iio_dev *indio_dev,
 {
 	int ret;
 	u8 threshtype;
-	bool adaptive;
+	bool thrfixed;
 	struct ad7150_chip_info *chip = iio_priv(indio_dev);
 
 	ret = i2c_smbus_read_byte_data(chip->client, AD7150_CFG);
@@ -137,21 +138,23 @@ static int ad7150_read_event_config(struct iio_dev *indio_dev,
 		return ret;
 
 	threshtype = (ret >> 5) & 0x03;
-	adaptive = !!(ret & 0x80);
+
+	/*check if threshold mode is fixed or adaptive*/
+	thrfixed = FIELD_GET(AD7150_CFG_FIX, ret);
 
 	switch (type) {
 	case IIO_EV_TYPE_MAG_ADAPTIVE:
 		if (dir == IIO_EV_DIR_RISING)
-			return adaptive && (threshtype == 0x1);
-		return adaptive && (threshtype == 0x0);
+			return !thrfixed && (threshtype == 0x1);
+		return !thrfixed && (threshtype == 0x0);
 	case IIO_EV_TYPE_THRESH_ADAPTIVE:
 		if (dir == IIO_EV_DIR_RISING)
-			return adaptive && (threshtype == 0x3);
-		return adaptive && (threshtype == 0x2);
+			return !thrfixed && (threshtype == 0x3);
+		return !thrfixed && (threshtype == 0x2);
 	case IIO_EV_TYPE_THRESH:
 		if (dir == IIO_EV_DIR_RISING)
-			return !adaptive && (threshtype == 0x1);
-		return !adaptive && (threshtype == 0x0);
+			return thrfixed && (threshtype == 0x1);
+		return thrfixed && (threshtype == 0x0);
 	default:
 		break;
 	}
-- 
2.20.1

