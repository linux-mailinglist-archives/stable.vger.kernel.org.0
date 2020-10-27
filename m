Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CB729B6A9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797498AbgJ0PX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:23:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797494AbgJ0PXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:23:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7D562064B;
        Tue, 27 Oct 2020 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812234;
        bh=YPwl2nRRBXhJB6gTrOoIj+hCojriWwjLq577jOuLd20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eOWZamYHCUAks0DnX9wHbGHgd2JB9Qj5P/4A+ER1p4nFOunc+zTdEOkzHHsSLniqQ
         onnCiLoxOi+R/hcZUWZ4Vcsdu/0niCzkLeAKBn+6MWfqElYo2pSa2hTLH1avKGaUH8
         /rdFoEpAL3WkYUzNCCmNOkQxJ1Er/8aegF8iZr9k=
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
Subject: [PATCH 5.9 137/757] media: i2c: ov5640: Remain in power down for DVP mode unless streaming
Date:   Tue, 27 Oct 2020 14:46:27 +0100
Message-Id: <20201027135457.026746359@linuxfoundation.org>
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
index ab19e04720d3a..6e558a7e2d244 100644
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
@@ -1120,6 +1122,12 @@ static int ov5640_load_regs(struct ov5640_dev *sensor,
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
@@ -1297,9 +1305,14 @@ static int ov5640_set_stream_dvp(struct ov5640_dev *sensor, bool on)
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



