Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE162419E7
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 12:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgHKKrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 06:47:49 -0400
Received: from foss.arm.com ([217.140.110.172]:36648 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbgHKKrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 06:47:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BC0931B;
        Tue, 11 Aug 2020 03:47:46 -0700 (PDT)
Received: from [10.37.12.74] (unknown [10.37.12.74])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C7CEC3F22E;
        Tue, 11 Aug 2020 03:47:42 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: arm64: Only reschedule if
 MMU_NOTIFIER_RANGE_BLOCKABLE is not set
To:     will@kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     maz@kernel.org, james.morse@arm.com, tsbogend@alpha.franken.de,
        paulus@ozlabs.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, stable@vger.kernel.org
References: <20200811102725.7121-1-will@kernel.org>
 <20200811102725.7121-3-will@kernel.org>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <1b326944-c4aa-eb52-b7dc-a77f9eecae63@arm.com>
Date:   Tue, 11 Aug 2020 11:52:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200811102725.7121-3-will@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/11/2020 11:27 AM, Will Deacon wrote:
> When an MMU notifier call results in unmapping a range that spans multiple
> PGDs, we end up calling into cond_resched_lock() when crossing a PGD boundary,
> since this avoids running into RCU stalls during VM teardown. Unfortunately,
> if the VM is destroyed as a result of OOM, then blocking is not permitted
> and the call to the scheduler triggers the following BUG():
> 
>   | BUG: sleeping function called from invalid context at arch/arm64/kvm/mmu.c:394
>   | in_atomic(): 1, irqs_disabled(): 0, non_block: 1, pid: 36, name: oom_reaper
>   | INFO: lockdep is turned off.
>   | CPU: 3 PID: 36 Comm: oom_reaper Not tainted 5.8.0 #1
>   | Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
>   | Call trace:
>   |  dump_backtrace+0x0/0x284
>   |  show_stack+0x1c/0x28
>   |  dump_stack+0xf0/0x1a4
>   |  ___might_sleep+0x2bc/0x2cc
>   |  unmap_stage2_range+0x160/0x1ac
>   |  kvm_unmap_hva_range+0x1a0/0x1c8
>   |  kvm_mmu_notifier_invalidate_range_start+0x8c/0xf8
>   |  __mmu_notifier_invalidate_range_start+0x218/0x31c
>   |  mmu_notifier_invalidate_range_start_nonblock+0x78/0xb0
>   |  __oom_reap_task_mm+0x128/0x268
>   |  oom_reap_task+0xac/0x298
>   |  oom_reaper+0x178/0x17c
>   |  kthread+0x1e4/0x1fc
>   |  ret_from_fork+0x10/0x30
> 
> Use the new 'flags' argument to kvm_unmap_hva_range() to ensure that we
> only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE is set in the notifier
> flags.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 8b3405e345b5 ("kvm: arm/arm64: Fix locking for kvm_free_stage2_pgd")
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
