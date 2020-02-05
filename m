Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 404F11525BA
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 05:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgBEE6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 23:58:17 -0500
Received: from ozlabs.org ([203.11.71.1]:50265 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727355AbgBEE6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Feb 2020 23:58:17 -0500
Received: from neuling.org (localhost [127.0.0.1])
        by ozlabs.org (Postfix) with ESMTP id 48C8TJ6jLSz9sSX;
        Wed,  5 Feb 2020 15:58:12 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=neuling.org;
        s=201811; t=1580878693;
        bh=GDmozdboWPQgEnW8hEeuDAs84CB1jvZHXbegjtv/k2s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gG0Ddt7AJ2KxbJszjY+TV0vWPnULv5lgh8NvKnXFCw1f1Ya5zGyIzdCbUl0+CKoRM
         eZ6JoY2Z/npVSdDK3G7wzxws4u87whMYsYfZ9vRrDsyGoLQ+bGsIRQS/yIGWw9L05O
         pw+AN5uvOe1FTe3aIombqvxDbXLjsOJUGkMKR+c9wScJmBiWqhDeiLUF2BoLJIAqa9
         aTpP2nR90uvRFagiLuah7fUHLyCVzBcZ/aiIHem4/Wv9OVPEAgHt83R/F2TLp40Kt4
         QPFGiWj0so0e8nEbtP/MbFVhT+K5kl8sUCKSu72Ok2zLIt1YwHzy8ckVYlTmFS1ZLl
         +y0OJWHza6XFA==
Received: by neuling.org (Postfix, from userid 1000)
        id AB5D32C0196; Wed,  5 Feb 2020 15:58:12 +1100 (AEDT)
Message-ID: <0af388c6a08d83ee7816fc3fc6053c905dc58344.camel@neuling.org>
Subject: Re: [PATCH v2 1/3] powerpc/tm: Clear the current thread's MSR[TS]
 after treclaim
From:   Michael Neuling <mikey@neuling.org>
To:     Gustavo Luiz Duarte <gustavold@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     gromero@linux.ibm.com, stable@vger.kernel.org
Date:   Wed, 05 Feb 2020 15:58:12 +1100
In-Reply-To: <20200203160906.24482-1-gustavold@linux.ibm.com>
References: <20200203160906.24482-1-gustavold@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Other than the minor things below that I think you need, the patch good wit=
h me.

Acked-by: Michael Neuling <mikey@neuling.org>

> Subject: Re: [PATCH v2 1/3] powerpc/tm: Clear the current thread's MSR[TS=
] after treclaim

The subject should mention "signals".

On Mon, 2020-02-03 at 13:09 -0300, Gustavo Luiz Duarte wrote:
> After a treclaim, we expect to be in non-transactional state. If we don't
> immediately clear the current thread's MSR[TS] and we get preempted, then
> tm_recheckpoint_new_task() will recheckpoint and we get rescheduled in
> suspended transaction state.

It's not "immediately", it's before re-enabling preemption.=20

There is a similar comment in the code that needs to be fixed too.

