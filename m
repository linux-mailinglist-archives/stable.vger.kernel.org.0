Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8BB99AD2
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388773AbfHVRQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390399AbfHVRIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:37 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E10C923407;
        Thu, 22 Aug 2019 17:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493716;
        bh=8zooDDLk4SMfizKNkmpLcqjt64Lv2VSIABX6QBeAj3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=woe8abyCqlbH94lceEW8pl5b87zHl9iVmhXYC46noJzVUdpmAjdXNY1rWkox3FEKg
         kX1qFgvNmUC1jGbfgmbNzw1NZaHePZ16VVPYky39Z+42W/6y9H07SwFlRiOGvZSR48
         m4ynAv9vjirmJGLNFNrMYabRrSz046EUGFwyoMS0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Yao Lihua <Lihua.Yao@desay-svautomotive.com>,
        Linh Phung <linh.phung.jy@renesas.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 041/135] clk: renesas: cpg-mssr: Fix reset control race condition
Date:   Thu, 22 Aug 2019 13:06:37 -0400
Message-Id: <20190822170811.13303-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit e1f1ae8002e4b06addc52443fcd975bbf554ae92 ]

The module reset code in the Renesas CPG/MSSR driver uses
read-modify-write (RMW) operations to write to a Software Reset Register
(SRCRn), and simple writes to write to a Software Reset Clearing
Register (SRSTCLRn), as was mandated by the R-Car Gen2 and Gen3 Hardware
User's Manuals.

However, this may cause a race condition when two devices are reset in
parallel: if the reset for device A completes in the middle of the RMW
operation for device B, device A may be reset again, causing subtle
failures (e.g. i2c timeouts):

	thread A			thread B
	--------			--------

	val = SRCRn
	val |= bit A
	SRCRn = val

	delay

					val = SRCRn (bit A is set)

	SRSTCLRn = bit A
	(bit A in SRCRn is cleared)

					val |= bit B
					SRCRn = val (bit A and B are set)

This can be reproduced on e.g. Salvator-XS using:

    $ while true; do i2cdump -f -y 4 0x6A b > /dev/null; done &
    $ while true; do i2cdump -f -y 2 0x10 b > /dev/null; done &

    i2c-rcar e6510000.i2c: error -110 : 40000002
    i2c-rcar e66d8000.i2c: error -110 : 40000002

According to the R-Car Gen3 Hardware Manual Errata for Rev.
0.80 of Feb 28, 2018, reflected in Rev. 1.00 of the R-Car Gen3 Hardware
User's Manual, writes to SRCRn do not require read-modify-write cycles.

Note that the R-Car Gen2 Hardware User's Manual has not been updated
yet, and still says a read-modify-write sequence is required.  According
to the hardware team, the reset hardware block is the same on both R-Car
Gen2 and Gen3, though.

Hence fix the issue by replacing the read-modify-write operations on
SRCRn by simple writes.

Reported-by: Yao Lihua <Lihua.Yao@desay-svautomotive.com>
Fixes: 6197aa65c4905532 ("clk: renesas: cpg-mssr: Add support for reset control")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Linh Phung <linh.phung.jy@renesas.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 0201809bbd377..9dfa28d6fd9f9 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -576,17 +576,11 @@ static int cpg_mssr_reset(struct reset_controller_dev *rcdev,
 	unsigned int reg = id / 32;
 	unsigned int bit = id % 32;
 	u32 bitmask = BIT(bit);
-	unsigned long flags;
-	u32 value;
 
 	dev_dbg(priv->dev, "reset %u%02u\n", reg, bit);
 
 	/* Reset module */
-	spin_lock_irqsave(&priv->rmw_lock, flags);
-	value = readl(priv->base + SRCR(reg));
-	value |= bitmask;
-	writel(value, priv->base + SRCR(reg));
-	spin_unlock_irqrestore(&priv->rmw_lock, flags);
+	writel(bitmask, priv->base + SRCR(reg));
 
 	/* Wait for at least one cycle of the RCLK clock (@ ca. 32 kHz) */
 	udelay(35);
@@ -603,16 +597,10 @@ static int cpg_mssr_assert(struct reset_controller_dev *rcdev, unsigned long id)
 	unsigned int reg = id / 32;
 	unsigned int bit = id % 32;
 	u32 bitmask = BIT(bit);
-	unsigned long flags;
-	u32 value;
 
 	dev_dbg(priv->dev, "assert %u%02u\n", reg, bit);
 
-	spin_lock_irqsave(&priv->rmw_lock, flags);
-	value = readl(priv->base + SRCR(reg));
-	value |= bitmask;
-	writel(value, priv->base + SRCR(reg));
-	spin_unlock_irqrestore(&priv->rmw_lock, flags);
+	writel(bitmask, priv->base + SRCR(reg));
 	return 0;
 }
 
-- 
2.20.1

