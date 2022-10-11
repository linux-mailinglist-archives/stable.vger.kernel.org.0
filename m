Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1265FB655
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiJKPDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiJKPBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:01:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9439F9DD8E;
        Tue, 11 Oct 2022 07:57:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 24DA5CE1885;
        Tue, 11 Oct 2022 14:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD31FC433D7;
        Tue, 11 Oct 2022 14:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499973;
        bh=+2Uexoq1RUVq8EcT0uT55HnAPIB1PMUURPdHRSIVR+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkwLQN1+Bol/2M35cigOI+zXicoMLWQvhsnYVV0chWsZlccAG6ZEAyNfWo/aiC+1x
         RTQBIgQmNjjtrU9nM0Ykb8kNFGP3uXHZbulcuKunYiSL/EGO7Gy79nzfvXiIAdQ5fs
         TdID1daAzBtmgnfQ4soYXgrGyW3hW0RXVclOrVvz6k2RDYcq6Qfu6GV2rg9pZz9eKk
         jcLk/PlmG558PV/ZboUhgg5CxlIA8YJ4So4zB3fGHXuoIw3pq9yRPz3IVTg4bo4Heo
         Nb694HLTH2FQSR7D8HtZnwSI6wEgWPAu6jtbasSun3zSVPaIgI97OObWT5zQ3j5Gq8
         0OmfC73K+J8qA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qi Zheng <zhengqi.arch@bytedance.com>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 13/26] arm64: run softirqs on the per-CPU IRQ stack
Date:   Tue, 11 Oct 2022 10:52:20 -0400
Message-Id: <20221011145233.1624013-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145233.1624013-1-sashal@kernel.org>
References: <20221011145233.1624013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qi Zheng <zhengqi.arch@bytedance.com>

[ Upstream commit 8eb858c44b98e0326bb32fca34ae671995cd73bb ]

Currently arm64 supports per-CPU IRQ stack, but softirqs
are still handled in the task context.

Since any call to local_bh_enable() at any level in the task's
call stack may trigger a softirq processing run, which could
potentially cause a task stack overflow if the combined stack
footprints exceed the stack's size, let's run these softirqs
on the IRQ stack as well.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20220815124739.15948-1-zhengqi.arch@bytedance.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig      |  1 +
 arch/arm64/kernel/irq.c | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 24cce3b9ff1a..496c68aa1b98 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -221,6 +221,7 @@ config ARM64
 	select HAVE_ARCH_USERFAULTFD_MINOR if USERFAULTFD
 	select TRACE_IRQFLAGS_SUPPORT
 	select TRACE_IRQFLAGS_NMI_SUPPORT
+	select HAVE_SOFTIRQ_ON_OWN_STACK
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index bda49430c9ea..38dbd3828f13 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -21,7 +21,9 @@
 #include <linux/seq_file.h>
 #include <linux/vmalloc.h>
 #include <asm/daifflags.h>
+#include <asm/exception.h>
 #include <asm/vmap_stack.h>
+#include <asm/softirq_stack.h>
 
 /* Only access this in an NMI enter/exit */
 DEFINE_PER_CPU(struct nmi_ctx, nmi_contexts);
@@ -71,6 +73,18 @@ static void init_irq_stacks(void)
 }
 #endif
 
+#ifndef CONFIG_PREEMPT_RT
+static void ____do_softirq(struct pt_regs *regs)
+{
+	__do_softirq();
+}
+
+void do_softirq_own_stack(void)
+{
+	call_on_irq_stack(NULL, ____do_softirq);
+}
+#endif
+
 static void default_handle_irq(struct pt_regs *regs)
 {
 	panic("IRQ taken without a root IRQ handler\n");
-- 
2.35.1

