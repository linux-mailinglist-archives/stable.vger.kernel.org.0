Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C303AD75C
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 12:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbfIIK4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 06:56:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39330 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729084AbfIIK4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Sep 2019 06:56:10 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3B376C049E10;
        Mon,  9 Sep 2019 10:56:10 +0000 (UTC)
Received: from llong.remote.csb (ovpn-120-141.rdu2.redhat.com [10.10.120.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 121D760623;
        Mon,  9 Sep 2019 10:56:01 +0000 (UTC)
Subject: Re: [PATCH] Revert "locking/pvqspinlock: Don't wait if vCPU is
 preempted"
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
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
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <29d04ee4-60e7-4df9-0c4f-fc29f2b0c6a8@redhat.com>
Date:   Mon, 9 Sep 2019 11:56:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1567993228-23668-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 09 Sep 2019 10:56:10 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/9/19 2:40 AM, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
>
> This patch reverts commit 75437bb304b20 (locking/pvqspinlock: Don't wait if 
> vCPU is preempted), we found great regression caused by this commit.
>
> Xeon Skylake box, 2 sockets, 40 cores, 80 threads, three VMs, each is 80 vCPUs.
> The score of ebizzy -M can reduce from 13000-14000 records/s to 1700-1800 
> records/s with this commit.
>
>           Host                       Guest                score
>
> vanilla + w/o kvm optimizes     vanilla               1700-1800 records/s
> vanilla + w/o kvm optimizes     vanilla + revert      13000-14000 records/s
> vanilla + w/ kvm optimizes      vanilla               4500-5000 records/s
> vanilla + w/ kvm optimizes      vanilla + revert      14000-15500 records/s
>
> Exit from aggressive wait-early mechanism can result in yield premature and 
> incur extra scheduling latency in over-subscribe scenario.
>
> kvm optimizes:
> [1] commit d73eb57b80b (KVM: Boost vCPUs that are delivering interrupts)
> [2] commit 266e85a5ec9 (KVM: X86: Boost queue head vCPU to mitigate lock waiter preemption)
>
> Tested-by: loobinliu@tencent.com
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Waiman Long <longman@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: loobinliu@tencent.com
> Cc: stable@vger.kernel.org 
> Fixes: 75437bb304b20 (locking/pvqspinlock: Don't wait if vCPU is preempted)
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  kernel/locking/qspinlock_paravirt.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/locking/qspinlock_paravirt.h b/kernel/locking/qspinlock_paravirt.h
> index 89bab07..e84d21a 100644
> --- a/kernel/locking/qspinlock_paravirt.h
> +++ b/kernel/locking/qspinlock_paravirt.h
> @@ -269,7 +269,7 @@ pv_wait_early(struct pv_node *prev, int loop)
>  	if ((loop & PV_PREV_CHECK_MASK) != 0)
>  		return false;
>  
> -	return READ_ONCE(prev->state) != vcpu_running || vcpu_is_preempted(prev->cpu);
> +	return READ_ONCE(prev->state) != vcpu_running;
>  }
>  
>  /*

There are several possibilities for this performance regression:

1) Multiple vcpus calling vcpu_is_preempted() repeatedly may cause some
cacheline contention issue depending on how that callback is implemented.

2) KVM may set the preempt flag for a short period whenver an vmexit
happens even if a vmenter is executed shortly after. In this case, we
may want to use a more durable vcpu suspend flag that indicates the vcpu
won't get a real vcpu back for a longer period of time.

Perhaps you can add a lock event counter to count the number of
wait_early events caused by vcpu_is_preempted() being true to see if it
really cause a lot more wait_early than without the vcpu_is_preempted()
call.

I have no objection to this, I just want to find out the root cause of it.

Cheers,
Longman

