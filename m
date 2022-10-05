Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B8F5F5D4B
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 01:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiJEXq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 19:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJEXqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 19:46:25 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2EB4F3AD
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 16:46:24 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1326637be6eso415376fac.13
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 16:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Wx2vx0LbbOvLQJAZykpinDnhlcxxA1vmhyf2RBmLvvI=;
        b=Lto54UkjJxCuusFrV/1pe+g2VFWWAB8f0JuTNpqmlJ5jZ0y++WH6e9sJRuwfH4NVMT
         whAFRwWE392pOiC4K5ms4W6Voo1sqLNLmJU5T90Rk/I3rywSuXEQ5JhC9gHf6X59U7GW
         DymYxDClE3+Tqgi18064Un90odDfuavmiNghcC5837POfZ/XBBhtpcT1DHzKvp6+dglo
         xSYrVGsilG5cHqZGPWuXjRg8c0MLkvUar8iOBOcUJKhRFCsemDWAMQllmqcsCQuQkVvz
         sTM0IvhkBZewmdQ0EXOSUUR042TulCDew28kCTPWsqVMDXSMbU7kQbPR5ilyYokDJ0q7
         7q/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wx2vx0LbbOvLQJAZykpinDnhlcxxA1vmhyf2RBmLvvI=;
        b=49sqaGhn0OttcsfFNov483UvYfOAzWIKZ+sLvQKDMN9UjlACXM9jxN/82erD6HdtsM
         8KI6kzHFgKWhBGUo0V66ahQt0qyfcazEFAAqDLHMEbWOE43j5FyK4tQDO3J/KbNXhRZ7
         XsxBDh3SZoz1v+abHalv+GHGr6Qwy46OighBQ8oyeQ+ZMM3JRU4t9knUDoCjMtaz/5Sf
         5vzL9HvrjBtzKL1cDN1aCa+BCMnz1CtIgJe343MrKkcDYmcI4p79NhFSS4YLOpRNo2bY
         YDkVYvsqImpSXgxALqNxsr72/oV94t3Alk+WKI8dANnKzyf/Yrg5i5La+rqCTuBepaHu
         DXkA==
X-Gm-Message-State: ACrzQf0Jd6syhcI7rEbyM8Or482kgA5BSdXImokkzn7cXR+C1auir4+6
        qvyBObvUCaL3rc3ZjtVnkOUfgHQf2nGp22O9oBhFMA==
X-Google-Smtp-Source: AMsMyM4i4zSJ660ou05jj+zRrnRSqMQsLcRWEfsJxYCG/auY1umhYkXd1YI2KucBNG03dm5D+syz5WBtWCMDkyNBP1Y=
X-Received: by 2002:a05:6870:82a4:b0:132:eb87:37 with SMTP id
 q36-20020a05687082a400b00132eb870037mr1941308oae.13.1665013583413; Wed, 05
 Oct 2022 16:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <20221005220227.1959-1-surajjs@amazon.com>
In-Reply-To: <20221005220227.1959-1-surajjs@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 5 Oct 2022 16:46:12 -0700
Message-ID: <CALMp9eThzv+5UBPtm77nvD_b48hHD7O1QLni7a+x9zAPicFk4Q@mail.gmail.com>
Subject: Re: [PATCH] x86/speculation: Mitigate eIBRS PBRSB predictions with WRMSR
To:     Suraj Jitindar Singh <surajjs@amazon.com>
Cc:     kvm@vger.kernel.org, sjitindarsingh@gmail.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@suse.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        jpoimboe@kernel.org, daniel.sneddon@linux.intel.com,
        pawan.kumar.gupta@linux.intel.com, benh@kernel.crashing.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 5, 2022 at 3:03 PM Suraj Jitindar Singh <surajjs@amazon.com> wrote:
