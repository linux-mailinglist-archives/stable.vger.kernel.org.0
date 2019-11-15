Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D159FD614
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfKOGWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:22:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbfKOGWP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:15 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFE8820728;
        Fri, 15 Nov 2019 06:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798934;
        bh=pCATTbiF5NuP+y+tN0vyFUdJXhwdFoHoBkoltCfJUlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dg0OInXCeh50cIRb9Za/fr2AXMpImcmjTKZ65142G8vaV/B95uA5C5IGHDXxiPBOs
         13OOn/1P+L90bRkq6b7ii8abooz0Y9R3AWAU4stQqZdQb9O9TN/10kjCLtbLoyxe7v
         fFTD7rSxc1iVuzQZyX9HevMSvvsxHcB5x6tXO9hY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 18/31] kvm: Convert kvm_lock to a mutex
Date:   Fri, 15 Nov 2019 14:20:47 +0800
Message-Id: <20191115062017.228649452@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
References: <20191115062009.813108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

commit 0d9ce162cf46c99628cc5da9510b959c7976735b upstream.

It doesn't seem as if there is any particular need for kvm_lock to be a
spinlock, so convert the lock to a mutex so that sleepable functions (in
particular cond_resched()) can be called while holding it.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 4.9:
 - Drop changes in kvm_hyperv_tsc_notifier(), vm_stat_clear(),
   vcpu_stat_clear(), kvm_uevent_notify_change()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/virtual/kvm/locking.txt |    6 +++---
 arch/s390/kvm/kvm-s390.c              |    4 ++--
 arch/x86/kvm/mmu.c                    |    4 ++--
 arch/x86/kvm/x86.c                    |   10 +++++-----
 include/linux/kvm_host.h              |    2 +-
 virt/kvm/kvm_main.c                   |   18 +++++++++---------
 6 files changed, 22 insertions(+), 22 deletions(-)

--- a/Documentation/virtual/kvm/locking.txt
+++ b/Documentation/virtual/kvm/locking.txt
@@ -13,8 +13,8 @@ The acquisition orders for mutexes are a
 - kvm->slots_lock is taken outside kvm->irq_lock, though acquiring
   them together is quite rare.
 
-For spinlocks, kvm_lock is taken outside kvm->mmu_lock.  Everything
-else is a leaf: no other lock is taken inside the critical sections.
+Everything else is a leaf: no other lock is taken inside the critical
+sections.
 
 2: Exception
 ------------
@@ -142,7 +142,7 @@ See the comments in spte_has_volatile_bi
 ------------
 
 Name:		kvm_lock
-Type:		spinlock_t
+Type:		mutex
 Arch:		any
 Protects:	- vm_list
 
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1422,13 +1422,13 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 	kvm->arch.sca = (struct bsca_block *) get_zeroed_page(alloc_flags);
 	if (!kvm->arch.sca)
 		goto out_err;
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	sca_offset += 16;
 	if (sca_offset + sizeof(struct bsca_block) > PAGE_SIZE)
 		sca_offset = 0;
 	kvm->arch.sca = (struct bsca_block *)
 			((char *) kvm->arch.sca + sca_offset);
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 
 	sprintf(debug_name, "kvm-%u", current->pid);
 
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4979,7 +4979,7 @@ mmu_shrink_scan(struct shrinker *shrink,
 	int nr_to_scan = sc->nr_to_scan;
 	unsigned long freed = 0;
 
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		int idx;
@@ -5029,7 +5029,7 @@ unlock:
 		break;
 	}
 
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 	return freed;
 }
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5978,17 +5978,17 @@ static int kvmclock_cpufreq_notifier(str
 
 	smp_call_function_single(freq->cpu, tsc_khz_changed, freq, 1);
 
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			if (vcpu->cpu != freq->cpu)
 				continue;
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-			if (vcpu->cpu != smp_processor_id())
+			if (vcpu->cpu != raw_smp_processor_id())
 				send_ipi = 1;
 		}
 	}
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 
 	if (freq->old < freq->new && send_ipi) {
 		/*
@@ -6126,12 +6126,12 @@ static void pvclock_gtod_update_fn(struc
 	struct kvm_vcpu *vcpu;
 	int i;
 
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
 		kvm_for_each_vcpu(i, vcpu, kvm)
 			kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
 	atomic_set(&kvm_guest_has_master_clock, 0);
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 }
 
 static DECLARE_WORK(pvclock_gtod_work, pvclock_gtod_update_fn);
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -129,7 +129,7 @@ static inline bool is_error_page(struct
 
 extern struct kmem_cache *kvm_vcpu_cache;
 
-extern spinlock_t kvm_lock;
+extern struct mutex kvm_lock;
 extern struct list_head vm_list;
 
 struct kvm_io_range {
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -87,7 +87,7 @@ module_param(halt_poll_ns_shrink, uint,
  *	kvm->lock --> kvm->slots_lock --> kvm->irq_lock
  */
 
-DEFINE_SPINLOCK(kvm_lock);
+DEFINE_MUTEX(kvm_lock);
 static DEFINE_RAW_SPINLOCK(kvm_count_lock);
 LIST_HEAD(vm_list);
 
@@ -666,9 +666,9 @@ static struct kvm *kvm_create_vm(unsigne
 	if (r)
 		goto out_err;
 
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 
 	preempt_notifier_inc();
 
@@ -724,9 +724,9 @@ static void kvm_destroy_vm(struct kvm *k
 
 	kvm_destroy_vm_debugfs(kvm);
 	kvm_arch_sync_events(kvm);
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	list_del(&kvm->vm_list);
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 	kvm_free_irq_routing(kvm);
 	for (i = 0; i < KVM_NR_BUSES; i++) {
 		if (kvm->buses[i])
@@ -3752,13 +3752,13 @@ static int vm_stat_get(void *_offset, u6
 	u64 tmp_val;
 
 	*val = 0;
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		stat_tmp.kvm = kvm;
 		vm_stat_get_per_vm((void *)&stat_tmp, &tmp_val);
 		*val += tmp_val;
 	}
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 	return 0;
 }
 
@@ -3772,13 +3772,13 @@ static int vcpu_stat_get(void *_offset,
 	u64 tmp_val;
 
 	*val = 0;
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		stat_tmp.kvm = kvm;
 		vcpu_stat_get_per_vm((void *)&stat_tmp, &tmp_val);
 		*val += tmp_val;
 	}
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 	return 0;
 }
 


