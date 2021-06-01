Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08AE3975C1
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 16:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbhFAOtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 10:49:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:64726 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234043AbhFAOtt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 10:49:49 -0400
IronPort-SDR: vrudBmHVAvDADRh3Pz3bl4Zaua7H8IXVIvG0gf2+O0yyM7aXKiZEx+7sSVhMipur3kQbtAd1v8
 T/lKT7NAbI2w==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="203366726"
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="203366726"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 07:48:07 -0700
IronPort-SDR: qFwZQLvN7SxRZJV/u3TyWB011tBoS0jt8DcrgejdwR3qRbN0Yb18I2WlEw4JJgWT0YMjd7ecCu
 gOMC9ZAOikMg==
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="479306927"
Received: from pychiu-mobl.amr.corp.intel.com (HELO [10.209.21.197]) ([10.209.21.197])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 07:48:07 -0700
Subject: Re: [RFC v2 1/2] x86/fpu: Fix state corruption in
 __fpu__restore_sig()
To:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>
Cc:     stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
References: <878s3u34iy.ffs@nanos.tec.linutronix.de>
 <603011b5-9479-3aac-78ee-74b9b5a5ef7c@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <96d765be-7fd4-08c3-6c2e-4ca8341d11e7@intel.com>
Date:   Tue, 1 Jun 2021 07:48:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <603011b5-9479-3aac-78ee-74b9b5a5ef7c@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> +static void sigusr1(int sig, siginfo_t *info, void *uc_void)
> +{
> +       ucontext_t *uc = uc_void;
> +       uint8_t *fpstate = (uint8_t *)uc->uc_mcontext.fpregs;
> +       uint64_t *xfeatures = (uint64_t *)(fpstate + 512);
> +
> +       printf("\tOriginal XFEATURES = 0x%lx\n", *xfeatures);
> +       *(xfeatures+2) = 0xfffffff;
> +       //*xfeatures = ~(uint64_t)0;
> +}

I was trying to think of something which might be more durable than
this, like if a new feature started using bytes 16->23 for something useful.

How about a memset() of the entire 64-byte header to 0xff?

On to

	[PATCH v3 2/5] x86/fpu: Fix state corruption in ...

> Instead of trying to give sensible semantics to the fpu clear functions
> in the presence of XSAVE header corruption, simply avoid corrupting the
> header in the first place by using copy_user_to_xstate().

Should we mention that the verbatim copying via __copy_from_user()
copies the (bad) reserved bit contents and how copy_user_to_xstate()
avoids it?

Maybe:

__copy_from_user() copies the entire user buffer into the kernel buffer,
verbatim.  This means that the kernel buffer may now contain entirely
invalid state on which XRSTOR will #GP.  validate_user_xstate_header()
can detect some of that corruption, but that leaves the onus on callers
to clear the buffer.

Avoid corruption of the kernel XSAVE buffer.  Use copy_user_to_xstate()
which validates the XSAVE header contents *BEFORE* copying the buffer
into the kernel.

Note: copy_user_to_xstate() was previously only called for
compacted-format kernel buffers.  It functions for both compacted and
non-compacted forms.  Using it for the non-compacted form will be slower
because of multiple __copy_from_user() operations in the
compacted-format code, but that cost is less important than simpler code
in an already slow path.

> --- a/arch/x86/kernel/fpu/signal.c
> +++ b/arch/x86/kernel/fpu/signal.c
> @@ -405,14 +405,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
>         if (use_xsave() && !fx_only) {
>                 u64 init_bv = xfeatures_mask_user() & ~user_xfeatures;
>  
> -               if (using_compacted_format()) {
> -                       ret = copy_user_to_xstate(&fpu->state.xsave, buf_fx);
> -               } else {
> -                       ret = __copy_from_user(&fpu->state.xsave, buf_fx, state_size);
> -
> -                       if (!ret && state_size > offsetof(struct xregs_state, header))
> -                               ret = validate_user_xstate_header(&fpu->state.xsave.header);
> -               }
> +               ret = copy_user_to_xstate(&fpu->state.xsave, buf_fx);
>                 if (ret)
>                         goto err_out;
>  

