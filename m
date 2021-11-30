Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F46E4629A3
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 02:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbhK3B2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 20:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhK3B2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 20:28:32 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF7AC061714
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 17:25:13 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id l7so37924382lja.2
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 17:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1aOU62sEoY17NbFNbDybiVS0K59KvQupYrTSRVeXj/A=;
        b=HyW4IaEHVteybeW/M0Z4jR0YqK2TCk5Kkdv1RkQqD8D63Kpi89zOcDlp1la7UYPsRS
         3EUwKSVoEsmMH6gkBc59W0P+RrUoBliJY+1gb8XdHPOd/FtlvxAGHeD3qyZsdSkUVLb6
         bIhlwFqWm2PDTEjHHzRbs7dgZQBjQAecMmwBN7M9oEcoTaTxDdXsnrxej2SdVtW6nG4U
         m/D77jWQ5ICZeLrA5bUJPb2eBR9fvBHLMsVWYSzz0R6nas82QcrAih0esrPjyMYuA7Px
         jbeDuTMnj+dbsOl+xhtClgUXR5IA3vr3pj1aJlnVWvoIdj0oLMVJb/oMar+Frtef+gYy
         ASjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1aOU62sEoY17NbFNbDybiVS0K59KvQupYrTSRVeXj/A=;
        b=2kDb1SKFeEJ6OkvzFL9aHUHYKq7E0LwSKHp3pEKasr4TBBjnq7HpJ3FBbNj3tiRdNe
         753/bYZhNTJ2RF1S0Zomm/Qq5ZEG73fDjSWPFJnFYiEJiPmCmv7Qh4R7lLfNo6uRBRLD
         56uwYuns0m19CRdihTO3fNYXy43mxiWhm88iNqR5yYjHMCR0jXpRHAdmClvqCayv3K8B
         g5KYcpXy6sCZ7bWPLO9Za9a0w45n8y6bYenWXK44T3+zkMeMKA3rNO75cODwLCUbIp0q
         +1sx20szZ0fMQV96t2BrsRjAvrUOzDJEgw3YaAXc/psEhJpoNhJjF/TP46ignNKG7nEK
         KtXw==
X-Gm-Message-State: AOAM530XoNw1jxrdaXKFM+cVyextidebKg43QsEGPozaUqg1z3jcimv5
        LhtAZJCPj7exrX8cptU/uQGFUEifVPRnb9Y0jWVj5g==
X-Google-Smtp-Source: ABdhPJxttSh9XdFPcNOWvXNMWWNt8QdUamM0+EPygp4nvEYFPqPBpnT8xC/kB4mnwwwxF+M2bDGZyQUl/U4Ro5fhkAU=
X-Received: by 2002:a2e:8991:: with SMTP id c17mr50284659lji.361.1638235511602;
 Mon, 29 Nov 2021 17:25:11 -0800 (PST)
MIME-Version: 1.0
References: <20211115211704.2621644-1-bgardon@google.com> <YZL1ZiKQVRQd8rZi@google.com>
In-Reply-To: <YZL1ZiKQVRQd8rZi@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 29 Nov 2021 17:24:45 -0800
Message-ID: <CALzav=cXWUUrKFwKgTEKjb=TQTLTNcQv62BwjdyUqsLjwYZ=hQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] KVM: x86/mmu: Fix TLB flush range when handling
 disconnected pt
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
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

This is a great point. Regardless of our stance on variable function
declaration, the refactor wouldn't make sense to send to stable (or at
the minimum it should be considered separately in its own patch).

> and my personal preference is to always declare variables at function sco=
pe (it's
> not a hard rule though, Paolo has overruled me at least once :-) ).
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

Ah I have not had the pleasure of debugging a variable shadowing bug
before :), so I never even considered this.

This is something that a compiler could easily detect and disallow for
us. In fact GCC has the -Wshadow=3Dlocal option which disallows local
variables shadowing other local variables and function parameters.
Unfortunately, Clang either doesn't support this option or spells it
differently (but I haven't been able to find it). I tried to build KVM
with -Wshadow=3Dlocal today but it looks like I need to get a newer
version of GCC and that's as far as I got.

Both Clang and GCC support -Wshadow but that is too broad. It prevents
local variables from shadowing global variables, which would prevent
us from having local variables named "apic" among other common names.

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
