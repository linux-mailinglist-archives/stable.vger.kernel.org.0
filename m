Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C57D6215D0
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbiKHOPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235233AbiKHOPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:15:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EB659FEC
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:15:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9234FB81ADB
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D31FC433C1;
        Tue,  8 Nov 2022 14:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916939;
        bh=Tv6zJr7iyXtbZ/Y993TFKM8q91I28FU8yNtKB2zLwwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohrZkG0epw/hgXxdTv7czEDu5P3dhxKSosg7qrAMtjdW52nwHWH1RJn6ObwZliKoY
         EyRSjEVgR9TQN3PqRKhgbK7jFLeAkMbLdnddY6FRCq9Q2hxGsio68YclZKD+ylYLbK
         gwhHH3lZubPfDv5Yk3Ch3V5f5j7/biR5ShOMgW+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 179/197] KVM: Initialize gfn_to_pfn_cache locks in dedicated helper
Date:   Tue,  8 Nov 2022 14:40:17 +0100
Message-Id: <20221108133403.051145170@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Luczaj <mhal@rbox.co>

commit 52491a38b2c2411f3f0229dc6ad610349c704a41 upstream.

Move the gfn_to_pfn_cache lock initialization to another helper and
call the new helper during VM/vCPU creation.  There are race
conditions possible due to kvm_gfn_to_pfn_cache_init()'s
ability to re-initialize the cache's locks.

For example: a race between ioctl(KVM_XEN_HVM_EVTCHN_SEND) and
kvm_gfn_to_pfn_cache_init() leads to a corrupted shinfo gpc lock.

                (thread 1)                |           (thread 2)
                                          |
 kvm_xen_set_evtchn_fast                  |
  read_lock_irqsave(&gpc->lock, ...)      |
                                          | kvm_gfn_to_pfn_cache_init
                                          |  rwlock_init(&gpc->lock)
  read_unlock_irqrestore(&gpc->lock, ...) |

Rename "cache_init" and "cache_destroy" to activate+deactivate to
avoid implying that the cache really is destroyed/freed.

Note, there more races in the newly named kvm_gpc_activate() that will
be addressed separately.

Fixes: 982ed0de4753 ("KVM: Reinstate gfn_to_pfn_cache with invalidation support")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
[sean: call out that this is a bug fix]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221013211234.1318131-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c       |   12 +++++----
 arch/x86/kvm/xen.c       |   57 ++++++++++++++++++++++++-----------------------
 include/linux/kvm_host.h |   24 ++++++++++++++-----
 virt/kvm/pfncache.c      |   21 +++++++++--------
 4 files changed, 66 insertions(+), 48 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2304,11 +2304,11 @@ static void kvm_write_system_time(struct
 
 	/* we verify if the enable bit is set... */
 	if (system_time & 1) {
-		kvm_gfn_to_pfn_cache_init(vcpu->kvm, &vcpu->arch.pv_time, vcpu,
-					  KVM_HOST_USES_PFN, system_time & ~1ULL,
-					  sizeof(struct pvclock_vcpu_time_info));
+		kvm_gpc_activate(vcpu->kvm, &vcpu->arch.pv_time, vcpu,
+				 KVM_HOST_USES_PFN, system_time & ~1ULL,
+				 sizeof(struct pvclock_vcpu_time_info));
 	} else {
-		kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vcpu->arch.pv_time);
+		kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.pv_time);
 	}
 
 	return;
@@ -3377,7 +3377,7 @@ static int kvm_pv_enable_async_pf_int(st
 
 static void kvmclock_reset(struct kvm_vcpu *vcpu)
 {
-	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vcpu->arch.pv_time);
+	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.pv_time);
 	vcpu->arch.time = 0;
 }
 
@@ -11629,6 +11629,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
 	vcpu->arch.regs_avail = ~0;
 	vcpu->arch.regs_dirty = ~0;
 
