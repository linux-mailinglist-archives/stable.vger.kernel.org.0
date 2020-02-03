Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64AE0150A86
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgBCQKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:10:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33478 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727708AbgBCQKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 11:10:14 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013G6S13129731;
        Mon, 3 Feb 2020 11:10:04 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xxn90mcvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 11:09:58 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013G6eLX005410;
        Mon, 3 Feb 2020 16:09:43 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 2xw0y6ppdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 16:09:43 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013G9g0K49807720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 16:09:42 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38520AE063;
        Mon,  3 Feb 2020 16:09:42 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 841FDAE05F;
        Mon,  3 Feb 2020 16:09:40 +0000 (GMT)
Received: from moss.ibm.com (unknown [9.85.192.4])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 16:09:40 +0000 (GMT)
From:   Gustavo Luiz Duarte <gustavold@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     mikey@neuling.org, gromero@linux.ibm.com,
        Gustavo Luiz Duarte <gustavold@linux.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/3] powerpc/tm: Clear the current thread's MSR[TS] after treclaim
Date:   Mon,  3 Feb 2020 13:09:04 -0300
Message-Id: <20200203160906.24482-1-gustavold@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_05:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=1
 mlxscore=0 adultscore=0 mlxlogscore=836 spamscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030119
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After a treclaim, we expect to be in non-transactional state. If we don't
immediately clear the current thread's MSR[TS] and we get preempted, then
tm_recheckpoint_new_task() will recheckpoint and we get rescheduled in
suspended transaction state.

