Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED8048DDAC
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 19:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbiAMS3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 13:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237535AbiAMS3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 13:29:06 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E92CC06173E
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 10:29:06 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id p27so10949334lfa.1
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 10:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9PJ/86w6fMelDu16gGywyp00uJUFkTSIXc+6iRnYOrI=;
        b=GbY5aJ9ARP4aJJ2clpUzOJ5t3iHurYtyL9uEyZ5VrF9mCyAJMXJinMrQL/+3ueWJgr
         2maMWcVlyLgbRMp09PWrYXOkDWZB4lwQx54iq77V0JtmM+4F5HPXGExBBynpThuci7IR
         qnWc/6oJV9SPIvDhfeTSefcuXbu8qkot8vuWI0A9aAeGL/S8r82b++E4ZLEcHcyWDKHW
         z0JsomuJjljkhWS5QAsWDhM1ZQfZY6VuspWANwmgdFL4qq1qe9JalJ+OVPHGx0le2SmP
         6hdKaU180R3CM4qnyBNmvJOF1+Sbb8nwH/YSJyleQ8MRRPAFZ2UKusROQKWWZQTTQZLQ
         zfRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9PJ/86w6fMelDu16gGywyp00uJUFkTSIXc+6iRnYOrI=;
        b=Mry2lVO9RA1H0kNN3qTCw4143ytVu5+SE+x96Aum9cD3o85K9Od8SfTqagQvWGIWS5
         fsjeDP1FBJitLxyqKS3ZO4CppF8zwIcUm/5LggLjhw4mM+6jgzK354ajQmccKC45plF/
         F46SQLq/h6zHQS3A5tyWwKtAtFFslyAlIgEs5GWCaqrkSrPoFUjTDo6iT3oV1ClD4khk
         Es63/OtzZTy8YFOlVNCpQWzmqmB97usakJfS9DwHEM+GTu05xKmdvRhdlqe7noO46PnN
         geNJJaXSNcXFIAy1MkF+5cpuVnwAhsnUu5RIYhC78KV/dbi5oIpGi7xQJWZWhAsCqVww
         ruNQ==
X-Gm-Message-State: AOAM531rosD20SoMhCtR+B0wWElFadrlFcZDjg9aDGlbzGyPzKgTegU/
        VxT0pWWnk9MaEWp8B2sGgJ1zr8NnFZXOB0nVPlf9r2rR8s/oKQ==
X-Google-Smtp-Source: ABdhPJyiohFQi0oaoBakOdVoCHuH4wamOKZAtPPGn1ZUiDorOwpG02nDDfQHxBsPotxlRgZZoK9MCJdozE/R0q2j62c=
X-Received: by 2002:a19:c505:: with SMTP id w5mr4381505lfe.518.1642098544304;
 Thu, 13 Jan 2022 10:29:04 -0800 (PST)
MIME-Version: 1.0
References: <20220112215801.3502286-1-dmatlack@google.com> <20220112215801.3502286-2-dmatlack@google.com>
 <Yd9g1KIoNwUPtFrt@google.com> <CALzav=djDTBxvXEz3O4QQu-2VkOcMESkpxmWYJYKikiGQLwyUA@mail.gmail.com>
 <Yd9ySjsQFeHKnIDv@google.com> <CALzav=eWMOuuXog5Rk9FwSjQDfM8==qdEGjSp=u9xB3VhBm6qw@mail.gmail.com>
In-Reply-To: <CALzav=eWMOuuXog5Rk9FwSjQDfM8==qdEGjSp=u9xB3VhBm6qw@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 13 Jan 2022 10:28:37 -0800
Message-ID: <CALzav=e0tARVjFijerR7f9RgM6gaUzQa+GcAhrK8+9A45FfWZg@mail.gmail.com>
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

