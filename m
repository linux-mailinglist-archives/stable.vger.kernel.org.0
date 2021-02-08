Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB62F313BEE
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 18:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhBHR7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 12:59:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234974AbhBHR6t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 12:58:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D99D264D92;
        Mon,  8 Feb 2021 17:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807089;
        bh=9KCxKv83bTMrdh86WXcM997XSiRYHA9+1m245xuIgqE=;
        h=From:To:Cc:Subject:Date:From;
        b=pqxizpO2RY+Y5wNruKTbXSMMYMyyJL0QqydeCxNSpwaTsB5BTtPA/GPGzpUA1dmnb
         Yq5NVf7A68rsLsK4ge5AB070DhYdccNGnuhvm9H9URAP7shRlReAcfD82FZ1X43hET
         NOW2k25JDx+a652eJJv5Flnv4xE4iijdoWsCQMEuKGMXHUULDE8fXf1lQqD+YpkX7G
         RvyYJSZS7wH3iklnELt3JbsS/n9q086E7d2TdJ+45LkqqHgvAKe/8/4X2K24nfMPOX
         kQ0sf+Wef67YcWn6DAzhnM0mnfAzuTYpYcYNPdKp+1gbHR0n08rkLDP3NC2c/zr38X
         8+Mo6sf3lWX4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Carl Philipp Klemm <philipp@uvos.xyz>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Suman Anna <s-anna@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 01/36] soc: ti: omap-prm: Fix boot time errors for rst_map_012 bits 0 and 1
Date:   Mon,  8 Feb 2021 12:57:31 -0500
Message-Id: <20210208175806.2091668-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 7078a5ba7a58e5db07583b176f8a03e0b8714731 ]

We have rst_map_012 used for various accelerators like dsp, ipu and iva.
For these use cases, we have rstctrl bit 2 control the subsystem module
reset, and have and bits 0 and 1 control the accelerator specific
features.

If the bootloader, or kexec boot, has left any accelerator specific
reset bits deasserted, deasserting bit 2 reset will potentially enable
an accelerator with unconfigured MMU and no firmware. And we may get
spammed with a lot by warnings on boot with "Data Access in User mode
during Functional access", or depending on the accelerator, the system
can also just hang.

This issue can be quite easily reproduced by setting a rst_map_012 type
rstctrl register to 0 or 4 in the bootloader, and booting the system.

Let's just assert all reset bits for rst_map_012 type resets. So far
it looks like the other rstctrl types don't need this. If it turns out
that the other type rstctrl bits also need reset on init, we need to
add an instance specific reset mask for the bits to avoid resetting
unwanted bits.

Reported-by: Carl Philipp Klemm <philipp@uvos.xyz>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Santosh Shilimkar <ssantosh@kernel.org>
Cc: Suman Anna <s-anna@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Tested-by: Carl Philipp Klemm <philipp@uvos.xyz>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/omap_prm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/soc/ti/omap_prm.c b/drivers/soc/ti/omap_prm.c
index 4d41dc3cdce1f..c8b14b3a171f7 100644
--- a/drivers/soc/ti/omap_prm.c
+++ b/drivers/soc/ti/omap_prm.c
@@ -552,6 +552,7 @@ static int omap_prm_reset_init(struct platform_device *pdev,
 	const struct omap_rst_map *map;
 	struct ti_prm_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	char buf[32];
+	u32 v;
 
 	/*
 	 * Check if we have controllable resets. If either rstctrl is non-zero
@@ -599,6 +600,16 @@ static int omap_prm_reset_init(struct platform_device *pdev,
 		map++;
 	}
 
+	/* Quirk handling to assert rst_map_012 bits on reset and avoid errors */
+	if (prm->data->rstmap == rst_map_012) {
+		v = readl_relaxed(reset->prm->base + reset->prm->data->rstctrl);
+		if ((v & reset->mask) != reset->mask) {
+			dev_dbg(&pdev->dev, "Asserting all resets: %08x\n", v);
+			writel_relaxed(reset->mask, reset->prm->base +
+				       reset->prm->data->rstctrl);
+		}
+	}
+
 	return devm_reset_controller_register(&pdev->dev, &reset->rcdev);
 }
 
-- 
2.27.0

