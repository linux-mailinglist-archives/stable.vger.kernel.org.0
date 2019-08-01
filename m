Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB5D7D3BA
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 05:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfHADfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 23:35:34 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39064 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfHADfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 23:35:34 -0400
Received: by mail-ot1-f68.google.com with SMTP id r21so66642967otq.6;
        Wed, 31 Jul 2019 20:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tfDohl1hkWyeEmYeVB02shzd6/LeRxstafK96hHNxW0=;
        b=oKJz2gJxDCanli9BPv4VG6U/5X4U5UnD11UUuzvvBmj0XdmH2vUg4t7rF8KK6UWDj/
         QLWbNSok3bW+sM+rdFbWiMCadM6lYkOFsD2qTktf4K1y9l3XetlUSYnazqyn/XJC1VHh
         +XEXoFVmTI/0cmXV7W0Yx8yesQLFy43K94EW/ZTX+t9S1oXOFQgJlAEn+MKzVgOvXIBj
         aLSZu7q7VHVyHv/QUaOl8T9BhnVKs/rz+Y53NC7y43LIdInp8iaU+gkCCXj86pTeD/tq
         Hj8+g7YQOYLwC2uPJJqSuAh2UsFtlX4xjTW8KcGB9ANDKMheaopQLgFVHC7JYYkf0Cw/
         sp1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tfDohl1hkWyeEmYeVB02shzd6/LeRxstafK96hHNxW0=;
        b=Jwh3XdXCJIMbfp3XjeX+WTDFJgWxYUr8E+21eaP5K8BHgoQ9UdTHRH/ajUDCpUcwKt
         qaIvYmKtzm4ZrLVMu1/tzx8GgMBQxiR3QzYmDe7JRQBUJWsoX6cG6HWL1J9RdqNuyJ5O
         wg7VbJhBO4+DAfFx4mFQuOoKVtLyx9YpDMzOO/nlEcuS7uqQogO7iDXf4PO9WiaePv9L
         9e+Rg9EgXe8XYRtetp7gUfDxI9KIA0Go8XN6MDkX4qho3WzYqurn8n2Jq99QGe5Buneu
         wbJh9Tgnyn6wIlhFZrBi9VdXcjrLWasHpVMEY9EySgwgDvEfuhZ2z7DFnH/OFWBJef4L
         /jKg==
X-Gm-Message-State: APjAAAUd4ul8admj3RVvEqpCRBDJnqz8tXrsiFrQPBKHj6jMPmt78hG/
        q+CRQjNHuy5eeOTtOcJiZgzDcllt5CsNnnfJsdw=
X-Google-Smtp-Source: APXvYqzEj5zqAqL4CVWZMSE8/eXPHQ6/+Opbz5Yftop3kbDtgICLJgAAjsit3aXWYne4p69TTLUGc0flvh/G4IxRPCw=
X-Received: by 2002:a9d:6959:: with SMTP id p25mr11102801oto.118.1564630533734;
 Wed, 31 Jul 2019 20:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <1564572438-15518-3-git-send-email-wanpengli@tencent.com>
 <1564573198-16219-1-git-send-email-wanpengli@tencent.com> <9240ada8-8e18-d2b2-006e-41ededb89efb@redhat.com>
In-Reply-To: <9240ada8-8e18-d2b2-006e-41ededb89efb@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 1 Aug 2019 11:35:17 +0800
Message-ID: <CANRm+CwJyShOHCanUNmeq8Rr3OWJc1iw0vq5ZAF_WLD-0mSEHA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: Fix leak vCPU's VMCS value into other pCPU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        "# v3 . 10+" <stable@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 31 Jul 2019 at 20:55, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 31/07/19 13:39, Wanpeng Li wrote:
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index ed061d8..12f2c91 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2506,7 +2506,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
> >                               continue;
> >                       if (vcpu == me)
> >                               continue;
> > -                     if (swait_active(&vcpu->wq) && !kvm_arch_vcpu_runnable(vcpu))
> > +                     if (READ_ONCE(vcpu->preempted) && swait_active(&vcpu->wq))
> >                               continue;
> >                       if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
> >                               !kvm_arch_vcpu_in_kernel(vcpu))
> >
>
> This cannot work.  swait_active means you are waiting, so you cannot be
> involuntarily preempted.
>
> The problem here is simply that kvm_vcpu_has_events is being called
> without holding the lock.  So kvm_arch_vcpu_runnable is okay, it's the
> implementation that's wrong.
>
> Just rename the existing function to just vcpu_runnable and make a new
> arch callback kvm_arch_dy_runnable.   kvm_arch_dy_runnable can be
> conservative and only returns true for a subset of events, in particular
> for x86 it can check:
>
> - vcpu->arch.pv.pv_unhalted
>
> - KVM_REQ_NMI or KVM_REQ_SMI or KVM_REQ_EVENT
>
> - PIR.ON if APICv is set
>
> Ultimately, all variables accessed in kvm_arch_dy_runnable should be
> accessed with READ_ONCE or atomic_read.
>
> And for all architectures, kvm_vcpu_on_spin should check
> list_empty_careful(&vcpu->async_pf.done)
>
> It's okay if your patch renames the function in non-x86 architectures,
> leaving the fix to maintainers.  So, let's CC Marc and Christian since
> ARM and s390 have pretty complex kvm_arch_vcpu_runnable as well.

Ok, just sent patch to do this.

Regards,
Wanpeng Li
