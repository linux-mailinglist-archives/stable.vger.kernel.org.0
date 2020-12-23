Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A9C2E1421
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbgLWCiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:38:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730138AbgLWCYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF0E623137;
        Wed, 23 Dec 2020 02:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690208;
        bh=J17Ye1tVNmhTMAZKXijNIjI7waSIU7anezzCCWHNJIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q324Z9kls1ppv48JJqo2Kbr05KJAZ2as7eCowFTFgCZJ6A/2Ys3ZDvq2l6pQltHe2
         XLWQFsUWRmxbuVF2naQSrEdKkMDrsyqzKzBKz4OSzUT8nXj7slcBhGUHqAwEziQzG6
         pv+LjYJbsjAOxV9yEYk9hABKJsMwIVBN1fSrTE8+p8O6/j5WWpbf7qpOWmnZxVwuyL
         mfH1y2PD6YRanP3is3Os9G53IsZv05BflrucFT1E9qvLQGxXkyFV5RdXUiy4YyPArO
         Hhov+bhLb2DJnChEbxtHCbPTAOxyxB6VpgYoreychW8tx6pgy5cRipz4WExliAl3lJ
         +bTIJ7bYiOBbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Youling Tang <tangyouling@loongson.cn>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 28/66] ARM: OMAP2+: Fix memleak in omap2xxx_clkt_vps_init
Date:   Tue, 22 Dec 2020 21:22:14 -0500
Message-Id: <20201223022253.2793452-28-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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

