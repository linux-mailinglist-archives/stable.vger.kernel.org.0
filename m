Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0FC29B6DA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368749AbgJ0P1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794647AbgJ0PYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:24:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A2D22064B;
        Tue, 27 Oct 2020 15:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812241;
        bh=WsO/3xgdooEX+IcSNZnLCeDHoNnU47gv7/UoTyrRZSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Q/OqqvVdjxfqJ9OflUx3STf3ql/bU5URqNWPRL0pNrrq18YRNRwvNA0GPj+BHY7q
         ofbhDwJ4Tfu3CCwuUPpqIIwP8qE67XEgtSgi3Cy/dZPocLaWAq/8yMc0kCwRAInxXS
         jZPX2x+Bjcj1wSjKbGp8xcCPnbbIFhSv0liEH7P8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 139/757] media: i2c: ov5640: Enable data pins on poweron for DVP mode
Date:   Tue, 27 Oct 2020 14:46:29 +0100
Message-Id: <20201027135457.127398077@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 576f5d4ba8f672953513280510abf9a736b015cc ]

During testing this sensor on iW-RainboW-G21D-Qseven platform in 8-bit DVP
mode with rcar-vin bridge noticed the capture worked fine for the first run
(with yavta), but for subsequent runs the bridge driver waited for the
frame to be captured. Debugging further noticed the data lines were
enabled/disabled in stream on/off callback and dumping the register
contents 0x3017/0x3018 in ov5640_set_stream_dvp() reported the correct
values, but yet frame capturing failed.

To get around this issue data lines are enabled in s_power callback.
(Also the sensor remains in power down mode if not streaming so power
consumption shouldn't be affected)

Fixes: f22996db44e2d ("media: ov5640: add support of DVP parallel interface")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Tested-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 73 +++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 33 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 90db5443c4248..3a4268aa5f023 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -276,8 +276,7 @@ static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
 /* YUV422 UYVY VGA@30fps */
 static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
 	{0x3103, 0x11, 0, 0}, {0x3008, 0x82, 0, 5}, {0x3008, 0x42, 0, 0},
-	{0x3103, 0x03, 0, 0}, {0x3017, 0x00, 0, 0}, {0x3018, 0x00, 0, 0},
-	{0x3630, 0x36, 0, 0},
+	{0x3103, 0x03, 0, 0}, {0x3630, 0x36, 0, 0},
 	{0x3631, 0x0e, 0, 0}, {0x3632, 0xe2, 0, 0}, {0x3633, 0x12, 0, 0},
 	{0x3621, 0xe0, 0, 0}, {0x3704, 0xa0, 0, 0}, {0x3703, 0x5a, 0, 0},
 	{0x3715, 0x78, 0, 0}, {0x3717, 0x01, 0, 0}, {0x370b, 0x60, 0, 0},
@@ -1283,33 +1282,6 @@ static int ov5640_set_stream_dvp(struct ov5640_dev *sensor, bool on)
 	if (ret)
 		return ret;
 
-	/*
-	 * enable VSYNC/HREF/PCLK DVP control lines
-	 * & D[9:6] DVP data lines
-	 *
-	 * PAD OUTPUT ENABLE 01
-	 * - 6:		VSYNC output enable
-	 * - 5:		HREF output enable
-	 * - 4:		PCLK output enable
-	 * - [3:0]:	D[9:6] output enable
-	 */
-	ret = ov5640_write_reg(sensor,
-			       OV5640_REG_PAD_OUTPUT_ENABLE01,
-			       on ? 0x7f : 0);
-	if (ret)
-		return ret;
-
-	/*
-	 * enable D[5:0] DVP data lines
-	 *
-	 * PAD OUTPUT ENABLE 02
-	 * - [7:2]:	D[5:0] output enable
-	 */
-	ret = ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT_ENABLE02,
-			       on ? 0xfc : 0);
-	if (ret)
-		return ret;
-
 	return ov5640_write_reg(sensor, OV5640_REG_SYS_CTRL0, on ?
 				OV5640_REG_SYS_CTRL0_SW_PWUP :
 				OV5640_REG_SYS_CTRL0_SW_PWDN);
@@ -2069,6 +2041,40 @@ static int ov5640_set_power_mipi(struct ov5640_dev *sensor, bool on)
 	return 0;
 }
 
+static int ov5640_set_power_dvp(struct ov5640_dev *sensor, bool on)
+{
+	int ret;
+
+	if (!on) {
+		/* Reset settings to their default values. */
+		ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT_ENABLE01, 0x00);
+		ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT_ENABLE02, 0x00);
+		return 0;
+	}
+
+	/*
+	 * enable VSYNC/HREF/PCLK DVP control lines
+	 * & D[9:6] DVP data lines
+	 *
+	 * PAD OUTPUT ENABLE 01
+	 * - 6:		VSYNC output enable
+	 * - 5:		HREF output enable
+	 * - 4:		PCLK output enable
+	 * - [3:0]:	D[9:6] output enable
+	 */
+	ret = ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT_ENABLE01, 0x7f);
+	if (ret)
+		return ret;
+
+	/*
+	 * enable D[5:0] DVP data lines
+	 *
+	 * PAD OUTPUT ENABLE 02
+	 * - [7:2]:	D[5:0] output enable
+	 */
+	return ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT_ENABLE02, 0xfc);
+}
+
 static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
 {
 	int ret = 0;
@@ -2083,11 +2089,12 @@ static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
 			goto power_off;
 	}
 
-	if (sensor->ep.bus_type == V4L2_MBUS_CSI2_DPHY) {
+	if (sensor->ep.bus_type == V4L2_MBUS_CSI2_DPHY)
 		ret = ov5640_set_power_mipi(sensor, on);
-		if (ret)
-			goto power_off;
-	}
+	else
+		ret = ov5640_set_power_dvp(sensor, on);
+	if (ret)
+		goto power_off;
 
 	if (!on)
 		ov5640_set_power_off(sensor);
-- 
2.25.1



