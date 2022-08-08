Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2701258C12D
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243777AbiHHB5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243879AbiHHB43 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:56:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EE01C93E;
        Sun,  7 Aug 2022 18:39:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88E6460EC2;
        Mon,  8 Aug 2022 01:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBB0C433B5;
        Mon,  8 Aug 2022 01:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922792;
        bh=KAH9CtYQ7V3naadWU1SjFlH5I6IWKEV/i6WuneECtvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvfwMg96CCtdkHOzZR3YDCXCX3DnwC2Dtltj1qLHNZ7rLjoJG1IJUHblOHCCKVhBl
         Q8igKJpARXg76CQ6Rgme6SZVmo3SimX4dYI+I8FOepi6+e+i6bMrj2HecirhVQKl4C
         V5Duv87DknEQ4rfRwzoArvd7F89oQ0LACXveL5hg2Y9Bwhymfi5rZ9q5EtT0LA40Dt
         Vu/INrsR0xIS71rPlz66TTMAVP+X76VuG9eGNI0vjOqlCGTquq6jIqMILB3qYzwT8s
         DeA9gpTSl1GJ1/dVSLPnL7aUYTFlBNdONnX7W1iN8b0dbsTQnNWfESGzzM5dfilj+W
         Xwqui7H+evKhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Samuel Holland <samuel@sholland.org>,
        kernel test robot <lkp@intel.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de
Subject: [PATCH AUTOSEL 4.14 04/12] genirq: GENERIC_IRQ_IPI depends on SMP
Date:   Sun,  7 Aug 2022 21:39:34 -0400
Message-Id: <20220808013943.316907-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013943.316907-1-sashal@kernel.org>
References: <20220808013943.316907-1-sashal@kernel.org>
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
index 9d8a1dd2e2c2..602602d7017b 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -138,7 +138,7 @@ config IMGPDC_IRQ
 config IRQ_MIPS_CPU
 	bool
 	select GENERIC_IRQ_CHIP
-	select GENERIC_IRQ_IPI if SYS_SUPPORTS_MULTITHREADING
+	select GENERIC_IRQ_IPI if SMP && SYS_SUPPORTS_MULTITHREADING
 	select IRQ_DOMAIN
 	select IRQ_DOMAIN_HIERARCHY if GENERIC_IRQ_IPI
 	select GENERIC_IRQ_EFFECTIVE_AFF_MASK
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 779d858da2b3..94fb3ad9e275 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -80,6 +80,7 @@ config IRQ_FASTEOI_HIERARCHY_HANDLERS
 # Generic IRQ IPI support
 config GENERIC_IRQ_IPI
 	bool
+	depends on SMP
 	select IRQ_DOMAIN_HIERARCHY
 
 # Generic MSI interrupt support
-- 
2.35.1

