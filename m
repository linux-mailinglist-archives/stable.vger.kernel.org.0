Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7BABBD69A
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 05:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411458AbfIYDPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 23:15:15 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44225 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411457AbfIYDPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 23:15:15 -0400
Received: by mail-ot1-f66.google.com with SMTP id 21so3458262otj.11;
        Tue, 24 Sep 2019 20:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=afcCPGULCNOtz/0h05xsNOQts8+NcMH2hirofuxLTdQ=;
        b=U+NMUppGyzVy2XDqOvfnHJt7FaU8Bs09UlndkxV+Isw+0giosZ4aNeiw+7XOfFXb8T
         8zNlSSlpkOWrbsSOGKdqudl+lwQ0spV7CnZ9xQYXFDJ5Du26veLJ/NShlVLVapOh2g1a
         v+BchHQ8LAQ9tAS1UgCGVwwWuw630X669rkFm3jsg6b4NQ7apKzJizHo61TAgNjPW/s3
         ybmqVdQFqhB6k8y2FoQDo6zaXVZpGU/AY7a9WZ6PdbWHfU5gDeW2WJaHNLdIZDmhdmXb
         b3u7qtOwp2g/nDygGnZARX4erkjePrmUmlbRNnP4qBEqPCAa2EaOOU7+pSyxzY5wxnr4
         Lc2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=afcCPGULCNOtz/0h05xsNOQts8+NcMH2hirofuxLTdQ=;
        b=HZSq3phJVa7wdy5cSS15apmuHZCzt1S5klO3QjpE800k3ztb8vEQ+0ifOsDn//bfKV
         zLU+EtF74li1+7p1/vXlR6L9/qmMrN1DpfMHHewQIOaKiFWjZvl5GNpMDIFWZ+XothIZ
         Hy8VzpNu8oXGHB0/BX4Tm+z9arS2wdgjHbF1oxBAxYV7d3/MaxN91oqj5LhFQLSVEGAr
         ECdOhaBgmgkRqieFCvUiO4N4BGihMln/O/sH4nVBrOz3YtIm0UQCyVCIc8fs4cJvP/so
         wIQRqHmjqfgwe3vEVEx2F06QSNXy/QDUnK5NkTFyYBQkZvgKA1HhktKTsXOb4RO5FsRI
         5EcQ==
X-Gm-Message-State: APjAAAWYS05is7EnC798m0d6aV1yrDhrT8wfz2muOqwMERbVpPkwiPG1
        tWFIdN+rtjzExtLcxXHcE98YfKL2SAeoP8NIr08=
X-Google-Smtp-Source: APXvYqx3uHu6GsUxdtRr8tl95tqn/QuheLHwAoSbpsrOzGMBbveA2admP6ZJxsCiutQSZnSIRfD7l6ZLmrRNVy1OUCE=
X-Received: by 2002:a9d:aa8:: with SMTP id 37mr4453390otq.56.1569381314722;
 Tue, 24 Sep 2019 20:15:14 -0700 (PDT)
MIME-Version: 1.0
References: <1567993228-23668-1-git-send-email-wanpengli@tencent.com>
 <29d04ee4-60e7-4df9-0c4f-fc29f2b0c6a8@redhat.com> <CANRm+CxVXsQCmEpxNJSifmQJk5cqoSifFq+huHJE1s7a-=0iXw@mail.gmail.com>
 <2dda32db-5662-f7a6-f52d-b835df1f45f1@redhat.com> <9ef778df-c34a-897c-bcfa-780256fb78ff@redhat.com>
In-Reply-To: <9ef778df-c34a-897c-bcfa-780256fb78ff@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 25 Sep 2019 11:15:02 +0800
Message-ID: <CANRm+Cyckfhm59GoP1m_SsHcAAiUAaLtnMLKSY2nJJJeexmTjQ@mail.gmail.com>
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

