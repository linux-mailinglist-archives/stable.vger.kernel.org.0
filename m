Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95CF2588903
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 11:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbiHCJD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 05:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiHCJD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 05:03:57 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A99F286F3;
        Wed,  3 Aug 2022 02:03:55 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id v5so8380353wmj.0;
        Wed, 03 Aug 2022 02:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZIQ4PjPtMmNCTF5H7NB1i9jqDTRqe+lP8qX6KWAkRQM=;
        b=ixVRcFv91G8mWMmEK8rgK9zV0RILjdiLL7X7n12x2d0b6i3xqWxVAr0FjKLrrbZeFw
         ZAu6yNOIw0rlHwKsSI8YWUfDv7YPR22qli2/tMGMenEwAK7MFTw6X9FlDehfl8ZwIms4
         YK8hRJwtnQWnxUrYUTxpquKrgmgRovKBOh94wyIHU6lP+aFocfWjQzETJKEzBzEV9jlS
         /mpWt+zYv9EiJI+CN6bt9IEsRo1s8iNNRDaEvyc52WEBZopYPMAD5Y1/DL2dM/yGRVoV
         BZAWIWyZaRpyZl1+ETD11ULtTApuBelJmzlCbckkOCR/WiJZsIYrF4U5wCZbACbYE+VM
         LyTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ZIQ4PjPtMmNCTF5H7NB1i9jqDTRqe+lP8qX6KWAkRQM=;
        b=hEnFK4hyBSpDbaKoVBXgOmldxPnZEN9kPe73N4Gnk8AKwAjAt+m+wdTyBcKHZbTvYF
         rLW+L/uMhl52VnPnmlqWuu5KpOK2ioFuFAxka/F7sQRUoxq0g5umqMjbeLIHOdZMYdCD
         R2psnw2k268Y7fm4B/ITx3eXIgCBFmELFa1ClM6i38z7nEE6r4cSZmyAEgjcH6UKLAPp
         G1XYUG2TybHvcOJ36mNNvFhnX2mVR7svv/vDX01h/1it2BuN2hFq0Sv5V0OKuA02bx2H
         N1bhwni2AHNcTJZDqAURTuNV35TKVGjECuRmLCMujzBrWb54BGQ8cxwcruftF2ip9+XT
         qC9A==
X-Gm-Message-State: ACgBeo2nMBcf5NwR15bT6VMh2DsWa2lKYB/rsYD3TC62pzbYAJ93D3EO
        d9mQ3p87JxxbhyA/YQtu9L8=
X-Google-Smtp-Source: AA6agR5AlI8pFtqxcdL50XhMpI9RUrux8QwexLdrXlPCfhJ1XrvtDSfR2w30D3d9+GXwDYSolN0U0A==
X-Received: by 2002:a05:600c:384c:b0:3a3:744d:8dd2 with SMTP id s12-20020a05600c384c00b003a3744d8dd2mr2131689wmr.117.1659517433839;
        Wed, 03 Aug 2022 02:03:53 -0700 (PDT)
Received: from gmail.com (84-236-113-167.pool.digikabel.hu. [84.236.113.167])
        by smtp.gmail.com with ESMTPSA id k17-20020adff291000000b0021d6924b777sm17673007wro.115.2022.08.03.02.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 02:03:52 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Wed, 3 Aug 2022 11:03:50 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Kyle Huey <me@kylehuey.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/fpu: Allow PKRU to be (once again) written by ptrace.
Message-ID: <Yuo59tV071/i6yhf@gmail.com>
References: <20220731050342.56513-1-khuey@kylehuey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220731050342.56513-1-khuey@kylehuey.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Kyle Huey <me@kylehuey.com> wrote:

> From: Kyle Huey <me@kylehuey.com>
> 
> When management of the PKRU register was moved away from XSTATE, emulation
> of PKRU's existence in XSTATE was added for APIs that read XSTATE, but not
> for APIs that write XSTATE. This can be seen by running gdb and executing
> `p $pkru`, `set $pkru = 42`, and `p $pkru`. On affected kernels (5.14+) the
> write to the PKRU register (which gdb performs through ptrace) is ignored.
> 
> There are three relevant APIs: PTRACE_SETREGSET with NT_X86_XSTATE,
> sigreturn, and KVM_SET_XSAVE. KVM_SET_XSAVE has its own special handling to
> make PKRU writes take effect (in fpu_copy_uabi_to_guest_fpstate). Push that
> down into copy_uabi_to_xstate and have PTRACE_SETREGSET with NT_X86_XSTATE
> and sigreturn pass in pointers to the appropriate PKRU value.
> 
> This also adds code to initialize the PKRU value to the hardware init value
> (namely 0) if the PKRU bit is not set in the XSTATE header to match XRSTOR.
> This is a change to the current KVM_SET_XSAVE behavior.
> 
> Signed-off-by: Kyle Huey <me@kylehuey.com>
> Cc: kvm@vger.kernel.org # For edge case behavior of KVM_SET_XSAVE
> Cc: stable@vger.kernel.org # 5.14+
> Fixes: e84ba47e313dbc097bf859bb6e4f9219883d5f78
> ---
>  arch/x86/kernel/fpu/core.c   | 11 +----------
>  arch/x86/kernel/fpu/regset.c |  2 +-
>  arch/x86/kernel/fpu/signal.c |  2 +-
>  arch/x86/kernel/fpu/xstate.c | 26 +++++++++++++++++++++-----
>  arch/x86/kernel/fpu/xstate.h |  4 ++--
>  5 files changed, 26 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 0531d6a06df5..dfb79e2ee81f 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -406,16 +406,7 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
>  	if (ustate->xsave.header.xfeatures & ~xcr0)
>  		return -EINVAL;
>  
> -	ret = copy_uabi_from_kernel_to_xstate(kstate, ustate);
> -	if (ret)
> -		return ret;
> -
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
>  
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
>  	} else {
>  		if (__copy_from_user(&fpregs->fxsave, buf_fx,
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index c8340156bfd2..1eea7af4afd9 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -1197,7 +1197,7 @@ static int copy_from_buffer(void *dst, unsigned int offset, unsigned int size,
>  
>  
>  static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
> -			       const void __user *ubuf)
> +			       const void __user *ubuf, u32 *pkru)
>  {
>  	struct xregs_state *xsave = &fpstate->regs.xsave;
>  	unsigned int offset, size;
> @@ -1235,6 +1235,22 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
>  	for (i = 0; i < XFEATURE_MAX; i++) {
>  		mask = BIT_ULL(i);
>  
> +		if (i == XFEATURE_PKRU) {
> +			/*
> +			 * Retrieve PKRU if not in init state, otherwise
> +			 * initialize it.
> +			 */
> +			if (hdr.xfeatures & mask) {
> +				struct pkru_state xpkru = {0};
> +
> +				copy_from_buffer(&xpkru, xstate_offsets[i],
> +						 sizeof(xpkru), kbuf, ubuf);

Shouldn't the failure case of copy_from_buffer() be handled?

Also, what's the security model for this register, do we trust all input 
values user-space provides for the PKRU field in the XSTATE? I realize that 
WRPKRU already gives user-space write access to the register - but does the 
CPU write it all into the XSTATE, with no restrictions on content 
whatsoever?

Thanks,

	Ingo
