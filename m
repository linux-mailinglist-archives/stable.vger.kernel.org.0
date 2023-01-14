Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C6366AA93
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjANJlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjANJk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:40:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1B57699;
        Sat, 14 Jan 2023 01:40:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07F94B80835;
        Sat, 14 Jan 2023 09:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BF4C433EF;
        Sat, 14 Jan 2023 09:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689241;
        bh=owq3Bo3tBCd8Lpc1D+teaTFeksBMxoTVilY5KWZZqjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jX8UW30v+Wn3HITcOUm3cyNVbOKTM1ke4A3Rv0rbxGY5nisnbSXG6a8wEgGPeKBdJ
         SC56IznCWQCYQ1BbrfBnWyseSR1GBKNQTwnJCBGNpp6STFytTKrRSeGSKSUrz8s58C
         A0qJ0hmCUn8ymka2jw9iUQj+w+c3QyKJ5NOT3034=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.1.6
Date:   Sat, 14 Jan 2023 10:40:31 +0100
Message-Id: <1673689231179166@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <1673689231200135@kroah.com>
References: <1673689231200135@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index ddbd2fc917c5..19e8c6dec6e5 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 1
-SUBLEVEL = 5
+SUBLEVEL = 6
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/parisc/include/uapi/asm/mman.h b/arch/parisc/include/uapi/asm/mman.h
index 22133a6a506e..68c44f99bc93 100644
--- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -49,6 +49,19 @@
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
 
+#define MADV_MERGEABLE   12		/* KSM may merge identical pages */
+#define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
+
+#define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
+#define MADV_NOHUGEPAGE 15		/* Not worth backing with hugepages */
+
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
+
+#define MADV_WIPEONFORK 18		/* Zero memory on fork, child only */
+#define MADV_KEEPONFORK 19		/* Undo MADV_WIPEONFORK */
+
 #define MADV_COLD	20		/* deactivate these pages */
 #define MADV_PAGEOUT	21		/* reclaim these pages */
 
@@ -57,27 +70,13 @@
 
 #define MADV_DONTNEED_LOCKED	24	/* like DONTNEED, but drop locked pages too */
 
-#define MADV_MERGEABLE   65		/* KSM may merge identical pages */
-#define MADV_UNMERGEABLE 66		/* KSM may not merge identical pages */
-
-#define MADV_HUGEPAGE	67		/* Worth backing with hugepages */
-#define MADV_NOHUGEPAGE	68		/* Not worth backing with hugepages */
-
-#define MADV_DONTDUMP   69		/* Explicity exclude from the core dump,
-					   overrides the coredump filter bits */
-#define MADV_DODUMP	70		/* Clear the MADV_NODUMP flag */
-
-#define MADV_WIPEONFORK 71		/* Zero memory on fork, child only */
-#define MADV_KEEPONFORK 72		/* Undo MADV_WIPEONFORK */
-
-#define MADV_COLLAPSE	73		/* Synchronous hugepage collapse */
+#define MADV_COLLAPSE	25		/* Synchronous hugepage collapse */
 
 #define MADV_HWPOISON     100		/* poison a page for testing */
 #define MADV_SOFT_OFFLINE 101		/* soft offline page for testing */
 
 /* compatibility flags */
 #define MAP_FILE	0
-#define MAP_VARIABLE	0
 
 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index 848b0702005d..09a34b07f02e 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -465,3 +465,31 @@ asmlinkage long parisc_inotify_init1(int flags)
 	flags = FIX_O_NONBLOCK(flags);
 	return sys_inotify_init1(flags);
 }
+
+/*
+ * madvise() wrapper
+ *
+ * Up to kernel v6.1 parisc has different values than all other
+ * platforms for the MADV_xxx flags listed below.
+ * To keep binary compatibility with existing userspace programs
+ * translate the former values to the new values.
+ *
+ * XXX: Remove this wrapper in year 2025 (or later)
+ */
+
+asmlinkage notrace long parisc_madvise(unsigned long start, size_t len_in, int behavior)
+{
+	switch (behavior) {
+	case 65: behavior = MADV_MERGEABLE;	break;
+	case 66: behavior = MADV_UNMERGEABLE;	break;
+	case 67: behavior = MADV_HUGEPAGE;	break;
+	case 68: behavior = MADV_NOHUGEPAGE;	break;
+	case 69: behavior = MADV_DONTDUMP;	break;
+	case 70: behavior = MADV_DODUMP;	break;
+	case 71: behavior = MADV_WIPEONFORK;	break;
+	case 72: behavior = MADV_KEEPONFORK;	break;
+	case 73: behavior = MADV_COLLAPSE;	break;
+	}
+
+	return sys_madvise(start, len_in, behavior);
+}
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index 8a99c998da9b..0e42fceb2d5e 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -131,7 +131,7 @@
 116	common	sysinfo			sys_sysinfo			compat_sys_sysinfo
 117	common	shutdown		sys_shutdown
 118	common	fsync			sys_fsync
