Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8992D6C730
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390778AbfGRDId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390769AbfGRDId (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:08:33 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2E73205F4;
        Thu, 18 Jul 2019 03:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419312;
        bh=ZIV++hQkTHoi/VL1oj9sR02db5mmE3gnYXLemXpyZeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CeHF8IlwWtSTHMb9smYHyY4AK+rbCuPw09tDflq7ffoAomA+cdfEKeB85EG+Wyj4d
         +IhfsWDc1umLSXK3OS8opOGEoji9PDpGwJ99mrPR+DfQgUJY6f4DrJOTuuBOz+eb42
         +yIPPdv75w0Yy5t8hNssNMOGKdm3BrSgOA5d+8mQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Melissa Wen <melissa.srw@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/80] staging:iio:ad7150: fix threshold mode config bit
Date:   Thu, 18 Jul 2019 12:01:01 +0900
Message-Id: <20190718030059.652676212@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



