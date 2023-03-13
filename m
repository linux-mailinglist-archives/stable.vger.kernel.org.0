Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB376B7F39
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 18:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbjCMRSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 13:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjCMRRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 13:17:48 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0937EA24
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 10:17:15 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id e19so5339876vsu.4
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 10:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678727792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=atthlkG+b5FY8NgV5FVLsw/Ng1x3zgIJDT+mNp/s7+c=;
        b=jj2jmzhM3skZ4z/7JrlVVqfRM7qjYiCJoSr16LkymZJHkG4rLtveTmkas30wAFlcXT
         I0Pi/w1JEL19Is0/TfeZeh/WhTGUart95C+f2ZBMdeqjdQLcnXGttO58nntAQZ4X8brT
         W2jzusJu8H/ffmV/+IDtRnJAdYjYUmFfkgivUTECd7V8CGw1p09NZ0IohEn2aAkIKIEc
         3aGch4p8pDWYrxjr+ZFdsLfMaWO35YxUrU90Af79tc14K4gGaFT3x13oyxTlSrD00Yg5
         1lABaI4tcGSvGpnUbdsyTr1OoREcbbo4Y10ary27Xqgv9m5tpoTZbNBGuaHFG/Bqj/Dg
         KODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678727792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=atthlkG+b5FY8NgV5FVLsw/Ng1x3zgIJDT+mNp/s7+c=;
        b=CFbQqqKNZDB5v4yoh5538nauFe+3qIZhUwe0O5Z+BeKF6XmetAeuuzZP6cUXdfeY8B
         s/AHQZqyJdytYy5pxtR4Wf7oSVn1r0A+o7r2qUc4wug1PAFmI9bJjpda7yImBQcduPlf
         QesYKLl2ormLwTRqk/cjHmoYqFJU6FjVkGhmzTk1UfWaVyfo2EprNlFO4XHHzXbDJUSL
         Cvtcw1X0UIHgXtNiOVPORu9OvB1ionrjryhnb61WZZ5iKQO2yM1AkYDJu0VwVDwQTumj
         lmmkl45zCWmojeoCbiURR6NmCIY/xE6bXyWIQ9NSogxYEy8W/xHRjlGSxZnEqX3kQb5d
         zLuQ==
X-Gm-Message-State: AO0yUKW7hJOhxkChnoEdZiHoFb9GZ4koJ5Im2RLcvVXY8SdMvJCBtBY1
        29ev3wv43SeBj0VWnDUx9iW6k1CiOTom2eQS4eE5LA==
X-Google-Smtp-Source: AK7set8T0nOpfvbkpWYW5W/OJm+3odNxN+DJmTGlzQYkjhNXuH4GeNK1jYLVeeVnzm6Yi0FQ93YVVHMVH/aIP4BN+pk=
X-Received: by 2002:a67:f350:0:b0:423:e6b4:9582 with SMTP id
 p16-20020a67f350000000b00423e6b49582mr4005065vsm.4.1678727791808; Mon, 13 Mar
 2023 10:16:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230313091425.1962708-1-maz@kernel.org> <20230313091425.1962708-2-maz@kernel.org>
 <ZA9HAQtkCDwFXcsm@google.com>
In-Reply-To: <ZA9HAQtkCDwFXcsm@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 13 Mar 2023 10:16:05 -0700
Message-ID: <CALzav=c3aKNT-7CzkrFC8YCCwj-E16JYWwsmOV-HaLbODG67hQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Disable interrupts while walking
 userspace PTs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 13, 2023 at 8:53=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> +David
>
> On Mon, Mar 13, 2023, Marc Zyngier wrote:
> > We walk the userspace PTs to discover what mapping size was
> > used there. However, this can race against the userspace tables
> > being freed, and we end-up in the weeds.
> >
> > Thankfully, the mm code is being generous and will IPI us when
> > doing so. So let's implement our part of the bargain and disable
> > interrupts around the walk. This ensures that nothing terrible
> > happens during that time.
> >
> > We still need to handle the removal of the page tables before
> > the walk. For that, allow get_user_mapping_size() to return an
> > error, and make sure this error can be propagated all the way
> > to the the exit handler.
> >
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Cc: stable@vger.kernel.org
> > ---
> >  arch/arm64/kvm/mmu.c | 35 ++++++++++++++++++++++++++++-------
> >  1 file changed, 28 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 7113587222ff..d7b8b25942df 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -666,14 +666,23 @@ static int get_user_mapping_size(struct kvm *kvm,=
 u64 addr)
> >                                  CONFIG_PGTABLE_LEVELS),
> >               .mm_ops         =3D &kvm_user_mm_ops,
> >       };
> > +     unsigned long flags;
> >       kvm_pte_t pte =3D 0;      /* Keep GCC quiet... */
> >       u32 level =3D ~0;
> >       int ret;
> >
> > +     /*
> > +      * Disable IRQs so that we hazard against a concurrent
> > +      * teardown of the userspace page tables (which relies on
> > +      * IPI-ing threads).
> > +      */
> > +     local_irq_save(flags);
> >       ret =3D kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
> > -     VM_BUG_ON(ret);
> > -     VM_BUG_ON(level >=3D KVM_PGTABLE_MAX_LEVELS);
> > -     VM_BUG_ON(!(pte & PTE_VALID));
> > +     local_irq_restore(flags);
> > +
> > +     /* Oops, the userspace PTs are gone... */
> > +     if (ret || level >=3D KVM_PGTABLE_MAX_LEVELS || !(pte & PTE_VALID=
))
> > +             return -EFAULT;
>
> I don't think this should return -EFAULT all the way out to userspace.  U=
nless
> arm64 differs from x86 in terms of how the userspace page tables are mana=
ged, not
> having a valid translation _right now_ doesn't mean that one can't be cre=
ated in
> the future, e.g. by way of a subsequent hva_to_pfn().
>
> FWIW, the approach x86 takes is to install a 4KiB (smallest granuale) tra=
nslation,

If I'm reading the ARM code correctly, returning -EFAULT here will
have that effect. get_user_mapping_size() is only called by
transparent_hugepage_adjust() which returns PAGE_SIZE if
get_user_mapping_size() returns anything less than PMD_SIZE.

> which is safe since there _was_ a valid translation when mmu_lock was acq=
uired and
> mmu_invalidate_retry() was checked.  It's the primary MMU's responsibilit=
y to ensure
> all secondary MMUs are purged before freeing memory, i.e. worst case shou=
ld be that
> KVMs stage-2 translation will be immediately zapped via mmu_notifier.
>
> KVM ARM also has a bug that might be related: the mmu_seq snapshot needs =
to be
> taken _before_ mmap_read_unlock(), otherwise vma_shift may be stale by th=
e time
> it's consumed.  I believe David is going to submit a patch (I found and "=
reported"
> the bug when doing an internal review of "common MMU" stuff).

Yeah and RISC-V has that same bug. I'll try to have fixes for each out
this week.

After that, I'd also like to refactor how ARM and RISC-V calculate the
host mapping size to match what we do on x86: always walk the host
page table. This will unify the handling for HugeTLB and THP, avoid
needing to take the mmap_lock, and we can even share the host page
table walk code across architectures (Linux's host page table code is
already common).
