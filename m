Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD965FEF6E
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiJNN6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiJNN5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:57:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D18C399C3;
        Fri, 14 Oct 2022 06:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C595B82344;
        Fri, 14 Oct 2022 13:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F838C433D6;
        Fri, 14 Oct 2022 13:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755668;
        bh=r0ReBO0zzwxX30C0ZeUOWuJsadYD7vzsDVqtWZkRi+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMtkimEQmTGNceQpeE4MskeKuAVhrG3FYycKl8Q2cQlZkH3+qvj48tcBnhSsJVZhP
         PPUYZlsYTHu0iUEkZgJSCAumNEhcNWTS4Nduz2L7wylVpvzQaCw5pj3OuR4+Qczin8
         UISEBgAIaoi9+QYlj9rLY68WCtuOGYQ2R4l0O0sJzaXM+Yi1UFA6YLS8ovT87EpiRJ
         oGHiULEr6Uka96fwSSh07kizBQtWHCiQxiUvTHuzxQUmwJEBDc/eTrlKxB81bIF+WU
         FW3ROmm9eWtK0z9LMdq/uPmJYpCHF673cFbRHE7MRrXvIp6BaBIsi8AVNQI7Jks2sr
         MxdyM6+VKt+8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, christophe.leroy@csgroup.eu,
        atrajeev@linux.vnet.ibm.com, ebiederm@xmission.com,
        keescook@chromium.org, naveen.n.rao@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 7/7] powerpc/64: Fix msr_check_and_set/clear MSR[EE] race
Date:   Fri, 14 Oct 2022 09:54:00 -0400
Message-Id: <20221014135402.2109942-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221014135402.2109942-1-sashal@kernel.org>
References: <20221014135402.2109942-1-sashal@kernel.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 0fa6831811f62cfc10415d731bcf9fde2647ad81 ]

irq soft-masking means that when Linux irqs are disabled, the MSR[EE]
value can change from 1 to 0 asynchronously: if a masked interrupt of
the PACA_IRQ_MUST_HARD_MASK variety fires while irqs are disabled,
the masked handler will return with MSR[EE]=0.

This means a sequence like mtmsr(mfmsr() | MSR_FP) is racy if it can
be called with local irqs disabled, unless a hard_irq_disable has been
done.

Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221004051157.308999-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/hw_irq.h | 24 ++++++++++++++++++++++++
 arch/powerpc/kernel/process.c     |  4 ++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index 32a18f2f49bc..3ef454f99d24 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -353,6 +353,30 @@ static inline void may_hard_irq_enable(void) { }
 
 #endif /* CONFIG_PPC64 */
 
+static inline unsigned long mtmsr_isync_irqsafe(unsigned long msr)
+{
+#ifdef CONFIG_PPC64
+	if (arch_irqs_disabled()) {
+		/*
+		 * With soft-masking, MSR[EE] can change from 1 to 0
+		 * asynchronously when irqs are disabled, and we don't want to
+		 * set MSR[EE] back to 1 here if that has happened. A race-free
+		 * way to do this is ensure EE is already 0. Another way it
+		 * could be done is with a RESTART_TABLE handler, but that's
+		 * probably overkill here.
+		 */
+		msr &= ~MSR_EE;
+		mtmsr_isync(msr);
+		irq_soft_mask_set(IRQS_ALL_DISABLED);
+		local_paca->irq_happened |= PACA_IRQ_HARD_DIS;
+	} else
+#endif
+		mtmsr_isync(msr);
+
+	return msr;
+}
+
+
 #define ARCH_IRQ_INIT_FLAGS	IRQ_NOREQUEST
 
 /*
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index cf87573e6e78..e6516c6d62bb 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -131,7 +131,7 @@ unsigned long notrace msr_check_and_set(unsigned long bits)
 #endif
 
 	if (oldmsr != newmsr)
-		mtmsr_isync(newmsr);
+		newmsr = mtmsr_isync_irqsafe(newmsr);
 
 	return newmsr;
 }
@@ -151,7 +151,7 @@ void notrace __msr_check_and_clear(unsigned long bits)
 #endif
 
 	if (oldmsr != newmsr)
-		mtmsr_isync(newmsr);
+		mtmsr_isync_irqsafe(newmsr);
 }
 EXPORT_SYMBOL(__msr_check_and_clear);
 
-- 
2.35.1

