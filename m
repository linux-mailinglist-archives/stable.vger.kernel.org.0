Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBB744A21E
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241629AbhKIBQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:16:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242613AbhKIBNz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:13:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7071661A86;
        Tue,  9 Nov 2021 01:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419942;
        bh=svtFdkae/ZD9yRAAJPa+Y8uFXyDBZcu1Qh/8cbt7Wvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npMIMND/4Iu0sIpz/m98ubyquvZc1XNmSHxbKMCF5ERGHghHGCaPpuy0fyUPqnaee
         3C3lfKZnpc+24AFoQxsJSGNvWXitKt0E2Tm8Y3DSV5HLu3NiJbCfffpIFw/D2Qc1np
         s8posSFXAWrFd3Ohy/6IAgYvt2exdeUt9dIiB969SJGEHRv5P/jvGTjdrHvjPDo6wK
         Ls/QiOC3TfqEikbdnUFBqHonprQkNxzXUaMbYaysivmiQpEK097zo0TnF/wgcPRRBJ
         SrmP2saNenSi2VzJFRkYq3h/gLxXUI5qWb+6Qs+ralOfOEQD1uk/K0Vw9PkFhA9MrK
         19OLX1LkPJJAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dirk Bender <d.bender@phytec.de>,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/47] media: mt9p031: Fix corrupted frame after restarting stream
Date:   Mon,  8 Nov 2021 12:49:58 -0500
Message-Id: <20211108175031.1190422-14-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
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
index 715be3632b01a..eb08acf43e3a2 100644
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

