Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACE1AF50E
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 06:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbfIKEZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 00:25:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfIKEZ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 00:25:59 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 343C718CB511;
        Wed, 11 Sep 2019 04:25:58 +0000 (UTC)
Received: from llong.remote.csb (ovpn-120-46.rdu2.redhat.com [10.10.120.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42E6119C6A;
        Wed, 11 Sep 2019 04:25:54 +0000 (UTC)
Subject: Re: [PATCH] Revert "locking/pvqspinlock: Don't wait if vCPU is
 preempted"
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
References: <1567993228-23668-1-git-send-email-wanpengli@tencent.com>
 <29d04ee4-60e7-4df9-0c4f-fc29f2b0c6a8@redhat.com>
 <CANRm+CxVXsQCmEpxNJSifmQJk5cqoSifFq+huHJE1s7a-=0iXw@mail.gmail.com>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <2dda32db-5662-f7a6-f52d-b835df1f45f1@redhat.com>
Date:   Wed, 11 Sep 2019 05:25:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CANRm+CxVXsQCmEpxNJSifmQJk5cqoSifFq+huHJE1s7a-=0iXw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Wed, 11 Sep 2019 04:25:58 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/10/19 6:56 AM, Wanpeng Li wrote:
> On Mon, 9 Sep 2019 at 18:56, Waiman Long <longman@redhat.com> wrote:
>> On 9/9/19 2:40 AM, Wanpeng Li wrote:
>>> From: Wanpeng Li <wanpengli@tencent.com>
>>>
>>> This patch reverts commit 75437bb304b20 (locking/pvqspinlock: Don't wait if
>>> vCPU is preempted), we found great regression caused by this commit.
>>>
>>> Xeon Skylake box, 2 sockets, 40 cores, 80 threads, three VMs, each is 80 vCPUs.
>>> The score of ebizzy -M can reduce from 13000-14000 records/s to 1700-1800
>>> records/s with this commit.
>>>
>>>           Host                       Guest                score
>>>
>>> vanilla + w/o kvm optimizes     vanilla               1700-1800 records/s
>>> vanilla + w/o kvm optimizes     vanilla + revert      13000-14000 records/s
>>> vanilla + w/ kvm optimizes      vanilla               4500-5000 records/s
>>> vanilla + w/ kvm optimizes      vanilla + revert      14000-15500 records/s
>>>
>>> Exit from aggressive wait-early mechanism can result in yield premature and
>>> incur extra scheduling latency in over-subscribe scenario.
>>>
>>> kvm optimizes:
>>> [1] commit d73eb57b80b (KVM: Boost vCPUs that are delivering interrupts)
>>> [2] commit 266e85a5ec9 (KVM: X86: Boost queue head vCPU to mitigate lock waiter preemption)
>>>
>>> Tested-by: loobinliu@tencent.com
>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: Ingo Molnar <mingo@kernel.org>
>>> Cc: Waiman Long <longman@redhat.com>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Cc: Radim Krčmář <rkrcmar@redhat.com>
>>> Cc: loobinliu@tencent.com
>>> Cc: stable@vger.kernel.org
>>> Fixes: 75437bb304b20 (locking/pvqspinlock: Don't wait if vCPU is preempted)
>>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>>> ---
>>>  kernel/locking/qspinlock_paravirt.h | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/locking/qspinlock_paravirt.h b/kernel/locking/qspinlock_paravirt.h
>>> index 89bab07..e84d21a 100644
>>> --- a/kernel/locking/qspinlock_paravirt.h
>>> +++ b/kernel/locking/qspinlock_paravirt.h
>>> @@ -269,7 +269,7 @@ pv_wait_early(struct pv_node *prev, int loop)
>>>       if ((loop & PV_PREV_CHECK_MASK) != 0)
>>>               return false;
>>>
>>> -     return READ_ONCE(prev->state) != vcpu_running || vcpu_is_preempted(prev->cpu);
>>> +     return READ_ONCE(prev->state) != vcpu_running;
>>>  }
>>>
>>>  /*
>> There are several possibilities for this performance regression:
>>
>> 1) Multiple vcpus calling vcpu_is_preempted() repeatedly may cause some
>> cacheline contention issue depending on how that callback is implemented.
>>
>> 2) KVM may set the preempt flag for a short period whenver an vmexit
>> happens even if a vmenter is executed shortly after. In this case, we
>> may want to use a more durable vcpu suspend flag that indicates the vcpu
>> won't get a real vcpu back for a longer period of time.
>>
>> Perhaps you can add a lock event counter to count the number of
>> wait_early events caused by vcpu_is_preempted() being true to see if it
>> really cause a lot more wait_early than without the vcpu_is_preempted()
>> call.
> pv_wait_again:1:179
> pv_wait_early:1:189429
> pv_wait_head:1:263
> pv_wait_node:1:189429
> pv_vcpu_is_preempted:1:45588
> =========sleep 5============
> pv_wait_again:1:181
> pv_wait_early:1:202574
> pv_wait_head:1:267
> pv_wait_node:1:202590
> pv_vcpu_is_preempted:1:46336
>
> The sampling period is 5s, 6% of wait_early events caused by
> vcpu_is_preempted() being true.

6% isn't that high. However, when one vCPU voluntarily releases its
vCPU, all the subsequently waiters in the queue will do the same. It is
a cascading effect. Perhaps we wait early too aggressive with the
original patch.

I also look up the email chain of the original commit. The patch
submitter did not provide any performance data to support this change.
The patch just looked reasonable at that time. So there was no
objection. Given that we now have hard evidence that this was not a good
idea. I think we should revert it.

Reviewed-by: Waiman Long <longman@redhat.com>

Thanks,
Longman

