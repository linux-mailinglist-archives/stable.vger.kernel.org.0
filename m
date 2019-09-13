Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6152AB2051
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390617AbfIMNUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390608AbfIMNUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:20:40 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9253920717;
        Fri, 13 Sep 2019 13:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380839;
        bh=kN2w/kcq9mBzaqs9yTiVeTulm8bkDRJ/dgotKQjrnuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6/A6XkRMvsyiF7wVOU5oL4Cfuudmz9RBU8GaNNUTxzFme++YRb4sODI7ty0NPQti
         a69FTKu/Tzdj7ZKH7VO0e46Mmp6yttB/mknXYur14+tLS0/27ZgHKVjZMFrn/+a44A
         MedaEP5cJx+up/IHI9seIZAnh3mGPiNozCVf1BKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Breno Leitao <leitao@debian.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 187/190] powerpc/tm: Remove msr_tm_active()
Date:   Fri, 13 Sep 2019 14:07:22 +0100
Message-Id: <20190913130614.853366270@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5c784c8414fba11b62e12439f11e109fb5751f38 ]

Currently msr_tm_active() is a wrapper around MSR_TM_ACTIVE() if
CONFIG_PPC_TRANSACTIONAL_MEM is set, or it is just a function that
returns false if CONFIG_PPC_TRANSACTIONAL_MEM is not set.

This function is not necessary, since MSR_TM_ACTIVE() just do the same and
could be used, removing the dualism and simplifying the code.

This patchset remove every instance of msr_tm_active() and replaced it
by MSR_TM_ACTIVE().

Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/reg.h |  7 ++++++-
 arch/powerpc/kernel/process.c  | 21 +++++++++------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index e5b314ed054e0..640a4d818772a 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -118,11 +118,16 @@
 #define MSR_TS_S	__MASK(MSR_TS_S_LG)	/*  Transaction Suspended */
 #define MSR_TS_T	__MASK(MSR_TS_T_LG)	/*  Transaction Transactional */
 #define MSR_TS_MASK	(MSR_TS_T | MSR_TS_S)   /* Transaction State bits */
-#define MSR_TM_ACTIVE(x) (((x) & MSR_TS_MASK) != 0) /* Transaction active? */
 #define MSR_TM_RESV(x) (((x) & MSR_TS_MASK) == MSR_TS_MASK) /* Reserved */
 #define MSR_TM_TRANSACTIONAL(x)	(((x) & MSR_TS_MASK) == MSR_TS_T)
 #define MSR_TM_SUSPENDED(x)	(((x) & MSR_TS_MASK) == MSR_TS_S)
 
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+#define MSR_TM_ACTIVE(x) (((x) & MSR_TS_MASK) != 0) /* Transaction active? */
+#else
+#define MSR_TM_ACTIVE(x) 0
+#endif
+
 #if defined(CONFIG_PPC_BOOK3S_64)
 #define MSR_64BIT	MSR_SF
 
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 967c044036718..49c6d474eb5ac 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -102,24 +102,18 @@ static void check_if_tm_restore_required(struct task_struct *tsk)
 	}
 }
 
-static inline bool msr_tm_active(unsigned long msr)
-{
-	return MSR_TM_ACTIVE(msr);
-}
-
 static bool tm_active_with_fp(struct task_struct *tsk)
 {
-	return msr_tm_active(tsk->thread.regs->msr) &&
+	return MSR_TM_ACTIVE(tsk->thread.regs->msr) &&
 		(tsk->thread.ckpt_regs.msr & MSR_FP);
 }
 
 static bool tm_active_with_altivec(struct task_struct *tsk)
 {
-	return msr_tm_active(tsk->thread.regs->msr) &&
+	return MSR_TM_ACTIVE(tsk->thread.regs->msr) &&
 		(tsk->thread.ckpt_regs.msr & MSR_VEC);
 }
 #else
-static inline bool msr_tm_active(unsigned long msr) { return false; }
 static inline void check_if_tm_restore_required(struct task_struct *tsk) { }
 static inline bool tm_active_with_fp(struct task_struct *tsk) { return false; }
 static inline bool tm_active_with_altivec(struct task_struct *tsk) { return false; }
@@ -247,7 +241,8 @@ void enable_kernel_fp(void)
 		 * giveup as this would save  to the 'live' structure not the
 		 * checkpointed structure.
 		 */
-		if(!msr_tm_active(cpumsr) && msr_tm_active(current->thread.regs->msr))
+		if (!MSR_TM_ACTIVE(cpumsr) &&
+		     MSR_TM_ACTIVE(current->thread.regs->msr))
 			return;
 		__giveup_fpu(current);
 	}
@@ -311,7 +306,8 @@ void enable_kernel_altivec(void)
 		 * giveup as this would save  to the 'live' structure not the
 		 * checkpointed structure.
 		 */
-		if(!msr_tm_active(cpumsr) && msr_tm_active(current->thread.regs->msr))
+		if (!MSR_TM_ACTIVE(cpumsr) &&
+		     MSR_TM_ACTIVE(current->thread.regs->msr))
 			return;
 		__giveup_altivec(current);
 	}
@@ -397,7 +393,8 @@ void enable_kernel_vsx(void)
 		 * giveup as this would save  to the 'live' structure not the
 		 * checkpointed structure.
 		 */
-		if(!msr_tm_active(cpumsr) && msr_tm_active(current->thread.regs->msr))
+		if (!MSR_TM_ACTIVE(cpumsr) &&
+		     MSR_TM_ACTIVE(current->thread.regs->msr))
 			return;
 		__giveup_vsx(current);
 	}
@@ -531,7 +528,7 @@ void restore_math(struct pt_regs *regs)
 {
 	unsigned long msr;
 
-	if (!msr_tm_active(regs->msr) &&
+	if (!MSR_TM_ACTIVE(regs->msr) &&
 		!current->thread.load_fp && !loadvec(current->thread))
 		return;
 
-- 
2.20.1