-119	common	madvise			sys_madvise
+119	common	madvise			parisc_madvise
 120	common	clone			sys_clone_wrapper
 121	common	setdomainname		sys_setdomainname
 122	common	sendfile		sys_sendfile			compat_sys_sendfile
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index d00db56a8868..9baa89a8877d 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -391,8 +391,6 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
 {
 	struct fpstate *kstate = gfpu->fpstate;
 	const union fpregs_state *ustate = buf;
-	struct pkru_state *xpkru;
-	int ret;
 
 	if (!cpu_feature_enabled(X86_FEATURE_XSAVE)) {
 		if (ustate->xsave.header.xfeatures & ~XFEATURE_MASK_FPSSE)
@@ -406,16 +404,15 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
 	if (ustate->xsave.header.xfeatures & ~xcr0)
 		return -EINVAL;
 
-	ret = copy_uabi_from_kernel_to_xstate(kstate, ustate);
-	if (ret)
-		return ret;
+	/*
+	 * Nullify @vpkru to preserve its current value if PKRU's bit isn't set
+	 * in the header.  KVM's odd ABI is to leave PKRU untouched in this
+	 * case (all other components are eventually re-initialized).
+	 */
+	if (!(ustate->xsave.header.xfeatures & XFEATURE_MASK_PKRU))
+		vpkru = NULL;
 
-	/* Retrieve PKRU if not in init state */
-	if (kstate->regs.xsave.header.xfeatures & XFEATURE_MASK_PKRU) {
-		xpkru = get_xsave_addr(&kstate->regs.xsave, XFEATURE_PKRU);
-		*vpkru = xpkru->pkru;
-	}
-	return 0;
+	return copy_uabi_from_kernel_to_xstate(kstate, ustate, vpkru);
 }
 EXPORT_SYMBOL_GPL(fpu_copy_uabi_to_guest_fpstate);
 #endif /* CONFIG_KVM */
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index 75ffaef8c299..6d056b68f4ed 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -167,7 +167,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	}
 
 	fpu_force_restore(fpu);
-	ret = copy_uabi_from_kernel_to_xstate(fpu->fpstate, kbuf ?: tmpbuf);
+	ret = copy_uabi_from_kernel_to_xstate(fpu->fpstate, kbuf ?: tmpbuf, &target->thread.pkru);
 
 out:
 	vfree(tmpbuf);
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 91d4b6de58ab..558076dbde5b 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -396,7 +396,7 @@ static bool __fpu_restore_sig(void __user *buf, void __user *buf_fx,
 
 	fpregs = &fpu->fpstate->regs;
 	if (use_xsave() && !fx_only) {
-		if (copy_sigframe_from_user_to_xstate(fpu->fpstate, buf_fx))
+		if (copy_sigframe_from_user_to_xstate(tsk, buf_fx))
 			return false;
 	} else {
 		if (__copy_from_user(&fpregs->fxsave, buf_fx,
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index c2dde46a538e..714166cc25f2 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1200,8 +1200,36 @@ static int copy_from_buffer(void *dst, unsigned int offset, unsigned int size,
 }
 
 
+/**
+ * copy_uabi_to_xstate - Copy a UABI format buffer to the kernel xstate
+ * @fpstate:	The fpstate buffer to copy to
+ * @kbuf:	The UABI format buffer, if it comes from the kernel
+ * @ubuf:	The UABI format buffer, if it comes from userspace
+ * @pkru:	The location to write the PKRU value to
+ *
+ * Converts from the UABI format into the kernel internal hardware
+ * dependent format.
+ *
+ * This function ultimately has three different callers with distinct PKRU
+ * behavior.
+ * 1.	When called from sigreturn the PKRU register will be restored from
+ *	@fpstate via an XRSTOR. Correctly copying the UABI format buffer to
+ *	@fpstate is sufficient to cover this case, but the caller will also
+ *	pass a pointer to the thread_struct's pkru field in @pkru and updating
+ *	it is harmless.
+ * 2.	When called from ptrace the PKRU register will be restored from the
+ *	thread_struct's pkru field. A pointer to that is passed in @pkru.
+ *	The kernel will restore it manually, so the XRSTOR behavior that resets
+ *	the PKRU register to the hardware init value (0) if the corresponding
+ *	xfeatures bit is not set is emulated here.
+ * 3.	When called from KVM the PKRU register will be restored from the vcpu's
+ *	pkru field. A pointer to that is passed in @pkru. KVM hasn't used
+ *	XRSTOR and hasn't had the PKRU resetting behavior described above. To
+ *	preserve that KVM behavior, it passes NULL for @pkru if the xfeatures
+ *	bit is not set.
+ */
 static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
-			       const void __user *ubuf)
+			       const void __user *ubuf, u32 *pkru)
 {
 	struct xregs_state *xsave = &fpstate->regs.xsave;
 	unsigned int offset, size;
@@ -1250,6 +1278,20 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
 		}
 	}
 
+	if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
+		struct pkru_state *xpkru;
+
+		xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
+		*pkru = xpkru->pkru;
+	} else {
+		/*
+		 * KVM may pass NULL here to indicate that it does not need
+		 * PKRU updated.
+		 */
+		if (pkru)
+			*pkru = 0;
+	}
+
 	/*
 	 * The state that came in from userspace was user-state only.
 	 * Mask all the user states out of 'xfeatures':
@@ -1268,9 +1310,9 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
  * Convert from a ptrace standard-format kernel buffer to kernel XSAVE[S]
  * format and copy to the target thread. Used by ptrace and KVM.
  */
