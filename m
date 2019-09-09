Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96476AD8B6
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 14:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387542AbfIIMQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 08:16:50 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33850 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfIIMQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 08:16:50 -0400
Received: by mail-ot1-f68.google.com with SMTP id z26so2932895oto.1;
        Mon, 09 Sep 2019 05:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GrYw5fylq35nkBF7sLhY3/+gYW5PnZNGyOlZU6/D74Y=;
        b=CDyJcmqWfFmDfyRtoSRkJhWTGHmsERPwQaIuM4G/T30ciCxIbKB2VlKKYezt/tRw8c
         NXnHRPKzHOt13LlxNL3sV18NPzIY+zfDrvbw2jQnx5dQjLHPvbBBrjwye1aSWXzx0RBn
         FIkhtHOW/WsNi/POEfsC9ecoBp772fjYfVtu9Wwk+h3k0fjYgL1HpDIDrKrkfntwryEc
         EQDYsH7n7ibBJQu1tU6bkOoSQTlEVcwqq4T9gUehE4LVyTcTqvGXkJ50w65pOFGI9I+q
         esi6qzSFWMVsz1doFTw6wqlyo7WQpFmyNnckMTfjfWy1sxNbouY3xiwRqrf18xIu8VEK
         aOYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GrYw5fylq35nkBF7sLhY3/+gYW5PnZNGyOlZU6/D74Y=;
        b=VGSxCppsK36HYJudNz1AwB1e5WQgt6gi4UehUYrRWDP7Qh6NIFxcN5AeM5dqBUqIla
         fj/PQ/fAPx3hufxExC8mGKMlbCH3uYq5otQ2UmPpl9ZZeYPn6w3nIoNpu6oDrzPe/Vc1
         QtVCWIXR37/xWW1mVXd/wm6xV2MliGHbmDySXul7BddpU0cbLEZBbThxLtXTzHNufqnc
         W19rKDHCEP7JI6zCXDBxpf9ePPq9PYqdO+M5Um98/axwwmIzFEXz8kFHeNl4HwOqlTz2
         PtYw34QTV/qPwJOwpyJ9ygE9ANYoY+vWf5TLyr8j96/+TogjFAn4hEP/ydyx8aq2CPPo
         G89Q==
X-Gm-Message-State: APjAAAWyMuBSpiEZHSX6TpaG6iVcicyjIxFUktlYcPPuq3eAetKCmjM9
        yi8duwQWZ8Al+xKMXor4k7fw0tiAFFeHVCYecYA=
X-Google-Smtp-Source: APXvYqxmOSyZAVRu8j/Uifj4DlAk1/3BaEGyaKhBFP1haxW0K3Vm+yGiOCsSGLcMVPazq3zaE4lJ29A9fhEBmodSZHE=
X-Received: by 2002:a9d:aa8:: with SMTP id 37mr18679935otq.56.1568031409203;
 Mon, 09 Sep 2019 05:16:49 -0700 (PDT)
MIME-Version: 1.0
References: <1567993228-23668-1-git-send-email-wanpengli@tencent.com>
 <29d04ee4-60e7-4df9-0c4f-fc29f2b0c6a8@redhat.com> <fbf152a5-134b-0540-3345-cb6b0b66f1a1@redhat.com>
In-Reply-To: <fbf152a5-134b-0540-3345-cb6b0b66f1a1@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 9 Sep 2019 20:16:36 +0800
Message-ID: <CANRm+CzxJKqivU6hnO6iahHLDFx6A+zTmoJXpBN8_AkdyKCv7w@mail.gmail.com>
Subject: Re: [PATCH] Revert "locking/pvqspinlock: Don't wait if vCPU is preempted"
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Waiman Long <longman@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, loobinliu@tencent.com,
        "# v3 . 10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 9 Sep 2019 at 19:06, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/09/19 12:56, Waiman Long wrote:
> > On 9/9/19 2:40 AM, Wanpeng Li wrote:
> >> From: Wanpeng Li <wanpengli@tencent.com>
> >>
> >> This patch reverts commit 75437bb304b20 (locking/pvqspinlock: Don't wa=
it if
> >> vCPU is preempted), we found great regression caused by this commit.
> >>
> >> Xeon Skylake box, 2 sockets, 40 cores, 80 threads, three VMs, each is =
80 vCPUs.
> >> The score of ebizzy -M can reduce from 13000-14000 records/s to 1700-1=
800
> >> records/s with this commit.
> >>
> >>           Host                       Guest                score
> >>
> >> vanilla + w/o kvm optimizes     vanilla               1700-1800 record=
s/s
> >> vanilla + w/o kvm optimizes     vanilla + revert      13000-14000 reco=
rds/s
> >> vanilla + w/ kvm optimizes      vanilla               4500-5000 record=
s/s
> >> vanilla + w/ kvm optimizes      vanilla + revert      14000-15500 reco=
rds/s
> >>
> >> Exit from aggressive wait-early mechanism can result in yield prematur=
e and
> >> incur extra scheduling latency in over-subscribe scenario.
> >>
> >> kvm optimizes:
> >> [1] commit d73eb57b80b (KVM: Boost vCPUs that are delivering interrupt=
s)
> >> [2] commit 266e85a5ec9 (KVM: X86: Boost queue head vCPU to mitigate lo=
ck waiter preemption)
> >>
> >> Tested-by: loobinliu@tencent.com
> >> Cc: Peter Zijlstra <peterz@infradead.org>
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> >> Cc: Ingo Molnar <mingo@kernel.org>
> >> Cc: Waiman Long <longman@redhat.com>
> >> Cc: Paolo Bonzini <pbonzini@redhat.com>
> >> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> >> Cc: loobinliu@tencent.com
> >> Cc: stable@vger.kernel.org
> >> Fixes: 75437bb304b20 (locking/pvqspinlock: Don't wait if vCPU is preem=
pted)
> >> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> >> ---
> >>  kernel/locking/qspinlock_paravirt.h | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/kernel/locking/qspinlock_paravirt.h b/kernel/locking/qspi=
nlock_paravirt.h
> >> index 89bab07..e84d21a 100644
> >> --- a/kernel/locking/qspinlock_paravirt.h
> >> +++ b/kernel/locking/qspinlock_paravirt.h
> >> @@ -269,7 +269,7 @@ pv_wait_early(struct pv_node *prev, int loop)
> >>      if ((loop & PV_PREV_CHECK_MASK) !=3D 0)
> >>              return false;
> >>
> >> -    return READ_ONCE(prev->state) !=3D vcpu_running || vcpu_is_preemp=
ted(prev->cpu);
> >> +    return READ_ONCE(prev->state) !=3D vcpu_running;
> >>  }
> >>
> >>  /*
> >
> > There are several possibilities for this performance regression:
> >
> > 1) Multiple vcpus calling vcpu_is_preempted() repeatedly may cause some
> > cacheline contention issue depending on how that callback is implemente=
d.
>
> Unlikely, it is a single percpu read.
>
> > 2) KVM may set the preempt flag for a short period whenver an vmexit
> > happens even if a vmenter is executed shortly after. In this case, we
> > may want to use a more durable vcpu suspend flag that indicates the vcp=
u
> > won't get a real vcpu back for a longer period of time.
>
> It sets it for exits to userspace, but they shouldn't really happen on a
> properly-configured system.
>
> However, it's easy to test this theory:
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2e302e977dac..feb6c75a7a88 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3368,26 +3368,28 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  {
>         int idx;
>
> -       if (vcpu->preempted)
> +       if (vcpu->preempted) {
>                 vcpu->arch.preempted_in_kernel =3D !kvm_x86_ops->get_cpl(=
vcpu);
>
> -       /*
> -        * Disable page faults because we're in atomic context here.
> -        * kvm_write_guest_offset_cached() would call might_fault()
> -        * that relies on pagefault_disable() to tell if there's a
> -        * bug. NOTE: the write to guest memory may not go through if
> -        * during postcopy live migration or if there's heavy guest
> -        * paging.
> -        */
> -       pagefault_disable();
> -       /*
> -        * kvm_memslots() will be called by
> -        * kvm_write_guest_offset_cached() so take the srcu lock.
> -        */
> -       idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> -       kvm_steal_time_set_preempted(vcpu);
> -       srcu_read_unlock(&vcpu->kvm->srcu, idx);
> -       pagefault_enable();
> +               /*
> +                * Disable page faults because we're in atomic context he=
re.
> +                * kvm_write_guest_offset_cached() would call might_fault=
()
> +                * that relies on pagefault_disable() to tell if there's =
a
> +                * bug. NOTE: the write to guest memory may not go throug=
h if
> +                * during postcopy live migration or if there's heavy gue=
st
> +                * paging.
> +                */
> +               pagefault_disable();
> +               /*
> +                * kvm_memslots() will be called by
> +                * kvm_write_guest_offset_cached() so take the srcu lock.
> +                */
> +               idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> +               kvm_steal_time_set_preempted(vcpu);
> +               srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +               pagefault_enable();
> +       }
> +
>         kvm_x86_ops->vcpu_put(vcpu);
>         vcpu->arch.last_host_tsc =3D rdtsc();
>         /*
>
> Wanpeng, can you try?

Yes, there is no difference for the score.

Wanpeng
