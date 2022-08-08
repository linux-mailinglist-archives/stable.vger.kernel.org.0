Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033F058BFA4
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242730AbiHHBm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242704AbiHHBkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:40:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A61B87A;
        Sun,  7 Aug 2022 18:34:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E054EB80881;
        Mon,  8 Aug 2022 01:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1465C433D6;
        Mon,  8 Aug 2022 01:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922489;
        bh=iyij/7Rda9GzVqk1fhaYf1o1xG310pgMr6a/apnunPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tX57G+uy+gkDIwroNJpL3JuJ3/AOmp8D1sCGH1ZyAiEvSzFxwW0Bfr340xBWKuyqh
         CMc6K07R6/ZzCk3sum79yabzVstBERTAJlMaiWa/3WnGuUcKNptueQtksDykSr39Qi
         CY7XBU6kJ2FpsYAIwognslYE4E3civEKfTc/X8OjUValigIaC0VIvFn+uOXD2KdT1x
         xxLQgztmr+hK/CXwMofE5cCWzvN9JhfLYBVsEh1/m81tH37zyRiKLvOWy+UHg+1CUz
         7NXiyxLva0nEu1dcRCDyq27leiHPBIthxpiPMLHi8p/z9rvUfOWMJpJcR25ZHEcggB
         +BSSVzKLe9k7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Samuel Holland <samuel@sholland.org>,
        kernel test robot <lkp@intel.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de
Subject: [PATCH AUTOSEL 5.18 17/53] genirq: GENERIC_IRQ_IPI depends on SMP
Date:   Sun,  7 Aug 2022 21:33:12 -0400
Message-Id: <20220808013350.314757-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
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
index d43d25a411dd..1af26c409cb1 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -177,7 +177,7 @@ config MADERA_IRQ
 config IRQ_MIPS_CPU
 	bool
 	select GENERIC_IRQ_CHIP
-	select GENERIC_IRQ_IPI if SYS_SUPPORTS_MULTITHREADING
+	select GENERIC_IRQ_IPI if SMP && SYS_SUPPORTS_MULTITHREADING
 	select IRQ_DOMAIN
 	select GENERIC_IRQ_EFFECTIVE_AFF_MASK
 
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 10929eda9825..fc760d064a65 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -82,6 +82,7 @@ config IRQ_FASTEOI_HIERARCHY_HANDLERS
 # Generic IRQ IPI support
 config GENERIC_IRQ_IPI
 	bool
+	depends on SMP
 	select IRQ_DOMAIN_HIERARCHY
 
 # Generic MSI interrupt support
-- 
2.35.1

