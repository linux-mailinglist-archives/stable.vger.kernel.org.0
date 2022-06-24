Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60171559B39
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 16:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiFXOPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 10:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbiFXOP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 10:15:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8814B5639E;
        Fri, 24 Jun 2022 07:15:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F6BBB828DA;
        Fri, 24 Jun 2022 14:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7682C34114;
        Fri, 24 Jun 2022 14:15:08 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Y1s5r4Kh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656080106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dpWcY0NYNZuezo2Tw0JtyiSfj9c/CF2JU5aAznNpM8M=;
        b=Y1s5r4KhWMGGLtWRMz0m53TqO+2HVN6EzdpbVeQB/he3PkOZ+gRFK2y2IDbAoPcrBsyun+
        7TbkC2jCthSeTFADtebhiEgLk3qSKaFy1BcPBlI2WUySrSlY4uORNVdgTAjRu7fgrJp7mB
        UtK8UtlG6x/s/673UrhKQZKMybmPtMA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3fab5d6c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 24 Jun 2022 14:15:06 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id h85so2832569iof.4;
        Fri, 24 Jun 2022 07:15:06 -0700 (PDT)
X-Gm-Message-State: AJIora98ooDFiLUwb4aj9PaKSkKjHVornbJoF8DCfcqrhSN3WZXiG3SC
        HekbR6vWsiuOoRG6L1FEQDQlmc8dUp99cYDgix8=
X-Google-Smtp-Source: AGRyM1t1InIqxukka1FzW9hva/iu0Be7xBboO5VNY8Vzat7NBpl5N1IllrbmNr4RPAeG8SjpJkBdnVQx0iRMYpNWvUw=
X-Received: by 2002:a05:6638:470a:b0:331:bd53:87a2 with SMTP id
 cs10-20020a056638470a00b00331bd5387a2mr8932516jab.204.1656080105550; Fri, 24
 Jun 2022 07:15:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220622105435.203922-1-Jason@zx2c4.com> <87a6a2qirw.fsf@linux.ibm.com>
In-Reply-To: <87a6a2qirw.fsf@linux.ibm.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 24 Jun 2022 16:14:54 +0200
X-Gmail-Original-Message-ID: <CAHmME9q9XY=nWvfbV+sV_frRaKPGBWSyShUShQyMayA_FpNWPg@mail.gmail.com>
Message-ID: <CAHmME9q9XY=nWvfbV+sV_frRaKPGBWSyShUShQyMayA_FpNWPg@mail.gmail.com>
Subject: Re: [PATCH] powerpc/kvm: don't crash on missing rng, and use darn
To:     Fabiano Rosas <farosas@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Fabiano,

On Fri, Jun 24, 2022 at 3:43 PM Fabiano Rosas <farosas@linux.ibm.com> wrote:
>
> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
>
> > On POWER8 systems that don't have ibm,power-rng available, a guest that
> > ignores the KVM_CAP_PPC_HWRNG flag and calls H_RANDOM anyway will
> > dereference a NULL pointer. And on machines with darn instead of
> > ibm,power-rng, H_RANDOM won't work at all.
> >
> > This patch kills two birds with one stone, by routing H_RANDOM calls to
> > ppc_md.get_random_seed, and doing the real mode check inside of it.
> >
> > Cc: stable@vger.kernel.org # v4.1+
> > Cc: Michael Ellerman <mpe@ellerman.id.au>
> > Fixes: e928e9cb3601 ("KVM: PPC: Book3S HV: Add fast real-mode H_RANDOM implementation.")
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
> >
> > This patch must be applied ontop of:
> > 1) https://github.com/linuxppc/linux/commit/f3eac426657d985b97c92fa5f7ae1d43f04721f3
> > 2) https://lore.kernel.org/all/20220622102532.173393-1-Jason@zx2c4.com/
> >
> >
> >  arch/powerpc/include/asm/archrandom.h |  5 ----
> >  arch/powerpc/kvm/book3s_hv_builtin.c  |  5 ++--
> >  arch/powerpc/platforms/powernv/rng.c  | 33 +++++++--------------------
> >  3 files changed, 11 insertions(+), 32 deletions(-)
> >
> > diff --git a/arch/powerpc/include/asm/archrandom.h b/arch/powerpc/include/asm/archrandom.h
> > index 11d4815841ab..3af27bb84a3d 100644
> > --- a/arch/powerpc/include/asm/archrandom.h
> > +++ b/arch/powerpc/include/asm/archrandom.h
> > @@ -38,12 +38,7 @@ static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
> >  #endif /* CONFIG_ARCH_RANDOM */
> >
> >  #ifdef CONFIG_PPC_POWERNV
> > -int pnv_hwrng_present(void);
> >  int pnv_get_random_long(unsigned long *v);
> > -int pnv_get_random_real_mode(unsigned long *v);
> > -#else
> > -static inline int pnv_hwrng_present(void) { return 0; }
> > -static inline int pnv_get_random_real_mode(unsigned long *v) { return 0; }
> >  #endif
> >
> >  #endif /* _ASM_POWERPC_ARCHRANDOM_H */
> > diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
> > index 799d40c2ab4f..1c6672826db5 100644
> > --- a/arch/powerpc/kvm/book3s_hv_builtin.c
> > +++ b/arch/powerpc/kvm/book3s_hv_builtin.c
> > @@ -176,13 +176,14 @@ EXPORT_SYMBOL_GPL(kvmppc_hcall_impl_hv_realmode);
> >
> >  int kvmppc_hwrng_present(void)
> >  {
> > -     return pnv_hwrng_present();
> > +     return ppc_md.get_random_seed != NULL;
> >  }
> >  EXPORT_SYMBOL_GPL(kvmppc_hwrng_present);
> >
> >  long kvmppc_rm_h_random(struct kvm_vcpu *vcpu)
> >  {
> > -     if (pnv_get_random_real_mode(&vcpu->arch.regs.gpr[4]))
> > +     if (ppc_md.get_random_seed &&
> > +         ppc_md.get_random_seed(&vcpu->arch.regs.gpr[4]))
> >               return H_SUCCESS;
>
> This is the same as arch_get_random_seed_long, perhaps you could use it
> instead.

Sure, why not. Will send a v2.

Jason
