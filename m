Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14ED435EAD6
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 04:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346116AbhDNC33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 22:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbhDNC33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 22:29:29 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28B7C061574;
        Tue, 13 Apr 2021 19:29:07 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id 6so15810815ilt.9;
        Tue, 13 Apr 2021 19:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/mn/74iV+6uKnyBOoO1G0wW39k+gcEhhG6w26EMBHjI=;
        b=IwsSJZfSF8fuOV0GZ4VaaFsmEGRHM0re6fHqpCO639VX+wtTfKVqXgJsPCCJ3qzOTJ
         l3W4g5hkChtTjNb71xiE6TH8WSSsX7n64pSp+CV5kPYxMmgJy+WLE4glcdZgREb57fsf
         YahFwyZoj66SlZMOCkynpT42bO+EqfNUelbRQKsv9zmSkT9uqHngreMvy/0a7rpNZSnw
         60PLyOy6sdG6x6zCmBBx/66Pg2mToyTYNWTfo1PbqrVhco6TZFRLN06wPM/oZFSPWcFf
         EU+wRCCqCH7u97R6I0+8eYe9Riq4jd5RVCed7vuUhsg1Tq9Q/ywJj/TMUPaNZr69Bm/q
         ypfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/mn/74iV+6uKnyBOoO1G0wW39k+gcEhhG6w26EMBHjI=;
        b=Xtk/A8bFydxlAkm+CVogHOpUTJva6jO/jpl0o0iYGjP47Bdu9PO0A5MLuHIyvk6cM+
         uvmXhzfzqXNqh+95I7v2PL9v+QHL0CgIiy6yUqgZ0NMlUFA6DB0yhxcVuCY2aeuPLyMB
         m6wTvHmO8o5JlULIvKEZiOnXFxwsflFGPceiwgPsi4lCsrWfUepIW7Tg08MpjIkmPqml
         0R3II7RS+eAPYtqA43bYXI5GmltqiIC+tQHy4B9eP6R6u8vzI19mxyyogejo8N/19EJp
         VYi8X/GDrrQM5+yoM8N4JrVIhWfl64akXG+m0Ce8SGneaYQKHyYxTqxCzZxypLm8dNAV
         D9kQ==
X-Gm-Message-State: AOAM5317iYTMR7eBdMC0nRLP6bqaoxkqxr4dbP19RWBQL968Ur1ggvds
        q+u+5JzPvChnTqIbI3+PnplIpUieKwwDsxM4f/s=
X-Google-Smtp-Source: ABdhPJyYbPrZh+XUB0O5XYeZ3YXbIs9/AkkcO2XBsQEwt3oJR3JA+ouv2Ni6PwKkk1LNGjIghPYnfO+qyXBjYWu3nuY=
X-Received: by 2002:a05:6e02:1d16:: with SMTP id i22mr4491158ila.164.1618367347159;
 Tue, 13 Apr 2021 19:29:07 -0700 (PDT)
MIME-Version: 1.0
References: <20201127112114.3219360-1-pbonzini@redhat.com> <20201127112114.3219360-3-pbonzini@redhat.com>
 <CAJhGHyCdqgtvK98_KieG-8MUfg1Jghd+H99q+FkgL0ZuqnvuAw@mail.gmail.com>
 <YHS/BxMiO6I1VOEY@google.com> <CAJhGHyAcnwkCfTcnxXcgAHnF=wPbH2EDp7H+e74ce+oNOWJ=_Q@mail.gmail.com>
 <80b013dc-0078-76f4-1299-3cff261ef7d8@redhat.com>
In-Reply-To: <80b013dc-0078-76f4-1299-3cff261ef7d8@redhat.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Wed, 14 Apr 2021 10:28:55 +0800
Message-ID: <CAJhGHyChfXdcAMzzD7P3aC8tnhFW5GvOt88vOY=D3pyb7hgNAA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: Fix split-irqchip vs interrupt injection
 window request
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Filippo Sironi <sironi@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "v4.7+" <stable@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 13, 2021 at 8:15 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 13/04/21 13:03, Lai Jiangshan wrote:
> > This patch claims that it has a place to
> > stash the IRQ when EFLAGS.IF=0, but inject_pending_event() seams to ignore
> > EFLAGS.IF and queues the IRQ to the guest directly in the first branch
> > of using "kvm_x86_ops.set_irq(vcpu)".
>
> This is only true for pure-userspace irqchip.  For split-irqchip, in
> which case the "place to stash" the interrupt is
> vcpu->arch.pending_external_vector.
>
> For pure-userspace irqchip, KVM_INTERRUPT only cares about being able to
> stash the interrupt in vcpu->arch.interrupt.injected.  It is indeed
> wrong for userspace to call KVM_INTERRUPT if the vCPU is not ready for
> interrupt injection, but KVM_INTERRUPT does not return an error.

Thanks for the reply.

May I ask what is the correct/practical way of using KVM_INTERRUPT ABI
for pure-userspace irqchip.

gVisor is indeed a pure-userspace irqchip, it will call KVM_INTERRUPT
when kvm_run->ready_for_interrupt_injection=1 (along with other conditions
unrelated to our discussion).

https://github.com/google/gvisor/blob/a9441aea2780da8c93da1c73da860219f98438de/pkg/sentry/platform/kvm/bluepill_amd64_unsafe.go#L105

if kvm_run->ready_for_interrupt_injection=1 when expection pending or
EFLAGS.IF=0, it would be unexpected for gVisor.

Thanks
Lai

>
> Ignoring the fact that this would be incorrect use of the API, are you
> saying that the incorrect injection was not possible before this patch?
>
> Paolo
>
