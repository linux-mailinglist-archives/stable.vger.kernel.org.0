Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B274B72B0
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241097AbiBOP5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:57:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239436AbiBOP5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:57:37 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4502DB93B8
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 07:57:27 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id z13so152459edc.12
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 07:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r1yKOdG3+HcdEveOP9QqIBqiCAtk8UFmG7zm3SFzQ9M=;
        b=mRnsdSWXqtWva+/wTXFIzYY2qPOA7NBqldJIzYYtUChPi7ncE9gdRSMXgP4AqO6oDC
         j7URGXMyT6QWz8W6Hm3OvuLmmUlozcUwQTEjs3EgY/5j6OmlDjivAfEABC0TV5+MUn5X
         w/npUZ+Q1vAikO9YA6K9Cv+qCz5YzIevMxyV0PMS+duM1HoRVQ78yn6V9Q+vnhanVEN/
         3CFhBi9Oar4pg0UvsMjObSnHdUvvsak9y+KEngiJaeXNuJXXp5HV2mT59YA5a9fFZGWD
         es4EmJMDYq2T/Y+ulDrDHEJhP2/ANpBMlM4hr/7d9r9h4u5TJzjAHIUXpAim/5ZcQFrL
         vTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r1yKOdG3+HcdEveOP9QqIBqiCAtk8UFmG7zm3SFzQ9M=;
        b=X3h9Cl+yjKFsG3ujkzzk5xOrSZAHJBihg2UcaL2DCGO0SoG2Kkn6HAm6fHlPtVCH0e
         M4UKMl/If/Tmkl2REpIFNMH4Gy/AS1NjHGpb3VAFXppZ5VCWidIGRDK9EYRUXbvTl0Iv
         g3VJ9K/6rFFBu+6f/Aoo5PaUTz+XjS59mZLL+cAXfop0K+F4Dj6U3uqBIbkjgD3bPtJm
         kS5jiOB/W57leXBA6sHAP/Y52IQd0joVFCHFZR7Sn0pNoiWXrmT7UCwsHCqRHYAy+Hbo
         cfC+IzINMFeG1xuffSToUsQaytQxZpq6QsfFTB1+2yFiC8tc/K8ZTDXIGCowMj8cKGAW
         fHmA==
X-Gm-Message-State: AOAM5309j2pRMhTByDPeT9sJuhrc621tivi4THPA8eKv5h5z9NAxjw61
        2P7dOBxIqsUFtHCoyTZmyiozcOF7xyBa4+xfwoBOcQ==
X-Google-Smtp-Source: ABdhPJwUuOsxdKm3ToptWX43l41nQVNc/oh9PLwajjIsiUjBkT3KljbfFUCR4lSGc1SVbNrXgtqp1dZJ+gN7TbNYW6U=
X-Received: by 2002:aa7:d40f:: with SMTP id z15mr4544792edq.357.1644940645587;
 Tue, 15 Feb 2022 07:57:25 -0800 (PST)
MIME-Version: 1.0
References: <20220215153644.3654582-1-bgeffon@google.com>
In-Reply-To: <20220215153644.3654582-1-bgeffon@google.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Tue, 15 Feb 2022 07:57:13 -0800
Message-ID: <CABXOdTe09SxzEpJE_BJO5=4NTjZt2a6zMviMzDH47X5MZao7WA@mail.gmail.com>
Subject: Re: [PATCH] x86/fpu: Correct pkru/xstate inconsistency
To:     Brian Geffon <bgeffon@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Willis Kung <williskung@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        "# v4 . 10+" <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Brian,

On Tue, Feb 15, 2022 at 7:37 AM Brian Geffon <bgeffon@google.com> wrote:
>
> There are two issues with PKRU handling prior to 5.13. The first is that

Nice catch and work. One question, though: From the above, it seems
like this patch only applies to kernels earlier than v5.13 or, more
specifically, to v5.4.y and v5.10.y. Is this correct, or should it be
applied to the upstream kernel and to all applicable stable releases ?

Thanks,
Guenter