+	kvm_gpc_init(&vcpu->arch.pv_time);
+
 	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	else
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -42,13 +42,13 @@ static int kvm_xen_shared_info_init(stru
 	int idx = srcu_read_lock(&kvm->srcu);
 
 	if (gfn == GPA_INVALID) {
-		kvm_gfn_to_pfn_cache_destroy(kvm, gpc);
+		kvm_gpc_deactivate(kvm, gpc);
 		goto out;
 	}
 
 	do {
-		ret = kvm_gfn_to_pfn_cache_init(kvm, gpc, NULL, KVM_HOST_USES_PFN,
-						gpa, PAGE_SIZE);
+		ret = kvm_gpc_activate(kvm, gpc, NULL, KVM_HOST_USES_PFN, gpa,
+				       PAGE_SIZE);
 		if (ret)
 			goto out;
 
@@ -554,15 +554,15 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcp
 			     offsetof(struct compat_vcpu_info, time));
 
 		if (data->u.gpa == GPA_INVALID) {
-			kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vcpu->arch.xen.vcpu_info_cache);
+			kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.vcpu_info_cache);
 			r = 0;
 			break;
 		}
 
-		r = kvm_gfn_to_pfn_cache_init(vcpu->kvm,
-					      &vcpu->arch.xen.vcpu_info_cache,
-					      NULL, KVM_HOST_USES_PFN, data->u.gpa,
-					      sizeof(struct vcpu_info));
+		r = kvm_gpc_activate(vcpu->kvm,
+				     &vcpu->arch.xen.vcpu_info_cache, NULL,
+				     KVM_HOST_USES_PFN, data->u.gpa,
+				     sizeof(struct vcpu_info));
 		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
@@ -570,16 +570,16 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcp
 
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
 		if (data->u.gpa == GPA_INVALID) {
-			kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
-						     &vcpu->arch.xen.vcpu_time_info_cache);
+			kvm_gpc_deactivate(vcpu->kvm,
+					   &vcpu->arch.xen.vcpu_time_info_cache);
 			r = 0;
 			break;
 		}
 
-		r = kvm_gfn_to_pfn_cache_init(vcpu->kvm,
-					      &vcpu->arch.xen.vcpu_time_info_cache,
-					      NULL, KVM_HOST_USES_PFN, data->u.gpa,
-					      sizeof(struct pvclock_vcpu_time_info));
+		r = kvm_gpc_activate(vcpu->kvm,
+				     &vcpu->arch.xen.vcpu_time_info_cache,
+				     NULL, KVM_HOST_USES_PFN, data->u.gpa,
+				     sizeof(struct pvclock_vcpu_time_info));
 		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 		break;
@@ -590,16 +590,15 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcp
 			break;
 		}
 		if (data->u.gpa == GPA_INVALID) {
-			kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
-						     &vcpu->arch.xen.runstate_cache);
+			kvm_gpc_deactivate(vcpu->kvm,
+					   &vcpu->arch.xen.runstate_cache);
 			r = 0;
 			break;
 		}
 
-		r = kvm_gfn_to_pfn_cache_init(vcpu->kvm,
-					      &vcpu->arch.xen.runstate_cache,
-					      NULL, KVM_HOST_USES_PFN, data->u.gpa,
-					      sizeof(struct vcpu_runstate_info));
+		r = kvm_gpc_activate(vcpu->kvm, &vcpu->arch.xen.runstate_cache,
+				     NULL, KVM_HOST_USES_PFN, data->u.gpa,
+				     sizeof(struct vcpu_runstate_info));
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT:
@@ -1817,7 +1816,12 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *
 {
 	vcpu->arch.xen.vcpu_id = vcpu->vcpu_idx;
 	vcpu->arch.xen.poll_evtchn = 0;
+
 	timer_setup(&vcpu->arch.xen.poll_timer, cancel_evtchn_poll, 0);
+
+	kvm_gpc_init(&vcpu->arch.xen.runstate_cache);
+	kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache);
+	kvm_gpc_init(&vcpu->arch.xen.vcpu_time_info_cache);
 }
 
 void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
@@ -1825,18 +1829,17 @@ void kvm_xen_destroy_vcpu(struct kvm_vcp
 	if (kvm_xen_timer_enabled(vcpu))
 		kvm_xen_stop_timer(vcpu);
 
-	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
-				     &vcpu->arch.xen.runstate_cache);
-	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
-				     &vcpu->arch.xen.vcpu_info_cache);
-	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
-				     &vcpu->arch.xen.vcpu_time_info_cache);
+	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.runstate_cache);
+	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.vcpu_info_cache);
+	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.vcpu_time_info_cache);
+
 	del_timer_sync(&vcpu->arch.xen.poll_timer);
 }
 
 void kvm_xen_init_vm(struct kvm *kvm)
 {
 	idr_init(&kvm->arch.xen.evtchn_ports);
+	kvm_gpc_init(&kvm->arch.xen.shinfo_cache);
 }
 
 void kvm_xen_destroy_vm(struct kvm *kvm)
