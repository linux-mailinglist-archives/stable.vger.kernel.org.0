Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1D6376A3C
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 20:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhEGTAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 15:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhEGTAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 15:00:53 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB541C061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 11:59:53 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id y2so13172312ybq.13
        for <stable@vger.kernel.org>; Fri, 07 May 2021 11:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2kiSQ0EodrzQgJhbsscaNfeeP0v0QH+sW0zFku5zQgg=;
        b=lTw9yV5RDqvr3wL3HiDhX+n84PCywZqqOPwVC0bm0j3okhesZlsX/u6/mXd90lCzwr
         1ndLToHE7JdEDKlokJOQctpFqF6Bcx6wRfb9nGdBt8sau0s9rbV8fsq8KFDkmaoK893+
         BEuzdLEmYuKE06giQvDrYRpjX99esbR+60QU1/KX0RvmPiT+eb2oSRCVBetLoXXUYmvd
         JXW0Bu53DFeL1QPVRRnQCbLmDQO2FRol69uoKqVXZjZWL6qjWjbk3tS+ANoEof5te2s9
         A3D0j9+hPjeHpqJJB+/CT7D49KnU0yTPl8ZOglE95UdQvAOKd4hec9u/gJSHIRjk9BuD
         CsGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2kiSQ0EodrzQgJhbsscaNfeeP0v0QH+sW0zFku5zQgg=;
        b=S+yBbk0/OL40yVWRRHISbahdhoD9IHT/pX+bt3Ijo+gaM4RneLlTaEptMcwAEP206z
         QvDG4J92O2+wqNHNMkqzE2/PgOvY7JqDcn2cB7dZcxTTfD+PfIbYk96bvukpyQCMzLz3
         829hvZuLqLDVnTspGmV/eQbqcwq1RkiQUjzoHu1o9i4TbRX+/qmBZ4cetntq40FtO+ri
         lvuljCjre6OKKVCSmuDMmBWUwa8Y4ejUttRrWI62SKAWTrD8e5XdrxvGk7SgOPoHzLTm
         P2zctLfHUlU8uFI1W3fQJZpWKBMlq6eclHQoTZ64ZFtEVg2PCdvdC/h27QxyshQSGucU
         udaQ==
X-Gm-Message-State: AOAM531L7I1Qtip8OXJK8qhIyUFoeUnleu6ZjL+wOCfYxiXIsP6FRAWl
        6mP3se5id5f/Trxb2bP1amO+KW/eFJn3MivqJgae+g==
X-Google-Smtp-Source: ABdhPJxdiGHbiugFN0oUKRMpH9dXc6WXNMgvBEZG8J5ER10t4I4Xts+lnh1UWZ8539Hg3YOxw2T4NiwP0syB4+mX5HY=
X-Received: by 2002:a25:2d64:: with SMTP id s36mr15920494ybe.412.1620413992763;
 Fri, 07 May 2021 11:59:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210507033725.1479129-1-pcc@google.com> <20210507101115.GB52849@C02TD0UTHF1T.local>
