Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614CA4E9D1B
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 19:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244444AbiC1RNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 13:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244299AbiC1RNp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 13:13:45 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99DB62CA7
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 10:12:04 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id k15so14134645vsr.11
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 10:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UWaKV5PzvMW5nZbiLxszZKdWQXmMmUkwwQ3825gf38s=;
        b=R7xcpGn4F4SryDPE+t1/YeYTe4LaDAEg6/E0sMq+cSGTF+bLiGwYlmipvLZ9MyHqUP
         t3JtvGYrb8aiMrYvpJU32BPc/ZcWVsNbACnXk9cVPKoCg1Cx0bQTlY4/B2eLAUY129SQ
         giLCzg1rmgcSO79OJMuavsAHgtPd77rebHhU0zXov/vg7pj3JOD8XePej9D2KDKQKmDl
         jGbS9Yjm7xACFn433eyVlta/a9z1iL2LZL/hvkpVeAGl5yAacayXqBwYr/tPDpfN5+dz
         c3jJgXMUIsUVG1RG6ufWqdivIvyhUBiMbe2NLwZT7PxgnOncG/hj9LxCmfO+WmCGPN2f
         iK9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UWaKV5PzvMW5nZbiLxszZKdWQXmMmUkwwQ3825gf38s=;
        b=PawW9y4sDFVQ2/8yZOG99Kp5q57pM6vxNEaQcjVhtz6oB/kemHNsSm1RJIi50HDaYj
         qIa2Owh19ch4c1Nqje+vop2g/zqoFzqI+Hy9kRh4dzRAX4SLclUluaJw4F13AIvNCMsc
         xhIvU9k+glLzw0AuUaWrdSHEPI0uFZ3ODwExTqpIO8fuR56h6H+0wmD9GdE/2gYy/zbc
         BofmvJWJoFjcqZH0QeTYBfnGQ9xY3vfGcu3tdnKOf4lvI5Conoymd+tHbWT3cfDKKR0e
         a8WE0UzuET3nboHEAgiK6ynp2KOtExVIEsHiFrei7DjAbNqKk5dB0WhgutZXBEhdi9YA
         VmIQ==
X-Gm-Message-State: AOAM531Wb9ZJ8o2Ll7c7QxY5IZNO1PETDEeo6EMamUYGFDFBj7IqbNi0
        oH8hP+S3HT+2PFwcG0fgDWe+AGKZf8sykVQPjZngLw==
X-Google-Smtp-Source: ABdhPJy6ebYTKgol4wjAl8XjhzvVed7h7B1wQrhg/pRpcYBIX8r5OZe7+TSudgLvk6HEb/Z80fDzNsqH9UPwC6vqqok=
X-Received: by 2002:a05:6102:34e2:b0:325:356a:36cc with SMTP id
 bi2-20020a05610234e200b00325356a36ccmr11701299vsb.70.1648487523266; Mon, 28
 Mar 2022 10:12:03 -0700 (PDT)
MIME-Version: 1.0
References: <1648482543-14923-1-git-send-email-kan.liang@linux.intel.com>
In-Reply-To: <1648482543-14923-1-git-send-email-kan.liang@linux.intel.com>
From:   Stephane Eranian <eranian@google.com>
Date:   Mon, 28 Mar 2022 10:11:52 -0700
Message-ID: <CABPqkBQS_VW4isEXBXzukWyUGqZSnR1G8c0p+MvK-MCVTjV2Ww@mail.gmail.com>
Subject: Re: [PATCH] perf/x86/intel: Don't extend the pseudo-encoding to GP counters
To:     kan.liang@linux.intel.com
Cc:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 28, 2022 at 8:50 AM <kan.liang@linux.intel.com> wrote:
>
> From: Kan Liang <kan.liang@linux.intel.com>
>
> The INST_RETIRED.PREC_DIST event (0x0100) doesn't count on SPR.
> perf stat -e cpu/event=0xc0,umask=0x0/,cpu/event=0x0,umask=0x1/ -C0
>
>  Performance counter stats for 'CPU(s) 0':
>
>            607,246      cpu/event=0xc0,umask=0x0/
>                  0      cpu/event=0x0,umask=0x1/
>
> The encoding for INST_RETIRED.PREC_DIST is pseudo-encoding, which
> doesn't work on the generic counters. However, current perf extends its
> mask to the generic counters.
>
> The pseudo event-code for a fixed counter must be 0x00. Check and avoid
> extending the mask for the fixed counter event which using the
> pseudo-encoding, e.g., ref-cycles and PREC_DIST event.
>
> With the patch,
> perf stat -e cpu/event=0xc0,umask=0x0/,cpu/event=0x0,umask=0x1/ -C0
>
>  Performance counter stats for 'CPU(s) 0':
>
>            583,184      cpu/event=0xc0,umask=0x0/
>            583,048      cpu/event=0x0,umask=0x1/
>
> Fixes: 2de71ee153ef ("perf/x86/intel: Fix ICL/SPR INST_RETIRED.PREC_DIST encodings")
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/events/intel/core.c      | 6 +++++-
>  arch/x86/include/asm/perf_event.h | 5 +++++
>  2 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index db32ef6..1d2e49d 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -5668,7 +5668,11 @@ static void intel_pmu_check_event_constraints(struct event_constraint *event_con
>                         /* Disabled fixed counters which are not in CPUID */
>                         c->idxmsk64 &= intel_ctrl;
>
> -                       if (c->idxmsk64 != INTEL_PMC_MSK_FIXED_REF_CYCLES)
> +                       /*
> +                        * Don't extend the pseudo-encoding to the
> +                        * generic counters
> +                        */
> +                       if (!use_fixed_pseudo_encoding(c->code))
>                                 c->idxmsk64 |= (1ULL << num_counters) - 1;
>                 }
>                 c->idxmsk64 &=
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 48e6ef56..cd85f03 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -242,6 +242,11 @@ struct x86_pmu_capability {
>  #define INTEL_PMC_IDX_FIXED_SLOTS      (INTEL_PMC_IDX_FIXED + 3)
>  #define INTEL_PMC_MSK_FIXED_SLOTS      (1ULL << INTEL_PMC_IDX_FIXED_SLOTS)
>
> +static inline bool use_fixed_pseudo_encoding(u64 code)
> +{
> +       return !(code & 0xff);
> +}
> +
I ack the problem.

That does not take into account the old encoding for PREC_DIST 0x01c0
which is also forced to
fixed counter0 on ICL and should not be extended.

That also limits the options for the SLOTS events which can be
measured by a GP. Yet to work
with PERF_METRICS, it has to be programmed into fixed counter 3.

>  /*
>   * We model BTS tracing as another fixed-mode PMC.
>   *
> --
> 2.7.4
>
