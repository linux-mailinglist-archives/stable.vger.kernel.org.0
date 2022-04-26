Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6BD50F761
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346382AbiDZJHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347794AbiDZJGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E23A3D4AE;
        Tue, 26 Apr 2022 01:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC984603E0;
        Tue, 26 Apr 2022 08:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B35C385A0;
        Tue, 26 Apr 2022 08:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962748;
        bh=9WAmhY5f6qFi8xrAoZFuaVIdy4mSbc5qCQoCZ9V5We8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txdlvN9wH8HAOt445NpTv0aEb16dc+Vu+CysJsXUeO1evN+KHFWfW3UaXLY0b79H6
         Bq8svrKrLb1/X8ZJHOwBtLWSU7YQnsxLAxgzaCpI7/N3/pA5C2Nuav9WYURVBsfotY
         C4hNXLZEE38beWLYYcwfY5CtK54w9GJit5TdCWqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 076/146] KVM: x86: hyper-v: Avoid writing to TSC page without an active vCPU
Date:   Tue, 26 Apr 2022 10:21:11 +0200
Message-Id: <20220426081752.202393117@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 42dcbe7d8bac997eef4c379e61d9121a15ed4e36 ]

The following WARN is triggered from kvm_vm_ioctl_set_clock():
 WARNING: CPU: 10 PID: 579353 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:3161 mark_page_dirty_in_slot+0x6c/0x80 [kvm]
 ...
 CPU: 10 PID: 579353 Comm: qemu-system-x86 Tainted: G        W  O      5.16.0.stable #20
 Hardware name: LENOVO 20UF001CUS/20UF001CUS, BIOS R1CET65W(1.34 ) 06/17/2021
 RIP: 0010:mark_page_dirty_in_slot+0x6c/0x80 [kvm]
 ...
 Call Trace:
  <TASK>
  ? kvm_write_guest+0x114/0x120 [kvm]
  kvm_hv_invalidate_tsc_page+0x9e/0xf0 [kvm]
  kvm_arch_vm_ioctl+0xa26/0xc50 [kvm]
  ? schedule+0x4e/0xc0
  ? __cond_resched+0x1a/0x50
  ? futex_wait+0x166/0x250
  ? __send_signal+0x1f1/0x3d0
  kvm_vm_ioctl+0x747/0xda0 [kvm]
  ...

The WARN was introduced by commit 03c0304a86bc ("KVM: Warn if
mark_page_dirty() is called without an active vCPU") but the change seems
to be correct (unlike Hyper-V TSC page update mechanism). In fact, there's
no real need to actually write to guest memory to invalidate TSC page, this
can be done by the first vCPU which goes through kvm_guest_time_update().

Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220407201013.963226-1-vkuznets@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  4 +---
 arch/x86/kvm/hyperv.c           | 40 +++++++--------------------------
 arch/x86/kvm/hyperv.h           |  2 +-
 arch/x86/kvm/x86.c              |  7 +++---
 4 files changed, 13 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 85ee96abba80..c4b4c0839dbd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -969,12 +969,10 @@ enum hv_tsc_page_status {
 	HV_TSC_PAGE_UNSET = 0,
 	/* TSC page MSR was written by the guest, update pending */
 	HV_TSC_PAGE_GUEST_CHANGED,
-	/* TSC page MSR was written by KVM userspace, update pending */
+	/* TSC page update was triggered from the host side */
 	HV_TSC_PAGE_HOST_CHANGED,
 	/* TSC page was properly set up and is currently active  */
 	HV_TSC_PAGE_SET,
-	/* TSC page is currently being updated and therefore is inactive */
-	HV_TSC_PAGE_UPDATING,
 	/* TSC page was set up with an inaccessible GPA */
 	HV_TSC_PAGE_BROKEN,
 };
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 10bc257d3803..247ac71b7a10 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1128,11 +1128,13 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	BUILD_BUG_ON(sizeof(tsc_seq) != sizeof(hv->tsc_ref.tsc_sequence));
 	BUILD_BUG_ON(offsetof(struct ms_hyperv_tsc_page, tsc_sequence) != 0);
 
+	mutex_lock(&hv->hv_lock);
+
 	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
+	    hv->hv_tsc_page_status == HV_TSC_PAGE_SET ||
 	    hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET)
