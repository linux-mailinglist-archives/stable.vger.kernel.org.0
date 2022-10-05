Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996B35F5D33
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 01:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJEXZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 19:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJEXZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 19:25:08 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943694314C
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 16:25:06 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id q10so239615oib.5
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 16:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ISAhMH5CXhMhm+1I427tmkYhfjMJ9VeL8BRy8vi5aDg=;
        b=Hv+Er/u1QUUMk2kRd/0THVgtqLoGx8V8d2vgB9TBKRsCdT6am1CAJjVlCP8D9CbGle
         736QJMJOO9Kmd6eDoJI/6b1syOcP3tLqa/IDk4VdA0EYbefLXx/SxQz6xlGG0yG1UMtZ
         0N0CzKsBwn67wr0WqwBLNlPTWtYGwdQtP7HmfxjbETjvMjZt4YmI8PnCcD2H8R707+kn
         P4faM9ADQpc31G2ax5Rhi69mzRRT/k7ughzWjn2VeyyKk8vNmj8vOy1tGtbsucxjaUzz
         AImN+C2uKh6TYfGlnSZvmwb9zB6BVvd97ZieJIk5kC36TMoI8L/eOCGwwPWMZ0bIxXo6
         eQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ISAhMH5CXhMhm+1I427tmkYhfjMJ9VeL8BRy8vi5aDg=;
        b=B97ov+lDGWTdDtO9lMJNDnMzKs2H+u8iMI17dGiDxRC9G0JIS7av5iWXm2F7Fwrk+m
         81O7sICtYHwxBjhJIkQsyLCCmAwQdzP138QOmSex0aCUsA0j2Pabnpe9lKtnQCAoM8bx
         f8oRsjWnBG3lbJBODNwmhmzGdui62TRYYmtzZFVk08g4qDOE6rDxi7/AhKkT2JeyKS4V
         RidF3gCUkKqzolG/az7W4pW9laxd0r4zvRrbXuea50ksvByi9I4KnhHFlLgwqDAizV3U
         QXcEBA+e59wyH/DMfCzjC70KoZdIEMpNCdqvkwTMMyvpDQFlipbGvV2QDJkHFzPy0j9R
         eaUg==
X-Gm-Message-State: ACrzQf1ThPqb/Cs1pN5N0P6/L4RiO1Hmci6fCRsoeC0HMxXuEdaQEYE7
        2Qo/pQ6M+A3d1kNNap7ZYlYIbH2X9TkNFQhkmIzlBA==
X-Google-Smtp-Source: AMsMyM7C2vSU/ABLi9NuabyIuI+l9SPY2QCOOlyvIwq45W+bnQFzXL5sL0YnWQX6S+6E6bU2OgRN2wUXgQnECLcWrSw=
X-Received: by 2002:a05:6808:f8e:b0:351:a39:e7ca with SMTP id
 o14-20020a0568080f8e00b003510a39e7camr3302472oiw.269.1665012305681; Wed, 05
 Oct 2022 16:25:05 -0700 (PDT)
MIME-Version: 1.0
References: <20221005220227.1959-1-surajjs@amazon.com>
In-Reply-To: <20221005220227.1959-1-surajjs@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 5 Oct 2022 16:24:54 -0700
Message-ID: <CALMp9eTU9s+2fZ809bfOWYoGXsiziQOxCM-5Ly0JF2HeSEkwhA@mail.gmail.com>
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

Okay. I see how this almost meets the requirements. But this WRMSR is
conditional, which means that there's a speculative path through this
code that ends up at the unbalanced RET without executing the WRMSR.

Also, for your timings of "no mitigation" and this proposed mitigation
to be the same, I assume that the guest in your timing test has a
different IA32_SPEC_CTRL value than the host, which isn't always going
to be the case in practice. How much does this WRMSR cost if the guest
and the host have the same IA32_SPEC_CTRL value?

> --
> 2.17.1
>
