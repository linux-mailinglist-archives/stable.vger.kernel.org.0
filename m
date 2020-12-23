Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8B22E162C
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgLWC6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:58:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728974AbgLWCU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EE58225AB;
        Wed, 23 Dec 2020 02:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690011;
        bh=E8mFVU7w5RNrXHNOs3bJSWp9hetRUAOYVpOx4Qu6e6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUExjZym2hl+zBGtXwuBrjRno5n4M3E22ZZBkntvgUw5LKXpvRTKEoRdhJQZzd4ap
         untBKRrxYKbkhs0QeeRklmmd+RVCSrrAxnwQ0eL+6AKVMgnVVhrICXTsD6c2xbZd2v
         jcelZQIuRKpurVmjK7HhxVaKWSiA+blAFLsQiK7dXz5irNJcUWS38eJn3URMQOB4re
         ikueRLzHHw3icSOicqfXAFpM/9Mj35AWCz94iN1aCvnKQjrsHiEXbbNjlCMakzref5
         2Ca8ToaPK1KQZaCnT4sgcXvKuIed/oOeVL3yiWWpmayLpL0ZyS9mr17dg2WMDCBnZZ
         y9vcbNm4R6JfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 091/130] media: rcar-vin: Mask VNCSI_IFMD register
Date:   Tue, 22 Dec 2020 21:17:34 -0500
Message-Id: <20201223021813.2791612-91-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index e5f6360801082..5605a42f6de54 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1330,7 +1330,9 @@ int rvin_dma_register(struct rvin_dev *vin, int irq)
  */
 int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel)
 {
-	u32 ifmd, vnmc;
+	const struct rvin_group_route *route;
+	u32 ifmd = 0;
+	u32 vnmc;
 	int ret;
 
 	ret = pm_runtime_get_sync(vin->dev);
@@ -1343,9 +1345,26 @@ int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel)
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

