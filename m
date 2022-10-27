Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9708560FCD1
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbiJ0QTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236549AbiJ0QS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:18:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6DA18F0C9
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+lEpw8fz5CKI+PUTb/XkQrqBjkbb06nsx/UIPL+5rI=;
        b=hyK575s7f/omeE5JWjYSl9siGjZu66zhwoOlv4uIQUZDczrT8zoXkFyksFPAqqE+o7mdcM
        QoMhVPzEHrayFj17J8BXfTY2UowReFf4D7lr9SDSQ/Ses165o/aIQoewrkbh9VCL9IrjDr
        0IWfEkkK7X6Fd6oStaR1rEVdDfiYlOo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-zNLFflQqPsaVIbSbOgmE9Q-1; Thu, 27 Oct 2022 12:18:51 -0400
X-MC-Unique: zNLFflQqPsaVIbSbOgmE9Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 748DD185A78F;
        Thu, 27 Oct 2022 16:18:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4974D1415117;
        Thu, 27 Oct 2022 16:18:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 01/16] KVM: Initialize gfn_to_pfn_cache locks in dedicated helper
Date:   Thu, 27 Oct 2022 12:18:34 -0400
Message-Id: <20221027161849.2989332-2-pbonzini@redhat.com>
In-Reply-To: <20221027161849.2989332-1-pbonzini@redhat.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Luczaj <mhal@rbox.co>

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
---
 arch/x86/kvm/x86.c       | 12 +++++----
 arch/x86/kvm/xen.c       | 57 +++++++++++++++++++++-------------------
 include/linux/kvm_host.h | 24 ++++++++++++-----
 virt/kvm/pfncache.c      | 21 ++++++++-------
 4 files changed, 66 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 104b72df33d6..521b433f978c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2315,11 +2315,11 @@ static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
 
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
@@ -3388,7 +3388,7 @@ static int kvm_pv_enable_async_pf_int(struct kvm_vcpu *vcpu, u64 data)
 
 static void kvmclock_reset(struct kvm_vcpu *vcpu)
 {
-	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vcpu->arch.pv_time);
+	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.pv_time);
 	vcpu->arch.time = 0;
 }
 
@@ -11829,6 +11829,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs_avail = ~0;
 	vcpu->arch.regs_dirty = ~0;
 
+	kvm_gpc_init(&vcpu->arch.pv_time);
+
 	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	else
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 93c628d3e3a9..b2be60c6efa4 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -42,13 +42,13 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
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
 
@@ -554,15 +554,15 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
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
 
@@ -570,16 +570,16 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 
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
@@ -590,16 +590,15 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
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
@@ -1816,7 +1815,12 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
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
@@ -1824,18 +1828,17 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
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
@@ -1843,7 +1846,7 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
 	struct evtchnfd *evtchnfd;
 	int i;
 
-	kvm_gfn_to_pfn_cache_destroy(kvm, &kvm->arch.xen.shinfo_cache);
+	kvm_gpc_deactivate(kvm, &kvm->arch.xen.shinfo_cache);
 
 	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i) {
 		if (!evtchnfd->deliver.port.port)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 00c3448ba7f8..18592bdf4c1b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1240,8 +1240,18 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
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
@@ -1265,9 +1275,9 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
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
@@ -1324,7 +1334,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
 
 /**
- * kvm_gfn_to_pfn_cache_destroy - destroy and unlink a gfn_to_pfn_cache.
+ * kvm_gpc_deactivate - deactivate and unlink a gfn_to_pfn_cache.
  *
  * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
@@ -1332,7 +1342,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
  * This removes a cache from the @kvm's list to be processed on MMU notifier
  * invocation.
  */
-void kvm_gfn_to_pfn_cache_destroy(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
+void kvm_gpc_deactivate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
 
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 68ff41d39545..08f97cf97264 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -346,17 +346,20 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
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
@@ -371,9 +374,9 @@ int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
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
@@ -384,4 +387,4 @@ void kvm_gfn_to_pfn_cache_destroy(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 		gpc->active = false;
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_destroy);
+EXPORT_SYMBOL_GPL(kvm_gpc_deactivate);
-- 
2.31.1


