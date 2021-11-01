Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB6C4418D7
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbhKAJwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234340AbhKAJu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:50:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAC6F61452;
        Mon,  1 Nov 2021 09:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759120;
        bh=wnjNkarDPbk9nqhsb1H7IJ1NW2bL0mjnkBEMCoB5J4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsiOVhfC0PI5Tgmzx1J513hH4RsVG2fWYNucYTlfYVVQCuZefWAHesnjE7faJHZLN
         /idiKygyfmCE+CeCtIwJUnm/0J3305FZ7cQXoPDoARHWPU8QEDWHGDtfNm5J167I9e
         R3D+3XC04H4BQa3wP2DJfaOdrwWZyaVT8ruY/IaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com,
        David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 123/125] KVM: x86: switch pvclock_gtod_sync_lock to a raw spinlock
Date:   Mon,  1 Nov 2021 10:18:16 +0100
Message-Id: <20211101082556.326799324@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

commit 8228c77d8b56e3f735baf71fefb1b548c23691a7 upstream.

On the preemption path when updating a Xen guest's runstate times, this
lock is taken inside the scheduler rq->lock, which is a raw spinlock.
This was shown in a lockdep warning:

[   89.138354] =============================
[   89.138356] [ BUG: Invalid wait context ]
[   89.138358] 5.15.0-rc5+ #834 Tainted: G S        I E
[   89.138360] -----------------------------
[   89.138361] xen_shinfo_test/2575 is trying to lock:
[   89.138363] ffffa34a0364efd8 (&kvm->arch.pvclock_gtod_sync_lock){....}-{3:3}, at: get_kvmclock_ns+0x1f/0x130 [kvm]
[   89.138442] other info that might help us debug this:
[   89.138444] context-{5:5}
[   89.138445] 4 locks held by xen_shinfo_test/2575:
[   89.138447]  #0: ffff972bdc3b8108 (&vcpu->mutex){+.+.}-{4:4}, at: kvm_vcpu_ioctl+0x77/0x6f0 [kvm]
[   89.138483]  #1: ffffa34a03662e90 (&kvm->srcu){....}-{0:0}, at: kvm_arch_vcpu_ioctl_run+0xdc/0x8b0 [kvm]
[   89.138526]  #2: ffff97331fdbac98 (&rq->__lock){-.-.}-{2:2}, at: __schedule+0xff/0xbd0
[   89.138534]  #3: ffffa34a03662e90 (&kvm->srcu){....}-{0:0}, at: kvm_arch_vcpu_put+0x26/0x170 [kvm]
...
[   89.138695]  get_kvmclock_ns+0x1f/0x130 [kvm]
[   89.138734]  kvm_xen_update_runstate+0x14/0x90 [kvm]
[   89.138783]  kvm_xen_update_runstate_guest+0x15/0xd0 [kvm]
[   89.138830]  kvm_arch_vcpu_put+0xe6/0x170 [kvm]
[   89.138870]  kvm_sched_out+0x2f/0x40 [kvm]
[   89.138900]  __schedule+0x5de/0xbd0

Cc: stable@vger.kernel.org
Reported-by: syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com
Fixes: 30b5c851af79 ("KVM: x86/xen: Add support for vCPU runstate information")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Message-Id: <1b02a06421c17993df337493a68ba923f3bd5c0f.camel@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/x86.c              |   28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 15 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1084,7 +1084,7 @@ struct kvm_arch {
 	u64 cur_tsc_generation;
 	int nr_vcpus_matched_tsc;
 
-	spinlock_t pvclock_gtod_sync_lock;
+	raw_spinlock_t pvclock_gtod_sync_lock;
 	bool use_master_clock;
 	u64 master_kernel_ns;
 	u64 master_cycle_now;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2537,7 +2537,7 @@ static void kvm_synchronize_tsc(struct k
 	kvm_vcpu_write_tsc_offset(vcpu, offset);
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
-	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
+	raw_spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
 	if (!matched) {
 		kvm->arch.nr_vcpus_matched_tsc = 0;
 	} else if (!already_matched) {
@@ -2545,7 +2545,7 @@ static void kvm_synchronize_tsc(struct k
 	}
 
 	kvm_track_tsc_matching(vcpu);
-	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
 }
 
 static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
@@ -2775,9 +2775,9 @@ static void kvm_gen_update_masterclock(s
 	kvm_make_mclock_inprogress_request(kvm);
 
 	/* no guest entries from this point */
-	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
+	raw_spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 	pvclock_update_vm_gtod_copy(kvm);
-	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
@@ -2795,15 +2795,15 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 	unsigned long flags;
 	u64 ret;
 
-	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
+	raw_spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 	if (!ka->use_master_clock) {
-		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+		raw_spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
 		return get_kvmclock_base_ns() + ka->kvmclock_offset;
 	}
 
 	hv_clock.tsc_timestamp = ka->master_cycle_now;
 	hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
-	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
 
 	/* both __this_cpu_read() and rdtsc() should be on the same cpu */
 	get_cpu();
@@ -2897,13 +2897,13 @@ static int kvm_guest_time_update(struct
 	 * If the host uses TSC clock, then passthrough TSC as stable
 	 * to the guest.
 	 */
-	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
+	raw_spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 	use_master_clock = ka->use_master_clock;
 	if (use_master_clock) {
 		host_tsc = ka->master_cycle_now;
 		kernel_ns = ka->master_kernel_ns;
 	}
-	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
@@ -6101,13 +6101,13 @@ set_pit2_out:
 		 * is slightly ahead) here we risk going negative on unsigned
 		 * 'system_time' when 'user_ns.clock' is very small.
 		 */
-		spin_lock_irq(&ka->pvclock_gtod_sync_lock);
+		raw_spin_lock_irq(&ka->pvclock_gtod_sync_lock);
 		if (kvm->arch.use_master_clock)
 			now_ns = ka->master_kernel_ns;
 		else
 			now_ns = get_kvmclock_base_ns();
 		ka->kvmclock_offset = user_ns.clock - now_ns;
-		spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
+		raw_spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
 
 		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
 		break;
@@ -8157,9 +8157,9 @@ static void kvm_hyperv_tsc_notifier(void
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		struct kvm_arch *ka = &kvm->arch;
 
-		spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
+		raw_spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 		pvclock_update_vm_gtod_copy(kvm);
-		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+		raw_spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
 
 		kvm_for_each_vcpu(cpu, vcpu, kvm)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
@@ -11148,7 +11148,7 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 
 	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
 	mutex_init(&kvm->arch.apic_map_lock);
-	spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
+	raw_spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
 
 	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
 	pvclock_update_vm_gtod_copy(kvm);


