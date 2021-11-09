Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570AB44A332
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242787AbhKIB0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:26:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241852AbhKIBVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:21:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED0FD61B27;
        Tue,  9 Nov 2021 01:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420107;
        bh=vztLzOr4nWOxS4kqpPZSFPvpeLB5f0Thi1CD+HofyI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWd4m0LJZ8dacykGHxoxHKoioG2TQfBmzllZuvIqX6Z1HCPMDTa5+7nIiM7mD8EOg
         OTZ/N1waES02klIw1eBUd+RUGt4LEOA31OeXZDokBFT0TKBGiNFGAwkBMHrmoMFDtg
         U00KVt8kWfbJpGypENrZpqVMPt0/OOGLiuIedrJS/qDrXedVpt/aA3vez7UgKWzHYo
         M3yYmGzkzw/bK++Ce9TEGmOqI4Fj//e83LS3Gqsjb10XvnrY1Zzk+TOXyuklwj6XCg
         h54JxoUyvohl+Pm6e66DyOOHYL/+mWEVNvTlKOMTNc3fTthcPRHWdp053Y2pP3+x/N
         xCePNdIUz1NKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dirk Bender <d.bender@phytec.de>,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/33] media: mt9p031: Fix corrupted frame after restarting stream
Date:   Mon,  8 Nov 2021 20:07:44 -0500
Message-Id: <20211109010807.1191567-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010807.1191567-1-sashal@kernel.org>
References: <20211109010807.1191567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dirk Bender <d.bender@phytec.de>

[ Upstream commit 0961ba6dd211a4a52d1dd4c2d59be60ac2dc08c7 ]

To prevent corrupted frames after starting and stopping the sensor its
datasheet specifies a specific pause sequence to follow:

Stopping:
	Set Pause_Restart Bit -> Set Restart Bit -> Set Chip_Enable Off

Restarting:
	Set Chip_Enable On -> Clear Pause_Restart Bit

The Restart Bit is cleared automatically and must not be cleared
manually as this would cause undefined behavior.

Signed-off-by: Dirk Bender <d.bender@phytec.de>
Signed-off-by: Stefan Riedmueller <s.riedmueller@phytec.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/mt9p031.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 237737fec09c1..e6159faff45af 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -81,7 +81,9 @@
 #define		MT9P031_PIXEL_CLOCK_INVERT		(1 << 15)
 #define		MT9P031_PIXEL_CLOCK_SHIFT(n)		((n) << 8)
 #define		MT9P031_PIXEL_CLOCK_DIVIDE(n)		((n) << 0)
-#define MT9P031_FRAME_RESTART				0x0b
+#define MT9P031_RESTART					0x0b
+#define		MT9P031_FRAME_PAUSE_RESTART		(1 << 1)
+#define		MT9P031_FRAME_RESTART			(1 << 0)
 #define MT9P031_SHUTTER_DELAY				0x0c
 #define MT9P031_RST					0x0d
 #define		MT9P031_RST_ENABLE			1
@@ -448,9 +450,23 @@ static int mt9p031_set_params(struct mt9p031 *mt9p031)
 static int mt9p031_s_stream(struct v4l2_subdev *subdev, int enable)
 {
 	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	int val;
 	int ret;
 
 	if (!enable) {
+		/* enable pause restart */
+		val = MT9P031_FRAME_PAUSE_RESTART;
+		ret = mt9p031_write(client, MT9P031_RESTART, val);
+		if (ret < 0)
+			return ret;
+
+		/* enable restart + keep pause restart set */
+		val |= MT9P031_FRAME_RESTART;
+		ret = mt9p031_write(client, MT9P031_RESTART, val);
+		if (ret < 0)
+			return ret;
+
 		/* Stop sensor readout */
 		ret = mt9p031_set_output_control(mt9p031,
 						 MT9P031_OUTPUT_CONTROL_CEN, 0);
@@ -470,6 +486,16 @@ static int mt9p031_s_stream(struct v4l2_subdev *subdev, int enable)
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * - clear pause restart
+	 * - don't clear restart as clearing restart manually can cause
+	 *   undefined behavior
+	 */
+	val = MT9P031_FRAME_RESTART;
+	ret = mt9p031_write(client, MT9P031_RESTART, val);
+	if (ret < 0)
+		return ret;
+
 	return mt9p031_pll_enable(mt9p031);
 }
 
-- 
2.33.0

