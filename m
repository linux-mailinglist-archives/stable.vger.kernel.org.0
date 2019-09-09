Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 963FBAD79F
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 13:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403856AbfIILGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 07:06:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730794AbfIILGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Sep 2019 07:06:12 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 32BCAC050DFF
        for <stable@vger.kernel.org>; Mon,  9 Sep 2019 11:06:11 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id r187so4411802wme.0
        for <stable@vger.kernel.org>; Mon, 09 Sep 2019 04:06:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7P1L82Hvd2CHZtV3y3+DuSRQWJRg8V37be+Beu7AiBw=;
        b=gmd4wXNFotENgAri5Y0V563uBS34t5EMwonMXIWa/13n0LCMVYrBHtiqJcjHvA++kY
         aH7jqFi8W64O5HcAg7ikW95OJlllIcnLZGChKDLyef0MyPtyuqltn2XWQBiMFPfxgQVb
         F0b+GRGjUHYY9dMxTJeHW5ih4gDQwdvgaJJOloXDSKlhFYojJ8jhH5G4JJlzaZm8MDLb
         +GSo0RHjKyH5ni9Uw+HWwejgobr0nXlDhs4ZjKCKdXFzh5hqqFhNF3zp+AlQP0NCCBAL
         +MLHn/q8BHiDRv152qokKWy5hgrixOvO7EGMkrB7HkCf5yUjZAMD8RXQWcluodavMoz0
         scjA==
X-Gm-Message-State: APjAAAUs4lPvdo/k2bItbZxtSiOR6ruMR+wQELpd1b66o2GBBiTwnTT+
        nL/PfKZ9UUz0Y96Z7prpMbvGpJwf+j6MVkRh9wLz64p/r7QVhqg5AuzobQBoKIw9BG7IFlztlv5
        EoBUqFOWrFFt70H7Y
X-Received: by 2002:adf:f284:: with SMTP id k4mr3118598wro.294.1568027169600;
        Mon, 09 Sep 2019 04:06:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwpJObjRb41D20LhnQ/9bC6pyQl1DWX1ZWggr3xyk6OHo4dXPNZEDXNgLaeWrw8SqEtwG9mSQ==
X-Received: by 2002:adf:f284:: with SMTP id k4mr3118569wro.294.1568027169308;
        Mon, 09 Sep 2019 04:06:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8dc1:ce1e:4b83:3ab7? ([2001:b07:6468:f312:8dc1:ce1e:4b83:3ab7])
        by smtp.gmail.com with ESMTPSA id x5sm19207918wrg.69.2019.09.09.04.06.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2019 04:06:08 -0700 (PDT)
Subject: Re: [PATCH] Revert "locking/pvqspinlock: Don't wait if vCPU is
 preempted"
To:     Waiman Long <longman@redhat.com>, Wanpeng Li <kernellwp@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, loobinliu@tencent.com,
        stable@vger.kernel.org
References: <1567993228-23668-1-git-send-email-wanpengli@tencent.com>
 <29d04ee4-60e7-4df9-0c4f-fc29f2b0c6a8@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <fbf152a5-134b-0540-3345-cb6b0b66f1a1@redhat.com>
