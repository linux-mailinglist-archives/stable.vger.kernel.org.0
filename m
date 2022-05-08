Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CEA51EF7C
	for <lists+stable@lfdr.de>; Sun,  8 May 2022 21:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiEHSNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 May 2022 14:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236132AbiEHQ7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 May 2022 12:59:54 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3FCDFFD
        for <stable@vger.kernel.org>; Sun,  8 May 2022 09:56:03 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id i27so22737863ejd.9
        for <stable@vger.kernel.org>; Sun, 08 May 2022 09:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7883SHL1XfkG7K2AL53ND9UiM0Z9TCxShP/nnldpK1I=;
        b=MHgxUxJnd4vzfieON7P7nSn19204+xxZCKOMCmwXWYAFYcUSUrPKQ3BAlvyb9S4ncr
         gOA4ofKtlIfZJSJEU4W/REaaGYZPczm3ZTpV3gL+U1O6y+9Gl36SC4sG7gTV4N9SR4dS
         jejt44hvBNn/MXRit+A1Q2s0R1QVaqaMHD64u8pzwI5+9cpVZle3Co8J3NU5qs8yKbRv
         vvx3uJyuW4hK/SwssNVr4V84itM0Z6Sg85YsIC/x+BvH/Ora97i6JsZANb8CL9Pc+pCy
         I19nfVcdudPuAdgObQJ26er9LPHfcHiYyJd9hS6ciqiTvo+Zm1B7bQ+z5XiwHRt2ESFR
         YpHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7883SHL1XfkG7K2AL53ND9UiM0Z9TCxShP/nnldpK1I=;
        b=P1E94nlHvrSHlLeDANaLuh9EnG3ZETMdAsWr9c9tEbz1arphCe8nawFlGx1PpbrgWi
         hW3irzsEC7uD07lITBzHBznj9hNifrcUKJTBjWg/YHijF9phIUhOnO8UQELYdiWcCTVT
         9anEjoEURGHm7QobzX6GiRuwGjHKJc1aFAabw4Z7HtD9VRmXN3SZIEqz584a6CUESmQ4
         gZrQ7S1G1+HfBRN95xgi/5y5OYdZc7mIUC9ntWVEbhH7+udIv/CwFhoCJap0fA1Upe2f
         hsd6cI973+oq6yK1uRz3OyTSCN4hnmCZ3g5NbGiNKxe8z6qyXji8dr/TwoMf3oK4HT0e
         zNOw==
X-Gm-Message-State: AOAM531OXObLxeQFpa7ER7aPL0pzaiwOi596hATPvTdpyRGijt5Hjt8v
        ys8YMtlwt5I5MMzuoyfA/BXnlCq9mfx5swd4/O/+2Nq8fQdD6A==
X-Google-Smtp-Source: ABdhPJwCPeN6Zfcn0jnH9LQi8HPAYNML/2/PQAmeunXmRyLQ3xXoFfcdiphW3xcRmHHaSlf3pBT1kudRNmyLPCJCuX8=
X-Received: by 2002:a17:906:cb09:b0:6f3:87ca:1351 with SMTP id
 lk9-20020a170906cb0900b006f387ca1351mr11304818ejb.674.1652028961398; Sun, 08
 May 2022 09:56:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220508165338.118886-1-khuey@kylehuey.com>
In-Reply-To: <20220508165338.118886-1-khuey@kylehuey.com>
From:   Kyle Huey <me@kylehuey.com>
Date:   Sun, 8 May 2022 09:55:46 -0700
Message-ID: <CAP045Ap9R3pL9ivwL5iSQB41KSKQ5Gwhh6SNTi_g+gA7z4RWDA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/svm: Account for family 17h event renumberings
 in amd_pmc_perf_hw_id
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        "Robert O'Callahan" <robert@ocallahan.org>,
        Keno Fischer <keno@juliacomputing.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This applies to 5.15 (and 5.10). I thought git send-email --subject
would overwrite the subject line in the patch but I was wrong.

- Kyle

On Sun, May 8, 2022 at 9:53 AM Kyle Huey <me@kylehuey.com> wrote:
>
> From: Kyle Huey <me@kylehuey.com>
>
> commit 5eb849322d7f7ae9d5c587c7bc3b4f7c6872cd2f upstream
>
> Zen renumbered some of the performance counters that correspond to the
> well known events in perf_hw_id. This code in KVM was never updated for
> that, so guest that attempt to use counters on Zen that correspond to the
> pre-Zen perf_hw_id values will silently receive the wrong values.
>
> This has been observed in the wild with rr[0] when running in Zen 3
> guests. rr uses the retired conditional branch counter 00d1 which is
> incorrectly recognized by KVM as PERF_COUNT_HW_STALLED_CYCLES_BACKEND.
>
> [0] https://rr-project.org/
>
> Signed-off-by: Kyle Huey <me@kylehuey.com>
> Message-Id: <20220503050136.86298-1-khuey@kylehuey.com>
> Cc: stable@vger.kernel.org
> [Check guest family, not host. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [Backport to 5.15: adjusted context]
> Signed-off-by: Kyle Huey <me@kylehuey.com>
> ---
>  arch/x86/kvm/svm/pmu.c | 28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index f337ce7e898e..d35c94e13afb 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -44,6 +44,22 @@ static struct kvm_event_hw_type_mapping amd_event_mapping[] = {
>         [7] = { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
>  };
>
> +/* duplicated from amd_f17h_perfmon_event_map. */
> +static struct kvm_event_hw_type_mapping amd_f17h_event_mapping[] = {
> +       [0] = { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
> +       [1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
> +       [2] = { 0x60, 0xff, PERF_COUNT_HW_CACHE_REFERENCES },
> +       [3] = { 0x64, 0x09, PERF_COUNT_HW_CACHE_MISSES },
> +       [4] = { 0xc2, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
> +       [5] = { 0xc3, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
> +       [6] = { 0x87, 0x02, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
> +       [7] = { 0x87, 0x01, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
> +};
> +
> +/* amd_pmc_perf_hw_id depends on these being the same size */
> +static_assert(ARRAY_SIZE(amd_event_mapping) ==
> +            ARRAY_SIZE(amd_f17h_event_mapping));
> +
>  static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
>  {
>         struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
> @@ -136,19 +152,25 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>
>  static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
>  {
> +       struct kvm_event_hw_type_mapping *event_mapping;
>         u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
>         u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
>         int i;
>
> +       if (guest_cpuid_family(pmc->vcpu) >= 0x17)
> +               event_mapping = amd_f17h_event_mapping;
> +       else
> +               event_mapping = amd_event_mapping;
> +
>         for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
> -               if (amd_event_mapping[i].eventsel == event_select
> -                   && amd_event_mapping[i].unit_mask == unit_mask)
> +               if (event_mapping[i].eventsel == event_select
> +                   && event_mapping[i].unit_mask == unit_mask)
>                         break;
>
>         if (i == ARRAY_SIZE(amd_event_mapping))
>                 return PERF_COUNT_HW_MAX;
>
> -       return amd_event_mapping[i].event_type;
> +       return event_mapping[i].event_type;
>  }
>
>  /* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
> --
> 2.36.0
>
