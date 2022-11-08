Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C484621BD2
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 19:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbiKHSXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 13:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbiKHSXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 13:23:49 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24712186E0;
        Tue,  8 Nov 2022 10:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667931828; x=1699467828;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FfEVd3QNZBOJtLgf+04AipIfhJH1euMdPMQmxEcCU5M=;
  b=MVn0rmQIC6w8gPdgLz+64lv84ddE37Wfya7Uu6SV8UsGuSUwP1Aoz01Q
   mNVmGl/bO6/asJ9ouD/HbM69q74S7cqNNGINTf07XePFS/vSbdGz55G6S
   T0PZ4/+ZDV8Om92mkyrfD5xxS3QaGJ42jx+GgBXZKfbo8OQKMn7cuI0CZ
   ieEJ7lG9qmQPE3rcbXQYaCGNl0BCcxNwpUWHc8KKyfFPPqbT8XSBsd/Xh
   Eusv8SbFX2l5FVShgHhu0BZf0U0tiW76wsGCIcd2XtxpjdwQcfo5VmcnQ
   F6P36ktDHQH4YGU6I9s/b3nF27zWIgsVZl7IkA4IgTWGAcUMkXyM7xfW2
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="372913952"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="372913952"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 10:23:04 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="811334327"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="811334327"
Received: from vibhusha-mobl1.amr.corp.intel.com (HELO [10.252.133.56]) ([10.252.133.56])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 10:23:02 -0800
Message-ID: <64e62ab9-71f6-6d90-24de-402921c244e7@intel.com>
Date:   Tue, 8 Nov 2022 10:23:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [RESEND PATCH v6 1/2] x86/fpu: Allow PKRU to be (once again)
 written by ptrace.
Content-Language: en-US
To:     Kyle Huey <me@kylehuey.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org
References: <20221107063807.81774-1-khuey@kylehuey.com>
 <20221107063807.81774-2-khuey@kylehuey.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20221107063807.81774-2-khuey@kylehuey.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kyle, sorry this took so long to get to.  I do really appreciate the fix
and the selftest.  This seems like something we want to get merged
sooner rather than later, so please bear with me.

On 11/6/22 22:38, Kyle Huey wrote:
> There are three APIs that write PKRU: sigreturn, PTRACE_SETREGSET with
> NT_X86_XSTATE, and KVM_SET_XSAVE. sigreturn still uses XRSTOR to write to
> PKRU. KVM_SET_XSAVE has its own special handling to make PKRU writes take
> effect (in fpu_copy_uabi_to_guest_fpstate). Push that down into
> copy_uabi_to_xstate and have PTRACE_SETREGSET with NT_X86_XSTATE pass in
> a pointer to the appropriate PKRU slot. copy_sigframe_from_user_to_xstate
> depends on copy_uabi_to_xstate populating the PKRU field in the task's
> XSTATE so that __fpu_restore_sig can do a XRSTOR from it, so continue doing
> that.

Please always write functions() with parenthesis to make it clear what
you're talking about.  Also, there are much better ways to format this
paragraph.  I probably would have said:

There are three APIs that write PKRU:
1. sigreturn
2. PTRACE_SETREGSET with NT_X86_XSTATE
3. KVM_SET_XSAVE

Then broken it up into three follow-on paragraphs.  I actually kinda had
to do this to even make sense of what you were trying to say above.  It
would also be nice to have a clear problem statement paired with the
mention of these three ABIs.

#1 and #3 work OK, right?  It's #2 that's broken?

> sigreturn still uses XRSTOR to write to PKRU.

... which means?  That sigreturn is fine and does not need to be touched
in this patch?

> KVM_SET_XSAVE has its own special handling to make PKRU writes take
> effect (in fpu_copy_uabi_to_guest_fpstate()).  Push that down into
> copy_uabi_to_xstate() and have PTRACE_SETREGSET with NT_X86_XSTATE pass in
> a pointer to the appropriate PKRU slot. 

So this is the bugfix?  KVM already does it right, and we just need to
make ptrace() share the KVM code?

> copy_sigframe_from_user_to_xstate() depends on copy_uabi_to_xstate()
> populating the PKRU field in the task's XSTATE so that
> __fpu_restore_sig() can do a XRSTOR from it, so continue doing that.

I'm not quite sure what this chunk of the changelog is trying to tell
me.  Isn't this the sigreturn path?  Why did the paragraph above go from
talking about sigreturn to KVM then back to sigreturn?

> This also adds code to initialize the PKRU value to the hardware init value
> (namely 0) if the PKRU bit is not set in the XSTATE header provided to
> ptrace, to match XRSTOR.

The implication here is that we would like the sigreturn ABI and the
ptrace ABI to behave in a similar fashion, right?

At a high level, this patch does a *LOT*.  Generally, it's nice when
bugfixes can be encapsulted in one patch, but I think there's too much
going on here for one patch.

> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 3b28c5b25e12..c273669e8a00 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -391,8 +391,6 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
>  {
>  	struct fpstate *kstate = gfpu->fpstate;
>  	const union fpregs_state *ustate = buf;
> -	struct pkru_state *xpkru;
> -	int ret;
>  
>  	if (!cpu_feature_enabled(X86_FEATURE_XSAVE)) {
>  		if (ustate->xsave.header.xfeatures & ~XFEATURE_MASK_FPSSE)
> @@ -406,16 +404,16 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
>  	if (ustate->xsave.header.xfeatures & ~xcr0)
>  		return -EINVAL;
>  
> -	ret = copy_uabi_from_kernel_to_xstate(kstate, ustate);
> -	if (ret)
> -		return ret;
> +	/*
> +	 * Nullify @vpkru to preserve its current value if PKRU's bit isn't set
> +	 * in the header.  KVM's odd ABI is to leave PKRU untouched in this
> +	 * case (all other components are eventually re-initialized).
> +	 * (Not clear that this is actually necessary for compat).
> +	 */
> +	if (!(ustate->xsave.header.xfeatures & XFEATURE_MASK_PKRU))
> +		vpkru = NULL;

I'm not a big fan of hunks that are part of bugfixes where it is not
clear that the hunk is necessary.

> -	/* Retrieve PKRU if not in init state */
> -	if (kstate->regs.xsave.header.xfeatures & XFEATURE_MASK_PKRU) {
> -		xpkru = get_xsave_addr(&kstate->regs.xsave, XFEATURE_PKRU);
> -		*vpkru = xpkru->pkru;
> -	}
> -	return 0;
> +	return copy_uabi_from_kernel_to_xstate(kstate, ustate, vpkru);
>  }
>  EXPORT_SYMBOL_GPL(fpu_copy_uabi_to_guest_fpstate);
>  #endif /* CONFIG_KVM */
> diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
> index 75ffaef8c299..6d056b68f4ed 100644
> --- a/arch/x86/kernel/fpu/regset.c
> +++ b/arch/x86/kernel/fpu/regset.c
> @@ -167,7 +167,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
>  	}
>  
>  	fpu_force_restore(fpu);
> -	ret = copy_uabi_from_kernel_to_xstate(fpu->fpstate, kbuf ?: tmpbuf);
> +	ret = copy_uabi_from_kernel_to_xstate(fpu->fpstate, kbuf ?: tmpbuf, &target->thread.pkru);

I actually hadn't dug into the KVM code around this before.  It seems
like the PKRU pointer (&target->thread.pkru) here can also be
&vcpu->arch.pkru if it comes from the KVM side.

I was missing why PKRU is so special here.  I think in *both* cases,
we're copying a potential PKRU value from userspace.  But, the fpstate
target is a useless place to write PKRU because the kernel doesn't
update from there.  So, the copy-in function
(copy_uabi_from_kernel_to_xstate()) needs a place to stash PKRU where
the kernel will see it.  The place that the kernel wants to stash it is
either the task PKRU field or the KVM vcpu field.  That's what the
pointer provides.

Also, is this getting a wee bit over 80 columns?

>  out:
>  	vfree(tmpbuf);
> diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
> index 91d4b6de58ab..558076dbde5b 100644
> --- a/arch/x86/kernel/fpu/signal.c
> +++ b/arch/x86/kernel/fpu/signal.c
> @@ -396,7 +396,7 @@ static bool __fpu_restore_sig(void __user *buf, void __user *buf_fx,
>  
>  	fpregs = &fpu->fpstate->regs;
>  	if (use_xsave() && !fx_only) {
> -		if (copy_sigframe_from_user_to_xstate(fpu->fpstate, buf_fx))
> +		if (copy_sigframe_from_user_to_xstate(tsk, buf_fx))
>  			return false;

This is also changing copy_sigframe_from_user_to_xstate() to take a
'task_struct' instead of an 'fpstate'.  Why?  That function just turns
it right back into an fpstate with: tsk->thread.fpu.fpstate.

>  	} else {
>  		if (__copy_from_user(&fpregs->fxsave, buf_fx,
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index c8340156bfd2..8f14981a3936 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -1197,7 +1197,7 @@ static int copy_from_buffer(void *dst, unsigned int offset, unsigned int size,
>  
>  
>  static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
> -			       const void __user *ubuf)
> +			       const void __user *ubuf, u32 *pkru)

I think this function deserves a little comment about what it expects
from 'pkru' here.  Maybe:

/*
 * The kernel will not update the actual PKRU register from the PKRU
 * space in @fpstate.  Allow callers to pass in an alternate destination
 * for PKRU.  This is currently either the pkru field from the
 * task_struct or vcpu.
 */

>  {
>  	struct xregs_state *xsave = &fpstate->regs.xsave;
>  	unsigned int offset, size;
> @@ -1246,6 +1246,21 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
>  		}
>  	}
>  
> +	/*
> +	 * Update the user protection key storage. Allow KVM to
> +	 * pass in a NULL pkru pointer if the mask bit is unset
> +	 * for its legacy ABI behavior.
> +	 */

If I read this in 5 years, do I know what the "KVM legacy ABI behavior" is?

> +	if (pkru)
> +		*pkru = 0;
> +
> +	if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
> +		struct pkru_state *xpkru;
> +
> +		xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
> +		*pkru = xpkru->pkru;
> +	}

This is a bit wonky.  The code kinda pretends that XFEATURE_MASK_PKRU
and 'pkru' are independent.  But, it's actually impossible to have a
pkru==NULL and have XFEATURE_MASK_PKRU set.  The code would oops in that
case.

Would something like this be more clear?

	if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
		struct pkru_state *xpkru;

		xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
		*pkru = xpkru->pkru;
	} else {
		/*
		 * KVM may pass a NULL 'pkru' to indicate
		 * that it does not need PKRU updated.
		 */
		if (pkru)
			*pkru = 0;
	}


