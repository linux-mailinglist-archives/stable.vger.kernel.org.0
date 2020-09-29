Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A284127C9E7
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgI2MOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730096AbgI2Lh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A06A122262;
        Tue, 29 Sep 2020 11:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379215;
        bh=o1UIEffgkGVqT10VkWmZfxY3hxOMHLjiuAxTGUvbeMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CyxKBXGGvXMEr0bCrxr8+gwxqU3yeSyd4akLedzcGhP22MMiG7aiQX8hv4vcVyN6
         IWE4E0TYy/rBZ4SC1HMRGFOVNDI2Ulmu49V3XD+JJy4xa2R5eN+PbaUyT0pa3PoT+M
         7JtCp6pOSnrVFcPRcqYRDPD8ccGW1w4wgz8ekMpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/388] s390: avoid misusing CALL_ON_STACK for task stack setup
Date:   Tue, 29 Sep 2020 12:56:35 +0200
Message-Id: <20200929110013.595760729@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 7bcaad1f9fac889f5fcd1a383acf7e00d006da41 ]

CALL_ON_STACK is intended to be used for temporary stack switching with
potential return to the caller.

When CALL_ON_STACK is misused to switch from nodat stack to task stack
back_chain information would later lead stack unwinder from task stack into
(per cpu) nodat stack which is reused for other purposes. This would
yield confusing unwinding result or errors.

To avoid that introduce CALL_ON_STACK_NORETURN to be used instead. It
makes sure that back_chain is zeroed and unwinder finishes gracefully
ending up at task pt_regs.

Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/stacktrace.h | 11 +++++++++++
 arch/s390/kernel/setup.c           |  9 +--------
 arch/s390/kernel/smp.c             |  2 +-
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/stacktrace.h b/arch/s390/include/asm/stacktrace.h
index 0ae4bbf7779c8..3679d224fd3c5 100644
--- a/arch/s390/include/asm/stacktrace.h
+++ b/arch/s390/include/asm/stacktrace.h
@@ -111,4 +111,15 @@ struct stack_frame {
 	r2;								\
 })
 
+#define CALL_ON_STACK_NORETURN(fn, stack)				\
+({									\
+	asm volatile(							\
+		"	la	15,0(%[_stack])\n"			\
+		"	xc	%[_bc](8,15),%[_bc](15)\n"		\
+		"	brasl	14,%[_fn]\n"				\
+		::[_bc] "i" (offsetof(struct stack_frame, back_chain)),	\
+		  [_stack] "a" (stack), [_fn] "X" (fn));		\
+	BUG();								\
+})
+
 #endif /* _ASM_S390_STACKTRACE_H */
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 07b2b61a0289f..82ef081e7448e 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -356,7 +356,6 @@ early_initcall(async_stack_realloc);
 
 void __init arch_call_rest_init(void)
 {
-	struct stack_frame *frame;
 	unsigned long stack;
 
 	stack = stack_alloc();
@@ -369,13 +368,7 @@ void __init arch_call_rest_init(void)
 	set_task_stack_end_magic(current);
 	stack += STACK_INIT_OFFSET;
 	S390_lowcore.kernel_stack = stack;
-	frame = (struct stack_frame *) stack;
-	memset(frame, 0, sizeof(*frame));
-	/* Branch to rest_init on the new stack, never returns */
-	asm volatile(
-		"	la	15,0(%[_frame])\n"
-		"	jg	rest_init\n"
-		: : [_frame] "a" (frame));
+	CALL_ON_STACK_NORETURN(rest_init, stack);
 }
 
 static void __init setup_lowcore_dat_off(void)
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 66bf050d785cf..ad426cc656e56 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -878,7 +878,7 @@ static void __no_sanitize_address smp_start_secondary(void *cpuvoid)
 	S390_lowcore.restart_source = -1UL;
 	__ctl_load(S390_lowcore.cregs_save_area, 0, 15);
 	__load_psw_mask(PSW_KERNEL_BITS | PSW_MASK_DAT);
-	CALL_ON_STACK(smp_init_secondary, S390_lowcore.kernel_stack, 0);
+	CALL_ON_STACK_NORETURN(smp_init_secondary, S390_lowcore.kernel_stack);
 }
 
 /* Upping and downing of CPUs */
-- 
2.25.1



