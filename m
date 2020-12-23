Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BCD2E1590
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgLWCuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:50:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729525AbgLWCV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8948E23340;
        Wed, 23 Dec 2020 02:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690104;
        bh=J17Ye1tVNmhTMAZKXijNIjI7waSIU7anezzCCWHNJIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zr9F/u4mMh2NjOhVgyAQ66hFfjiAEHBbyG2OQt3ybahFhvW3/8j0DOW6s4BpckIki
         9GQdeNfA/hmwCHlpsuHezQ2P+JrQ8vT9Bl2wi8rJkMyFxIG8iiRHBI0wcJQKeNdWbc
         Ecw36VLo/pKX5wGHrsepKi11fOCTFDPn9cAMm9gohWqpHtuL+YWME6Phy5s31e1X5v
         6WFjgjvd/zWZVP7yTEGrWv9aIE8BZ8jYvlQpVxdYuHG9cM/CrxKqIwmTVYytUHL47w
         0AQq+aCYpRgxCBDrTxcfuYtjrKudtGphdHt83+gTgLkG2PVPSph8J/M5D890beuvGC
         2MSPLELO12MjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Youling Tang <tangyouling@loongson.cn>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 33/87] ARM: OMAP2+: Fix memleak in omap2xxx_clkt_vps_init
Date:   Tue, 22 Dec 2020 21:20:09 -0500
Message-Id: <20201223022103.2792705-33-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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

