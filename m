Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF4E2E3CB9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437608AbgL1OFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:05:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:39626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437603AbgL1OFU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:05:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D37A9206D4;
        Mon, 28 Dec 2020 14:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164279;
        bh=8kdiTmAs+/MqIjQzw6RgGMxwUpnXUF5q/Lslf2MH8JE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DXCLR/SvYZXnyL4uZxZlbdADkHf6GMj2BFDwbpH9BiViekbmgSfXi4LuCd5ylLNwv
         CJJGnn+WypMw5C5Kv4iMqR+Afkau2Mbph+L9InZ88rfM4a73rFGwbNgB34KgW8Yrfc
         Owq334vlTkKS9QT7Oa2cjwBXc8YtFDMBwpHfssxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugues Fruchet <hugues.fruchet@st.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/717] media: ov5640: fix support of BT656 bus mode
Date:   Mon, 28 Dec 2020 13:42:03 +0100
Message-Id: <20201228125026.937508218@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugues Fruchet <hugues.fruchet@st.com>

[ Upstream commit 68579b32e786f9680e7c6b6c7d17e26943bb02b3 ]

Fix PCLK polarity not being taken into account.
Add comments about BT656 register control.
Remove useless ov5640_set_stream_bt656() function.
Refine comments about MIPI IO register control.

Fixes: 4039b03720f7 ("media: i2c: ov5640: Add support for BT656 mode")
Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 82 +++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 37 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 8d0254d0e5ea7..8f0812e859012 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1216,20 +1216,6 @@ static int ov5640_set_autogain(struct ov5640_dev *sensor, bool on)
 			      BIT(1), on ? 0 : BIT(1));
 }
 
-static int ov5640_set_stream_bt656(struct ov5640_dev *sensor, bool on)
-{
-	int ret;
-
-	ret = ov5640_write_reg(sensor, OV5640_REG_CCIR656_CTRL00,
-			       on ? 0x1 : 0x00);
-	if (ret)
-		return ret;
-
-	return ov5640_write_reg(sensor, OV5640_REG_SYS_CTRL0, on ?
-				OV5640_REG_SYS_CTRL0_SW_PWUP :
-				OV5640_REG_SYS_CTRL0_SW_PWDN);
-}
-
 static int ov5640_set_stream_dvp(struct ov5640_dev *sensor, bool on)
 {
 	return ov5640_write_reg(sensor, OV5640_REG_SYS_CTRL0, on ?
@@ -1994,13 +1980,13 @@ static int ov5640_set_power_mipi(struct ov5640_dev *sensor, bool on)
 static int ov5640_set_power_dvp(struct ov5640_dev *sensor, bool on)
 {
 	unsigned int flags = sensor->ep.bus.parallel.flags;
-	u8 pclk_pol = 0;
-	u8 hsync_pol = 0;
-	u8 vsync_pol = 0;
+	bool bt656 = sensor->ep.bus_type == V4L2_MBUS_BT656;
+	u8 polarities = 0;
 	int ret;
 
 	if (!on) {
 		/* Reset settings to their default values. */
+		ov5640_write_reg(sensor, OV5640_REG_CCIR656_CTRL00, 0x00);
 		ov5640_write_reg(sensor, OV5640_REG_IO_MIPI_CTRL00, 0x58);
 		ov5640_write_reg(sensor, OV5640_REG_POLARITY_CTRL00, 0x20);
 		ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT_ENABLE01, 0x00);
@@ -2024,7 +2010,35 @@ static int ov5640_set_power_dvp(struct ov5640_dev *sensor, bool on)
 	 * - VSYNC:	active high
 	 * - HREF:	active low
 	 * - PCLK:	active low
+	 *
+	 * VSYNC & HREF are not configured if BT656 bus mode is selected
 	 */
+
+	/*
+	 * BT656 embedded synchronization configuration
+	 *
+	 * CCIR656 CTRL00
+	 * - [7]:	SYNC code selection (0: auto generate sync code,
+	 *		1: sync code from regs 0x4732-0x4735)
+	 * - [6]:	f value in CCIR656 SYNC code when fixed f value
+	 * - [5]:	Fixed f value
+	 * - [4:3]:	Blank toggle data options (00: data=1'h040/1'h200,
+	 *		01: data from regs 0x4736-0x4738, 10: always keep 0)
+	 * - [1]:	Clip data disable
+	 * - [0]:	CCIR656 mode enable
+	 *
+	 * Default CCIR656 SAV/EAV mode with default codes
+	 * SAV=0xff000080 & EAV=0xff00009d is enabled here with settings:
+	 * - CCIR656 mode enable
+	 * - auto generation of sync codes
+	 * - blank toggle data 1'h040/1'h200
+	 * - clip reserved data (0x00 & 0xff changed to 0x01 & 0xfe)
+	 */
+	ret = ov5640_write_reg(sensor, OV5640_REG_CCIR656_CTRL00,
+			       bt656 ? 0x01 : 0x00);
+	if (ret)
+		return ret;
+
 	/*
 	 * configure parallel port control lines polarity
 	 *
@@ -2035,29 +2049,26 @@ static int ov5640_set_power_dvp(struct ov5640_dev *sensor, bool on)
 	 *		datasheet and hardware, 0 is active high
 	 *		and 1 is active low...)
 	 */
-	if (sensor->ep.bus_type == V4L2_MBUS_PARALLEL) {
-		if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
-			pclk_pol = 1;
+	if (!bt656) {
 		if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
-			hsync_pol = 1;
+			polarities |= BIT(1);
 		if (flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
-			vsync_pol = 1;
-
-		ret = ov5640_write_reg(sensor, OV5640_REG_POLARITY_CTRL00,
-				       (pclk_pol << 5) | (hsync_pol << 1) |
-				       vsync_pol);
-
-		if (ret)
-			return ret;
+			polarities |= BIT(0);
 	}
+	if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
+		polarities |= BIT(5);
+
+	ret = ov5640_write_reg(sensor, OV5640_REG_POLARITY_CTRL00, polarities);
+	if (ret)
+		return ret;
 
 	/*
-	 * powerdown MIPI TX/RX PHY & disable MIPI
+	 * powerdown MIPI TX/RX PHY & enable DVP
 	 *
 	 * MIPI CONTROL 00
-	 * 4:	 PWDN PHY TX
-	 * 3:	 PWDN PHY RX
-	 * 2:	 MIPI enable
+	 * [4] = 1	: Power down MIPI HS Tx
+	 * [3] = 1	: Power down MIPI LS Rx
+	 * [2] = 0	: DVP enable (MIPI disable)
 	 */
 	ret = ov5640_write_reg(sensor, OV5640_REG_IO_MIPI_CTRL00, 0x18);
 	if (ret)
@@ -2074,8 +2085,7 @@ static int ov5640_set_power_dvp(struct ov5640_dev *sensor, bool on)
 	 * - [3:0]:	D[9:6] output enable
 	 */
 	ret = ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT_ENABLE01,
-			       sensor->ep.bus_type == V4L2_MBUS_PARALLEL ?
-			       0x7f : 0x1f);
+			       bt656 ? 0x1f : 0x7f);
 	if (ret)
 		return ret;
 
@@ -2925,8 +2935,6 @@ static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
 
 		if (sensor->ep.bus_type == V4L2_MBUS_CSI2_DPHY)
 			ret = ov5640_set_stream_mipi(sensor, enable);
-		else if (sensor->ep.bus_type == V4L2_MBUS_BT656)
-			ret = ov5640_set_stream_bt656(sensor, enable);
 		else
 			ret = ov5640_set_stream_dvp(sensor, enable);
 
-- 
2.27.0



