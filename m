Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCCE29C322
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821409AbgJ0Rn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897002AbgJ0Obz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:31:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E082F20754;
        Tue, 27 Oct 2020 14:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809114;
        bh=QRVEWHv8ldmZfDe56LjOnNSX4KMguMuf+pp5YeWG2KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsUwwClliym/z24+AgkVO9gA0l8uWpSPmnp1QPaDGTfRTj2uiEJfJUsW5S9X0mmnO
         ZRzYAeat5ilkeycfAG2guLmQCuHgDmqyCN1/X4luJ+MNMTlT31P/VKWg3neiT6CQ5l
         ajAAC8EjE04/s3VKaj7TWZeub5rb2/aq0yzcjXjE=
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
Subject: [PATCH 5.4 079/408] media: i2c: ov5640: Remain in power down for DVP mode unless streaming
Date:   Tue, 27 Oct 2020 14:50:17 +0100
Message-Id: <20201027135458.721805064@linuxfoundation.org>
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

[ Upstream commit 3b987d70e903962eb8c5961ba166c345a49d1a0b ]

Keep the sensor in software power down mode and wake up only in
ov5640_set_stream_dvp() callback.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Tested-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index b21ddbd514465..065f9706db7e5 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -34,6 +34,8 @@
 #define OV5640_REG_SYS_RESET02		0x3002
 #define OV5640_REG_SYS_CLOCK_ENABLE02	0x3006
 #define OV5640_REG_SYS_CTRL0		0x3008
+#define OV5640_REG_SYS_CTRL0_SW_PWDN	0x42
+#define OV5640_REG_SYS_CTRL0_SW_PWUP	0x02
 #define OV5640_REG_CHIP_ID		0x300a
 #define OV5640_REG_IO_MIPI_CTRL00	0x300e
 #define OV5640_REG_PAD_OUTPUT_ENABLE01	0x3017
@@ -1109,6 +1111,12 @@ static int ov5640_load_regs(struct ov5640_dev *sensor,
 		val = regs->val;
 		mask = regs->mask;
 
+		/* remain in power down mode for DVP */
+		if (regs->reg_addr == OV5640_REG_SYS_CTRL0 &&
+		    val == OV5640_REG_SYS_CTRL0_SW_PWUP &&
+		    sensor->ep.bus_type != V4L2_MBUS_CSI2_DPHY)
+			continue;
+
 		if (mask)
 			ret = ov5640_mod_reg(sensor, reg_addr, mask, val);
 		else
@@ -1286,9 +1294,14 @@ static int ov5640_set_stream_dvp(struct ov5640_dev *sensor, bool on)
 	 * PAD OUTPUT ENABLE 02
 	 * - [7:2]:	D[5:0] output enable
 	 */
-	return ov5640_write_reg(sensor,
-				OV5640_REG_PAD_OUTPUT_ENABLE02,
-				on ? 0xfc : 0);
+	ret = ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT_ENABLE02,
+			       on ? 0xfc : 0);
+	if (ret)
+		return ret;
+
+	return ov5640_write_reg(sensor, OV5640_REG_SYS_CTRL0, on ?
+				OV5640_REG_SYS_CTRL0_SW_PWUP :
+				OV5640_REG_SYS_CTRL0_SW_PWDN);
 }
 
 static int ov5640_set_stream_mipi(struct ov5640_dev *sensor, bool on)
-- 
2.25.1