> when eagerly switching PKRU we check that current is not a kernel
> thread as kernel threads will never use PKRU. It's possible that
> this_cpu_read_stable() on current_task (ie. get_current()) is returning
> an old cached value. By forcing the read with this_cpu_read() the
> correct task is used. Without this it's possible when switching from
> a kernel thread to a userspace thread that we'll still observe the
> PF_KTHREAD flag and never restore the PKRU. And as a result this
> issue only occurs when switching from a kernel thread to a userspace
> thread, switching from a non kernel thread works perfectly fine because
> all we consider in that situation is the flags from some other non
> kernel task and the next fpu is passed in to switch_fpu_finish().
>
> Without reloading the value finish_fpu_load() after being inlined into
> __switch_to() uses a stale value of current:
>
>   ba1:   8b 35 00 00 00 00       mov    0x0(%rip),%esi
>   ba7:   f0 41 80 4d 01 40       lock orb $0x40,0x1(%r13)
>   bad:   e9 00 00 00 00          jmp    bb2 <__switch_to+0x1eb>
>   bb2:   41 f6 45 3e 20          testb  $0x20,0x3e(%r13)
>   bb7:   75 1c                   jne    bd5 <__switch_to+0x20e>
>
> By using this_cpu_read() and avoiding the cached value the compiler does
> insert an additional load instruction and observes the correct value now:
>
>   ba1:   8b 35 00 00 00 00       mov    0x0(%rip),%esi
>   ba7:   f0 41 80 4d 01 40       lock orb $0x40,0x1(%r13)
>   bad:   e9 00 00 00 00          jmp    bb2 <__switch_to+0x1eb>
>   bb2:   65 48 8b 05 00 00 00    mov    %gs:0x0(%rip),%rax
>   bb9:   00
>   bba:   f6 40 3e 20             testb  $0x20,0x3e(%rax)
>   bbe:   75 1c                   jne    bdc <__switch_to+0x215>
>
> The second issue is when using write_pkru() we only write to the
> xstate when the feature bit is set because get_xsave_addr() returns
> NULL when the feature bit is not set. This is problematic as the CPU
> is free to clear the feature bit when it observes the xstate in the
> init state, this behavior seems to be documented a few places throughout
> the kernel. If the bit was cleared then in write_pkru() we would happily
> write to PKRU without ever updating the xstate, and the FPU restore on
> return to userspace would load the old value agian.
>
> Fixes: 0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
> Signed-off-by: Brian Geffon <bgeffon@google.com>
> Signed-off-by: Willis Kung <williskung@google.com>
> Tested-by: Willis Kung <williskung@google.com>
> ---
>  arch/x86/include/asm/fpu/internal.h |  2 +-
>  arch/x86/include/asm/pgtable.h      | 14 ++++++++++----
>  2 files changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
> index 03b3de491b5e..540bda5bdd28 100644
> --- a/arch/x86/include/asm/fpu/internal.h
> +++ b/arch/x86/include/asm/fpu/internal.h
> @@ -598,7 +598,7 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
>          * PKRU state is switched eagerly because it needs to be valid before we
>          * return to userland e.g. for a copy_to_user() operation.
>          */
> -       if (!(current->flags & PF_KTHREAD)) {
> +       if (!(this_cpu_read(current_task)->flags & PF_KTHREAD)) {
>                 /*
>                  * If the PKRU bit in xsave.header.xfeatures is not set,
>                  * then the PKRU component was in init state, which means
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 9e71bf86d8d0..aa381b530de0 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -140,16 +140,22 @@ static inline void write_pkru(u32 pkru)
>         if (!boot_cpu_has(X86_FEATURE_OSPKE))
>                 return;
>
> -       pk = get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PKRU);
> -
>         /*
>          * The PKRU value in xstate needs to be in sync with the value that is
>          * written to the CPU. The FPU restore on return to userland would
>          * otherwise load the previous value again.
>          */
>         fpregs_lock();
> -       if (pk)
> -               pk->pkru = pkru;
> +       /*
> +        * The CPU is free to clear the feature bit when the xstate is in the
> +        * init state. For this reason, we need to make sure the feature bit is
> +        * reset when we're explicitly writing to pkru. If we did not then we
> +        * would write to pkru and it would not be saved on a context switch.
> +        */
> +       current->thread.fpu.state.xsave.header.xfeatures |= XFEATURE_MASK_PKRU;
> +       pk = get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PKRU);
> +       BUG_ON(!pk);
> +       pk->pkru = pkru;
>         __write_pkru(pkru);
>         fpregs_unlock();
>  }
> --
> 2.35.1.265.g69c8d7142f-goog
>
