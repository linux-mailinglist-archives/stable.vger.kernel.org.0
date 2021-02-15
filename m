Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CAA31BCD8
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhBOPgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:36:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231403AbhBOPdw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:33:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C4AB64E68;
        Mon, 15 Feb 2021 15:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403072;
        bh=9KCxKv83bTMrdh86WXcM997XSiRYHA9+1m245xuIgqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f++XxIxfOfu0VZw0tJPusr4zXPuoEiVrljIrRUVNyZLZNd08AknnKngLoOcG57sBN
         asRpcwMeVTHKVcKAqcps6To74FjqRJaJ8rCmXn6c5I9uOjxujRNdxmI+PL9S2wp9bI
         bwKYrt1pmuOQXWJUm5UwuLEhy1rYDu93HTSh3He8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Philipp Klemm <philipp@uvos.xyz>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Suman Anna <s-anna@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/104] soc: ti: omap-prm: Fix boot time errors for rst_map_012 bits 0 and 1
Date:   Mon, 15 Feb 2021 16:26:30 +0100
Message-Id: <20210215152720.034554689@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



