Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578505FEF0A
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiJNNwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiJNNww (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:52:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5C31D0D5E;
        Fri, 14 Oct 2022 06:52:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 317E161B16;
        Fri, 14 Oct 2022 13:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A53C433C1;
        Fri, 14 Oct 2022 13:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755540;
        bh=aou8zT373DAp4BNXB3UVOTCNCfNwfKTDAw/Wf7mzWBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lbU9UH+1eePB5Nw76uX5MjgwwvV4hvykLWWWZ8cm3tfCs8Y3dTQ9hJWnJjq4J+ueY
         1tAvi9tNMHRWpLNISM+8S9Wp9gZf1170RPFWiC3KEOFE3+XjwuErCJyhV3TZnxXiZN
         23x2qOUVv1HyyHM3hNIH8ZfCSVDD4NsQ4rJcKpHIAsG0DKb9e37SXCS4UDxI6Pwl1I
         68Jq0MvFqJpqPIZ1wUPNoUeDIHbUOncnQI4ZkgYjqp55ZkxKGe32VKmbK9yXsIZhyH
         HMmJphK1Vn9ZQh1W1ihpZeJmpqCD6W96qzNQ7g+tvsULApKLpNkMi1hbs9gIlWtVnP
         2ddASsHb3wGZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, christophe.leroy@csgroup.eu,
        atrajeev@linux.vnet.ibm.com, keescook@chromium.org,
        ebiederm@xmission.com, Julia.Lawall@inria.fr, heying24@huawei.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.0 11/11] powerpc/64: Fix msr_check_and_set/clear MSR[EE] race
Date:   Fri, 14 Oct 2022 09:51:37 -0400
Message-Id: <20221014135139.2109024-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221014135139.2109024-1-sashal@kernel.org>
References: <20221014135139.2109024-1-sashal@kernel.org>
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
index 983551859891..9cb1daa1be4f 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -489,6 +489,30 @@ static inline void irq_soft_mask_regs_set_state(struct pt_regs *regs, unsigned l
 }
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
 
 #endif  /* __ASSEMBLY__ */
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 0fbda89cd1bb..37df0428e4fb 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -127,7 +127,7 @@ unsigned long notrace msr_check_and_set(unsigned long bits)
 		newmsr |= MSR_VSX;
 
 	if (oldmsr != newmsr)
-		mtmsr_isync(newmsr);
+		newmsr = mtmsr_isync_irqsafe(newmsr);
 
 	return newmsr;
 }
@@ -145,7 +145,7 @@ void notrace __msr_check_and_clear(unsigned long bits)
 		newmsr &= ~MSR_VSX;
 
 	if (oldmsr != newmsr)
-		mtmsr_isync(newmsr);
+		mtmsr_isync_irqsafe(newmsr);
 }
 EXPORT_SYMBOL(__msr_check_and_clear);
 
-- 
2.35.1