When handling a signal caught in transactional state, handle_rt_signal64()
calls get_tm_stackpointer() that treclaims the transaction using
tm_reclaim_current() but without clearing the thread's MSR[TS]. This can cause
the TM Bad Thing exception below if later we pagefault and get preempted trying
to access the user's sigframe, using __put_user(). Afterwards, when we are
rescheduled back into do_page_fault() (but now in suspended state since the
thread's MSR[TS] was not cleared), upon executing 'rfid' after completion of
the page fault handling, the exception is raised because a transition from
suspended to non-transactional state is invalid.

	Unexpected TM Bad Thing exception at c00000000000de44 (msr 0x8000000302a03031) tm_scratch=800000010280b033
	Oops: Unrecoverable exception, sig: 6 [#1]
	LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
	Modules linked in: nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6_tables ip_tables nft_compat ip_set nf_tables nfnetlink xts vmx_crypto sg virtio_balloon
	r_mod cdrom virtio_net net_failover virtio_blk virtio_scsi failover dm_mirror dm_region_hash dm_log dm_mod
	CPU: 25 PID: 15547 Comm: a.out Not tainted 5.4.0-rc2 #32
	NIP:  c00000000000de44 LR: c000000000034728 CTR: 0000000000000000
	REGS: c00000003fe7bd70 TRAP: 0700   Not tainted  (5.4.0-rc2)
	MSR:  8000000302a03031 <SF,VEC,VSX,FP,ME,IR,DR,LE,TM[SE]>  CR: 44000884  XER: 00000000
	CFAR: c00000000000dda4 IRQMASK: 0
	PACATMSCRATCH: 800000010280b033
	GPR00: c000000000034728 c000000f65a17c80 c000000001662800 00007fffacf3fd78
	GPR04: 0000000000001000 0000000000001000 0000000000000000 c000000f611f8af0
	GPR08: 0000000000000000 0000000078006001 0000000000000000 000c000000000000
	GPR12: c000000f611f84b0 c00000003ffcb200 0000000000000000 0000000000000000
	GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
	GPR20: 0000000000000000 0000000000000000 0000000000000000 c000000f611f8140
	GPR24: 0000000000000000 00007fffacf3fd68 c000000f65a17d90 c000000f611f7800
	GPR28: c000000f65a17e90 c000000f65a17e90 c000000001685e18 00007fffacf3f000
	NIP [c00000000000de44] fast_exception_return+0xf4/0x1b0
	LR [c000000000034728] handle_rt_signal64+0x78/0xc50
	Call Trace:
	[c000000f65a17c80] [c000000000034710] handle_rt_signal64+0x60/0xc50 (unreliable)
	[c000000f65a17d30] [c000000000023640] do_notify_resume+0x330/0x460
	[c000000f65a17e20] [c00000000000dcc4] ret_from_except_lite+0x70/0x74
	Instruction dump:
	7c4ff120 e8410170 7c5a03a6 38400000 f8410060 e8010070 e8410080 e8610088
	60000000 60000000 e8810090 e8210078 <4c000024> 48000000 e8610178 88ed0989
	---[ end trace 93094aa44b442f87 ]---

The simplified sequence of events that triggers the above exception is:

  ...				# userspace in NON-TRANSACTIONAL state
  tbegin			# userspace in TRANSACTIONAL state
  signal delivery		# kernelspace in SUSPENDED state
  handle_rt_signal64()
    get_tm_stackpointer()
      treclaim			# kernelspace in NON-TRANSACTIONAL state
    __put_user()
      page fault happens. We will never get back here because of the TM Bad Thing exception.

  page fault handling kicks in and we voluntarily preempt ourselves
  do_page_fault()
    __schedule()
      __switch_to(other_task)

  our task is rescheduled and we recheckpoint because the thread's MSR[TS] was not cleared
  __switch_to(our_task)
    switch_to_tm()
      tm_recheckpoint_new_task()
        trechkpt			# kernelspace in SUSPENDED state

  The page fault handling resumes, but now we are in suspended transaction state
  do_page_fault()    completes
  rfid     <----- trying to get back where the page fault happened (we were non-transactional back then)
  TM Bad Thing			# illegal transition from suspended to non-transactional

This patch fixes that issue by clearing the current thread's MSR[TS] just after
treclaim in get_tm_stackpointer() so that we stay in non-transactional state in
case we are preempted. In order to make treclaim and clearing the thread's
MSR[TS] atomic from a preemption perspective when CONFIG_PREEMPT is set,
preempt_disable/enable() is used. It's also necessary to save the previous
value of the thread's MSR before get_tm_stackpointer() is called so that it can
be exposed to the signal handler later in setup_tm_sigcontexts() to inform the
userspace MSR at the moment of the signal delivery.

Found with tm-signal-context-force-tm kernel selftest on P8 KVM.

v2: Fix build failure when tm is disabled.

Fixes: 2b0a576d15e0 ("powerpc: Add new transactional memory state to the signal context")
Cc: stable@vger.kernel.org # v3.9
Signed-off-by: Gustavo Luiz Duarte <gustavold@linux.ibm.com>
---
 arch/powerpc/kernel/signal.c    | 17 +++++++++++++++--
 arch/powerpc/kernel/signal_32.c | 28 ++++++++++++++--------------
 arch/powerpc/kernel/signal_64.c | 22 ++++++++++------------
 3 files changed, 39 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index e6c30cee6abf..1660be1061ac 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -200,14 +200,27 @@ unsigned long get_tm_stackpointer(struct task_struct *tsk)
 	 * normal/non-checkpointed stack pointer.
 	 */
 
+	unsigned long ret = tsk->thread.regs->gpr[1];
+
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	BUG_ON(tsk != current);
 
 	if (MSR_TM_ACTIVE(tsk->thread.regs->msr)) {
+		preempt_disable();
 		tm_reclaim_current(TM_CAUSE_SIGNAL);
 		if (MSR_TM_TRANSACTIONAL(tsk->thread.regs->msr))
-			return tsk->thread.ckpt_regs.gpr[1];
+			ret = tsk->thread.ckpt_regs.gpr[1];
+
+		/* If we treclaim, we must immediately clear the current
+		 * thread's TM bits. Otherwise we might be preempted and have
+		 * the live MSR[TS] changed behind our back
+		 * (tm_recheckpoint_new_task() would recheckpoint).
+		 * Besides, we enter the signal handler in non-transactional
+		 * state.
+		 */
+		tsk->thread.regs->msr &= ~MSR_TS_MASK;
+		preempt_enable();
 	}
 #endif
-	return tsk->thread.regs->gpr[1];
+	return ret;
 }
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index 98600b276f76..1b090a76b444 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -489,19 +489,11 @@ static int save_user_regs(struct pt_regs *regs, struct mcontext __user *frame,
  */
 static int save_tm_user_regs(struct pt_regs *regs,
 			     struct mcontext __user *frame,
-			     struct mcontext __user *tm_frame, int sigret)
+			     struct mcontext __user *tm_frame, int sigret,
+			     unsigned long msr)
 {
-	unsigned long msr = regs->msr;
-
 	WARN_ON(tm_suspend_disabled);
 
-	/* Remove TM bits from thread's MSR.  The MSR in the sigcontext
-	 * just indicates to userland that we were doing a transaction, but we
-	 * don't want to return in transactional state.  This also ensures
-	 * that flush_fp_to_thread won't set TIF_RESTORE_TM again.
-	 */
-	regs->msr &= ~MSR_TS_MASK;
-
 	/* Save both sets of general registers */
 	if (save_general_regs(&current->thread.ckpt_regs, frame)
 	    || save_general_regs(regs, tm_frame))
@@ -912,6 +904,10 @@ int handle_rt_signal32(struct ksignal *ksig, sigset_t *oldset,
 	int sigret;
 	unsigned long tramp;
 	struct pt_regs *regs = tsk->thread.regs;
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	/* Save the thread's msr before get_tm_stackpointer() changes it */
+	unsigned long msr = regs->msr;
+#endif
 
 	BUG_ON(tsk != current);
 
@@ -944,13 +940,13 @@ int handle_rt_signal32(struct ksignal *ksig, sigset_t *oldset,
 
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	tm_frame = &rt_sf->uc_transact.uc_mcontext;
-	if (MSR_TM_ACTIVE(regs->msr)) {
+	if (MSR_TM_ACTIVE(msr)) {
 		if (__put_user((unsigned long)&rt_sf->uc_transact,
 			       &rt_sf->uc.uc_link) ||
 		    __put_user((unsigned long)tm_frame,
 			       &rt_sf->uc_transact.uc_regs))
 			goto badframe;
-		if (save_tm_user_regs(regs, frame, tm_frame, sigret))
+		if (save_tm_user_regs(regs, frame, tm_frame, sigret, msr))
 			goto badframe;
 	}
 	else
@@ -1369,6 +1365,10 @@ int handle_signal32(struct ksignal *ksig, sigset_t *oldset,
 	int sigret;
 	unsigned long tramp;
 	struct pt_regs *regs = tsk->thread.regs;
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	/* Save the thread's msr before get_tm_stackpointer() changes it */
+	unsigned long msr = regs->msr;
+#endif
 
 	BUG_ON(tsk != current);
 
@@ -1402,9 +1402,9 @@ int handle_signal32(struct ksignal *ksig, sigset_t *oldset,
 
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	tm_mctx = &frame->mctx_transact;
-	if (MSR_TM_ACTIVE(regs->msr)) {
+	if (MSR_TM_ACTIVE(msr)) {
 		if (save_tm_user_regs(regs, &frame->mctx, &frame->mctx_transact,
-				      sigret))
+				      sigret, msr))
 			goto badframe;
 	}
 	else
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index 117515564ec7..84ed2e77ef9c 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -192,7 +192,8 @@ static long setup_sigcontext(struct sigcontext __user *sc,
 static long setup_tm_sigcontexts(struct sigcontext __user *sc,
 				 struct sigcontext __user *tm_sc,
 				 struct task_struct *tsk,
-				 int signr, sigset_t *set, unsigned long handler)
+				 int signr, sigset_t *set, unsigned long handler,
+				 unsigned long msr)
 {
 	/* When CONFIG_ALTIVEC is set, we _always_ setup v_regs even if the
 	 * process never used altivec yet (MSR_VEC is zero in pt_regs of
@@ -207,12 +208,11 @@ static long setup_tm_sigcontexts(struct sigcontext __user *sc,
 	elf_vrreg_t __user *tm_v_regs = sigcontext_vmx_regs(tm_sc);
 #endif
 	struct pt_regs *regs = tsk->thread.regs;
-	unsigned long msr = tsk->thread.regs->msr;
 	long err = 0;
 
 	BUG_ON(tsk != current);
 
-	BUG_ON(!MSR_TM_ACTIVE(regs->msr));
+	BUG_ON(!MSR_TM_ACTIVE(msr));
 
 	WARN_ON(tm_suspend_disabled);
 
@@ -222,13 +222,6 @@ static long setup_tm_sigcontexts(struct sigcontext __user *sc,
 	 */
 	msr |= tsk->thread.ckpt_regs.msr & (MSR_FP | MSR_VEC | MSR_VSX);
 
-	/* Remove TM bits from thread's MSR.  The MSR in the sigcontext
-	 * just indicates to userland that we were doing a transaction, but we
-	 * don't want to return in transactional state.  This also ensures
-	 * that flush_fp_to_thread won't set TIF_RESTORE_TM again.
-	 */
-	regs->msr &= ~MSR_TS_MASK;
-
 #ifdef CONFIG_ALTIVEC
 	err |= __put_user(v_regs, &sc->v_regs);
 	err |= __put_user(tm_v_regs, &tm_sc->v_regs);
@@ -824,6 +817,10 @@ int handle_rt_signal64(struct ksignal *ksig, sigset_t *set,
 	unsigned long newsp = 0;
 	long err = 0;
 	struct pt_regs *regs = tsk->thread.regs;
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	/* Save the thread's msr before get_tm_stackpointer() changes it */
+	unsigned long msr = regs->msr;
+#endif
 
 	BUG_ON(tsk != current);
 
@@ -841,7 +838,7 @@ int handle_rt_signal64(struct ksignal *ksig, sigset_t *set,
 	err |= __put_user(0, &frame->uc.uc_flags);
 	err |= __save_altstack(&frame->uc.uc_stack, regs->gpr[1]);
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
-	if (MSR_TM_ACTIVE(regs->msr)) {
+	if (MSR_TM_ACTIVE(msr)) {
 		/* The ucontext_t passed to userland points to the second
 		 * ucontext_t (for transactional state) with its uc_link ptr.
 		 */
@@ -849,7 +846,8 @@ int handle_rt_signal64(struct ksignal *ksig, sigset_t *set,
 		err |= setup_tm_sigcontexts(&frame->uc.uc_mcontext,
 					    &frame->uc_transact.uc_mcontext,
 					    tsk, ksig->sig, NULL,
-					    (unsigned long)ksig->ka.sa.sa_handler);
+					    (unsigned long)ksig->ka.sa.sa_handler,
+					    msr);
 	} else
 #endif
 	{
-- 
2.21.1

