Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7908C6215D2
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbiKHOPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235336AbiKHOPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:15:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A696686B9
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:15:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36BBC615A9
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384CDC433D6;
        Tue,  8 Nov 2022 14:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916945;
        bh=AMD7flq0DGW68euzCBHzDcnnh6MKbuKfiOc7ASsFsZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fimoqbuyXhj/md4+/2+AtxDqJr8Er2unjPjh3BNi70EXZyLu+Rojai3euxagtvspk
         7dEyGUMZPZWuz7Bf8PbRx5aix1oP7Q/776zGt63zX1WZmPueNYwbgXyaeYkeL1qHP1
         fGXm5dhTpWSYrqt1dWUEq0qwe90vEtgvFeTqPnuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ": Michal Luczaj" <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 180/197] KVM: Reject attempts to consume or refresh inactive gfn_to_pfn_cache
Date:   Tue,  8 Nov 2022 14:40:18 +0100
Message-Id: <20221108133403.097849188@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit ecbcf030b45666ad11bc98565e71dfbcb7be4393 upstream.

Reject kvm_gpc_check() and kvm_gpc_refresh() if the cache is inactive.
Not checking the active flag during refresh is particularly egregious, as
KVM can end up with a valid, inactive cache, which can lead to a variety
of use-after-free bugs, e.g. consuming a NULL kernel pointer or missing
an mmu_notifier invalidation due to the cache not being on the list of
gfns to invalidate.

Note, "active" needs to be set if and only if the cache is on the list
of caches, i.e. is reachable via mmu_notifier events.  If a relevant
mmu_notifier event occurs while the cache is "active" but not on the
list, KVM will not acquire the cache's lock and so will not serailize
the mmu_notifier event with active users and/or kvm_gpc_refresh().

A race between KVM_XEN_ATTR_TYPE_SHARED_INFO and KVM_XEN_HVM_EVTCHN_SEND
can be exploited to trigger the bug.

1. Deactivate shinfo cache:

kvm_xen_hvm_set_attr
case KVM_XEN_ATTR_TYPE_SHARED_INFO
 kvm_gpc_deactivate
  kvm_gpc_unmap
   gpc->valid = false
   gpc->khva = NULL
  gpc->active = false

Result: active = false, valid = false

2. Cause cache refresh:

kvm_arch_vm_ioctl
case KVM_XEN_HVM_EVTCHN_SEND
 kvm_xen_hvm_evtchn_send
  kvm_xen_set_evtchn
   kvm_xen_set_evtchn_fast
    kvm_gpc_check
    return -EWOULDBLOCK because !gpc->valid
   kvm_xen_set_evtchn_fast
    return -EWOULDBLOCK
   kvm_gpc_refresh
    hva_to_pfn_retry
     gpc->valid = true
     gpc->khva = not NULL

Result: active = false, valid = true

3. Race ioctl KVM_XEN_HVM_EVTCHN_SEND against ioctl
KVM_XEN_ATTR_TYPE_SHARED_INFO:

kvm_arch_vm_ioctl
case KVM_XEN_HVM_EVTCHN_SEND
 kvm_xen_hvm_evtchn_send
  kvm_xen_set_evtchn
   kvm_xen_set_evtchn_fast
    read_lock gpc->lock
                                          kvm_xen_hvm_set_attr case
                                          KVM_XEN_ATTR_TYPE_SHARED_INFO
                                           mutex_lock kvm->lock
                                           kvm_xen_shared_info_init
                                            kvm_gpc_activate
                                             gpc->khva = NULL
    kvm_gpc_check
     [ Check passes because gpc->valid is
       still true, even though gpc->khva
       is already NULL. ]
    shinfo = gpc->khva
    pending_bits = shinfo->evtchn_pending
    CRASH: test_and_set_bit(..., pending_bits)

Fixes: 982ed0de4753 ("KVM: Reinstate gfn_to_pfn_cache with invalidation support")
Cc: stable@vger.kernel.org
Reported-by: : Michal Luczaj <mhal@rbox.co>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221013211234.1318131-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/pfncache.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -81,6 +81,9 @@ bool kvm_gfn_to_pfn_cache_check(struct k
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 
+	if (!gpc->active)
+		return false;
+
 	if ((gpa & ~PAGE_MASK) + len > PAGE_SIZE)
 		return false;
 
@@ -240,10 +243,11 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	unsigned long page_offset = gpa & ~PAGE_MASK;
-	kvm_pfn_t old_pfn, new_pfn;
+	bool unmap_old = false;
 	unsigned long old_uhva;
+	kvm_pfn_t old_pfn;
 	void *old_khva;
-	int ret = 0;
+	int ret;
 
 	/*
 	 * If must fit within a single page. The 'len' argument is
@@ -261,6 +265,11 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 
 	write_lock_irq(&gpc->lock);
 
+	if (!gpc->active) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	old_pfn = gpc->pfn;
 	old_khva = gpc->khva - offset_in_page(gpc->khva);
 	old_uhva = gpc->uhva;
@@ -291,6 +300,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 		/* If the HVA→PFN mapping was already valid, don't unmap it. */
 		old_pfn = KVM_PFN_ERR_FAULT;
 		old_khva = NULL;
+		ret = 0;
 	}
 
  out:
@@ -305,14 +315,15 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 		gpc->khva = NULL;
 	}
 
-	/* Snapshot the new pfn before dropping the lock! */
-	new_pfn = gpc->pfn;
+	/* Detect a pfn change before dropping the lock! */
+	unmap_old = (old_pfn != gpc->pfn);
 
+out_unlock:
 	write_unlock_irq(&gpc->lock);
 
 	mutex_unlock(&gpc->refresh_lock);
 
-	if (old_pfn != new_pfn)
+	if (unmap_old)
 		gpc_unmap_khva(kvm, old_pfn, old_khva);
 
 	return ret;
@@ -366,11 +377,19 @@ int kvm_gpc_activate(struct kvm *kvm, st
 		gpc->vcpu = vcpu;
 		gpc->usage = usage;
 		gpc->valid = false;
-		gpc->active = true;
 
 		spin_lock(&kvm->gpc_lock);
 		list_add(&gpc->list, &kvm->gpc_list);
 		spin_unlock(&kvm->gpc_lock);
+
+		/*
+		 * Activate the cache after adding it to the list, a concurrent
+		 * refresh must not establish a mapping until the cache is
+		 * reachable by mmu_notifier events.
+		 */
+		write_lock_irq(&gpc->lock);
+		gpc->active = true;
+		write_unlock_irq(&gpc->lock);
 	}
 	return kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpa, len);
 }
@@ -379,12 +398,20 @@ EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 void kvm_gpc_deactivate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 {
 	if (gpc->active) {
+		/*
+		 * Deactivate the cache before removing it from the list, KVM
+		 * must stall mmu_notifier events until all users go away, i.e.
+		 * until gpc->lock is dropped and refresh is guaranteed to fail.
+		 */
+		write_lock_irq(&gpc->lock);
+		gpc->active = false;
+		write_unlock_irq(&gpc->lock);
+
 		spin_lock(&kvm->gpc_lock);
 		list_del(&gpc->list);
 		spin_unlock(&kvm->gpc_lock);
 
 		kvm_gfn_to_pfn_cache_unmap(kvm, gpc);
-		gpc->active = false;
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_deactivate);


