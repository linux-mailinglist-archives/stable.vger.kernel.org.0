Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8FDE7BC0
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 22:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731303AbfJ1VtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 17:49:25 -0400
Received: from vps.xff.cz ([195.181.215.36]:50070 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730592AbfJ1VtZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 17:49:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1572299363; bh=yfQ5bNur1qQsSwWai80uin5ZDClxDtOcYUot2/fijL0=;
        h=From:To:Cc:Subject:Date:From;
        b=RVD9lhOKFIWyR8uwdk2pCEi1JXI/uuyWgSwtBUN3we5JB1c5A5vVxcsn92C47QBc3
         nU/lzm4szLyF6lnP6vBtiKuiNZ/DtVMsFUIocfOEhl1LTdROS25HWBRU2SA2j2MLqT
         xjJKew//0G2ek76ewJ6TrFzTUjb3lW3lW3QYv408=
From:   Ondrej Jirman <megous@megous.com>
To:     linux-sunxi@googlegroups.com
Cc:     Ondrej Jirman <megous@megous.com>, stable@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Allwinner
        sunXi SoC support), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ARM: sunxi: Fix CPU powerdown on A83T
Date:   Mon, 28 Oct 2019 22:49:14 +0100
Message-Id: <20191028214914.3465156-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PRCM_PWROFF_GATING_REG has CPU0 at bit 4 on A83T. So without this
patch, instead of gating the CPU0, the whole cluster was power gated,
when shutting down first CPU in the cluster.

Fixes: 6961275e72a8c1 ("ARM: sun8i: smp: Add support for A83T")
Signed-off-by: Ondrej Jirman <megous@megous.com>
Cc: stable@vger.kernel.org
---
 arch/arm/mach-sunxi/mc_smp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-sunxi/mc_smp.c b/arch/arm/mach-sunxi/mc_smp.c
index 239084cf8192..26cbce135338 100644
--- a/arch/arm/mach-sunxi/mc_smp.c
+++ b/arch/arm/mach-sunxi/mc_smp.c
@@ -481,14 +481,18 @@ static void sunxi_mc_smp_cpu_die(unsigned int l_cpu)
 static int sunxi_cpu_powerdown(unsigned int cpu, unsigned int cluster)
 {
 	u32 reg;
+	int gating_bit = cpu;
 
 	pr_debug("%s: cluster %u cpu %u\n", __func__, cluster, cpu);
 	if (cpu >= SUNXI_CPUS_PER_CLUSTER || cluster >= SUNXI_NR_CLUSTERS)
 		return -EINVAL;
 
+	if (is_a83t && cpu == 0)
+		gating_bit = 4;
+
 	/* gate processor power */
 	reg = readl(prcm_base + PRCM_PWROFF_GATING_REG(cluster));
-	reg |= PRCM_PWROFF_GATING_REG_CORE(cpu);
+	reg |= PRCM_PWROFF_GATING_REG_CORE(gating_bit);
 	writel(reg, prcm_base + PRCM_PWROFF_GATING_REG(cluster));
 	udelay(20);
 
-- 
2.23.0

