Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBB729C2FE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821137AbgJ0Rko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902465AbgJ0Odq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:33:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8E2C207BB;
        Tue, 27 Oct 2020 14:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809225;
        bh=NdPLT1Ytqe5Sfa4wBWM2D0jE/C4xF03Pc9wlE1uPqVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rty9USGsFGz0M3D41b6gI9axXYnEUj9uPP+wlPEbl1clzFKCSYD3Lmj03iHnAp/Bx
         DyaOQhFQPQPz2irVgpEMFQ4cruPExM6lUHkNwD+ikXjdF/MZ1Nbjd4IiO7+uTfjZL+
         tu1lUYsw3AuMWD1NHQAV/c8fheLpUChiQ350ee+g=
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
Subject: [PATCH 5.4 080/408] media: i2c: ov5640: Separate out mipi configuration from s_power
Date:   Tue, 27 Oct 2020 14:50:18 +0100
Message-Id: <20201027135458.772629745@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit b1751ae652fb95919c08df5bdd739ccf9886158a ]

In preparation for adding DVP configuration in s_power callback
move mipi configuration into separate function

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Tested-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 116 +++++++++++++++++++------------------
 1 file changed, 60 insertions(+), 56 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 065f9706db7e5..3c6ad2dd9c0e1 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2000,6 +2000,61 @@ static void ov5640_set_power_off(struct ov5640_dev *sensor)
 	clk_disable_unprepare(sensor->xclk);
 }
 
+static int ov5640_set_power_mipi(struct ov5640_dev *sensor, bool on)
+{
+	int ret;
+
+	if (!on) {
+		/* Reset MIPI bus settings to their default values. */
+		ov5640_write_reg(sensor, OV5640_REG_IO_MIPI_CTRL00, 0x58);
+		ov5640_write_reg(sensor, OV5640_REG_MIPI_CTRL00, 0x04);
+		ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT00, 0x00);
+		return 0;
+	}
+
+	/*
+	 * Power up MIPI HS Tx and LS Rx; 2 data lanes mode
+	 *
+	 * 0x300e = 0x40
+	 * [7:5] = 010	: 2 data lanes mode (see FIXME note in
+	 *		  "ov5640_set_stream_mipi()")
+	 * [4] = 0	: Power up MIPI HS Tx
+	 * [3] = 0	: Power up MIPI LS Rx
+	 * [2] = 0	: MIPI interface disabled
+	 */
+	ret = ov5640_write_reg(sensor, OV5640_REG_IO_MIPI_CTRL00, 0x40);
+	if (ret)
+		return ret;
+
+	/*
+	 * Gate clock and set LP11 in 'no packets mode' (idle)
+	 *
+	 * 0x4800 = 0x24
+	 * [5] = 1	: Gate clock when 'no packets'
+	 * [2] = 1	: MIPI bus in LP11 when 'no packets'
+	 */
+	ret = ov5640_write_reg(sensor, OV5640_REG_MIPI_CTRL00, 0x24);
+	if (ret)
+		return ret;
+
+	/*
+	 * Set data lanes and clock in LP11 when 'sleeping'
+	 *
+	 * 0x3019 = 0x70
+	 * [6] = 1	: MIPI data lane 2 in LP11 when 'sleeping'
+	 * [5] = 1	: MIPI data lane 1 in LP11 when 'sleeping'
+	 * [4] = 1	: MIPI clock lane in LP11 when 'sleeping'
+	 */
+	ret = ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT00, 0x70);
+	if (ret)
+		return ret;
+
+	/* Give lanes some time to coax into LP11 state. */
+	usleep_range(500, 1000);
+
+	return 0;
+}
+
 static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
 {
 	int ret = 0;
@@ -2012,67 +2067,16 @@ static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
 		ret = ov5640_restore_mode(sensor);
 		if (ret)
 			goto power_off;
+	}
 
-		/* We're done here for DVP bus, while CSI-2 needs setup. */
-		if (sensor->ep.bus_type != V4L2_MBUS_CSI2_DPHY)
-			return 0;
-
-		/*
-		 * Power up MIPI HS Tx and LS Rx; 2 data lanes mode
-		 *
-		 * 0x300e = 0x40
-		 * [7:5] = 010	: 2 data lanes mode (see FIXME note in
-		 *		  "ov5640_set_stream_mipi()")
-		 * [4] = 0	: Power up MIPI HS Tx
-		 * [3] = 0	: Power up MIPI LS Rx
-		 * [2] = 0	: MIPI interface disabled
-		 */
-		ret = ov5640_write_reg(sensor,
-				       OV5640_REG_IO_MIPI_CTRL00, 0x40);
-		if (ret)
-			goto power_off;
-
-		/*
-		 * Gate clock and set LP11 in 'no packets mode' (idle)
-		 *
-		 * 0x4800 = 0x24
-		 * [5] = 1	: Gate clock when 'no packets'
-		 * [2] = 1	: MIPI bus in LP11 when 'no packets'
-		 */
-		ret = ov5640_write_reg(sensor,
-				       OV5640_REG_MIPI_CTRL00, 0x24);
-		if (ret)
-			goto power_off;
-
-		/*
-		 * Set data lanes and clock in LP11 when 'sleeping'
-		 *
-		 * 0x3019 = 0x70
-		 * [6] = 1	: MIPI data lane 2 in LP11 when 'sleeping'
-		 * [5] = 1	: MIPI data lane 1 in LP11 when 'sleeping'
-		 * [4] = 1	: MIPI clock lane in LP11 when 'sleeping'
-		 */
-		ret = ov5640_write_reg(sensor,
-				       OV5640_REG_PAD_OUTPUT00, 0x70);
+	if (sensor->ep.bus_type == V4L2_MBUS_CSI2_DPHY) {
+		ret = ov5640_set_power_mipi(sensor, on);
 		if (ret)
 			goto power_off;
+	}
 
-		/* Give lanes some time to coax into LP11 state. */
-		usleep_range(500, 1000);
-
-	} else {
-		if (sensor->ep.bus_type == V4L2_MBUS_CSI2_DPHY) {
-			/* Reset MIPI bus settings to their default values. */
-			ov5640_write_reg(sensor,
-					 OV5640_REG_IO_MIPI_CTRL00, 0x58);
-			ov5640_write_reg(sensor,
-					 OV5640_REG_MIPI_CTRL00, 0x04);
-			ov5640_write_reg(sensor,
-					 OV5640_REG_PAD_OUTPUT00, 0x00);
-		}
-
+	if (!on)
 		ov5640_set_power_off(sensor);
-	}
 
 	return 0;
 
-- 
2.25.1