> When handling a signal caught in transactional state, handle_rt_signal64(=
)
> calls get_tm_stackpointer() that treclaims the transaction using
> tm_reclaim_current() but without clearing the thread's MSR[TS]. This can =
cause
> the TM Bad Thing exception below if later we pagefault and get preempted =
trying
> to access the user's sigframe, using __put_user(). Afterwards, when we ar=
e
> rescheduled back into do_page_fault() (but now in suspended state since t=
he
> thread's MSR[TS] was not cleared), upon executing 'rfid' after completion=
 of
> the page fault handling, the exception is raised because a transition fro=
m
> suspended to non-transactional state is invalid.
>=20
> 	Unexpected TM Bad Thing exception at c00000000000de44 (msr 0x8000000302a=
03031) tm_scratch=3D800000010280b033
> 	Oops: Unrecoverable exception, sig: 6 [#1]
> 	LE PAGE_SIZE=3D64K MMU=3DHash SMP NR_CPUS=3D2048 NUMA pSeries
> 	Modules linked in: nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_d=
efrag_ipv4 ip6_tables ip_tables nft_compat ip_set nf_tables nfnetlink xts v=
mx_crypto sg virtio_balloon
> 	r_mod cdrom virtio_net net_failover virtio_blk virtio_scsi failover dm_m=
irror dm_region_hash dm_log dm_mod
> 	CPU: 25 PID: 15547 Comm: a.out Not tainted 5.4.0-rc2 #32
> 	NIP:  c00000000000de44 LR: c000000000034728 CTR: 0000000000000000
> 	REGS: c00000003fe7bd70 TRAP: 0700   Not tainted  (5.4.0-rc2)
> 	MSR:  8000000302a03031 <SF,VEC,VSX,FP,ME,IR,DR,LE,TM[SE]>  CR: 44000884 =
 XER: 00000000
> 	CFAR: c00000000000dda4 IRQMASK: 0
> 	PACATMSCRATCH: 800000010280b033
> 	GPR00: c000000000034728 c000000f65a17c80 c000000001662800 00007fffacf3fd=
78
> 	GPR04: 0000000000001000 0000000000001000 0000000000000000 c000000f611f8a=
f0
> 	GPR08: 0000000000000000 0000000078006001 0000000000000000 000c0000000000=
00
> 	GPR12: c000000f611f84b0 c00000003ffcb200 0000000000000000 00000000000000=
00
> 	GPR16: 0000000000000000 0000000000000000 0000000000000000 00000000000000=
00
> 	GPR20: 0000000000000000 0000000000000000 0000000000000000 c000000f611f81=
40
> 	GPR24: 0000000000000000 00007fffacf3fd68 c000000f65a17d90 c000000f611f78=
00
> 	GPR28: c000000f65a17e90 c000000f65a17e90 c000000001685e18 00007fffacf3f0=
00
> 	NIP [c00000000000de44] fast_exception_return+0xf4/0x1b0
> 	LR [c000000000034728] handle_rt_signal64+0x78/0xc50
> 	Call Trace:
> 	[c000000f65a17c80] [c000000000034710] handle_rt_signal64+0x60/0xc50 (unr=
eliable)
> 	[c000000f65a17d30] [c000000000023640] do_notify_resume+0x330/0x460
> 	[c000000f65a17e20] [c00000000000dcc4] ret_from_except_lite+0x70/0x74
> 	Instruction dump:
> 	7c4ff120 e8410170 7c5a03a6 38400000 f8410060 e8010070 e8410080 e8610088
> 	60000000 60000000 e8810090 e8210078 <4c000024> 48000000 e8610178 88ed098=
9
> 	---[ end trace 93094aa44b442f87 ]---
>=20
> The simplified sequence of events that triggers the above exception is:
>=20
>   ...				# userspace in NON-TRANSACTIONAL state
>   tbegin			# userspace in TRANSACTIONAL state
>   signal delivery		# kernelspace in SUSPENDED state
>   handle_rt_signal64()
>     get_tm_stackpointer()
>       treclaim			# kernelspace in NON-TRANSACTIONAL state
>     __put_user()
>       page fault happens. We will never get back here because of the TM B=
ad Thing exception.
>=20
>   page fault handling kicks in and we voluntarily preempt ourselves
>   do_page_fault()
>     __schedule()
>       __switch_to(other_task)
>=20
>   our task is rescheduled and we recheckpoint because the thread's MSR[TS=
] was not cleared
>   __switch_to(our_task)
>     switch_to_tm()
>       tm_recheckpoint_new_task()
>         trechkpt			# kernelspace in SUSPENDED state
>=20
>   The page fault handling resumes, but now we are in suspended transactio=
n state
>   do_page_fault()    completes
>   rfid     <----- trying to get back where the page fault happened (we we=
re non-transactional back then)
>   TM Bad Thing			# illegal transition from suspended to non-transactional
>=20
> This patch fixes that issue by clearing the current thread's MSR[TS] just=
 after
> treclaim in get_tm_stackpointer() so that we stay in non-transactional st=
ate in
> case we are preempted. In order to make treclaim and clearing the thread'=
s
> MSR[TS] atomic from a preemption perspective when CONFIG_PREEMPT is set,
> preempt_disable/enable() is used. It's also necessary to save the previou=
s
> value of the thread's MSR before get_tm_stackpointer() is called so that =
it can
> be exposed to the signal handler later in setup_tm_sigcontexts() to infor=
m the
> userspace MSR at the moment of the signal delivery.
>=20
> Found with tm-signal-context-force-tm kernel selftest on P8 KVM.

Why are you mentioning KVM?

>=20
> v2: Fix build failure when tm is disabled.
>=20
> Fixes: 2b0a576d15e0 ("powerpc: Add new transactional memory state to the =
signal context")
> Cc: stable@vger.kernel.org # v3.9
> Signed-off-by: Gustavo Luiz Duarte <gustavold@linux.ibm.com>
> ---
>  arch/powerpc/kernel/signal.c    | 17 +++++++++++++++--
>  arch/powerpc/kernel/signal_32.c | 28 ++++++++++++++--------------
>  arch/powerpc/kernel/signal_64.c | 22 ++++++++++------------
>  3 files changed, 39 insertions(+), 28 deletions(-)
>=20
> diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
> index e6c30cee6abf..1660be1061ac 100644
> --- a/arch/powerpc/kernel/signal.c
> +++ b/arch/powerpc/kernel/signal.c
> @@ -200,14 +200,27 @@ unsigned long get_tm_stackpointer(struct task_struc=
t *tsk)
>  	 * normal/non-checkpointed stack pointer.
>  	 */
> =20
> +	unsigned long ret =3D tsk->thread.regs->gpr[1];
> +
>  #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
>  	BUG_ON(tsk !=3D current);
> =20
>  	if (MSR_TM_ACTIVE(tsk->thread.regs->msr)) {
> +		preempt_disable();
>  		tm_reclaim_current(TM_CAUSE_SIGNAL);
>  		if (MSR_TM_TRANSACTIONAL(tsk->thread.regs->msr))
> -			return tsk->thread.ckpt_regs.gpr[1];
> +			ret =3D tsk->thread.ckpt_regs.gpr[1];
> +
> +		/* If we treclaim, we must immediately clear the current
> +		 * thread's TM bits. Otherwise we might be preempted and have
> +		 * the live MSR[TS] changed behind our back
> +		 * (tm_recheckpoint_new_task() would recheckpoint).
> +		 * Besides, we enter the signal handler in non-transactional
> +		 * state.
> +		 */
> +		tsk->thread.regs->msr &=3D ~MSR_TS_MASK;
> +		preempt_enable();
>  	}
>  #endif
> -	return tsk->thread.regs->gpr[1];
> +	return ret;
>  }
> diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal=
_32.c
> index 98600b276f76..1b090a76b444 100644
> --- a/arch/powerpc/kernel/signal_32.c
> +++ b/arch/powerpc/kernel/signal_32.c
> @@ -489,19 +489,11 @@ static int save_user_regs(struct pt_regs *regs, str=
uct mcontext __user *frame,
>   */
>  static int save_tm_user_regs(struct pt_regs *regs,
>  			     struct mcontext __user *frame,
> -			     struct mcontext __user *tm_frame, int sigret)
> +			     struct mcontext __user *tm_frame, int sigret,
> +			     unsigned long msr)
>  {
> -	unsigned long msr =3D regs->msr;
> -
>  	WARN_ON(tm_suspend_disabled);
> =20
> -	/* Remove TM bits from thread's MSR.  The MSR in the sigcontext
> -	 * just indicates to userland that we were doing a transaction, but we
> -	 * don't want to return in transactional state.  This also ensures
> -	 * that flush_fp_to_thread won't set TIF_RESTORE_TM again.
> -	 */
> -	regs->msr &=3D ~MSR_TS_MASK;
> -
>  	/* Save both sets of general registers */
>  	if (save_general_regs(&current->thread.ckpt_regs, frame)
>  	    || save_general_regs(regs, tm_frame))
> @@ -912,6 +904,10 @@ int handle_rt_signal32(struct ksignal *ksig, sigset_=
t *oldset,
>  	int sigret;
>  	unsigned long tramp;
>  	struct pt_regs *regs =3D tsk->thread.regs;
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +	/* Save the thread's msr before get_tm_stackpointer() changes it */
> +	unsigned long msr =3D regs->msr;
> +#endif
> =20
>  	BUG_ON(tsk !=3D current);
> =20
> @@ -944,13 +940,13 @@ int handle_rt_signal32(struct ksignal *ksig, sigset=
_t *oldset,
> =20
>  #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
>  	tm_frame =3D &rt_sf->uc_transact.uc_mcontext;
> -	if (MSR_TM_ACTIVE(regs->msr)) {
> +	if (MSR_TM_ACTIVE(msr)) {
>  		if (__put_user((unsigned long)&rt_sf->uc_transact,
>  			       &rt_sf->uc.uc_link) ||
>  		    __put_user((unsigned long)tm_frame,
>  			       &rt_sf->uc_transact.uc_regs))
>  			goto badframe;
> -		if (save_tm_user_regs(regs, frame, tm_frame, sigret))
> +		if (save_tm_user_regs(regs, frame, tm_frame, sigret, msr))
>  			goto badframe;
>  	}
>  	else
> @@ -1369,6 +1365,10 @@ int handle_signal32(struct ksignal *ksig, sigset_t=
 *oldset,
>  	int sigret;
>  	unsigned long tramp;
>  	struct pt_regs *regs =3D tsk->thread.regs;
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +	/* Save the thread's msr before get_tm_stackpointer() changes it */
> +	unsigned long msr =3D regs->msr;
> +#endif
> =20
>  	BUG_ON(tsk !=3D current);
> =20
> @@ -1402,9 +1402,9 @@ int handle_signal32(struct ksignal *ksig, sigset_t =
*oldset,
> =20
>  #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
>  	tm_mctx =3D &frame->mctx_transact;
> -	if (MSR_TM_ACTIVE(regs->msr)) {
> +	if (MSR_TM_ACTIVE(msr)) {
>  		if (save_tm_user_regs(regs, &frame->mctx, &frame->mctx_transact,
> -				      sigret))
> +				      sigret, msr))
>  			goto badframe;
>  	}
>  	else
> diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal=
_64.c
> index 117515564ec7..84ed2e77ef9c 100644
> --- a/arch/powerpc/kernel/signal_64.c
> +++ b/arch/powerpc/kernel/signal_64.c
> @@ -192,7 +192,8 @@ static long setup_sigcontext(struct sigcontext __user=
 *sc,
>  static long setup_tm_sigcontexts(struct sigcontext __user *sc,
>  				 struct sigcontext __user *tm_sc,
>  				 struct task_struct *tsk,
> -				 int signr, sigset_t *set, unsigned long handler)
> +				 int signr, sigset_t *set, unsigned long handler,
> +				 unsigned long msr)
>  {
>  	/* When CONFIG_ALTIVEC is set, we _always_ setup v_regs even if the
>  	 * process never used altivec yet (MSR_VEC is zero in pt_regs of
> @@ -207,12 +208,11 @@ static long setup_tm_sigcontexts(struct sigcontext =
__user *sc,
>  	elf_vrreg_t __user *tm_v_regs =3D sigcontext_vmx_regs(tm_sc);
>  #endif
>  	struct pt_regs *regs =3D tsk->thread.regs;
> -	unsigned long msr =3D tsk->thread.regs->msr;
>  	long err =3D 0;
> =20
>  	BUG_ON(tsk !=3D current);
> =20
> -	BUG_ON(!MSR_TM_ACTIVE(regs->msr));
> +	BUG_ON(!MSR_TM_ACTIVE(msr));
> =20
>  	WARN_ON(tm_suspend_disabled);
> =20
> @@ -222,13 +222,6 @@ static long setup_tm_sigcontexts(struct sigcontext _=
_user *sc,
>  	 */
>  	msr |=3D tsk->thread.ckpt_regs.msr & (MSR_FP | MSR_VEC | MSR_VSX);
> =20
> -	/* Remove TM bits from thread's MSR.  The MSR in the sigcontext
> -	 * just indicates to userland that we were doing a transaction, but we
> -	 * don't want to return in transactional state.  This also ensures
> -	 * that flush_fp_to_thread won't set TIF_RESTORE_TM again.
> -	 */
> -	regs->msr &=3D ~MSR_TS_MASK;
> -
>  #ifdef CONFIG_ALTIVEC
>  	err |=3D __put_user(v_regs, &sc->v_regs);
>  	err |=3D __put_user(tm_v_regs, &tm_sc->v_regs);
> @@ -824,6 +817,10 @@ int handle_rt_signal64(struct ksignal *ksig, sigset_=
t *set,
>  	unsigned long newsp =3D 0;
>  	long err =3D 0;
>  	struct pt_regs *regs =3D tsk->thread.regs;
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +	/* Save the thread's msr before get_tm_stackpointer() changes it */
> +	unsigned long msr =3D regs->msr;
> +#endif
> =20
>  	BUG_ON(tsk !=3D current);
> =20
> @@ -841,7 +838,7 @@ int handle_rt_signal64(struct ksignal *ksig, sigset_t=
 *set,
>  	err |=3D __put_user(0, &frame->uc.uc_flags);
>  	err |=3D __save_altstack(&frame->uc.uc_stack, regs->gpr[1]);
>  #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> -	if (MSR_TM_ACTIVE(regs->msr)) {
> +	if (MSR_TM_ACTIVE(msr)) {
>  		/* The ucontext_t passed to userland points to the second
>  		 * ucontext_t (for transactional state) with its uc_link ptr.
>  		 */
> @@ -849,7 +846,8 @@ int handle_rt_signal64(struct ksignal *ksig, sigset_t=
 *set,
>  		err |=3D setup_tm_sigcontexts(&frame->uc.uc_mcontext,
>  					    &frame->uc_transact.uc_mcontext,
>  					    tsk, ksig->sig, NULL,
> -					    (unsigned long)ksig->ka.sa.sa_handler);
> +					    (unsigned long)ksig->ka.sa.sa_handler,
> +					    msr);
>  	} else
>  #endif
>  	{