-int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf)
+int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf, u32 *pkru)
 {
-	return copy_uabi_to_xstate(fpstate, kbuf, NULL);
+	return copy_uabi_to_xstate(fpstate, kbuf, NULL, pkru);
 }
 
 /*
@@ -1278,10 +1320,10 @@ int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf)
  * XSAVE[S] format and copy to the target thread. This is called from the
  * sigreturn() and rt_sigreturn() system calls.
  */
-int copy_sigframe_from_user_to_xstate(struct fpstate *fpstate,
+int copy_sigframe_from_user_to_xstate(struct task_struct *tsk,
 				      const void __user *ubuf)
 {
-	return copy_uabi_to_xstate(fpstate, NULL, ubuf);
+	return copy_uabi_to_xstate(tsk->thread.fpu.fpstate, NULL, ubuf, &tsk->thread.pkru);
 }
 
 static bool validate_independent_components(u64 mask)
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 5ad47031383b..a4ecb04d8d64 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -46,8 +46,8 @@ extern void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
 				      u32 pkru_val, enum xstate_copy_mode copy_mode);
 extern void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
 				    enum xstate_copy_mode mode);
-extern int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf);
-extern int copy_sigframe_from_user_to_xstate(struct fpstate *fpstate, const void __user *ubuf);
+extern int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf, u32 *pkru);
+extern int copy_sigframe_from_user_to_xstate(struct task_struct *tsk, const void __user *ubuf);
 
 
 extern void fpu__init_cpu_xstate(void);
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 34d1cd5883fb..c7329523a10f 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -928,7 +928,7 @@ nfsd4_read(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	 * the client wants us to do more in this compound:
 	 */
 	if (!nfsd4_last_compound_op(rqstp))
-		__clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
+		clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
 
 	/* check stateid */
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
@@ -2615,12 +2615,11 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 	cstate->minorversion = args->minorversion;
 	fh_init(current_fh, NFS4_FHSIZE);
 	fh_init(save_fh, NFS4_FHSIZE);
-
 	/*
 	 * Don't use the deferral mechanism for NFSv4; compounds make it
 	 * too hard to avoid non-idempotency problems.
 	 */
-	__clear_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
+	clear_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
 
 	/*
 	 * According to RFC3010, this takes precedence over all other errors.
@@ -2742,7 +2741,7 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 out:
 	cstate->status = status;
 	/* Reset deferral mechanism for RPC deferrals */
-	__set_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
+	set_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 78849646fe83..8377e14b8fba 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2464,7 +2464,7 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 	argp->rqstp->rq_cachetype = cachethis ? RC_REPLBUFF : RC_NOCACHE;
 
 	if (readcount > 1 || max_reply > PAGE_SIZE - auth_slack)
-		__clear_bit(RQ_SPLICE_OK, &argp->rqstp->rq_flags);
+		clear_bit(RQ_SPLICE_OK, &argp->rqstp->rq_flags);
 
 	return true;
 }