>
> tl;dr: The existing mitigation for eIBRS PBRSB predictions uses an INT3 to
> ensure a call instruction retires before a following unbalanced RET. Replace
> this with a WRMSR serialising instruction which has a lower performance
> penalty.
>
> == Background ==
>
> eIBRS (enhanced indirect branch restricted speculation) is used to prevent
> predictor addresses from one privilege domain from being used for prediction
> in a higher privilege domain.
>
> == Problem ==
>
> On processors with eIBRS protections there can be a case where upon VM exit
> a guest address may be used as an RSB prediction for an unbalanced RET if a
> CALL instruction hasn't yet been retired. This is termed PBRSB (Post-Barrier
> Return Stack Buffer).
>
> A mitigation for this was introduced in:
> (2b1299322016731d56807aa49254a5ea3080b6b3 x86/speculation: Add RSB VM Exit protections)
>
> This mitigation [1] has a ~1% performance impact on VM exit compared to without
> it [2].
>
> == Solution ==
>
> The WRMSR instruction can be used as a speculation barrier and a serialising
> instruction. Use this on the VM exit path instead to ensure that a CALL
> instruction (in this case the call to vmx_spec_ctrl_restore_host) has retired
> before the prediction of a following unbalanced RET.
>
> This mitigation [3] has a negligible performance impact.
>
> == Testing ==
>
> Run the outl_to_kernel kvm-unit-tests test 200 times per configuration which
> counts the cycles for an exit to kernel mode.
>
> [1] With existing mitigation:
> Average: 2026 cycles
> [2] With no mitigation:
> Average: 2008 cycles
> [3] With proposed mitigation:
> Average: 2008 cycles
>
> Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/include/asm/nospec-branch.h | 7 +++----
>  arch/x86/kvm/vmx/vmenter.S           | 3 +--
>  arch/x86/kvm/vmx/vmx.c               | 5 +++++
>  3 files changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index c936ce9f0c47..e5723e024b47 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -159,10 +159,9 @@
>    * A simpler FILL_RETURN_BUFFER macro. Don't make people use the CPP
>    * monstrosity above, manually.
>    */
> -.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req ftr2=ALT_NOT(X86_FEATURE_ALWAYS)
> -       ALTERNATIVE_2 "jmp .Lskip_rsb_\@", \
> -               __stringify(__FILL_RETURN_BUFFER(\reg,\nr)), \ftr, \
> -               __stringify(__FILL_ONE_RETURN), \ftr2
> +.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
> +       ALTERNATIVE "jmp .Lskip_rsb_\@", \
> +               __stringify(__FILL_RETURN_BUFFER(\reg,\nr)), \ftr
>
>  .Lskip_rsb_\@:
>  .endm
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 6de96b943804..eb82797bd7bf 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -231,8 +231,7 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
>          * single call to retire, before the first unbalanced RET.
>           */
>
> -       FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT,\
> -                          X86_FEATURE_RSB_VMEXIT_LITE
> +       FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
>
>
>         pop %_ASM_ARG2  /* @flags */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c9b49a09e6b5..fdcd8e10c2ab 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7049,8 +7049,13 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
>          * For legacy IBRS, the IBRS bit always needs to be written after
>          * transitioning from a less privileged predictor mode, regardless of
>          * whether the guest/host values differ.
> +        *
> +        * For eIBRS affected by Post Barrier RSB Predictions a serialising
> +        * instruction (wrmsr) must be executed to ensure a call instruction has
> +        * retired before the prediction of a following unbalanced ret.
>          */
>         if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) ||
> +           cpu_feature_enabled(X86_FEATURE_RSB_VMEXIT_LITE) ||
>             vmx->spec_ctrl != hostval)
>                 native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);

Better, I think, would be to leave the condition alone and put an
LFENCE on the 'else' path:

         if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) ||
             vmx->spec_ctrl != hostval)
                 native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
        else
                rmb();

When the guest and host have different IA32_SPEC_CTRL values, you get
the serialization from the WRMSR. Otherwise, you get it from the
cheaper LFENCE.

This is still more convoluted than having the mitigation in one place.
