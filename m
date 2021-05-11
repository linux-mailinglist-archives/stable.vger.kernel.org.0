Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5803A37A498
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 12:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhEKKaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 06:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhEKKaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 06:30:08 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F82C061574;
        Tue, 11 May 2021 03:29:02 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id q7-20020a9d57870000b02902a5c2bd8c17so17081940oth.5;
        Tue, 11 May 2021 03:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zQB0PqP12TFHAd0NTVcth9DgppuMURJYYCn1jtkYIJ8=;
        b=NHjn3pGyGWaimt9x9gYKbRfEtgKJWgkBh17mD8PILXdnCpWzdRkqoZDl+ncj/G8tzr
         HA4NbjE9UJuDWBFL+gf5KrCP/3ZlWJjZD5+ElfgS1l6ElA5p5AWl7hsSXDibAXUXaJCB
         cV4LHTvY/gAlIZXkYtNoIi/PxCx70vnfKgEgGgEblmz0lmpWZHh/Xal0Vy3kYivOeHzh
         cXXzrz0cd8YxnXEbcklLpiiygCHz1+fnNJg9aOuT2D8iTWWDDriYmSdsWMCx6TcyuBze
         0+eiXgcw+QQGA3TrcWKvYGV/mDIierY8A8diPYoSf2Tgknssn5v/Y47GCyw5UXsaKwDJ
         9YqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zQB0PqP12TFHAd0NTVcth9DgppuMURJYYCn1jtkYIJ8=;
        b=Z6sVBeLA2DMC8w3iDuG10vr8DCdo1EV1cvg8A2r2RX8oSAgC2tpjErYmXlCfZiiuXr
         vhBmLGX185R8HBjD+6AKQEcRwcLCdMkH0TAHI1ZXeSAN86ngJmG6H56lmXE226BxeBcD
         FwmuZU+nrEVE6Phf1JmV1FdEXYhBSkS/FGzX8rUDB9G+AO1r3NGgMoLQkoQLLdEpK9sv
         4TqoXQxtcBcfZqkEAUUYIOhr2stILYpg+Bta5W6V057ber613PQysUNXxil3QMHkGJ0s
         U0qkrnGfNTiIdarh+yRnKnVoOHxezpf7VkPcd7N85VAP9Ap1oCKLqagFYsN1ORLTPMId
         ydPQ==
X-Gm-Message-State: AOAM532kpDPxbDiA7dJjTa+y743RK+Td49VETe/Y+JjnijdLYNMVDaLe
        vsDCdiX4eBXUdSqBEiUrSofx3Mf2LHUTe0B1xgU=
X-Google-Smtp-Source: ABdhPJwDiPFrAqSihqHv5/98X7pipyq2E0feML6An2J40zbxI50aiU+jKseH8mNVFGtmOPyR2IPZ9Mna0dKw4gSommY=
X-Received: by 2002:a9d:7a88:: with SMTP id l8mr17468192otn.185.1620728942017;
 Tue, 11 May 2021 03:29:02 -0700 (PDT)
MIME-Version: 1.0
References: <1620466310-8428-1-git-send-email-wanpengli@tencent.com>
 <1620466310-8428-3-git-send-email-wanpengli@tencent.com> <YJnNPpalqYwERwEL@google.com>
In-Reply-To: <YJnNPpalqYwERwEL@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 11 May 2021 18:28:51 +0800
Message-ID: <CANRm+Cy55bgvETx2gdVEFnaciEvi=1p-uUWojZdsn2_2X1AWUQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: X86: Fix vCPU preempted state from guest point
 of view
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "# v3 . 10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 11 May 2021 at 08:18, Sean Christopherson <seanjc@google.com> wrote:
>
> On Sat, May 08, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Commit 66570e966dd9 (kvm: x86: only provide PV features if enabled in guest's
> > CPUID) avoids to access pv tlb shootdown host side logic when this pv feature
> > is not exposed to guest, however, kvm_steal_time.preempted not only leveraged
> > by pv tlb shootdown logic but also mitigate the lock holder preemption issue.
> > From guest point of view, vCPU is always preempted since we lose the reset of
> > kvm_steal_time.preempted before vmentry if pv tlb shootdown feature is not
> > exposed. This patch fixes it by clearing kvm_steal_time.preempted before
> > vmentry.
> >
> > Fixes: 66570e966dd9 (kvm: x86: only provide PV features if enabled in guest's CPUID)
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/x86.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index c0244a6..c38e990 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3105,7 +3105,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
> >                                      st->preempted & KVM_VCPU_FLUSH_TLB);
> >               if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
> >                       kvm_vcpu_flush_tlb_guest(vcpu);
> > -     }
> > +     } else
> > +             st->preempted = 0;
>
> Curly braces needed since the if-statment needs 'em.  Other than that,

Will send out a new version after 1-2 get reviewed. :)

>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>
> >
> >       vcpu->arch.st.preempted = 0;
> >
> > --
> > 2.7.4
> >
