Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5985E45388B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 18:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238915AbhKPRdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 12:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238906AbhKPRdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 12:33:00 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322A0C061764
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 09:30:03 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id y16so27108705ioc.8
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 09:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UFXLUrqt2nWjnEKxs8dvNrPBWJOzGCmF0MKcZw+tO+E=;
        b=dluHkotYDKJNPQxe/aYzm9VcuvkPHtOj3GlbfBPZ2Fva+bWRx4a7xEHBEvIwoQuymZ
         QG1A+X0KpRfscM20AKXTdDqYKRAA92U1vvMLN05x3hSc5lMqh6tlFDa84vX6jES+4fCq
         f87jWtAGxkpCyyY0I+2Fqiyny61PdCUyVlvRtfNWZPuMQVUmHIF1CfkaoZtzhVSXRHpS
         SyiD9HuuTDkKEDC7tUpQPvUjSoXrl6a2GTvB4RnMZNupDCpgSEl2PJJFLxDx+woy3eg6
         fHGW80Wrakaz0W+60xgpJlz4tG+A4TWJxQTjQjDurY9fIQ+hKv+qxFPU/KTKxGO7qcY8
         reaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UFXLUrqt2nWjnEKxs8dvNrPBWJOzGCmF0MKcZw+tO+E=;
        b=C4AqWEQW3I1sxSEUzpbFg/RPEzDnNUfGbK4J3b699yDsyehXgC4VkAVkrXWwshjv2f
         4u2vTh51eo2eOEoR3g/hG8fjXiJXrh8k7sXLlndbCF6OB80l7NGlW7tuZ8Pmrwgxycd6
         vfFzxpwQi4emH8lb0St+I+aEvppWCcSwbxJYqZkwuUG9N5Lba1WpQXt0j4MjzRcv1eo4
         UES99OQWofs16ySuJ9o3ix365Wfd06/OH4PNtbpkWzZjjoVDDrkT8n7fVrxeRaSQ8phU
         1viwV2Aq6xh8MDmDrapwWBCY4DnkRXx23bfMd4l1qlb3zvTAMQH5Obh7I8Kx5/OlmZ7l
         LeEQ==
X-Gm-Message-State: AOAM532oqAiYtvgi3f6KyuqRvPqu8Vy0FbLRTtiEbynW7l2gOtmd4SKf
        pcYXM7yqjztVt3zZnB+cCigmQ9p53UfXmd81Xy9n4w==
X-Google-Smtp-Source: ABdhPJzYH+IIPNW2qbWehRxVmvJb0UAszoUsv5tmhNjRZ4u918O1kNBkkesQHn3b3tc5ZiH7sRY06sN8IUPwh7WWF3A=
X-Received: by 2002:a02:70cf:: with SMTP id f198mr7017013jac.124.1637083802289;
 Tue, 16 Nov 2021 09:30:02 -0800 (PST)
