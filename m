Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF5558C0A9
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243304AbiHHBxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243849AbiHHBwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:52:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6AB1A3A8;
        Sun,  7 Aug 2022 18:38:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEB7760DF8;
        Mon,  8 Aug 2022 01:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEBAC433C1;
        Mon,  8 Aug 2022 01:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922726;
        bh=Kp5EEZ3UNLoq699/egJF5/pkdtcxNMdsuMRmwsLcwUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdkF41Jrn1oWZatQjxBTr7ecQSR+91dN8C4fTyMnDd632lc0lRlXAjcxVX/aMOuUu
         a/OhQxhTO0wSB+K4lyxZH2EGSGzvWoaFQNzEoZqvvVyMmZVFWawWxLd2kzragwkVe/
         sFPKPP7cp7RdYehXTv5+q0HVr2djfcLPvYGZ2280KbA/jXV/21qOHT4aLqmF+wmJDf
         wuLLXlpHRxHKgK4n6UT7TgVOEu2FiNgQX2Ksg4vNID4cc1Q7nS7kPjyXwvx3j8WnW8
         azU1it8FBxrGgF7g1dPCK4tD4Q1le9mqNvVPHDC2IGputXJ3+87Z2x/1WoOpYDx/f4
         ou4chgBOqC+Wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Samuel Holland <samuel@sholland.org>,
        kernel test robot <lkp@intel.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de
Subject: [PATCH AUTOSEL 5.4 06/23] genirq: GENERIC_IRQ_IPI depends on SMP
Date:   Sun,  7 Aug 2022 21:38:13 -0400
Message-Id: <20220808013832.316381-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013832.316381-1-sashal@kernel.org>
References: <20220808013832.316381-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 0f5209fee90b4544c58b4278d944425292789967 ]

The generic IPI code depends on the IRQ affinity mask being allocated
and initialized. This will not be the case if SMP is disabled. Fix up
the remaining driver that selected GENERIC_IRQ_IPI in a non-SMP config.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220701200056.46555-3-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/Kconfig | 2 +-
 kernel/irq/Kconfig      | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 20f44ef9c4c9..e50b5516bbef 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -178,7 +178,7 @@ config MADERA_IRQ
 config IRQ_MIPS_CPU
 	bool
 	select GENERIC_IRQ_CHIP
-	select GENERIC_IRQ_IPI if SYS_SUPPORTS_MULTITHREADING
+	select GENERIC_IRQ_IPI if SMP && SYS_SUPPORTS_MULTITHREADING
 	select IRQ_DOMAIN
 	select IRQ_DOMAIN_HIERARCHY if GENERIC_IRQ_IPI
 	select GENERIC_IRQ_EFFECTIVE_AFF_MASK
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 4e11120265c7..3a8a631044f0 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -81,6 +81,7 @@ config IRQ_FASTEOI_HIERARCHY_HANDLERS
 # Generic IRQ IPI support
 config GENERIC_IRQ_IPI
 	bool
+	depends on SMP
 	select IRQ_DOMAIN_HIERARCHY
 
 # Generic MSI interrupt support
-- 
2.35.1

