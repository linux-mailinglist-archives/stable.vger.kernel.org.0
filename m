Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C832E16C0
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgLWDCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:02:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728729AbgLWCTm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D844F229CA;
        Wed, 23 Dec 2020 02:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689954;
        bh=Ny0nvANgIhhU6bTHscWWumHSI7lRAkDxmM5KCedXLDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Au4Wku9gEgHzhswKaaM2klLl0I7Azuga3aQgGNR6DOPEOJ9QgE3yvJg8YUvYwbWEY
         79k9p4c0+Ar3+YTu3QsY7Ptpxn1dco6BjQC/b82rg1dtKv3+6smW5MScZZL1AKk1mC
         4gnC7PjNN8JPw1+6C5/EpOV+RK0dfg4ZgK+WEVMHBfZqIik0VkpEQ05dJx6oIBJaRd
         8ObpErOz/IA0Q5WzAlojCfnAWwExcis3+R1Jks7zZqfDM1QtseQyb/uNxOcRo+bwKc
         9Rg7B8KZZYDRJynVbYOPeeNgyq+hgC2oqshOvJygWMl0adWRT6tdKtGzFAFOSHZ2r/
         PsVjKM8VaECBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Youling Tang <tangyouling@loongson.cn>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 047/130] ARM: OMAP2+: Fix memleak in omap2xxx_clkt_vps_init
Date:   Tue, 22 Dec 2020 21:16:50 -0500
Message-Id: <20201223021813.2791612-47-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index 2a3e72286d3ab..70892b3da28d3 100644
--- a/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
+++ b/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
@@ -244,6 +244,12 @@ void omap2xxx_clkt_vps_init(void)
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