MIME-Version: 1.0
References: <20211115211704.2621644-1-bgardon@google.com> <YZL1ZiKQVRQd8rZi@google.com>
In-Reply-To: <YZL1ZiKQVRQd8rZi@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 16 Nov 2021 09:29:50 -0800
Message-ID: <CANgfPd-UQKbnkoKGS0yoQvTtMAyPc0Xa2=o7ics2vQ50-KGQHA@mail.gmail.com>
Subject: Re: [PATCH 1/1] KVM: x86/mmu: Fix TLB flush range when handling
 disconnected pt
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 4:03 PM Sean Christopherson <seanjc@google.com> wro=
te:
>
> On Mon, Nov 15, 2021, Ben Gardon wrote:
> > When recursively clearing out disconnected pts, the range based TLB
> > flush in handle_removed_tdp_mmu_page uses the wrong starting GFN,
> > resulting in the flush mostly missing the affected range. Fix this by
> > using base_gfn for the flush.
> >
> > In response to feedback from David Matlack on the RFC version of this
> > patch, also move a few definitions into the for loop in the function to
> > prevent unintended references to them in the future.
>
> Rats, I didn't read David's feedback or I would've responded there.
>
> > Fixes: a066e61f13cf ("KVM: x86/mmu: Factor out handling of removed page=
 tables")
> > CC: stable@vger.kernel.org
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 7c5dd83e52de..4bd541050d21 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -317,9 +317,6 @@ static void handle_removed_tdp_mmu_page(struct kvm =
*kvm, tdp_ptep_t pt,
> >       struct kvm_mmu_page *sp =3D sptep_to_sp(rcu_dereference(pt));
> >       int level =3D sp->role.level;
> >       gfn_t base_gfn =3D sp->gfn;
> > -     u64 old_child_spte;
> > -     u64 *sptep;
> > -     gfn_t gfn;
> >       int i;
> >
> >       trace_kvm_mmu_prepare_zap_page(sp);
> > @@ -327,8 +324,9 @@ static void handle_removed_tdp_mmu_page(struct kvm =
*kvm, tdp_ptep_t pt,
> >       tdp_mmu_unlink_page(kvm, sp, shared);
> >
> >       for (i =3D 0; i < PT64_ENT_PER_PAGE; i++) {
> > -             sptep =3D rcu_dereference(pt) + i;
> > -             gfn =3D base_gfn + i * KVM_PAGES_PER_HPAGE(level);
> > +             u64 *sptep =3D rcu_dereference(pt) + i;
> > +             gfn_t gfn =3D base_gfn + i * KVM_PAGES_PER_HPAGE(level);
> > +             u64 old_child_spte;
>
> TL;DR: this type of optional refactoring doesn't belong in a patch Cc'd f=
or stable,
> and my personal preference is to always declare variables at function sco=
pe (it's
> not a hard rule though, Paolo has overruled me at least once :-) ).

That makes sense. I don't have a preference either way. Paolo, if you
want the version without the refactor, the version I sent in the RFC
should be good. If the refactor is desired, I can separate it out into
another patch and send a v2 of this patch as a mini series, tagging
only the fix for stable.

I've generally preferred declaring variables at function scope too
since that seems like the overwhelming convention, but it's always
struck me as a bit of a waste to not make use of scoping rules more.
It does make it nice and clear how things should be laid out when
debugging the kernel with GDB or something though.

In any case, please let me know how you'd like the changes organized
and I can send up follow ups as needed, or we can just move forward
with the RFC version.

>
> Declaring variables in an inner scope is not always "better".  In particu=
lar, it
> can lead to variable shadowing, which can lead to functional issues of a =
different
> sort.  Most shadowing is fairly obvious, and truly egregious bugs will of=
ten result
> in the compiler complaining about consuming an uninitialized variable.
>
> But the worst-case scenario is if the inner scope shadows a function para=
meter, in
> which the case the compiler will not complain and will even consume an un=
initialized
> variable without warning.  IIRC, we actually had a Hyper-V bug of that na=
ture
> where an incoming @vcpu was shadowed.  Examples below.
>
> So yes, on one hand moving the declarations inside the loop avoid potenti=
al flavor
> of bug, but they create the possibility for an entirely different class o=
f bugs.
> The main reason I prefer declaring at function scope is that I find it ea=
sier to
> visually detect using variables after a for loop, versus detecting that a=
 variable
> is being shadowed, especially if the function is largish and the two decl=
arations
> don't fit on the screen.
>
> There are of course counter-examples, e.g. commit 5c49d1850ddd ("KVM: VMX=
: Fix a
> TSX_CTRL_CPUID_CLEAR field mask issue") immediately jumps to mind, so the=
re's
> certainly an element of personal preference.
>
> E.g. this will fail with "error: =E2=80=98sptep=E2=80=99 redeclared as di=
fferent kind of symbol
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4e226cdb40d9..011639bf633c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -369,7 +369,7 @@ static void tdp_mmu_unlink_page(struct kvm *kvm, stru=
ct kvm_mmu_page *sp,
>   * early rcu_dereferences in the function.
>   */
>  static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
> -                                       bool shared)
> +                                       bool shared, u64 *sptep)
>  {
>         struct kvm_mmu_page *sp =3D sptep_to_sp(rcu_dereference(pt));
>         int level =3D sp->role.level;
> @@ -431,8 +431,9 @@ static void handle_removed_tdp_mmu_page(struct kvm *k=
vm, tdp_ptep_t pt,
>                                     shared);
>         }
>
> -       kvm_flush_remote_tlbs_with_address(kvm, gfn,
> -                                          KVM_PAGES_PER_HPAGE(level + 1)=
);
> +       if (sptep)
> +               kvm_flush_remote_tlbs_with_address(kvm, gfn,
> +                                                  KVM_PAGES_PER_HPAGE(le=
vel + 1));
>
>         call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
> @@ -532,7 +533,7 @@ static void __handle_changed_spte(struct kvm *kvm, in=
t as_id, gfn_t gfn,
>          */
>         if (was_present && !was_leaf && (is_leaf || !is_present))
>                 handle_removed_tdp_mmu_page(kvm,
> -                               spte_to_child_pt(old_spte, level), shared=
);
> +                               spte_to_child_pt(old_spte, level), shared=
, NULL);
>  }
>
>  static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>
>
> whereas moving the second declaration into the loop will compile happily.
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4e226cdb40d9..3e83fd66c0dc 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -369,13 +369,12 @@ static void tdp_mmu_unlink_page(struct kvm *kvm, st=
ruct kvm_mmu_page *sp,
>   * early rcu_dereferences in the function.
>   */
>  static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
> -                                       bool shared)
> +                                       bool shared, u64 *sptep)
>  {
>         struct kvm_mmu_page *sp =3D sptep_to_sp(rcu_dereference(pt));
>         int level =3D sp->role.level;
>         gfn_t base_gfn =3D sp->gfn;
>         u64 old_child_spte;
> -       u64 *sptep;
>         gfn_t gfn;
>         int i;
>
> @@ -384,7 +383,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *k=
vm, tdp_ptep_t pt,
>         tdp_mmu_unlink_page(kvm, sp, shared);
>
>         for (i =3D 0; i < PT64_ENT_PER_PAGE; i++) {
> -               sptep =3D rcu_dereference(pt) + i;
> +               u64 *sptep =3D rcu_dereference(pt) + i;
>                 gfn =3D base_gfn + i * KVM_PAGES_PER_HPAGE(level);
>
>                 if (shared) {
> @@ -431,8 +430,9 @@ static void handle_removed_tdp_mmu_page(struct kvm *k=
vm, tdp_ptep_t pt,
>                                     shared);
>         }
>
> -       kvm_flush_remote_tlbs_with_address(kvm, gfn,
> -                                          KVM_PAGES_PER_HPAGE(level + 1)=
);
> +       if (sptep)
> +               kvm_flush_remote_tlbs_with_address(kvm, gfn,
> +                                                  KVM_PAGES_PER_HPAGE(le=
vel + 1));
>
>         call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
> @@ -532,7 +532,7 @@ static void __handle_changed_spte(struct kvm *kvm, in=
t as_id, gfn_t gfn,
>          */
>         if (was_present && !was_leaf && (is_leaf || !is_present))
>                 handle_removed_tdp_mmu_page(kvm,
> -                               spte_to_child_pt(old_spte, level), shared=
);
> +                               spte_to_child_pt(old_spte, level), shared=
, NULL);
>  }
>
>  static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
