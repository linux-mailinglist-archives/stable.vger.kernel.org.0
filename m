Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 230F3BA76F
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405823AbfIVS6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:32950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406370AbfIVS6Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:58:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4814021A4A;
        Sun, 22 Sep 2019 18:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178703;
        bh=j67NKNp1md3REwfcpHfBf9dbvu5Cj75dKsr8XcqXwBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ZCYyu++8VDE7z40WM2N6Pw3SpDGxW2ELQibLAECi4N9Vm0bHHVNZseGsU8nE20br
         /poBLjNxhY9Gdbu5hWAmQqLpXcHEvMkO+SrDXqoBd51njxoFOkjo+JeB59gdx6CyHh
         1GM14cEsfJbF3wRC6DrMHEshNSwOwCgWe/pgyuw8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Fabio Estevam <festevam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 40/89] media: i2c: ov5645: Fix power sequence
Date:   Sun, 22 Sep 2019 14:56:28 -0400
Message-Id: <20190922185717.3412-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit 092e8eb90a7dc7dd210cd4e2ea36075d0a7f96af ]

This is mostly a port of Jacopo's fix:

  commit aa4bb8b8838ffcc776a79f49a4d7476b82405349
  Author: Jacopo Mondi <jacopo@jmondi.org>
  Date:   Fri Jul 6 05:51:52 2018 -0400

  media: ov5640: Re-work MIPI startup sequence

In the OV5645 case, the changes are:

- At set_power(1) time power up MIPI Tx/Rx and set data and clock lanes in
  LP11 during 'sleep' and 'idle' with MIPI clock in non-continuous mode.
- At set_power(0) time power down MIPI Tx/Rx (in addition to the current
  power down of regulators and clock gating).
- At s_stream time enable/disable the MIPI interface output.

With this commit the sensor is able to enter LP-11 mode during power up,
as expected by some CSI-2 controllers.

Many thanks to Fabio Estevam for his help debugging this issue.

Tested-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5645.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
index 2d96c18497593..de15a13443e47 100644
--- a/drivers/media/i2c/ov5645.c
+++ b/drivers/media/i2c/ov5645.c
@@ -53,6 +53,8 @@
 #define		OV5645_CHIP_ID_HIGH_BYTE	0x56
 #define OV5645_CHIP_ID_LOW		0x300b
 #define		OV5645_CHIP_ID_LOW_BYTE		0x45
+#define OV5645_IO_MIPI_CTRL00		0x300e
+#define OV5645_PAD_OUTPUT00		0x3019
 #define OV5645_AWB_MANUAL_CONTROL	0x3406
 #define		OV5645_AWB_MANUAL_ENABLE	BIT(0)
 #define OV5645_AEC_PK_MANUAL		0x3503
@@ -63,6 +65,7 @@
 #define		OV5645_ISP_VFLIP		BIT(2)
 #define OV5645_TIMING_TC_REG21		0x3821
 #define		OV5645_SENSOR_MIRROR		BIT(1)
+#define OV5645_MIPI_CTRL00		0x4800
 #define OV5645_PRE_ISP_TEST_SETTING_1	0x503d
 #define		OV5645_TEST_PATTERN_MASK	0x3
 #define		OV5645_SET_TEST_PATTERN(x)	((x) & OV5645_TEST_PATTERN_MASK)
@@ -129,7 +132,6 @@ static const struct reg_value ov5645_global_init_setting[] = {
 	{ 0x3503, 0x07 },
 	{ 0x3002, 0x1c },
 	{ 0x3006, 0xc3 },
-	{ 0x300e, 0x45 },
 	{ 0x3017, 0x00 },
 	{ 0x3018, 0x00 },
 	{ 0x302e, 0x0b },
@@ -358,7 +360,10 @@ static const struct reg_value ov5645_global_init_setting[] = {
 	{ 0x3a1f, 0x14 },
 	{ 0x0601, 0x02 },
 	{ 0x3008, 0x42 },
-	{ 0x3008, 0x02 }
+	{ 0x3008, 0x02 },
+	{ OV5645_IO_MIPI_CTRL00, 0x40 },
+	{ OV5645_MIPI_CTRL00, 0x24 },
+	{ OV5645_PAD_OUTPUT00, 0x70 }
 };
 
 static const struct reg_value ov5645_setting_sxga[] = {
@@ -743,13 +748,9 @@ static int ov5645_s_power(struct v4l2_subdev *sd, int on)
 				goto exit;
 			}
 
-			ret = ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
-					       OV5645_SYSTEM_CTRL0_STOP);
-			if (ret < 0) {
-				ov5645_set_power_off(ov5645);
-				goto exit;
-			}
+			usleep_range(500, 1000);
 		} else {
+			ov5645_write_reg(ov5645, OV5645_IO_MIPI_CTRL00, 0x58);
 			ov5645_set_power_off(ov5645);
 		}
 	}
@@ -1069,11 +1070,20 @@ static int ov5645_s_stream(struct v4l2_subdev *subdev, int enable)
 			dev_err(ov5645->dev, "could not sync v4l2 controls\n");
 			return ret;
 		}
+
+		ret = ov5645_write_reg(ov5645, OV5645_IO_MIPI_CTRL00, 0x45);
+		if (ret < 0)
+			return ret;
+
 		ret = ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
 				       OV5645_SYSTEM_CTRL0_START);
 		if (ret < 0)
 			return ret;
 	} else {
+		ret = ov5645_write_reg(ov5645, OV5645_IO_MIPI_CTRL00, 0x40);
+		if (ret < 0)
+			return ret;
+
 		ret = ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
 				       OV5645_SYSTEM_CTRL0_STOP);
 		if (ret < 0)
-- 
2.20.1