On Thu, Jan 13, 2022 at 9:04 AM David Matlack <dmatlack@google.com> wrote:
>
> On Wed, Jan 12, 2022 at 4:29 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Jan 12, 2022, David Matlack wrote:
> > > On Wed, Jan 12, 2022 at 3:14 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Wed, Jan 12, 2022, David Matlack wrote:
> > > > > When the TDP MMU is write-protection GFNs for page table protection (as
> > > > > opposed to for dirty logging, or due to the HVA not being writable), it
> > > > > checks if the SPTE is already write-protected and if so skips modifying
> > > > > the SPTE and the TLB flush.
> > > > >
> > > > > This behavior is incorrect because the SPTE may be write-protected for
> > > > > dirty logging. This implies that the SPTE could be locklessly be made
> > > > > writable on the next write access, and that vCPUs could still be running
> > > > > with writable SPTEs cached in their TLB.
> > > > >
> > > > > Fix this by unconditionally setting the SPTE and only skipping the TLB
> > > > > flush if the SPTE was already marked !MMU-writable or !Host-writable,
> > > > > which guarantees the SPTE cannot be locklessly be made writable and no
> > > > > vCPUs are running the writable SPTEs cached in their TLBs.
> > > > >
> > > > > Technically it would be safe to skip setting the SPTE as well since:
> > > > >
> > > > >   (a) If MMU-writable is set then Host-writable must be cleared
> > > > >       and the only way to set Host-writable is to fault the SPTE
> > > > >       back in entirely (at which point any unsynced shadow pages
> > > > >       reachable by the new SPTE will be synced and MMU-writable can
> > > > >       be safetly be set again).
> > > > >
> > > > >   and
> > > > >
> > > > >   (b) MMU-writable is never consulted on its own.
> > > > >
> > > > > And in fact this is what the shadow MMU does when write-protecting guest
> > > > > page tables. However setting the SPTE unconditionally is much easier to
> > > > > reason about and does not require a huge comment explaining why it is safe.
> > > >
> > > > I disagree.  I looked at the code+comment before reading the full changelog and
> > > > typed up a response saying the code should be:
> > > >
> > > >                 if (!is_writable_pte(iter.old_spte) &&
> > > >                     !spte_can_locklessly_be_made_writable(spte))
> > > >                         break;
> > > >
> > > > Then I went read the changelog and here we are :-)
> > > >
> > > > I find that much more easier to grok, e.g. in plain English: "if the SPTE isn't
> > > > writable and can't be made writable, there's nothing to do".
> > >
> > > Oh interesting. I actually find that confusing because it can easily
> > > lead to the MMU-writable bit staying set. Here we are protecting GFNs
> > > and we're opting to leave the MMU-writable bit set. It takes a lot of
> > > digging to figure out that this is safe because if MMU-writable is set
> > > and the SPTE cannot be locklessly be made writable then it implies
> > > Host-writable is clear, and Host-writable can't be reset without
> > > syncing the all shadow pages reachable by the MMU. Oh and the
> > > MMU-writable bit is never consulted on its own (e.g. We never iterate
> > > through all SPTEs to find the ones that are !MMU-writable).
> >
> > Ah, you've missed the other wrinkle: MMU-writable can bet set iff Host-writable
> > is set.  In other words, the MMU-writable bit is never left set because it can't
> > be set if spte_can_locklessly_be_made_writable() returns false.

The changed_pte notifier looks like it clears Host-writable without
clearing MMU-writable. Specifically the call chain:

kvm_mmu_notifier_change_pte()
  kvm_set_spte_gfn()
    kvm_tdp_mmu_set_spte_gfn()
      set_spte_gfn()
        kvm_mmu_changed_pte_notifier_make_spte()

Is there some guarantee that old_spte is !MMU-writable at this point?
If not I could easily change kvm_mmu_changed_pte_notifier_make_spte()
to also clear MMU-writable and preserve the invariant.


>
> Ohhh I did miss that and yes that explains it. I'll send another
> version of this patch that skips setting the SPTE unnecessarily.
>
> >
> > To reduce confusion, we can and probably should do:
> >
> > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > index a4af2a42695c..bc691ff72cab 100644
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -316,8 +316,7 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
> >
> >  static inline bool spte_can_locklessly_be_made_writable(u64 spte)
> >  {
> > -       return (spte & shadow_host_writable_mask) &&
> > -              (spte & shadow_mmu_writable_mask);
> > +       return (spte & shadow_mmu_writable_mask);
> >  }
> >
> >  static inline u64 get_mmio_spte_generation(u64 spte)
> >
> > Though it'd be nice to have a WARN somewhere to enforce that MMU-Writable isn't
> > set without Host-writable.
> >
> > We could also rename the helper to is_mmu_writable_spte(), though I'm not sure
> > that's actually better.
> >
> > Yet another option would be to invert the flag and make it shadow_mmu_pt_protected_mask
> > or something, i.e. make it more explicitly a flag that says "this thing is write-protected
> > for shadowing a page table".
