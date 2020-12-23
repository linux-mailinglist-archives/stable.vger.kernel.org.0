Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C418C2E13BF
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgLWCeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:34:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728747AbgLWCY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 930162333F;
        Wed, 23 Dec 2020 02:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690282;
        bh=J17Ye1tVNmhTMAZKXijNIjI7waSIU7anezzCCWHNJIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTV1c4wIkWtHReTtANXGGJISzzRy1l69yeDZ+xtc/X2DojxcSBJVdSCK/sME9Uf5p
         o/hBqz0Kmev6gei47beMmUlrW5PxMB9UsHKiAeXnAYJnOpBi2gjjv2syu2KjELmJko
         qWG6NbIOwmhcdmQUfSbWMlcSZd6rG0G9kTTFtCJtup0tfNB3ZWxymzOBklqvEHXyWL
         BuOmMacckF2wEAxDRGHRiKW7Kc1mTS3GuikW4j8l4Vj4usEJkUIbomERT1ry4y5LAB
         brPmXF+2uByv4gRaSLY2n7VsJ63gW3K5LsNnI8k15//wp28P8X4wgQyjcK5dsPHHiK
         7KaccyMDWcXQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Youling Tang <tangyouling@loongson.cn>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 21/48] ARM: OMAP2+: Fix memleak in omap2xxx_clkt_vps_init
Date:   Tue, 22 Dec 2020 21:23:49 -0500
Message-Id: <20201223022417.2794032-21-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Youling Tang <tangyouling@loongson.cn>

[ Upstream commit 3c5902d270edb6ccc3049acfe5d3e96653c87dcd ]

If the clk_register fails, we should free hw before function returns to
prevent memleak.

Signed-off-by: Youling Tang <tangyouling@loongson.cn>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c b/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
index b64d717bfab6c..45fa2a87d5715 100644
--- a/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
+++ b/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
@@ -247,6 +247,12 @@ void omap2xxx_clkt_vps_init(void)
 	hw->hw.init = &init;
 
 	clk = clk_register(NULL, &hw->hw);
+	if (IS_ERR(clk)) {
+		printk(KERN_ERR "Failed to register clock\n");
+		kfree(hw);
+		return;
+	}
+
 	clkdev_create(clk, "cpufreq_ck", NULL);
 	return;
 cleanup:
-- 
2.27.0