diff --git a/init/Kconfig b/init/Kconfig
index 94125d3b6893..0c214af99085 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -892,13 +892,17 @@ config CC_IMPLICIT_FALLTHROUGH
 	default "-Wimplicit-fallthrough=5" if CC_IS_GCC && $(cc-option,-Wimplicit-fallthrough=5)
 	default "-Wimplicit-fallthrough" if CC_IS_CLANG && $(cc-option,-Wunreachable-code-fallthrough)
 
-# Currently, disable gcc-12 array-bounds globally.
+# Currently, disable gcc-11,12 array-bounds globally.
 # We may want to target only particular configurations some day.
+config GCC11_NO_ARRAY_BOUNDS
+	def_bool y
+
 config GCC12_NO_ARRAY_BOUNDS
 	def_bool y
 
 config CC_NO_ARRAY_BOUNDS
 	bool
+	default y if CC_IS_GCC && GCC_VERSION >= 110000 && GCC_VERSION < 120000 && GCC11_NO_ARRAY_BOUNDS
 	default y if CC_IS_GCC && GCC_VERSION >= 120000 && GCC_VERSION < 130000 && GCC12_NO_ARRAY_BOUNDS
 
 #
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 4a27dfb1ba0f..c82532e20699 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1132,6 +1132,11 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 			return -ENOENT;
 		}
 