On Wed, 11 Sep 2019 at 21:04, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/09/19 06:25, Waiman Long wrote:
> > On 9/10/19 6:56 AM, Wanpeng Li wrote:
> >> On Mon, 9 Sep 2019 at 18:56, Waiman Long <longman@redhat.com> wrote:
> >>> On 9/9/19 2:40 AM, Wanpeng Li wrote:
> >>>> From: Wanpeng Li <wanpengli@tencent.com>
> >>>>
> >>>> This patch reverts commit 75437bb304b20 (locking/pvqspinlock: Don't =
wait if
> >>>> vCPU is preempted), we found great regression caused by this commit.
> >>>>
> >>>> Xeon Skylake box, 2 sockets, 40 cores, 80 threads, three VMs, each i=
s 80 vCPUs.
> >>>> The score of ebizzy -M can reduce from 13000-14000 records/s to 1700=
-1800
> >>>> records/s with this commit.
> >>>>
> >>>>           Host                       Guest                score
> >>>>
> >>>> vanilla + w/o kvm optimizes     vanilla               1700-1800 reco=
rds/s
> >>>> vanilla + w/o kvm optimizes     vanilla + revert      13000-14000 re=
cords/s
> >>>> vanilla + w/ kvm optimizes      vanilla               4500-5000 reco=
rds/s
> >>>> vanilla + w/ kvm optimizes      vanilla + revert      14000-15500 re=
cords/s
> >>>>
> >>>> Exit from aggressive wait-early mechanism can result in yield premat=
ure and
> >>>> incur extra scheduling latency in over-subscribe scenario.
> >>>>
> >>>> kvm optimizes:
> >>>> [1] commit d73eb57b80b (KVM: Boost vCPUs that are delivering interru=
pts)
> >>>> [2] commit 266e85a5ec9 (KVM: X86: Boost queue head vCPU to mitigate =
lock waiter preemption)
> >>>>
> >>>> Tested-by: loobinliu@tencent.com
> >>>> Cc: Peter Zijlstra <peterz@infradead.org>
> >>>> Cc: Thomas Gleixner <tglx@linutronix.de>
> >>>> Cc: Ingo Molnar <mingo@kernel.org>
> >>>> Cc: Waiman Long <longman@redhat.com>
> >>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
> >>>> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> >>>> Cc: loobinliu@tencent.com
> >>>> Cc: stable@vger.kernel.org
> >>>> Fixes: 75437bb304b20 (locking/pvqspinlock: Don't wait if vCPU is pre=
empted)
> >>>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> >>>> ---
> >>>>  kernel/locking/qspinlock_paravirt.h | 2 +-
> >>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/kernel/locking/qspinlock_paravirt.h b/kernel/locking/qs=
pinlock_paravirt.h
> >>>> index 89bab07..e84d21a 100644
> >>>> --- a/kernel/locking/qspinlock_paravirt.h
> >>>> +++ b/kernel/locking/qspinlock_paravirt.h
> >>>> @@ -269,7 +269,7 @@ pv_wait_early(struct pv_node *prev, int loop)
> >>>>       if ((loop & PV_PREV_CHECK_MASK) !=3D 0)
> >>>>               return false;
> >>>>
> >>>> -     return READ_ONCE(prev->state) !=3D vcpu_running || vcpu_is_pre=
empted(prev->cpu);
> >>>> +     return READ_ONCE(prev->state) !=3D vcpu_running;
> >>>>  }
> >>>>
> >>>>  /*
> >>> There are several possibilities for this performance regression:
> >>>
> >>> 1) Multiple vcpus calling vcpu_is_preempted() repeatedly may cause so=
me
> >>> cacheline contention issue depending on how that callback is implemen=
ted.
> >>>
> >>> 2) KVM may set the preempt flag for a short period whenver an vmexit
> >>> happens even if a vmenter is executed shortly after. In this case, we
> >>> may want to use a more durable vcpu suspend flag that indicates the v=
cpu
> >>> won't get a real vcpu back for a longer period of time.
> >>>
> >>> Perhaps you can add a lock event counter to count the number of
> >>> wait_early events caused by vcpu_is_preempted() being true to see if =
it
> >>> really cause a lot more wait_early than without the vcpu_is_preempted=
()
> >>> call.
> >> pv_wait_again:1:179
> >> pv_wait_early:1:189429
> >> pv_wait_head:1:263
> >> pv_wait_node:1:189429
> >> pv_vcpu_is_preempted:1:45588
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3Dsleep 5=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> pv_wait_again:1:181
> >> pv_wait_early:1:202574
> >> pv_wait_head:1:267
> >> pv_wait_node:1:202590
> >> pv_vcpu_is_preempted:1:46336
> >>
> >> The sampling period is 5s, 6% of wait_early events caused by
> >> vcpu_is_preempted() being true.
> >
> > 6% isn't that high. However, when one vCPU voluntarily releases its
> > vCPU, all the subsequently waiters in the queue will do the same. It is
> > a cascading effect. Perhaps we wait early too aggressive with the
> > original patch.
> >
> > I also look up the email chain of the original commit. The patch
> > submitter did not provide any performance data to support this change.
> > The patch just looked reasonable at that time. So there was no
> > objection. Given that we now have hard evidence that this was not a goo=
d
> > idea. I think we should revert it.
> >
> > Reviewed-by: Waiman Long <longman@redhat.com>
> >
> > Thanks,
> > Longman
> >
>
> Queued, thanks.

Didn't see it in yesterday's updated kvm/queue. :)

    Wanpeng
