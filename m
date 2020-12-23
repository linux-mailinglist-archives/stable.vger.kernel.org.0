Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD452E14C4
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgLWCnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:43:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729873AbgLWCXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F14F22248;
        Wed, 23 Dec 2020 02:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690143;
        bh=qF9l755odwp307/T/N4iq49b/ec7+MuRGg7fKtWJgkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GG3fI/0uKfXHDg7UO1rqpzI3WHly6c8nyu0srm88rM2uu4/lBxP5v3dOonIWMRRYu
         EwZwLtMN0j4LXXR2F6Npfi3uRvq3RPWkWSPK3SgRUiWqrxG68CDPwAjxog9aaJ7nNP
         ZR0lQaxXHOU55mj41ukWT9GbtDA0lJ4e0WRmddIocmeOZyjDh5KvUsmYY0+zOF+sZV
         l2Pr+x+3vpYtouj7KsCnwCAy5AXcZZnTh7JheUX49J6f06RtlXUnku+u3aA3iBuT47
         CUmJtQvLygv4+OlJGseV+KazpZdpU+ZJKKFMMcLAoP7Ct5hFOF6n0JBhVNx4KKj/Xr
         9BxTLNRoQ1WNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 64/87] media: rcar-vin: Mask VNCSI_IFMD register
Date:   Tue, 22 Dec 2020 21:20:40 -0500
Message-Id: <20201223022103.2792705-64-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacopo Mondi <jacopo+renesas@jmondi.org>

[ Upstream commit fb25ca37317200fa97ea6b8952e07958f06da7a6 ]

The VNCSI_IFMD register controls the data expansion mode and the
channel routing between the CSI-2 receivers and VIN instances.

According to the chip manual revision 2.20 not all fields are available
for all the SoCs:
- V3M, V3H and E3 do not support the DES1 field has they do not feature
  a CSI20 receiver.
- D3 only supports parallel input, and the whole register shall always
  be written as 0.

Inspect the per-SoC channel routing table where the available CSI-2
instances are reported and configure VNCSI_IFMD accordingly.

This patch supports this BSP change commit:

https://github.com/renesas-rcar/linux-bsp/commit/f54697394457
("media: rcar-vin: Fix VnCSI_IFMD register access for r8a77990")

[hverkuil: replace BSP commit ID with BSP URL]

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Suggested-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 25 +++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 70a8cc433a03f..4fee9132472bb 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1319,7 +1319,9 @@ int rvin_dma_register(struct rvin_dev *vin, int irq)
  */
 int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel)
 {
-	u32 ifmd, vnmc;
+	const struct rvin_group_route *route;
+	u32 ifmd = 0;
+	u32 vnmc;
 	int ret;
 
 	ret = pm_runtime_get_sync(vin->dev);
@@ -1332,9 +1334,26 @@ int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel)
 	vnmc = rvin_read(vin, VNMC_REG);
 	rvin_write(vin, vnmc & ~VNMC_VUP, VNMC_REG);
 
-	ifmd = VNCSI_IFMD_DES1 | VNCSI_IFMD_DES0 | VNCSI_IFMD_CSI_CHSEL(chsel);
+	/*
+	 * Set data expansion mode to "pad with 0s" by inspecting the routes
+	 * table to find out which bit fields are available in the IFMD
+	 * register. IFMD_DES1 controls data expansion mode for CSI20/21,
+	 * IFMD_DES0 controls data expansion mode for CSI40/41.
+	 */
+	for (route = vin->info->routes; route->mask; route++) {
+		if (route->csi == RVIN_CSI20 || route->csi == RVIN_CSI21)
+			ifmd |= VNCSI_IFMD_DES1;
+		else
+			ifmd |= VNCSI_IFMD_DES0;
 
-	rvin_write(vin, ifmd, VNCSI_IFMD_REG);
+		if (ifmd == (VNCSI_IFMD_DES0 | VNCSI_IFMD_DES1))
+			break;
+	}
+
+	if (ifmd) {
+		ifmd |= VNCSI_IFMD_CSI_CHSEL(chsel);
+		rvin_write(vin, ifmd, VNCSI_IFMD_REG);
+	}
 
 	vin_dbg(vin, "Set IFMD 0x%x\n", ifmd);
 
-- 
2.27.0

