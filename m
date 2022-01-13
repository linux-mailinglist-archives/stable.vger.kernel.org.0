Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF1748CFA9
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 01:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiAMA3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 19:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiAMA3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 19:29:03 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEA1C06173F
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 16:29:03 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id u11so1871735plh.13
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 16:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6v073fsQusJxX9RyrcoYOw17rkqjhmxMvDTCnY/vP9w=;
        b=rGvI8CeeR+nQqdedtdGrv5tTwj/e3VmPtyGdxm+d0KimYAK0kZmsPUZ26JyCnkP7Cx
         5zpbzmZJ3cCtbfW7udPmLNrwoTYLer/CIkr6Ya/fhhnejPwCiufejG48IpaYH5ie5A2g
         llZxVL0RklqwVdRQxBmk8w4JvOOKt9whcbd4WuYVrytMKa6KWhVvPx+K8IbE2IwhGal7
         DyhF27CW2SpgrzS+/ljkBHiCtk9IYMbLl0W8bPz19OoKR/WJAqY76oYBWbDoyR30p79c
         MunjqeC078WOWj5dOcEpZQBzTG3pTOEw/7puoaPC7BnMU06pFYpROSu43UK5AdQAjoZs
         fU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6v073fsQusJxX9RyrcoYOw17rkqjhmxMvDTCnY/vP9w=;
        b=RT6Xs3eCEFdriaDoPcwcTEyAYnwGxmP4lOw5Oe7VZ/nH2UO2uufn7AHFXNC0bmdBBw
         JPtCxV+DdEUTX8RGRXagLHIh2r39rpB+7CjjCaJzhy7A9+N3gt+DZUMhS/q3ij1vfXA8
         WxTqJaUpmZlne3Ntk1jwIFQpc5SNxTmfrliMmiZ9PKF1P0QLNX9CKGgT82pZOIRhW6p0
         Mv5FBWhWwDzB+isaOdU16Q5/Ie1Iq0IjUmGVkLOZduiFK4ZPYIOfJWjF1gLvxcC/gP0E
         fHd9m2Fz7AL0Bzc+p3Re/5p4h0/0gIolM+LOKhNN1naFBxFQIYv2/DHzi9uYVPc9mLf9
         /2rg==
X-Gm-Message-State: AOAM531isH/2aIhWAEiSnvmlsLvB0JLbbJ/jsUrsi9A2Dyw5gy3OSBpf
        LGZpZOgeKOiVVLC8dmhZ11tKTA==
X-Google-Smtp-Source: ABdhPJyvmtfX8r8nddFaDn0gy6W4w92sqx19Yv8Z7F4j6RGNlmNiZNSAraYsfz5NUIif5/2C7Ymi1g==
X-Received: by 2002:a17:903:2403:b0:14a:70dc:1593 with SMTP id e3-20020a170903240300b0014a70dc1593mr1895026plo.145.1642033742897;
        Wed, 12 Jan 2022 16:29:02 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id qe10sm7478379pjb.5.2022.01.12.16.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 16:29:02 -0800 (PST)
Date:   Thu, 13 Jan 2022 00:28:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>,
        kvm list <kvm@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Fix write-protection of PTs mapped by
 the TDP MMU
Message-ID: <Yd9ySjsQFeHKnIDv@google.com>
References: <20220112215801.3502286-1-dmatlack@google.com>
 <20220112215801.3502286-2-dmatlack@google.com>
 <Yd9g1KIoNwUPtFrt@google.com>
 <CALzav=djDTBxvXEz3O4QQu-2VkOcMESkpxmWYJYKikiGQLwyUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=djDTBxvXEz3O4QQu-2VkOcMESkpxmWYJYKikiGQLwyUA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022, David Matlack wrote:
> On Wed, Jan 12, 2022 at 3:14 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Jan 12, 2022, David Matlack wrote:
> > > When the TDP MMU is write-protection GFNs for page table protection (as
> > > opposed to for dirty logging, or due to the HVA not being writable), it
> > > checks if the SPTE is already write-protected and if so skips modifying
> > > the SPTE and the TLB flush.
> > >
> > > This behavior is incorrect because the SPTE may be write-protected for
> > > dirty logging. This implies that the SPTE could be locklessly be made
> > > writable on the next write access, and that vCPUs could still be running
> > > with writable SPTEs cached in their TLB.
> > >
> > > Fix this by unconditionally setting the SPTE and only skipping the TLB
> > > flush if the SPTE was already marked !MMU-writable or !Host-writable,
> > > which guarantees the SPTE cannot be locklessly be made writable and no
> > > vCPUs are running the writable SPTEs cached in their TLBs.
> > >
> > > Technically it would be safe to skip setting the SPTE as well since:
> > >
> > >   (a) If MMU-writable is set then Host-writable must be cleared
> > >       and the only way to set Host-writable is to fault the SPTE
> > >       back in entirely (at which point any unsynced shadow pages
> > >       reachable by the new SPTE will be synced and MMU-writable can
> > >       be safetly be set again).
> > >
> > >   and
> > >
> > >   (b) MMU-writable is never consulted on its own.
> > >
> > > And in fact this is what the shadow MMU does when write-protecting guest
> > > page tables. However setting the SPTE unconditionally is much easier to
> > > reason about and does not require a huge comment explaining why it is safe.
> >
> > I disagree.  I looked at the code+comment before reading the full changelog and
> > typed up a response saying the code should be:
> >
> >                 if (!is_writable_pte(iter.old_spte) &&
> >                     !spte_can_locklessly_be_made_writable(spte))
> >                         break;
> >
> > Then I went read the changelog and here we are :-)
> >
> > I find that much more easier to grok, e.g. in plain English: "if the SPTE isn't
> > writable and can't be made writable, there's nothing to do".
> 
> Oh interesting. I actually find that confusing because it can easily
> lead to the MMU-writable bit staying set. Here we are protecting GFNs
> and we're opting to leave the MMU-writable bit set. It takes a lot of
> digging to figure out that this is safe because if MMU-writable is set
> and the SPTE cannot be locklessly be made writable then it implies
> Host-writable is clear, and Host-writable can't be reset without
> syncing the all shadow pages reachable by the MMU. Oh and the
> MMU-writable bit is never consulted on its own (e.g. We never iterate
> through all SPTEs to find the ones that are !MMU-writable).

Ah, you've missed the other wrinkle: MMU-writable can bet set iff Host-writable
is set.  In other words, the MMU-writable bit is never left set because it can't
be set if spte_can_locklessly_be_made_writable() returns false.

To reduce confusion, we can and probably should do:

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index a4af2a42695c..bc691ff72cab 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -316,8 +316,7 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,

 static inline bool spte_can_locklessly_be_made_writable(u64 spte)
 {
-       return (spte & shadow_host_writable_mask) &&
-              (spte & shadow_mmu_writable_mask);
+       return (spte & shadow_mmu_writable_mask);
 }

 static inline u64 get_mmio_spte_generation(u64 spte)

Though it'd be nice to have a WARN somewhere to enforce that MMU-Writable isn't
set without Host-writable.

We could also rename the helper to is_mmu_writable_spte(), though I'm not sure
that's actually better.

Yet another option would be to invert the flag and make it shadow_mmu_pt_protected_mask
or something, i.e. make it more explicitly a flag that says "this thing is write-protected
for shadowing a page table".
