Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2D349BE96
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 23:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbiAYWf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 17:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbiAYWf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 17:35:26 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9CAC06173B
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 14:35:26 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y17so10379312plg.7
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 14:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0M7owXOq3qZGARwQYEE9e9GWNAqaRqztJrKeOng9vpc=;
        b=GdXEKlQYElIv9ULr8hBZlH/RH+MXzURiXhviAl2U5C+ney1iy5A/FTp1R85BY5qoQV
         lq8aGWzcgT10MFDGyQENO04//aWdjb6pwUD7DZuNWjLOwYxTPaxhl4FwEIZzl4FbucGO
         X6KkemzdlyE/ivuQkzdQlXErA/vQUuBadJcLEXHtdzjUPl0YCUpkusaceoGXhyXMorst
         IxTLYJv8X8wtNCTrcmpYcT7G8uLlvfI2cSWGvS6go0nP9TVOeZRiBTw7yFyjRqfZsKF8
         F/noUbGwF2CWwvw8rA2vSvj/c4wKFOpRE1cPPRKq2IQ/E/vEcFeYap6i5oBv8kYqgpws
         HYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0M7owXOq3qZGARwQYEE9e9GWNAqaRqztJrKeOng9vpc=;
        b=NfNVNOy3Z4tJR4laQ3bO9T95my8Zn9XiPxY9ZRINhkxznmaWIW8QBCSKOxAw9ZmUdV
         kMuhzy2VGomvrsSmQExsN5eZikQXLKt24Trj6MnHKAsZDpFWtJSI/5ogoppPPKaF3xlm
         Q/dozJx+zbHUq4fvBdXJuq0f8wx0zja9GsnarBQdzwYVoysomejlkETfDk+JOFr1e7tn
         FMuHL1RGnmIBiMDaicIThovlfSJpJB5D6lyXe5GBA3heddnHi9SfA+efmFXIpSQzc+vQ
         +9PiydqZH8SswSZf4V95eSmtiCtvJZkygwCbEbaBTscUp1+BxvwmpdO20B4Lp7iQ8SYm
         vcVQ==
X-Gm-Message-State: AOAM533rlllm+e1bhLzdaNeEsgABivers4EBZZn4P1V8GNBWSws8qK0S
        Lr03eQclcoWQA7urzy7Bw/RNuw==
X-Google-Smtp-Source: ABdhPJzhWRXWvLTvNxTrJFdDr3lGvVUpTgZQOwkQPqZksFF24Yp2wsQ2KSrTP6Vrogw0bqtD+9C+Eg==
X-Received: by 2002:a17:90b:2243:: with SMTP id hk3mr20891pjb.181.1643150125398;
        Tue, 25 Jan 2022 14:35:25 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e17sm40659pfj.168.2022.01.25.14.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 14:35:24 -0800 (PST)
Date:   Tue, 25 Jan 2022 22:35:21 +0000
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
Message-ID: <YfB7KWFNMvo0FkCO@google.com>
References: <20220124172633.103323-1-tadeusz.struk@linaro.org>
 <6fd96538-b767-41e8-0cca-5b9be1dbb1c9@redhat.com>
 <Ye7wCbRpcbU2G4qH@google.com>
 <a806f5e1-9247-679c-4990-0bbf6c8de9d9@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a806f5e1-9247-679c-4990-0bbf6c8de9d9@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022, Tadeusz Struk wrote:
> On 1/24/22 10:29, Sean Christopherson wrote:
> > On Mon, Jan 24, 2022, Paolo Bonzini wrote:
> > > On 1/24/22 18:26, Tadeusz Struk wrote:
> > > > Syzbot reported an use-after-free bug in update_accessed_dirty_bits().
> > > > Fix this by checking if the memremap'ed pointer is still valid.
> > > access_ok only checks that the pointer is in the userspace range.  Is this
> > > correct?  And if so, what are the exact circumstances in which access_ok
> > > returns a non-NULL but also non-userspace address?
> > I "objected" to this patch in its initial posting[*].  AFAICT adding access_ok()
> > is just masking a more egregious bug where interpretation of vm_pgoff as a PFN
> > base is flat out wrong except for select backing stores that use VM_PFNMAP.  In
> > other words, the vm_pgoff hack works for the /dev/mem use case, but it is wrong
> > in general.
> > 
> 
> The issue here is not related to /dev/mem, but binder allocated memory, which is
> yet another special mapping use case. In this case the condition
> 
> if (!vma || !(vma->vm_flags & VM_PFNMAP))
> 
> doesn't cover this special mappings. Adding the access_ok() was my something
> that fixed the use-after-free issue for me, and since I didn't have anything
> better I thought I will send an RFC to start some discussion.
> After some more debugging I came up with the bellow.
> Will that be more acceptable?

I'm pretty sure anything that keeps the vm_pgoff "logic" is a band-aid.  But I'm 99%
sure we can simply do cmpxchg directly on the user address, we just need to get
support for that, which has happily been posted[*].  I'll give that a shot tomorrow,
I want to convert similar code in the emulator, it'd be very nice to purge all of
this crud.

[*] https://lore.kernel.org/all/20220120160822.852009966@infradead.org
