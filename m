Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA8E7AFD5A
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 15:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfIKNEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 09:04:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47798 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727302AbfIKNEh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 09:04:37 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 916023D94D
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 13:04:36 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id u10so889161wrn.21
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 06:04:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5cZwRFkPnBfvd9KKrvlsF0v7o7pc2TdTfWhZUtnofjs=;
        b=E92WhUR4IkwAO8NHMkqpQtvutaWfsBP7UXRIZFl+lNuFGwUjAKhRZdrBW5vuqYH+v9
         BB6yXEMFePgeK2itTLhqYAs4tff7RD0K5nJFkykiO82dUzWTPjXgesN8IbP2Bcx7Yld8
         SX3WA6/AR9s1fHfa8yCNRGGt2omscNDErehQEMWJq/D6BqXE5H99K2lw2x7ARxwVOZnA
         oIWYzrf2eryCc01DWgfe54uk/jf8ymg8u8Vz/5+7YNU7OQu37XTQakKiFrD0NZ9Ep8wV
         LJawgW8nzoHWD2JPRJP4/74Voz6KYJrOqc6YtMaU/0v0fr3LUD10Mj9CUpTso5NlZqBW
         rDDg==
X-Gm-Message-State: APjAAAX84LotHbnx8a8hBnk8Z73wcrof/t6lYx74au4BmwSl9sGpziuH
        mPGpnNSm2ijqgcxyhUQbo+9u5rFRmEqD/GgaLUXq90lLiE/CB4s5mE7bLJbpPY/kPaUCkqNtUo/
        dyv1XhFpG7c9f8ozR
X-Received: by 2002:adf:f48e:: with SMTP id l14mr29136124wro.234.1568207074753;
        Wed, 11 Sep 2019 06:04:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzBF20UcHxsYOQf/lES4ZO/bVViSm+7jzfEb91Ml+VtQ6z82mrGbxsV6Pa7Uej4nDz/PD+EEQ==
X-Received: by 2002:adf:f48e:: with SMTP id l14mr29136106wro.234.1568207074435;
        Wed, 11 Sep 2019 06:04:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:102b:3795:6714:7df6? ([2001:b07:6468:f312:102b:3795:6714:7df6])
        by smtp.gmail.com with ESMTPSA id y13sm42446736wrg.8.2019.09.11.06.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 06:04:33 -0700 (PDT)
Subject: Re: [PATCH] Revert "locking/pvqspinlock: Don't wait if vCPU is
 preempted"
To:     Waiman Long <longman@redhat.com>, Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
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
 <2dda32db-5662-f7a6-f52d-b835df1f45f1@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9ef778df-c34a-897c-bcfa-780256fb78ff@redhat.com>
Date:   Wed, 11 Sep 2019 15:04:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2dda32db-5662-f7a6-f52d-b835df1f45f1@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/09/19 06:25, Waiman Long wrote:
> On 9/10/19 6:56 AM, Wanpeng Li wrote:
>> On Mon, 9 Sep 2019 at 18:56, Waiman Long <longman@redhat.com> wrote:
>>> On 9/9/19 2:40 AM, Wanpeng Li wrote:
>>>> From: Wanpeng Li <wanpengli@tencent.com>
>>>>
>>>> This patch reverts commit 75437bb304b20 (locking/pvqspinlock: Don't wait if
>>>> vCPU is preempted), we found great regression caused by this commit.
>>>>
>>>> Xeon Skylake box, 2 sockets, 40 cores, 80 threads, three VMs, each is 80 vCPUs.
>>>> The score of ebizzy -M can reduce from 13000-14000 records/s to 1700-1800
>>>> records/s with this commit.
>>>>
>>>>           Host                       Guest                score
>>>>
>>>> vanilla + w/o kvm optimizes     vanilla               1700-1800 records/s
>>>> vanilla + w/o kvm optimizes     vanilla + revert      13000-14000 records/s
>>>> vanilla + w/ kvm optimizes      vanilla               4500-5000 records/s
>>>> vanilla + w/ kvm optimizes      vanilla + revert      14000-15500 records/s
>>>>
>>>> Exit from aggressive wait-early mechanism can result in yield premature and
>>>> incur extra scheduling latency in over-subscribe scenario.
>>>>
>>>> kvm optimizes:
>>>> [1] commit d73eb57b80b (KVM: Boost vCPUs that are delivering interrupts)
>>>> [2] commit 266e85a5ec9 (KVM: X86: Boost queue head vCPU to mitigate lock waiter preemption)
>>>>
>>>> Tested-by: loobinliu@tencent.com
>>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> Cc: Ingo Molnar <mingo@kernel.org>
>>>> Cc: Waiman Long <longman@redhat.com>
>>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>>> Cc: Radim Krčmář <rkrcmar@redhat.com>
>>>> Cc: loobinliu@tencent.com
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 75437bb304b20 (locking/pvqspinlock: Don't wait if vCPU is preempted)
>>>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>>>> ---
>>>>  kernel/locking/qspinlock_paravirt.h | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/kernel/locking/qspinlock_paravirt.h b/kernel/locking/qspinlock_paravirt.h
>>>> index 89bab07..e84d21a 100644
>>>> --- a/kernel/locking/qspinlock_paravirt.h
>>>> +++ b/kernel/locking/qspinlock_paravirt.h
>>>> @@ -269,7 +269,7 @@ pv_wait_early(struct pv_node *prev, int loop)
>>>>       if ((loop & PV_PREV_CHECK_MASK) != 0)
>>>>               return false;
>>>>
>>>> -     return READ_ONCE(prev->state) != vcpu_running || vcpu_is_preempted(prev->cpu);
>>>> +     return READ_ONCE(prev->state) != vcpu_running;
>>>>  }
>>>>
>>>>  /*
>>> There are several possibilities for this performance regression:
>>>
>>> 1) Multiple vcpus calling vcpu_is_preempted() repeatedly may cause some
>>> cacheline contention issue depending on how that callback is implemented.
>>>
>>> 2) KVM may set the preempt flag for a short period whenver an vmexit
>>> happens even if a vmenter is executed shortly after. In this case, we
>>> may want to use a more durable vcpu suspend flag that indicates the vcpu
>>> won't get a real vcpu back for a longer period of time.
>>>
>>> Perhaps you can add a lock event counter to count the number of
>>> wait_early events caused by vcpu_is_preempted() being true to see if it
>>> really cause a lot more wait_early than without the vcpu_is_preempted()
>>> call.
>> pv_wait_again:1:179
>> pv_wait_early:1:189429
>> pv_wait_head:1:263
>> pv_wait_node:1:189429
>> pv_vcpu_is_preempted:1:45588
>> =========sleep 5============
>> pv_wait_again:1:181
>> pv_wait_early:1:202574
>> pv_wait_head:1:267
>> pv_wait_node:1:202590
>> pv_vcpu_is_preempted:1:46336
>>
>> The sampling period is 5s, 6% of wait_early events caused by
>> vcpu_is_preempted() being true.
> 
> 6% isn't that high. However, when one vCPU voluntarily releases its
> vCPU, all the subsequently waiters in the queue will do the same. It is
> a cascading effect. Perhaps we wait early too aggressive with the
> original patch.
> 
> I also look up the email chain of the original commit. The patch
> submitter did not provide any performance data to support this change.
> The patch just looked reasonable at that time. So there was no
> objection. Given that we now have hard evidence that this was not a good
> idea. I think we should revert it.
> 
> Reviewed-by: Waiman Long <longman@redhat.com>
> 
> Thanks,
> Longman
> 

Queued, thanks.

Paolo
