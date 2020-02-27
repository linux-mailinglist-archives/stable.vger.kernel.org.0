Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409E2171F37
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731713AbgB0OdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:33:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732498AbgB0OAx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:00:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DE552073D;
        Thu, 27 Feb 2020 14:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812052;
        bh=5FV+k+ngRidW9PmWVh+vHJp+W5gO391FAPAFV+eiRjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRXG53UyJPX2LdngkcfJ9QVR/AP2h52i32elhM5IkzmEYvCiOiNfZHBHIuG/PV2JD
         fegbTaMrURlR/8CDiGrqP1WZ7ITdni9HlTBarPPB8VFqivT1VRSv+GXMH+cqAm2nF4
         MjZr+FYTi/ATRKQAD8mn4hH2Zf9nTgL0IAgBcB/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Neuling <mikey@neuling.org>,
        Cyril Bur <cyrilbur@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 204/237] powerpc/tm: P9 disable transactionally suspended sigcontexts
Date:   Thu, 27 Feb 2020 14:36:58 +0100
Message-Id: <20200227132311.259765788@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Neuling <mikey@neuling.org>

[ Upstream commit 92fb8690bd04cb421d987d246deac60eef85d272 ]

Unfortunately userspace can construct a sigcontext which enables
suspend. Thus userspace can force Linux into a path where trechkpt is
executed.

This patch blocks this from happening on POWER9 by sanity checking
sigcontexts passed in.

ptrace doesn't have this problem as only MSR SE and BE can be changed
via ptrace.

This patch also adds a number of WARN_ON()s in case we ever enter
suspend when we shouldn't. This should not happen, but if it does the
symptoms are soft lockup warnings which are not obviously TM related,
so the WARN_ON()s should make it obvious what's happening.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Cyril Bur <cyrilbur@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/process.c   | 2 ++
 arch/powerpc/kernel/signal_32.c | 4 ++++
 arch/powerpc/kernel/signal_64.c | 5 +++++
 3 files changed, 11 insertions(+)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index ba0d4f9a99bac..1615d60cd55cb 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -903,6 +903,8 @@ static inline void tm_reclaim_task(struct task_struct *tsk)
 	if (!MSR_TM_ACTIVE(thr->regs->msr))
 		goto out_and_saveregs;
 
+	WARN_ON(tm_suspend_disabled);
+
 	TM_DEBUG("--- tm_reclaim on pid %d (NIP=%lx, "
 		 "ccr=%lx, msr=%lx, trap=%lx)\n",
 		 tsk->pid, thr->regs->nip,
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index a03fc3109fa55..7157cb6951512 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -519,6 +519,8 @@ static int save_tm_user_regs(struct pt_regs *regs,
 {
 	unsigned long msr = regs->msr;
 
+	WARN_ON(tm_suspend_disabled);
+
 	/* Remove TM bits from thread's MSR.  The MSR in the sigcontext
 	 * just indicates to userland that we were doing a transaction, but we
 	 * don't want to return in transactional state.  This also ensures
@@ -769,6 +771,8 @@ static long restore_tm_user_regs(struct pt_regs *regs,
 	int i;
 #endif
 
+	if (tm_suspend_disabled)
+		return 1;
 	/*
 	 * restore general registers but not including MSR or SOFTE. Also
 	 * take care of keeping r2 (TLS) intact if not a signal.
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index b75bf6e74209e..2d52fed72e216 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -214,6 +214,8 @@ static long setup_tm_sigcontexts(struct sigcontext __user *sc,
 
 	BUG_ON(!MSR_TM_ACTIVE(regs->msr));
 
+	WARN_ON(tm_suspend_disabled);
+
 	/* Remove TM bits from thread's MSR.  The MSR in the sigcontext
 	 * just indicates to userland that we were doing a transaction, but we
 	 * don't want to return in transactional state.  This also ensures
@@ -430,6 +432,9 @@ static long restore_tm_sigcontexts(struct task_struct *tsk,
 
 	BUG_ON(tsk != current);
 
+	if (tm_suspend_disabled)
+		return -EINVAL;
+
 	/* copy the GPRs */
 	err |= __copy_from_user(regs->gpr, tm_sc->gp_regs, sizeof(regs->gpr));
 	err |= __copy_from_user(&tsk->thread.ckpt_regs, sc->gp_regs,
-- 
2.20.1



