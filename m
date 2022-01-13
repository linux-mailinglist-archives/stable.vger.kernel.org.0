Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9156548DE1D
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 20:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiAMT3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 14:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiAMT3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 14:29:12 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D32CC061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 11:29:12 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 128so767232pfe.12
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 11:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ROVS5rBm3Cz2W7S8I9dH4k+dRH+0gu+Fwbo6sb8zAv4=;
        b=qYxLeriBR4hEl0PAMbDC6uHko0lBwc7MNT6+tSu1ZVoUxbUJ8n44ouopnHLy/mz092
         mz0sOLWk0wVlutM9QlUvbj+FYEzJBPkcGFOZlp7JELxPfbibtXdFoO9q4WKKi2Ykm0nl
         +UgRytc99ed0b0jF0XFc2IF64mGrk+yito7s3BSv6GYy+6cyEdMUqKSil1L1ILha7YoP
         raE0ZCCb443bMAIknGUdU1r3qHxZ7NGBRurlMZeql9L4KZp0UsH0FBohCimq36x5aBxN
         i976s9+72rkrxev9bctJrT/2V3fi315+S40dE9xd9ib9eywhvjGcCzLMpC7u8f0o4aRO
         F+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ROVS5rBm3Cz2W7S8I9dH4k+dRH+0gu+Fwbo6sb8zAv4=;
        b=lHdA+c95CSJ8vC+/IJWXtSzKIyLsD8Rdse3aBgR6GuDJT8LuuI5dPLlJWzahxrhpsp
         qh94jZ2ZLXv0CTQrm6ax3P+70Y6a61niv+0jYHsF7yvozBCnyRpmkL05FSokhHeWG5QI
         H7Xdbzq5iziAY6vwMiQbN/UAUaboiUEKKjT4aMFBy/QPhh4bwIHNXZKuxu/nv2fUOhs9
         bEGEA9gfBt1zjxDDvS5r0RXrjHCgDd1isziO4Fi46RRlMSf2um1c5MJttmbGGR9Tjb3T
         iV4d9mNiDvTRx3mvEvWzSZnL+/oLPz6N7FS+zlbgGJOPDtb1a9ZbbSkCWWn0Ha4wl9v5
         h77A==
X-Gm-Message-State: AOAM530qSqIW1P7AsDIM/xN9hoV6PGRBeSkCRM3RY9CYsCoSbhd1j5SO
        ee2YeKlIpXsTnF2OLvrVZ6urKg==
X-Google-Smtp-Source: ABdhPJzp+3opgjvBAgLmiA+ZDVQGYD2H3ErTGoj7k05eePcJiZvAUhJhuN+yqFX0jKDuereypjnrHg==
X-Received: by 2002:a63:7845:: with SMTP id t66mr5203707pgc.103.1642102151862;
        Thu, 13 Jan 2022 11:29:11 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n26sm2818946pgb.91.2022.01.13.11.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 11:29:11 -0800 (PST)
Date:   Thu, 13 Jan 2022 19:29:07 +0000
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
Message-ID: <YeB9gxIsjQNhE/21@google.com>
References: <20220112215801.3502286-1-dmatlack@google.com>
 <20220112215801.3502286-2-dmatlack@google.com>
 <Yd9g1KIoNwUPtFrt@google.com>
 <CALzav=djDTBxvXEz3O4QQu-2VkOcMESkpxmWYJYKikiGQLwyUA@mail.gmail.com>
 <Yd9ySjsQFeHKnIDv@google.com>
 <CALzav=eWMOuuXog5Rk9FwSjQDfM8==qdEGjSp=u9xB3VhBm6qw@mail.gmail.com>
 <CALzav=e0tARVjFijerR7f9RgM6gaUzQa+GcAhrK8+9A45FfWZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=e0tARVjFijerR7f9RgM6gaUzQa+GcAhrK8+9A45FfWZg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022, David Matlack wrote:
> On Thu, Jan 13, 2022 at 9:04 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On Wed, Jan 12, 2022 at 4:29 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > Oh interesting. I actually find that confusing because it can easily
> > > > lead to the MMU-writable bit staying set. Here we are protecting GFNs
> > > > and we're opting to leave the MMU-writable bit set. It takes a lot of
> > > > digging to figure out that this is safe because if MMU-writable is set
> > > > and the SPTE cannot be locklessly be made writable then it implies
> > > > Host-writable is clear, and Host-writable can't be reset without
> > > > syncing the all shadow pages reachable by the MMU. Oh and the
> > > > MMU-writable bit is never consulted on its own (e.g. We never iterate
> > > > through all SPTEs to find the ones that are !MMU-writable).
> > >
> > > Ah, you've missed the other wrinkle: MMU-writable can bet set iff Host-writable
> > > is set.  In other words, the MMU-writable bit is never left set because it can't
> > > be set if spte_can_locklessly_be_made_writable() returns false.
> 
> The changed_pte notifier looks like it clears Host-writable without
> clearing MMU-writable. Specifically the call chain:
> 
> kvm_mmu_notifier_change_pte()
>   kvm_set_spte_gfn()
>     kvm_tdp_mmu_set_spte_gfn()
>       set_spte_gfn()
>         kvm_mmu_changed_pte_notifier_make_spte()
> 
> Is there some guarantee that old_spte is !MMU-writable at this point?

Ugh, I misread that code, multiple times.  There's no guarantee, it was likely
just missed when MMU-writable was introduced.

Note, you literally cannot hit that code path in current kernels.  See commit
c13fda237f08 ("KVM: Assert that notifier count is elevated in .change_pte()").
So whatever you do is effectively untestable.

I really want to rip out .change_pte(), but I also don't want to do any performance
testing to justify removing the code instead of fixing it proper, so it's hung
around as a zombie...

> If not I could easily change kvm_mmu_changed_pte_notifier_make_spte()
> to also clear MMU-writable and preserve the invariant.

Yes, please.