Date:   Mon, 9 Sep 2019 13:06:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <29d04ee4-60e7-4df9-0c4f-fc29f2b0c6a8@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/09/19 12:56, Waiman Long wrote:
> On 9/9/19 2:40 AM, Wanpeng Li wrote:
>> From: Wanpeng Li <wanpengli@tencent.com>
>>
>> This patch reverts commit 75437bb304b20 (locking/pvqspinlock: Don't wait if 
>> vCPU is preempted), we found great regression caused by this commit.
>>
>> Xeon Skylake box, 2 sockets, 40 cores, 80 threads, three VMs, each is 80 vCPUs.
>> The score of ebizzy -M can reduce from 13000-14000 records/s to 1700-1800 
>> records/s with this commit.
>>
>>           Host                       Guest                score
>>
>> vanilla + w/o kvm optimizes     vanilla               1700-1800 records/s
>> vanilla + w/o kvm optimizes     vanilla + revert      13000-14000 records/s
>> vanilla + w/ kvm optimizes      vanilla               4500-5000 records/s
>> vanilla + w/ kvm optimizes      vanilla + revert      14000-15500 records/s
>>
>> Exit from aggressive wait-early mechanism can result in yield premature and 
>> incur extra scheduling latency in over-subscribe scenario.
>>
>> kvm optimizes:
>> [1] commit d73eb57b80b (KVM: Boost vCPUs that are delivering interrupts)
>> [2] commit 266e85a5ec9 (KVM: X86: Boost queue head vCPU to mitigate lock waiter preemption)
>>
>> Tested-by: loobinliu@tencent.com
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Waiman Long <longman@redhat.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Radim Krčmář <rkrcmar@redhat.com>
>> Cc: loobinliu@tencent.com
>> Cc: stable@vger.kernel.org 
>> Fixes: 75437bb304b20 (locking/pvqspinlock: Don't wait if vCPU is preempted)
>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>> ---
>>  kernel/locking/qspinlock_paravirt.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/locking/qspinlock_paravirt.h b/kernel/locking/qspinlock_paravirt.h
>> index 89bab07..e84d21a 100644
>> --- a/kernel/locking/qspinlock_paravirt.h
>> +++ b/kernel/locking/qspinlock_paravirt.h
>> @@ -269,7 +269,7 @@ pv_wait_early(struct pv_node *prev, int loop)
>>  	if ((loop & PV_PREV_CHECK_MASK) != 0)
>>  		return false;
>>  
>> -	return READ_ONCE(prev->state) != vcpu_running || vcpu_is_preempted(prev->cpu);
>> +	return READ_ONCE(prev->state) != vcpu_running;
>>  }
>>  
>>  /*
> 
> There are several possibilities for this performance regression:
> 
> 1) Multiple vcpus calling vcpu_is_preempted() repeatedly may cause some
> cacheline contention issue depending on how that callback is implemented.

Unlikely, it is a single percpu read.

> 2) KVM may set the preempt flag for a short period whenver an vmexit
> happens even if a vmenter is executed shortly after. In this case, we
> may want to use a more durable vcpu suspend flag that indicates the vcpu
> won't get a real vcpu back for a longer period of time.

It sets it for exits to userspace, but they shouldn't really happen on a 
properly-configured system.

However, it's easy to test this theory:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e302e977dac..feb6c75a7a88 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3368,26 +3368,28 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
-	if (vcpu->preempted)
+	if (vcpu->preempted) {
 		vcpu->arch.preempted_in_kernel = !kvm_x86_ops->get_cpl(vcpu);
 
-	/*
-	 * Disable page faults because we're in atomic context here.
-	 * kvm_write_guest_offset_cached() would call might_fault()
-	 * that relies on pagefault_disable() to tell if there's a
-	 * bug. NOTE: the write to guest memory may not go through if
-	 * during postcopy live migration or if there's heavy guest
-	 * paging.
-	 */
-	pagefault_disable();
-	/*
-	 * kvm_memslots() will be called by
-	 * kvm_write_guest_offset_cached() so take the srcu lock.
-	 */
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	kvm_steal_time_set_preempted(vcpu);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-	pagefault_enable();
+		/*
+		 * Disable page faults because we're in atomic context here.
+		 * kvm_write_guest_offset_cached() would call might_fault()
+		 * that relies on pagefault_disable() to tell if there's a
+		 * bug. NOTE: the write to guest memory may not go through if
+		 * during postcopy live migration or if there's heavy guest
+		 * paging.
+		 */
+		pagefault_disable();
+		/*
+		 * kvm_memslots() will be called by
+		 * kvm_write_guest_offset_cached() so take the srcu lock.
+		 */
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		kvm_steal_time_set_preempted(vcpu);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+		pagefault_enable();
+	}
+
 	kvm_x86_ops->vcpu_put(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
 	/*

Wanpeng, can you try?

Paolo

> Perhaps you can add a lock event counter to count the number of
> wait_early events caused by vcpu_is_preempted() being true to see if it
> really cause a lot more wait_early than without the vcpu_is_preempted()
> call.
> 
> I have no objection to this, I just want to find out the root cause of it.
> 
> Cheers,
> Longman
> 

