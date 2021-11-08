Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760CA44A144
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237809AbhKIBJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:09:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238752AbhKIBHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:07:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C66C6124D;
        Tue,  9 Nov 2021 01:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419773;
        bh=XYUZB8pR/teBlpBJrwe+Ygcg07nPnBAF3eRFhC0HolM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOix3Sje6TJwKy4KNYbQFELlsU0mvAE0Ni3JmUMCpxr7h4V/HGStEAbMYiZ/plDIV
         uA3r19ymfOIiIix1It43wDQLjnNkYphBozb/YbgHKWLrTX2yr3Xz20VmmVj5Df5iRr
         6i8X9QGJAw8wyY7MhSSdUByud3YCTXlfN+y4aI0ivdmYJbtgkrHDcYqECeK7QWDYdg
         n5Xabi/+0nB5bXvsZ9bWsCG8DfDhYzFGbj5gg/PgvUlHzi6f18A+VM0wlkkB38oxQe
         HdHCEDOLuvK1fa0JK+hgGC+RHICqRJLdSt/R0P99mEK1IJ3BAlA+BtmruLm3tatjGg
         YcmOj0IjPm7xQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dirk Bender <d.bender@phytec.de>,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 035/138] media: mt9p031: Fix corrupted frame after restarting stream
Date:   Mon,  8 Nov 2021 12:45:01 -0500
Message-Id: <20211108174644.1187889-35-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
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
index 6eb88ef997836..3ae1b28c8351b 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -78,7 +78,9 @@
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
@@ -444,9 +446,23 @@ static int mt9p031_set_params(struct mt9p031 *mt9p031)
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
@@ -466,6 +482,16 @@ static int mt9p031_s_stream(struct v4l2_subdev *subdev, int enable)
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

