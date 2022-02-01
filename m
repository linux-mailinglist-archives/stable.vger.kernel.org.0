Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8F54A5486
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 02:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiBABLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 20:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbiBABLh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 20:11:37 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF46C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 17:11:37 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id y5-20020a17090aca8500b001b8127e3d3aso847082pjt.3
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 17:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RnvJV6b7/j5Jxr+1C9hrz96NKHODQKx3YqNn53/mrwc=;
        b=ru++Z00wt2RDXSjZsPbbY9OdYqxwonj9WU9/AEnsWy0Sd60iQsvnuDe/ikWYUCpCgp
         P9o5RtmBeKN2zJOQuUXqq3+VEdsIOhQdz3VkhzJr85YnIiaKRoKSKK4SD45nnd4MHuKQ
         pzkM988kmNvJNq9cevvbs1NGfWeP0oHj6SUQ2fQSyvMb28EhfUBoOTL54f8aZbMs9u/a
         xx4KCPB+83Gf9/CcXS0RuUChz/HwOi4l8Zopcz37od8mOdvspwXmwQGRVoCCO7/tdIe0
         FB6/H2WcQRCzjPU8NGpvyQ1Qbh9NkUFvAuruJ8Bt0q8iqo8tmZnnCiMQYFOvwVN5M5WC
         UPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RnvJV6b7/j5Jxr+1C9hrz96NKHODQKx3YqNn53/mrwc=;
        b=5sf0XXqlNBOdWgxwYzaxhI/hgcfMHWarRmO1NaKAghZ7sq9LmnuMqtGMreLqyG6Bka
         +s9OPOIoADeqcKUjUVjLGXhrL+uxUfpw/APah2/Hvq6dW7kF2x3Gq7r1Ft/pd/eAmzSC
         uX1taqVtV+O2rQDm6w/7wlHoXpv2RmYVsp7ParRUMfmiuTGRXWIFU3ElbFA5Z1po4yAz
         FhnjNJZS0ihYquqCjexg/Kbf4YGXzWaEsSkgRX5NBe2ZcLY/MpMt1QM5Fq9bpH/3zZFV
         O30HmeIhKJXHxOdG/19Gl6me8qhJxR3Zv2t3c9tBq4e5/jP2xc/J0OdR4UILAWsZjbCN
         oW1w==
X-Gm-Message-State: AOAM531tVq5VdO8xn9qXq6ggrw+lmElabH7IxKplA6iRljSbsBVsXec7
        6tOVj/lxeKunP8iag2/350TQRA==
X-Google-Smtp-Source: ABdhPJwVd2ZNVCk+9kbju+tpuARr+aLnjnWwuh/0cpXgdIRloF8enAx83K4OR+vWQz49oZk9nq14xA==
X-Received: by 2002:a17:903:1c6:: with SMTP id e6mr24088183plh.132.1643677896574;
        Mon, 31 Jan 2022 17:11:36 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id pg2sm515235pjb.54.2022.01.31.17.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 17:11:35 -0800 (PST)
Date:   Tue, 1 Feb 2022 01:11:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Subject: Re: [PATCH RESEND] KVM: x86/mmu: fix UAF in
 paging_update_accessed_dirty_bits
Message-ID: <YfiIxK36yD5pQgu3@google.com>
References: <20220124172633.103323-1-tadeusz.struk@linaro.org>
 <6fd96538-b767-41e8-0cca-5b9be1dbb1c9@redhat.com>
 <Ye7wCbRpcbU2G4qH@google.com>
 <a806f5e1-9247-679c-4990-0bbf6c8de9d9@linaro.org>
 <YfB7KWFNMvo0FkCO@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfB7KWFNMvo0FkCO@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022, Sean Christopherson wrote:
> On Mon, Jan 24, 2022, Tadeusz Struk wrote:
> > On 1/24/22 10:29, Sean Christopherson wrote:
> > > On Mon, Jan 24, 2022, Paolo Bonzini wrote:
> > > > On 1/24/22 18:26, Tadeusz Struk wrote:
> > > > > Syzbot reported an use-after-free bug in update_accessed_dirty_bits().
> > > > > Fix this by checking if the memremap'ed pointer is still valid.
> > > > access_ok only checks that the pointer is in the userspace range.  Is this
> > > > correct?  And if so, what are the exact circumstances in which access_ok
> > > > returns a non-NULL but also non-userspace address?
> > > I "objected" to this patch in its initial posting[*].  AFAICT adding access_ok()
> > > is just masking a more egregious bug where interpretation of vm_pgoff as a PFN
> > > base is flat out wrong except for select backing stores that use VM_PFNMAP.  In
> > > other words, the vm_pgoff hack works for the /dev/mem use case, but it is wrong
> > > in general.
> > > 
> > 
> > The issue here is not related to /dev/mem, but binder allocated memory, which is
> > yet another special mapping use case. In this case the condition
> > 
> > if (!vma || !(vma->vm_flags & VM_PFNMAP))
> > 
> > doesn't cover this special mappings. Adding the access_ok() was my something
> > that fixed the use-after-free issue for me, and since I didn't have anything
> > better I thought I will send an RFC to start some discussion.
> > After some more debugging I came up with the bellow.
> > Will that be more acceptable?
> 
> I'm pretty sure anything that keeps the vm_pgoff "logic" is a band-aid.  But I'm 99%
> sure we can simply do cmpxchg directly on the user address, we just need to get
> support for that, which has happily been posted[*].  I'll give that a shot tomorrow,
> I want to convert similar code in the emulator, it'd be very nice to purge all of
> this crud.
> 
> [*] https://lore.kernel.org/all/20220120160822.852009966@infradead.org

Posted a series and belatedly realized my script didn't pick up Debugged-by: to Cc
you :-/  Let me know if you want me to forward any/all of the series to you.

https://lore.kernel.org/all/20220201010838.1494405-1-seanjc@google.com