+		if (new && new->ops == &noqueue_qdisc_ops) {
+			NL_SET_ERR_MSG(extack, "Cannot assign noqueue to a class");
+			return -EINVAL;
+		}
+
 		err = cops->graft(parent, cl, new, &old, extack);
 		if (err)
 			return err;
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 9a5db285d4ae..bdc34ea0d939 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -900,7 +900,7 @@ unwrap_integ_data(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq, struct g
 	 * rejecting the server-computed MIC in this somewhat rare case,
 	 * do not use splice with the GSS integrity service.
 	 */
-	__clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
+	clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
 
 	/* Did we already verify the signature on the original pass through? */
 	if (rqstp->rq_deferred)
@@ -972,7 +972,7 @@ unwrap_priv_data(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq, struct gs
 	int pad, remaining_len, offset;
 	u32 rseqno;
 
-	__clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
+	clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
 
 	priv_len = svc_getnl(&buf->head[0]);
 	if (rqstp->rq_deferred) {
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 149171774bc6..24577d1b9907 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1244,10 +1244,10 @@ svc_process_common(struct svc_rqst *rqstp, struct kvec *argv, struct kvec *resv)
 		goto err_short_len;
 
 	/* Will be turned off by GSS integrity and privacy services */
-	__set_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
+	set_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
 	/* Will be turned off only when NFSv4 Sessions are used */
-	__set_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
-	__clear_bit(RQ_DROPME, &rqstp->rq_flags);
+	set_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
+	clear_bit(RQ_DROPME, &rqstp->rq_flags);
 
 	svc_putu32(resv, rqstp->rq_xid);
 
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 2106003645a7..c2ce12538008 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1238,7 +1238,7 @@ static struct cache_deferred_req *svc_defer(struct cache_req *req)
 	trace_svc_defer(rqstp);
 	svc_xprt_get(rqstp->rq_xprt);
 	dr->xprt = rqstp->rq_xprt;
-	__set_bit(RQ_DROPME, &rqstp->rq_flags);
+	set_bit(RQ_DROPME, &rqstp->rq_flags);
 
 	dr->handle.revisit = svc_revisit;
 	return &dr->handle;
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 2fc98fea59b4..e833103f4629 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -298,9 +298,9 @@ static void svc_sock_setbufsize(struct svc_sock *svsk, unsigned int nreqs)
 static void svc_sock_secure_port(struct svc_rqst *rqstp)
 {
 	if (svc_port_is_privileged(svc_addr(rqstp)))
-		__set_bit(RQ_SECURE, &rqstp->rq_flags);
+		set_bit(RQ_SECURE, &rqstp->rq_flags);
 	else
-		__clear_bit(RQ_SECURE, &rqstp->rq_flags);
+		clear_bit(RQ_SECURE, &rqstp->rq_flags);
 }
 
 /*
@@ -1008,9 +1008,9 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp)
 	rqstp->rq_xprt_ctxt   = NULL;
 	rqstp->rq_prot	      = IPPROTO_TCP;
 	if (test_bit(XPT_LOCAL, &svsk->sk_xprt.xpt_flags))
-		__set_bit(RQ_LOCAL, &rqstp->rq_flags);
+		set_bit(RQ_LOCAL, &rqstp->rq_flags);
 	else
-		__clear_bit(RQ_LOCAL, &rqstp->rq_flags);
+		clear_bit(RQ_LOCAL, &rqstp->rq_flags);
 
 	p = (__be32 *)rqstp->rq_arg.head[0].iov_base;
 	calldir = p[1];
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 199fa012f18a..94b20fb47135 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -602,7 +602,7 @@ static int svc_rdma_has_wspace(struct svc_xprt *xprt)
 
 static void svc_rdma_secure_port(struct svc_rqst *rqstp)
 {
-	__set_bit(RQ_SECURE, &rqstp->rq_flags);
+	set_bit(RQ_SECURE, &rqstp->rq_flags);
 }
 
 static void svc_rdma_kill_temp_xprt(struct svc_xprt *xprt)
diff --git a/sound/core/control.c b/sound/core/control.c
index 50e7ba66f187..82aa1af1d1d8 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1203,14 +1203,19 @@ static int snd_ctl_elem_read(struct snd_card *card,
 	const u32 pattern = 0xdeadbeef;
 	int ret;
 
+	down_read(&card->controls_rwsem);
 	kctl = snd_ctl_find_id(card, &control->id);
-	if (kctl == NULL)
-		return -ENOENT;
+	if (kctl == NULL) {
+		ret = -ENOENT;
+		goto unlock;
+	}
 
 	index_offset = snd_ctl_get_ioff(kctl, &control->id);
 	vd = &kctl->vd[index_offset];
-	if (!(vd->access & SNDRV_CTL_ELEM_ACCESS_READ) || kctl->get == NULL)
-		return -EPERM;
+	if (!(vd->access & SNDRV_CTL_ELEM_ACCESS_READ) || kctl->get == NULL) {
+		ret = -EPERM;
+		goto unlock;
+	}
 
 	snd_ctl_build_ioff(&control->id, kctl, index_offset);
 
@@ -1220,7 +1225,7 @@ static int snd_ctl_elem_read(struct snd_card *card,
 	info.id = control->id;
 	ret = __snd_ctl_elem_info(card, kctl, &info, NULL);
 	if (ret < 0)
-		return ret;
+		goto unlock;
 #endif
 
 	if (!snd_ctl_skip_validation(&info))
@@ -1230,7 +1235,7 @@ static int snd_ctl_elem_read(struct snd_card *card,
 		ret = kctl->get(kctl, control);
 	snd_power_unref(card);
 	if (ret < 0)
-		return ret;
+		goto unlock;
 	if (!snd_ctl_skip_validation(&info) &&
 	    sanity_check_elem_value(card, control, &info, pattern) < 0) {
 		dev_err(card->dev,
@@ -1238,8 +1243,11 @@ static int snd_ctl_elem_read(struct snd_card *card,
 			control->id.iface, control->id.device,
 			control->id.subdevice, control->id.name,
 			control->id.index);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
+unlock:
+	up_read(&card->controls_rwsem);
 	return ret;
 }
 
@@ -1253,9 +1261,7 @@ static int snd_ctl_elem_read_user(struct snd_card *card,
 	if (IS_ERR(control))
 		return PTR_ERR(control);
 
-	down_read(&card->controls_rwsem);
 	result = snd_ctl_elem_read(card, control);
-	up_read(&card->controls_rwsem);
 	if (result < 0)
 		goto error;
 
diff --git a/sound/pci/hda/cs35l41_hda.c b/sound/pci/hda/cs35l41_hda.c
index e5f0549bf06d..a5b10a6a33a5 100644
--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -598,8 +598,8 @@ static int cs35l41_system_suspend(struct device *dev)
 	dev_dbg(cs35l41->dev, "System Suspend\n");
 
 	if (cs35l41->hw_cfg.bst_type == CS35L41_EXT_BOOST_NO_VSPK_SWITCH) {
-		dev_err(cs35l41->dev, "System Suspend not supported\n");
-		return -EINVAL;
+		dev_err_once(cs35l41->dev, "System Suspend not supported\n");
+		return 0; /* don't block the whole system suspend */
 	}
 
 	ret = pm_runtime_force_suspend(dev);
@@ -624,8 +624,8 @@ static int cs35l41_system_resume(struct device *dev)
 	dev_dbg(cs35l41->dev, "System Resume\n");
 
 	if (cs35l41->hw_cfg.bst_type == CS35L41_EXT_BOOST_NO_VSPK_SWITCH) {
-		dev_err(cs35l41->dev, "System Resume not supported\n");
-		return -EINVAL;
+		dev_err_once(cs35l41->dev, "System Resume not supported\n");
+		return 0; /* don't block the whole system resume */
 	}
 
 	if (cs35l41->reset_gpio) {
@@ -647,6 +647,15 @@ static int cs35l41_system_resume(struct device *dev)
 	return ret;
 }
 
+static int cs35l41_runtime_idle(struct device *dev)
+{
+	struct cs35l41_hda *cs35l41 = dev_get_drvdata(dev);
+
+	if (cs35l41->hw_cfg.bst_type == CS35L41_EXT_BOOST_NO_VSPK_SWITCH)
+		return -EBUSY; /* suspend not supported yet on this model */
+	return 0;
+}
+
 static int cs35l41_runtime_suspend(struct device *dev)
 {
 	struct cs35l41_hda *cs35l41 = dev_get_drvdata(dev);
@@ -1536,7 +1545,8 @@ void cs35l41_hda_remove(struct device *dev)
 EXPORT_SYMBOL_NS_GPL(cs35l41_hda_remove, SND_HDA_SCODEC_CS35L41);
 
 const struct dev_pm_ops cs35l41_hda_pm_ops = {
-	RUNTIME_PM_OPS(cs35l41_runtime_suspend, cs35l41_runtime_resume, NULL)
+	RUNTIME_PM_OPS(cs35l41_runtime_suspend, cs35l41_runtime_resume,
+		       cs35l41_runtime_idle)
 	SYSTEM_SLEEP_PM_OPS(cs35l41_system_suspend, cs35l41_system_resume)
 };
 EXPORT_SYMBOL_NS_GPL(cs35l41_hda_pm_ops, SND_HDA_SCODEC_CS35L41);
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 386dd9d9143f..9ea633fe9339 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1981,6 +1981,7 @@ static const struct snd_pci_quirk force_connect_list[] = {
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),
+	SND_PCI_QUIRK(0x103c, 0x8715, "HP", 1),
 	SND_PCI_QUIRK(0x1462, 0xec94, "MS-7C94", 1),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", 1),
 	{}
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3794b522c222..764eb07bbaff 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9239,6 +9239,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0b1a, "Dell Precision 5570", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0b37, "Dell Inspiron 16 Plus 7620 2-in-1", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
 	SND_PCI_QUIRK(0x1028, 0x0b71, "Dell Inspiron 16 Plus 7620", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
+	SND_PCI_QUIRK(0x1028, 0x0c03, "Dell Precision 5340", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0c19, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c1a, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c1b, "Dell Precision 3440", ALC236_FIXUP_DELL_DUAL_CODECS),
@@ -9406,6 +9407,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8ad2, "HP EliteBook 860 16 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b5d, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b5e, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
diff --git a/tools/arch/parisc/include/uapi/asm/mman.h b/tools/arch/parisc/include/uapi/asm/mman.h
index 506c06a6536f..4cc88a642e10 100644
--- a/tools/arch/parisc/include/uapi/asm/mman.h
+++ b/tools/arch/parisc/include/uapi/asm/mman.h
@@ -1,20 +1,20 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef TOOLS_ARCH_PARISC_UAPI_ASM_MMAN_FIX_H
 #define TOOLS_ARCH_PARISC_UAPI_ASM_MMAN_FIX_H
-#define MADV_DODUMP	70
+#define MADV_DODUMP	17
 #define MADV_DOFORK	11
-#define MADV_DONTDUMP   69
+#define MADV_DONTDUMP   16
 #define MADV_DONTFORK	10
 #define MADV_DONTNEED   4
 #define MADV_FREE	8
-#define MADV_HUGEPAGE	67
-#define MADV_MERGEABLE   65
-#define MADV_NOHUGEPAGE	68
+#define MADV_HUGEPAGE	14
+#define MADV_MERGEABLE  12
+#define MADV_NOHUGEPAGE 15
 #define MADV_NORMAL     0
 #define MADV_RANDOM     1
 #define MADV_REMOVE	9
 #define MADV_SEQUENTIAL 2
-#define MADV_UNMERGEABLE 66
+#define MADV_UNMERGEABLE 13
 #define MADV_WILLNEED   3
 #define MAP_ANONYMOUS	0x10
 #define MAP_DENYWRITE	0x0800
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 6cefb4315d75..a5d49b3b6a09 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -10,25 +10,13 @@ extern struct timeval bench__start, bench__end, bench__runtime;
  * The madvise transparent hugepage constants were added in glibc
  * 2.13. For compatibility with older versions of glibc, define these
  * tokens if they are not already defined.
- *
- * PA-RISC uses different madvise values from other architectures and
- * needs to be special-cased.
  */
-#ifdef __hppa__
-# ifndef MADV_HUGEPAGE
-#  define MADV_HUGEPAGE		67
-# endif
-# ifndef MADV_NOHUGEPAGE
-#  define MADV_NOHUGEPAGE	68
-# endif
-#else
 # ifndef MADV_HUGEPAGE
 #  define MADV_HUGEPAGE		14
 # endif
 # ifndef MADV_NOHUGEPAGE
 #  define MADV_NOHUGEPAGE	15
 # endif
-#endif
 
 int bench_numa(int argc, const char **argv);
 int bench_sched_messaging(int argc, const char **argv);
diff --git a/tools/testing/selftests/vm/pkey-x86.h b/tools/testing/selftests/vm/pkey-x86.h
index b078ce9c6d2a..72c14cd3ddc7 100644
--- a/tools/testing/selftests/vm/pkey-x86.h
+++ b/tools/testing/selftests/vm/pkey-x86.h
@@ -104,6 +104,18 @@ static inline int cpu_has_pkeys(void)
 	return 1;
 }
 
+static inline int cpu_max_xsave_size(void)
+{
+	unsigned long XSTATE_CPUID = 0xd;
+	unsigned int eax;
+	unsigned int ebx;
+	unsigned int ecx;
+	unsigned int edx;
+
+	__cpuid_count(XSTATE_CPUID, 0, eax, ebx, ecx, edx);
+	return ecx;
+}
+
 static inline u32 pkey_bit_position(int pkey)
 {
 	return pkey * PKEY_BITS_PER_PKEY;
diff --git a/tools/testing/selftests/vm/protection_keys.c b/tools/testing/selftests/vm/protection_keys.c
index 291bc1e07842..95f403a0c46d 100644
--- a/tools/testing/selftests/vm/protection_keys.c
+++ b/tools/testing/selftests/vm/protection_keys.c
@@ -18,12 +18,13 @@
  *	do a plain mprotect() to a mprotect_pkey() area and make sure the pkey sticks
  *
  * Compile like this:
- *	gcc      -o protection_keys    -O2 -g -std=gnu99 -pthread -Wall protection_keys.c -lrt -ldl -lm
- *	gcc -m32 -o protection_keys_32 -O2 -g -std=gnu99 -pthread -Wall protection_keys.c -lrt -ldl -lm
+ *	gcc -mxsave      -o protection_keys    -O2 -g -std=gnu99 -pthread -Wall protection_keys.c -lrt -ldl -lm
+ *	gcc -mxsave -m32 -o protection_keys_32 -O2 -g -std=gnu99 -pthread -Wall protection_keys.c -lrt -ldl -lm
  */
 #define _GNU_SOURCE
 #define __SANE_USERSPACE_TYPES__
 #include <errno.h>
+#include <linux/elf.h>
 #include <linux/futex.h>
 #include <time.h>
 #include <sys/time.h>
@@ -1550,6 +1551,129 @@ void test_implicit_mprotect_exec_only_memory(int *ptr, u16 pkey)
 	do_not_expect_pkey_fault("plain read on recently PROT_EXEC area");
 }
 
+#if defined(__i386__) || defined(__x86_64__)
+void test_ptrace_modifies_pkru(int *ptr, u16 pkey)
+{
+	u32 new_pkru;
+	pid_t child;
+	int status, ret;
+	int pkey_offset = pkey_reg_xstate_offset();
+	size_t xsave_size = cpu_max_xsave_size();
+	void *xsave;
+	u32 *pkey_register;
+	u64 *xstate_bv;
+	struct iovec iov;
+
+	new_pkru = ~read_pkey_reg();
+	/* Don't make PROT_EXEC mappings inaccessible */
+	new_pkru &= ~3;
+
+	child = fork();
+	pkey_assert(child >= 0);
+	dprintf3("[%d] fork() ret: %d\n", getpid(), child);
+	if (!child) {
+		ptrace(PTRACE_TRACEME, 0, 0, 0);
+		/* Stop and allow the tracer to modify PKRU directly */
+		raise(SIGSTOP);
+
+		/*
+		 * need __read_pkey_reg() version so we do not do shadow_pkey_reg
+		 * checking
+		 */
+		if (__read_pkey_reg() != new_pkru)
+			exit(1);
+
+		/* Stop and allow the tracer to clear XSTATE_BV for PKRU */
+		raise(SIGSTOP);
+
+		if (__read_pkey_reg() != 0)
+			exit(1);
+
+		/* Stop and allow the tracer to examine PKRU */
+		raise(SIGSTOP);
+
+		exit(0);
+	}
+
+	pkey_assert(child == waitpid(child, &status, 0));
+	dprintf3("[%d] waitpid(%d) status: %x\n", getpid(), child, status);
+	pkey_assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGSTOP);
+
+	xsave = (void *)malloc(xsave_size);
+	pkey_assert(xsave > 0);
+
+	/* Modify the PKRU register directly */
+	iov.iov_base = xsave;
+	iov.iov_len = xsave_size;
+	ret = ptrace(PTRACE_GETREGSET, child, (void *)NT_X86_XSTATE, &iov);
+	pkey_assert(ret == 0);
+
+	pkey_register = (u32 *)(xsave + pkey_offset);
+	pkey_assert(*pkey_register == read_pkey_reg());
+
+	*pkey_register = new_pkru;
+
+	ret = ptrace(PTRACE_SETREGSET, child, (void *)NT_X86_XSTATE, &iov);
+	pkey_assert(ret == 0);
+
+	/* Test that the modification is visible in ptrace before any execution */
+	memset(xsave, 0xCC, xsave_size);
+	ret = ptrace(PTRACE_GETREGSET, child, (void *)NT_X86_XSTATE, &iov);
+	pkey_assert(ret == 0);
+	pkey_assert(*pkey_register == new_pkru);
+
+	/* Execute the tracee */
+	ret = ptrace(PTRACE_CONT, child, 0, 0);
+	pkey_assert(ret == 0);
+
+	/* Test that the tracee saw the PKRU value change */
+	pkey_assert(child == waitpid(child, &status, 0));
+	dprintf3("[%d] waitpid(%d) status: %x\n", getpid(), child, status);
+	pkey_assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGSTOP);
+
+	/* Test that the modification is visible in ptrace after execution */
+	memset(xsave, 0xCC, xsave_size);
+	ret = ptrace(PTRACE_GETREGSET, child, (void *)NT_X86_XSTATE, &iov);
+	pkey_assert(ret == 0);
+	pkey_assert(*pkey_register == new_pkru);
+
+	/* Clear the PKRU bit from XSTATE_BV */
+	xstate_bv = (u64 *)(xsave + 512);
+	*xstate_bv &= ~(1 << 9);
+
+	ret = ptrace(PTRACE_SETREGSET, child, (void *)NT_X86_XSTATE, &iov);
+	pkey_assert(ret == 0);
+
+	/* Test that the modification is visible in ptrace before any execution */
+	memset(xsave, 0xCC, xsave_size);
+	ret = ptrace(PTRACE_GETREGSET, child, (void *)NT_X86_XSTATE, &iov);
+	pkey_assert(ret == 0);
+	pkey_assert(*pkey_register == 0);
+
+	ret = ptrace(PTRACE_CONT, child, 0, 0);
+	pkey_assert(ret == 0);
+
+	/* Test that the tracee saw the PKRU value go to 0 */
+	pkey_assert(child == waitpid(child, &status, 0));
+	dprintf3("[%d] waitpid(%d) status: %x\n", getpid(), child, status);
+	pkey_assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGSTOP);
+
+	/* Test that the modification is visible in ptrace after execution */
+	memset(xsave, 0xCC, xsave_size);
+	ret = ptrace(PTRACE_GETREGSET, child, (void *)NT_X86_XSTATE, &iov);
+	pkey_assert(ret == 0);
+	pkey_assert(*pkey_register == 0);
+
+	ret = ptrace(PTRACE_CONT, child, 0, 0);
+	pkey_assert(ret == 0);
+	pkey_assert(child == waitpid(child, &status, 0));
+	dprintf3("[%d] waitpid(%d) status: %x\n", getpid(), child, status);
+	pkey_assert(WIFEXITED(status));
+	pkey_assert(WEXITSTATUS(status) == 0);
+	free(xsave);
+}
+#endif
+
 void test_mprotect_pkey_on_unsupported_cpu(int *ptr, u16 pkey)
 {
 	int size = PAGE_SIZE;
@@ -1585,6 +1709,9 @@ void (*pkey_tests[])(int *ptr, u16 pkey) = {
 	test_pkey_syscalls_bad_args,
 	test_pkey_alloc_exhaust,
 	test_pkey_alloc_free_attach_pkey0,
+#if defined(__i386__) || defined(__x86_64__)
+	test_ptrace_modifies_pkru,
+#endif
 };
 
 void run_tests_once(void)
