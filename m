Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5FF5FEF74
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiJNN67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiJNN6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:58:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49258399C3;
        Fri, 14 Oct 2022 06:58:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52BA961B49;
        Fri, 14 Oct 2022 13:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DF2C433C1;
        Fri, 14 Oct 2022 13:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755686;
        bh=q2L3bh/SATxgdBEHHGvSWTUdP+QqN2SHMKRLJmEs5Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXQUQr20OhfoY3+s/pkNiRYtLh6z7Tycm7t7KCjM1QA1xbKQSdmir+i3t0bdl8dBb
         NDrpDafQG7StM6ErZtXd65xen22TQc5Xsma0YBIiHSAE5Q01aKD4mxZhlLnE6r8vqw
         cIRKVKLuf2qXOoYFqXt9E3Rw7cTrAt3vjxOnC1ElAydp76GVsaNarMFX0sBvziCiRM
         USHF5DNb3Zss4YBFYDTU6FGCbqXLd5FOrAYEwiCoVZ+xeySntyc5TGdux/od/jzxBz
         j9J2mDUp31TWAmEFccTWVOurrRh+O12AoJzz4uIuxEANuB9LRGMwZKYbOOYnZQbL0J
         ZVN6XLob6sdHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, christophe.leroy@csgroup.eu,
        atrajeev@linux.vnet.ibm.com, keescook@chromium.org,
        ebiederm@xmission.com, naveen.n.rao@linux.vnet.ibm.com,
        Julia.Lawall@inria.fr, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 5/5] powerpc/64: Fix msr_check_and_set/clear MSR[EE] race
Date:   Fri, 14 Oct 2022 09:54:28 -0400
Message-Id: <20221014135430.2110067-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221014135430.2110067-1-sashal@kernel.org>
References: <20221014135430.2110067-1-sashal@kernel.org>
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
index 9f89fac4ed08..a703b98ced11 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -131,7 +131,7 @@ unsigned long msr_check_and_set(unsigned long bits)
 #endif
 
 	if (oldmsr != newmsr)
-		mtmsr_isync(newmsr);
+		newmsr = mtmsr_isync_irqsafe(newmsr);
 
 	return newmsr;
 }
@@ -150,7 +150,7 @@ void __msr_check_and_clear(unsigned long bits)
 #endif
 
 	if (oldmsr != newmsr)
-		mtmsr_isync(newmsr);
+		mtmsr_isync_irqsafe(newmsr);
 }
 EXPORT_SYMBOL(__msr_check_and_clear);
 
-- 
2.35.1

