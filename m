Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C729A828BB
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 02:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbfHFAf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 20:35:57 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46554 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728870AbfHFAf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 20:35:57 -0400
Received: by mail-ot1-f67.google.com with SMTP id z23so59945506ote.13;
        Mon, 05 Aug 2019 17:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z9NTvWBCg6Eq31qvrM6xnHz2Uar1qkqJe1rdCMMJAYQ=;
        b=fq19oDdB3Z+CqaxXIcSgiosGBMsWrfwO45aYTJuV2pCNYTAO3zsqv4DE1WVvNCBowR
         G1qsu9Kgd9o6qQ5oBZpRkNvtTYCDbRpsUIz3yxRG3lAhyPRPhAKH6dw1V7IzoCoJ4Rrt
         EenmaWr6VfMtlVQNfAUrnB9My/kVt8yBc3+3wENQS1vISf1sroE30SCgcavTa4MruFRU
         InUFQkRlzs/hffNkIdXss8JMNaFXVad9XjJf3tvzWN1d9D8pWlIKO3ZNpryC3zxNqQT6
         qcNF6JHHQttGFAzfD2eNCPeO5DFvnmz5j9jUOvYbHoCG1rez+kars4rT91/sxyw4BHM3
         hejQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z9NTvWBCg6Eq31qvrM6xnHz2Uar1qkqJe1rdCMMJAYQ=;
        b=SefCVXwwlWU3JnJ8NxZTYAq8GgG+bdUre1iuZYMxJq1URGOlaXllcU/D0W387/CjjN
         1zC3h3o6aF4eNUWGblGEusyknQudLIkLvDli6GHACvhYjMDlrsjYcAZKlfy4bMWNM9Fe
         Xf4fCGQodkkIG4AYerUTKF9KMeuo/4bR3mq3pJivlO5XOB4Tb8zK/fny4lfyo+NvzEk1
         fd9cHMUeb+gqOzejot694W+LKeJYe48hlbWj9hD9vNrET/G7SwXPO8wgF60plnH0Rtsa
         NHzjSclk3EAXTKXCLrKz1u1kSGK0I/0hfwk6gXveC3nMWdMLBg9x1P+uxSEz5BwahGYG
         OVRQ==
X-Gm-Message-State: APjAAAUnIFFwsm44dnlo6+iyq8xmX37jTE5OCd+xl/MjVs4tfgeoAvb9
        YHX97ZtBNhHN9m8Hz+mcsCdKVCno55IS2/RXw1WmzQ==
X-Google-Smtp-Source: APXvYqyVm6G9MWttRZ2MuXzLawro8vn5XN33ftVOxoe3go0cI6eGaCe95KJzUOtKGkK/1d9w4yxvpdef/zIeI+eSuHw=
X-Received: by 2002:a9d:62c4:: with SMTP id z4mr594082otk.56.1565051755954;
 Mon, 05 Aug 2019 17:35:55 -0700 (PDT)
MIME-Version: 1.0
References: <1564970604-10044-1-git-send-email-wanpengli@tencent.com> <9acbc733-442f-0f65-9b56-ff800a3fa0f5@redhat.com>
In-Reply-To: <9acbc733-442f-0f65-9b56-ff800a3fa0f5@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 6 Aug 2019 08:35:44 +0800
Message-ID: <CANRm+CwH54S555nw-Zik-3NFDH9yqe+SOZrGc3mPoAU_qGxP-A@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] KVM: Fix leak vCPU's VMCS value into other pCPU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "# v3 . 10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 6 Aug 2019 at 07:17, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/08/19 04:03, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > After commit d73eb57b80b (KVM: Boost vCPUs that are delivering interrup=
ts), a
> > five years old bug is exposed. Running ebizzy benchmark in three 80 vCP=
Us VMs
> > on one 80 pCPUs Skylake server, a lot of rcu_sched stall warning splatt=
ing
> > in the VMs after stress testing:
> >
> >  INFO: rcu_sched detected stalls on CPUs/tasks: { 4 41 57 62 77} (detec=
ted by 15, t=3D60004 jiffies, g=3D899, c=3D898, q=3D15073)
> >  Call Trace:
> >    flush_tlb_mm_range+0x68/0x140
> >    tlb_flush_mmu.part.75+0x37/0xe0
> >    tlb_finish_mmu+0x55/0x60
> >    zap_page_range+0x142/0x190
> >    SyS_madvise+0x3cd/0x9c0
> >    system_call_fastpath+0x1c/0x21
> >
> > swait_active() sustains to be true before finish_swait() is called in
> > kvm_vcpu_block(), voluntarily preempted vCPUs are taken into account
> > by kvm_vcpu_on_spin() loop greatly increases the probability condition
> > kvm_arch_vcpu_runnable(vcpu) is checked and can be true, when APICv
> > is enabled the yield-candidate vCPU's VMCS RVI field leaks(by
> > vmx_sync_pir_to_irr()) into spinning-on-a-taken-lock vCPU's current
> > VMCS.
> >
> > This patch fixes it by checking conservatively a subset of events.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> > Cc: Marc Zyngier <Marc.Zyngier@arm.com>
> > Cc: stable@vger.kernel.org
> > Fixes: 98f4a1467 (KVM: add kvm_arch_vcpu_runnable() test to kvm_vcpu_on=
_spin() loop)
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > v3 -> v4:
> >  * just test KVM_REQ_*
> >  * rename the hook to apicv_has_pending_interrupt
> >  * wrap with #ifdef CONFIG_KVM_ASYNC_PF
> > v2 -> v3:
> >  * check conservatively a subset of events
> > v1 -> v2:
> >  * checking swait_active(&vcpu->wq) for involuntary preemption
> >
> >  arch/mips/kvm/mips.c            |  5 +++++
> >  arch/powerpc/kvm/powerpc.c      |  5 +++++
> >  arch/s390/kvm/kvm-s390.c        |  5 +++++
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/svm.c              |  6 ++++++
> >  arch/x86/kvm/vmx/vmx.c          |  6 ++++++
> >  arch/x86/kvm/x86.c              | 16 ++++++++++++++++
> >  include/linux/kvm_host.h        |  1 +
> >  virt/kvm/arm/arm.c              |  5 +++++
> >  virt/kvm/kvm_main.c             | 16 +++++++++++++++-
> >  10 files changed, 65 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> > index 2cfe839..95a4642 100644
> > --- a/arch/mips/kvm/mips.c
> > +++ b/arch/mips/kvm/mips.c
> > @@ -98,6 +98,11 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
> >       return !!(vcpu->arch.pending_exceptions);
> >  }
> >
> > +bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
>
> Using a __weak definition for the default implementation is a bit more
> concise.  Queued with that change.

Thank you, Paolo! Btw, how about other 5 patches?

Regards,
Wanpeng Li
