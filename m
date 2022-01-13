Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3798E48DC8C
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 18:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiAMRE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 12:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiAMRE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 12:04:58 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C73C06161C
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 09:04:57 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id x6so21812866lfa.5
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 09:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wiirCHI6lYv/CvxqqTOCCFzFHxDjKSiNSEL6CkjYGGw=;
        b=EUPKJhUtspuecuPUtrqoPbXGji9V+3FgBt0DaEawld3fO07b7AO93zwSDYtw55cLUj
         Szj5Zgn+nUaxMY5I5Dx5VVH5q0Cz7X3FNmiZKaus/OvwmrTbYeIO/Ioh6f6SeDkH7/wn
         s4xo5HlDvoYa1V0OKN507EahpWGzkJpk32vpr16b7Ai1yo4Z1BoTaS7a0gVBIHg/7iux
         XbjGWv5moUDxTrH0smsYj8AST4GRih3l5k/KTbKvgZsMPdFhMHLezEVjPQ1h0CCMBilG
         5G34IHjGjlau/l/7CcUmDOnX6o4ZDa16uLZN+j/5+P6c2gieRx6egtewNNZuPX5fi/6e
         kJDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wiirCHI6lYv/CvxqqTOCCFzFHxDjKSiNSEL6CkjYGGw=;
        b=lLGx1kcCnu7zIxdXnah3XxE2rgAl88kBwbx/E2bXbIalvBlaVJkeUMGfnldeJ6suWO
         XwPc+dIxXLz06Jw6oZZ50dtX4qAauEcyzt99DfnfW376O2Uq+6IRm74zl7vVROqVtzhg
         GoFbMv/CwU0aJC8IKmWv0u3dCq5kE0v/YvaWOMdXdbbedv9q06vlijZ2j5wCtUXQXr8d
         uIo7RfQQ8puk6yBGvjUOjHS63SBxeN1j+y/qWENji5BpYXbf3G+YJ64IdxXT5GrmTL7+
         rSatiNu1qMdOwpwwxICeTZ/hofgK+pJAmScaJCMC4tGGzuSjSdEiRlfaifMLyxaUCCvX
         U67w==
X-Gm-Message-State: AOAM530erCjHe8f6sz1B0AslK5uWHhNAaMEEFOWivM1P/2UVjTSHR29L
        uKe3LmXoyI52t4qV10O+OUMX2Sk2UFmXZXrxVhAN0w==
X-Google-Smtp-Source: ABdhPJz02utokoeajYaSeqYK/taCM+DKTuVZz2XxQwBmd1oWGB6TtTAmPd1qoMbLHtOVdtmQ92QC3rbqZV3NsKRYKJ4=
X-Received: by 2002:a2e:9ac3:: with SMTP id p3mr3696662ljj.49.1642093495576;
 Thu, 13 Jan 2022 09:04:55 -0800 (PST)
MIME-Version: 1.0
References: <20220112215801.3502286-1-dmatlack@google.com> <20220112215801.3502286-2-dmatlack@google.com>
 <Yd9g1KIoNwUPtFrt@google.com> <CALzav=djDTBxvXEz3O4QQu-2VkOcMESkpxmWYJYKikiGQLwyUA@mail.gmail.com>
 <Yd9ySjsQFeHKnIDv@google.com>
In-Reply-To: <Yd9ySjsQFeHKnIDv@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 13 Jan 2022 09:04:28 -0800
Message-ID: <CALzav=eWMOuuXog5Rk9FwSjQDfM8==qdEGjSp=u9xB3VhBm6qw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Fix write-protection of PTs mapped by
 the TDP MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>,
        kvm list <kvm@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 4:29 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Jan 12, 2022, David Matlack wrote:
> > On Wed, Jan 12, 2022 at 3:14 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Wed, Jan 12, 2022, David Matlack wrote:
> > > > When the TDP MMU is write-protection GFNs for page table protection (as
> > > > opposed to for dirty logging, or due to the HVA not being writable), it
> > > > checks if the SPTE is already write-protected and if so skips modifying
> > > > the SPTE and the TLB flush.
> > > >
> > > > This behavior is incorrect because the SPTE may be write-protected for
> > > > dirty logging. This implies that the SPTE could be locklessly be made
> > > > writable on the next write access, and that vCPUs could still be running
> > > > with writable SPTEs cached in their TLB.
> > > >
> > > > Fix this by unconditionally setting the SPTE and only skipping the TLB
> > > > flush if the SPTE was already marked !MMU-writable or !Host-writable,
> > > > which guarantees the SPTE cannot be locklessly be made writable and no
> > > > vCPUs are running the writable SPTEs cached in their TLBs.
> > > >
> > > > Technically it would be safe to skip setting the SPTE as well since:
> > > >
> > > >   (a) If MMU-writable is set then Host-writable must be cleared
> > > >       and the only way to set Host-writable is to fault the SPTE
> > > >       back in entirely (at which point any unsynced shadow pages
> > > >       reachable by the new SPTE will be synced and MMU-writable can
> > > >       be safetly be set again).
> > > >
> > > >   and
> > > >
> > > >   (b) MMU-writable is never consulted on its own.
> > > >
> > > > And in fact this is what the shadow MMU does when write-protecting guest
> > > > page tables. However setting the SPTE unconditionally is much easier to
> > > > reason about and does not require a huge comment explaining why it is safe.
> > >
> > > I disagree.  I looked at the code+comment before reading the full changelog and
> > > typed up a response saying the code should be:
> > >
> > >                 if (!is_writable_pte(iter.old_spte) &&
> > >                     !spte_can_locklessly_be_made_writable(spte))
> > >                         break;
> > >
> > > Then I went read the changelog and here we are :-)
> > >
> > > I find that much more easier to grok, e.g. in plain English: "if the SPTE isn't
> > > writable and can't be made writable, there's nothing to do".
> >
> > Oh interesting. I actually find that confusing because it can easily
> > lead to the MMU-writable bit staying set. Here we are protecting GFNs
> > and we're opting to leave the MMU-writable bit set. It takes a lot of
> > digging to figure out that this is safe because if MMU-writable is set
> > and the SPTE cannot be locklessly be made writable then it implies
> > Host-writable is clear, and Host-writable can't be reset without
> > syncing the all shadow pages reachable by the MMU. Oh and the
> > MMU-writable bit is never consulted on its own (e.g. We never iterate
> > through all SPTEs to find the ones that are !MMU-writable).
>
> Ah, you've missed the other wrinkle: MMU-writable can bet set iff Host-writable
> is set.  In other words, the MMU-writable bit is never left set because it can't
> be set if spte_can_locklessly_be_made_writable() returns false.

Ohhh I did miss that and yes that explains it. I'll send another
version of this patch that skips setting the SPTE unnecessarily.

>
> To reduce confusion, we can and probably should do:
>
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index a4af2a42695c..bc691ff72cab 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -316,8 +316,7 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
>
>  static inline bool spte_can_locklessly_be_made_writable(u64 spte)
>  {
> -       return (spte & shadow_host_writable_mask) &&
> -              (spte & shadow_mmu_writable_mask);
> +       return (spte & shadow_mmu_writable_mask);
>  }
>
>  static inline u64 get_mmio_spte_generation(u64 spte)
>
> Though it'd be nice to have a WARN somewhere to enforce that MMU-Writable isn't
> set without Host-writable.
>
> We could also rename the helper to is_mmu_writable_spte(), though I'm not sure
> that's actually better.
>
> Yet another option would be to invert the flag and make it shadow_mmu_pt_protected_mask
> or something, i.e. make it more explicitly a flag that says "this thing is write-protected
> for shadowing a page table".