In-Reply-To: <20210507101115.GB52849@C02TD0UTHF1T.local>
From:   Peter Collingbourne <pcc@google.com>
Date:   Fri, 7 May 2021 11:59:41 -0700
Message-ID: <CAMn1gO6Jyt046KBxO_3tKeQL2Kx2-Aq59R+R5Pb9DhKV1_zD1A@mail.gmail.com>
Subject: Re: [PATCH] arm64: mte: initialize RGSR_EL1.SEED in __cpu_setup
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 7, 2021 at 3:11 AM Mark Rutland <mark.rutland@arm.com> wrote:
>
> Hi Peter,
>
> On Thu, May 06, 2021 at 08:37:25PM -0700, Peter Collingbourne wrote:
> > A valid implementation choice for the ChooseRandomNonExcludedTag()
> > pseudocode function used by IRG is to behave in the same way as with
> > GCR_EL1.RRND=0. This would mean that RGSR_EL1.SEED is used as an LFSR
> > which must have a non-zero value in order for IRG to properly produce
> > pseudorandom numbers. However, RGSR_EL1 is reset to an UNKNOWN value
> > on soft reset and thus may reset to 0. Therefore we must initialize
> > RGSR_EL1.SEED to a non-zero value in order to ensure that IRG behaves
> > as expected.
> >
> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > Cc: stable@vger.kernel.org
> > Link: https://linux-review.googlesource.com/id/I2b089b6c7d6f17ee37e2f0db7df5ad5bcc04526c
> > ---
> >  arch/arm64/mm/proc.S | 17 +++++++++++++++--
> >  1 file changed, 15 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> > index 0a48191534ff..e8e1eaee4b3f 100644
> > --- a/arch/arm64/mm/proc.S
> > +++ b/arch/arm64/mm/proc.S
> > @@ -437,7 +437,7 @@ SYM_FUNC_START(__cpu_setup)
> >       mrs     x10, ID_AA64PFR1_EL1
> >       ubfx    x10, x10, #ID_AA64PFR1_MTE_SHIFT, #4
> >       cmp     x10, #ID_AA64PFR1_MTE
> > -     b.lt    1f
> > +     b.lt    2f
> >
> >       /* Normal Tagged memory type at the corresponding MAIR index */
> >       mov     x10, #MAIR_ATTR_NORMAL_TAGGED
> > @@ -447,6 +447,19 @@ SYM_FUNC_START(__cpu_setup)
> >       mov     x10, #(SYS_GCR_EL1_RRND | SYS_GCR_EL1_EXCL_MASK)
> >       msr_s   SYS_GCR_EL1, x10
> >
> > +     /*
> > +      * Initialize RGSR_EL1.SEED to a non-zero value. If the implementation
> > +      * chooses to implement GCR_EL1.RRND=1 in the same way as RRND=0 then
> > +      * the seed will be used as an LFSR, so it should be put onto the MLS.
> > +      */
>
> For those of us not familiar with LFSRs, could we crib a bit from the
> commit message to describe why, e.g.
>
>         /*
>          * If GCR_EL1.RRND=1 is implemented the same way as RRND=0, then
>          * RGSR_EL1.SEED must be non-zero for IRG to produce
>          * pseudorandom numbers. As RGSR_EL1 is UNKNOWN out of reset, we
>          * must initialize it.
>          */

Done in v2.

> > +     mrs     x10, CNTVCT_EL0
> > +     and     x10, x10, #SYS_RGSR_EL1_SEED_MASK
> > +     cbnz    x10, 1f
> > +     mov     x10, #1
> > +1:
>
> To minimize the diff and make this more locally contained, we could
> avoid the branch and relabelling by using ANDS and CSET:
>
>         mrs     x10, CNTVCT_EL0
>         ands    x10, x10, #SYS_RGSR_EL1_SEED_MASK
>         cset    x10, ne
>
> ... or we could unconditionally ORR in 1:
>
>         mrs     x10, CNTVCT_EL0
>         orr     x10, x10, #1
>         and     x10, x10, #SYS_RGSR_EL1_SEED_MASK

Let's go with the first option to preserve as much entropy as
possible. But I think the last instruction needs to be:

csinc   x10, x10, xzr, ne

Otherwise we will end up setting x10 to either 0 or 1.

Peter

>
> Thanks,
> Mark.
>
> > +     lsl     x10, x10, #SYS_RGSR_EL1_SEED_SHIFT
> > +     msr_s   SYS_RGSR_EL1, x10
> > +
> >       /* clear any pending tag check faults in TFSR*_EL1 */
> >       msr_s   SYS_TFSR_EL1, xzr
> >       msr_s   SYS_TFSRE0_EL1, xzr
> > @@ -454,7 +467,7 @@ SYM_FUNC_START(__cpu_setup)
> >       /* set the TCR_EL1 bits */
> >       mov_q   x10, TCR_KASAN_HW_FLAGS
> >       orr     tcr, tcr, x10
> > -1:
> > +2:
> >  #endif
> >       tcr_clear_errata_bits tcr, x9, x5
> >
> > --
> > 2.31.1.607.g51e8a6a459-goog
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
