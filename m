Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62762F13F5
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732648AbhAKNRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:17:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:35478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731660AbhAKNRe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:17:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E030222BE9;
        Mon, 11 Jan 2021 13:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371038;
        bh=56ljdGGTh5L4PdGUDOdZmasYU7QmrraHehc84vPPjYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfg5EOYbyylaPGRPSBQIpUtjve1OaD5O63lmKM4uSDmskxc2izVftIuctXXt35JlF
         hyD117UucDPnfYBzE3pZqLD2TkhSwh9bEtSvX9/odc1BHYspeT5hy7NSPPWVwCT5iT
         w665qZhLOtEVUHgZOjegB61+0EN41a949UwH3P4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>
Subject: [PATCH 5.10 114/145] KVM: x86/mmu: Ensure TDP MMU roots are freed after yield
Date:   Mon, 11 Jan 2021 14:02:18 +0100
Message-Id: <20210111130054.005402130@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

commit a889ea54b3daa63ee1463dc19ed699407d61458b upstream.

Many TDP MMU functions which need to perform some action on all TDP MMU
roots hold a reference on that root so that they can safely drop the MMU
lock in order to yield to other threads. However, when releasing the
reference on the root, there is a bug: the root will not be freed even
if its reference count (root_count) is reduced to 0.

To simplify acquiring and releasing references on TDP MMU root pages, and
to ensure that these roots are properly freed, move the get/put operations
into another TDP MMU root iterator macro.

Moving the get/put operations into an iterator macro also helps
simplify control flow when a root does need to be freed. Note that using
the list_for_each_entry_safe macro would not have been appropriate in
this situation because it could keep a pointer to the next root across
an MMU lock release + reacquire, during which time that root could be
freed.

Reported-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
Fixes: 063afacd8730 ("kvm: x86/mmu: Support invalidate range MMU notifier for TDP MMU")
Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
Fixes: 14881998566d ("kvm: x86/mmu: Support disabling dirty logging for the tdp MMU")
Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20210107001935.3732070-1-bgardon@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu/tdp_mmu.c |  104 ++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 56 deletions(-)

--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -42,7 +42,48 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 }
 
-#define for_each_tdp_mmu_root(_kvm, _root)			    \
+static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
+{
+	if (kvm_mmu_put_root(kvm, root))
+		kvm_tdp_mmu_free_root(kvm, root);
+}
+
+static inline bool tdp_mmu_next_root_valid(struct kvm *kvm,
+					   struct kvm_mmu_page *root)
+{
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	if (list_entry_is_head(root, &kvm->arch.tdp_mmu_roots, link))
+		return false;
+
+	kvm_mmu_get_root(kvm, root);
+	return true;
+
+}
+
+static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
+						     struct kvm_mmu_page *root)
+{
+	struct kvm_mmu_page *next_root;
+
+	next_root = list_next_entry(root, link);
+	tdp_mmu_put_root(kvm, root);
+	return next_root;
+}
+
+/*
+ * Note: this iterator gets and puts references to the roots it iterates over.
+ * This makes it safe to release the MMU lock and yield within the loop, but
+ * if exiting the loop early, the caller must drop the reference to the most
+ * recent root. (Unless keeping a live reference is desirable.)
+ */
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root)				\
+	for (_root = list_first_entry(&_kvm->arch.tdp_mmu_roots,	\
+				      typeof(*_root), link);		\
+	     tdp_mmu_next_root_valid(_kvm, _root);			\
+	     _root = tdp_mmu_next_root(_kvm, _root))
+
+#define for_each_tdp_mmu_root(_kvm, _root)				\
 	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
 
 bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
@@ -439,18 +480,9 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kv
 	struct kvm_mmu_page *root;
 	bool flush = false;
 
-	for_each_tdp_mmu_root(kvm, root) {
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
+	for_each_tdp_mmu_root_yield_safe(kvm, root)
 		flush |= zap_gfn_range(kvm, root, start, end, true);
 
-		kvm_mmu_put_root(kvm, root);
-	}
-
 	return flush;
 }
 
@@ -609,13 +641,7 @@ static int kvm_tdp_mmu_handle_hva_range(
 	int ret = 0;
 	int as_id;
 
-	for_each_tdp_mmu_root(kvm, root) {
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
+	for_each_tdp_mmu_root_yield_safe(kvm, root) {
 		as_id = kvm_mmu_page_as_id(root);
 		slots = __kvm_memslots(kvm, as_id);
 		kvm_for_each_memslot(memslot, slots) {
@@ -637,8 +663,6 @@ static int kvm_tdp_mmu_handle_hva_range(
 			ret |= handler(kvm, memslot, root, gfn_start,
 				       gfn_end, data);
 		}
-
-		kvm_mmu_put_root(kvm, root);
 	}
 
 	return ret;
@@ -826,21 +850,13 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
 
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
 		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
 			     slot->base_gfn + slot->npages, min_level);
-
-		kvm_mmu_put_root(kvm, root);
 	}
 
 	return spte_set;
@@ -894,21 +910,13 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
 
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
 		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
-
-		kvm_mmu_put_root(kvm, root);
 	}
 
 	return spte_set;
@@ -1017,21 +1025,13 @@ bool kvm_tdp_mmu_slot_set_dirty(struct k
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
 
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
 		spte_set |= set_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
-
-		kvm_mmu_put_root(kvm, root);
 	}
 	return spte_set;
 }
@@ -1077,21 +1077,13 @@ void kvm_tdp_mmu_zap_collapsible_sptes(s
 	struct kvm_mmu_page *root;
 	int root_as_id;
 
-	for_each_tdp_mmu_root(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
 
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
 		zap_collapsible_spte_range(kvm, root, slot->base_gfn,
 					   slot->base_gfn + slot->npages);
-
-		kvm_mmu_put_root(kvm, root);
 	}
 }
 