@@ -1844,7 +1847,7 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
 	struct evtchnfd *evtchnfd;
 	int i;
 
-	kvm_gfn_to_pfn_cache_destroy(kvm, &kvm->arch.xen.shinfo_cache);
+	kvm_gpc_deactivate(kvm, &kvm->arch.xen.shinfo_cache);
 
 	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i) {
 		if (!evtchnfd->deliver.port.port)
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1241,8 +1241,18 @@ int kvm_vcpu_write_guest(struct kvm_vcpu
 void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 /**
- * kvm_gfn_to_pfn_cache_init - prepare a cached kernel mapping and HPA for a
- *                             given guest physical address.
+ * kvm_gpc_init - initialize gfn_to_pfn_cache.
+ *
+ * @gpc:	   struct gfn_to_pfn_cache object.
+ *
+ * This sets up a gfn_to_pfn_cache by initializing locks.  Note, the cache must
+ * be zero-allocated (or zeroed by the caller before init).
+ */
+void kvm_gpc_init(struct gfn_to_pfn_cache *gpc);
+
+/**
+ * kvm_gpc_activate - prepare a cached kernel mapping and HPA for a given guest
+ *                    physical address.
  *
  * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
@@ -1266,9 +1276,9 @@ void kvm_vcpu_mark_page_dirty(struct kvm
  * kvm_gfn_to_pfn_cache_check() to ensure that the cache is valid before
  * accessing the target page.
  */
-int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-			      struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
-			      gpa_t gpa, unsigned long len);
+int kvm_gpc_activate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
+		     struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
+		     gpa_t gpa, unsigned long len);
 
 /**
  * kvm_gfn_to_pfn_cache_check - check validity of a gfn_to_pfn_cache.
@@ -1325,7 +1335,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
 
 /**
- * kvm_gfn_to_pfn_cache_destroy - destroy and unlink a gfn_to_pfn_cache.
+ * kvm_gpc_deactivate - deactivate and unlink a gfn_to_pfn_cache.
  *
  * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
@@ -1333,7 +1343,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct k
  * This removes a cache from the @kvm's list to be processed on MMU notifier
  * invocation.
  */
-void kvm_gfn_to_pfn_cache_destroy(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
+void kvm_gpc_deactivate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
 
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -346,17 +346,20 @@ void kvm_gfn_to_pfn_cache_unmap(struct k
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_unmap);
 
+void kvm_gpc_init(struct gfn_to_pfn_cache *gpc)
+{
+	rwlock_init(&gpc->lock);
+	mutex_init(&gpc->refresh_lock);
+}
+EXPORT_SYMBOL_GPL(kvm_gpc_init);
 
-int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-			      struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
-			      gpa_t gpa, unsigned long len)
+int kvm_gpc_activate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
+		     struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
+		     gpa_t gpa, unsigned long len)
 {
 	WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) != usage);
 
 	if (!gpc->active) {
-		rwlock_init(&gpc->lock);
-		mutex_init(&gpc->refresh_lock);
-
 		gpc->khva = NULL;
 		gpc->pfn = KVM_PFN_ERR_FAULT;
 		gpc->uhva = KVM_HVA_ERR_BAD;
@@ -371,9 +374,9 @@ int kvm_gfn_to_pfn_cache_init(struct kvm
 	}
 	return kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpa, len);
 }
-EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_init);
+EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 
-void kvm_gfn_to_pfn_cache_destroy(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
+void kvm_gpc_deactivate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 {
 	if (gpc->active) {
 		spin_lock(&kvm->gpc_lock);
@@ -384,4 +387,4 @@ void kvm_gfn_to_pfn_cache_destroy(struct
 		gpc->active = false;
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_destroy);
+EXPORT_SYMBOL_GPL(kvm_gpc_deactivate);