-		return;
+		goto out_unlock;
 
-	mutex_lock(&hv->hv_lock);
 	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
 		goto out_unlock;
 
@@ -1194,45 +1196,19 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	mutex_unlock(&hv->hv_lock);
 }
 
-void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
+void kvm_hv_request_tsc_page_update(struct kvm *kvm)
 {
 	struct kvm_hv *hv = to_kvm_hv(kvm);
-	u64 gfn;
-	int idx;
-
-	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
-	    hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET ||
-	    tsc_page_update_unsafe(hv))
-		return;
 
 	mutex_lock(&hv->hv_lock);
 
-	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
-		goto out_unlock;
-
-	/* Preserve HV_TSC_PAGE_GUEST_CHANGED/HV_TSC_PAGE_HOST_CHANGED states */
-	if (hv->hv_tsc_page_status == HV_TSC_PAGE_SET)
-		hv->hv_tsc_page_status = HV_TSC_PAGE_UPDATING;
+	if (hv->hv_tsc_page_status == HV_TSC_PAGE_SET &&
+	    !tsc_page_update_unsafe(hv))
+		hv->hv_tsc_page_status = HV_TSC_PAGE_HOST_CHANGED;
 
-	gfn = hv->hv_tsc_page >> HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT;
-
-	hv->tsc_ref.tsc_sequence = 0;
-
-	/*
-	 * Take the srcu lock as memslots will be accessed to check the gfn
-	 * cache generation against the memslots generation.
-	 */
-	idx = srcu_read_lock(&kvm->srcu);
-	if (kvm_write_guest(kvm, gfn_to_gpa(gfn),
-			    &hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence)))
-		hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
-	srcu_read_unlock(&kvm->srcu, idx);
-
-out_unlock:
 	mutex_unlock(&hv->hv_lock);
 }
 
-
 static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 {
 	if (!hv_vcpu->enforce_cpuid)
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index ed1c4e546d04..3e79b4a9ed4e 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -133,7 +133,7 @@ void kvm_hv_process_stimers(struct kvm_vcpu *vcpu);
 
 void kvm_hv_setup_tsc_page(struct kvm *kvm,
 			   struct pvclock_vcpu_time_info *hv_clock);
-void kvm_hv_invalidate_tsc_page(struct kvm *kvm);
+void kvm_hv_request_tsc_page_update(struct kvm *kvm);
 
 void kvm_hv_init_vm(struct kvm *kvm);
 void kvm_hv_destroy_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05128162ebd5..7a98dea498ed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2874,7 +2874,7 @@ static void kvm_end_pvclock_update(struct kvm *kvm)
 
 static void kvm_update_masterclock(struct kvm *kvm)
 {
-	kvm_hv_invalidate_tsc_page(kvm);
+	kvm_hv_request_tsc_page_update(kvm);
 	kvm_start_pvclock_update(kvm);
 	pvclock_update_vm_gtod_copy(kvm);
 	kvm_end_pvclock_update(kvm);
@@ -3086,8 +3086,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 				       offsetof(struct compat_vcpu_info, time));
 	if (vcpu->xen.vcpu_time_info_set)
 		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
-	if (!v->vcpu_idx)
-		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
+	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
 }
 
@@ -6190,7 +6189,7 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
 	if (data.flags & ~KVM_CLOCK_VALID_FLAGS)
 		return -EINVAL;
 
-	kvm_hv_invalidate_tsc_page(kvm);
+	kvm_hv_request_tsc_page_update(kvm);
 	kvm_start_pvclock_update(kvm);
 	pvclock_update_vm_gtod_copy(kvm);
 
-- 
2.35.1



