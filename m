Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3344F3058
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353751AbiDEKJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345348AbiDEJW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:22:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911DE47063;
        Tue,  5 Apr 2022 02:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F92761527;
        Tue,  5 Apr 2022 09:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C4BC385A0;
        Tue,  5 Apr 2022 09:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149840;
        bh=x3IlawOepDT46tssbhfPkDBLLjvobJXk+L4ZOx5NkTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4C525z86TFkd3q0GPYKPNRozLmOX6TZWVOGI5tC3Al6pE5wsQsLMblPIA2GG5o7b
         2GdK4Crtw3KPEL1t7WzifFnHlTDwtXzWNn6FnUl/oNmRCMI0E05y37EYMtIfNsupYu
         jqsbpR/im2+Jav4HGxfcP5QjY6/tW6qSARRcT2E8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 0860/1017] KVM: x86/mmu: Zap _all_ roots when unmapping gfn range in TDP MMU
Date:   Tue,  5 Apr 2022 09:29:33 +0200
Message-Id: <20220405070419.762058246@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit d62007edf01f5c11f75d0f4b1e538fc52a5b1982 upstream.

Zap both valid and invalid roots when zapping/unmapping a gfn range, as
KVM must ensure it holds no references to the freed page after returning
from the unmap operation.  Most notably, the TDP MMU doesn't zap invalid
roots in mmu_notifier callbacks.  This leads to use-after-free and other
issues if the mmu_notifier runs to completion while an invalid root
zapper yields as KVM fails to honor the requirement that there must be
_no_ references to the page after the mmu_notifier returns.

The bug is most easily reproduced by hacking KVM to cause a collision
between set_nx_huge_pages() and kvm_mmu_notifier_release(), but the bug
exists between kvm_mmu_notifier_invalidate_range_start() and memslot
updates as well.  Invalidating a root ensures pages aren't accessible by
the guest, and KVM won't read or write page data itself, but KVM will
trigger e.g. kvm_set_pfn_dirty() when zapping SPTEs, and thus completing
a zap of an invalid root _after_ the mmu_notifier returns is fatal.

  WARNING: CPU: 24 PID: 1496 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:173 [kvm]
  RIP: 0010:kvm_is_zone_device_pfn+0x96/0xa0 [kvm]
  Call Trace:
   <TASK>
   kvm_set_pfn_dirty+0xa8/0xe0 [kvm]
   __handle_changed_spte+0x2ab/0x5e0 [kvm]
   __handle_changed_spte+0x2ab/0x5e0 [kvm]
   __handle_changed_spte+0x2ab/0x5e0 [kvm]
   zap_gfn_range+0x1f3/0x310 [kvm]
   kvm_tdp_mmu_zap_invalidated_roots+0x50/0x90 [kvm]
   kvm_mmu_zap_all_fast+0x177/0x1a0 [kvm]
   set_nx_huge_pages+0xb4/0x190 [kvm]
   param_attr_store+0x70/0x100
   module_attr_store+0x19/0x30
   kernfs_fop_write_iter+0x119/0x1b0
   new_sync_write+0x11c/0x1b0
   vfs_write+0x1cc/0x270
   ksys_write+0x5f/0xe0
   do_syscall_64+0x38/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>

Fixes: b7cccd397f31 ("KVM: x86/mmu: Fast invalidation for TDP MMU")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211215011557.399940-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -99,15 +99,18 @@ void kvm_tdp_mmu_put_root(struct kvm *kv
 }
 
 /*
- * Finds the next valid root after root (or the first valid root if root
- * is NULL), takes a reference on it, and returns that next root. If root
- * is not NULL, this thread should have already taken a reference on it, and
- * that reference will be dropped. If no valid root is found, this
- * function will return NULL.
+ * Returns the next root after @prev_root (or the first root if @prev_root is
+ * NULL).  A reference to the returned root is acquired, and the reference to
+ * @prev_root is released (the caller obviously must hold a reference to
+ * @prev_root if it's non-NULL).
+ *
+ * If @only_valid is true, invalid roots are skipped.
+ *
+ * Returns NULL if the end of tdp_mmu_roots was reached.
  */
 static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 					      struct kvm_mmu_page *prev_root,
-					      bool shared)
+					      bool shared, bool only_valid)
 {
 	struct kvm_mmu_page *next_root;
 
@@ -122,7 +125,7 @@ static struct kvm_mmu_page *tdp_mmu_next
 						   typeof(*next_root), link);
 
 	while (next_root) {
-		if (!next_root->role.invalid &&
+		if ((!only_valid || !next_root->role.invalid) &&
 		    kvm_tdp_mmu_get_root(kvm, next_root))
 			break;
 
@@ -148,13 +151,19 @@ static struct kvm_mmu_page *tdp_mmu_next
  * mode. In the unlikely event that this thread must free a root, the lock
  * will be temporarily dropped and reacquired in write mode.
  */
-#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
-	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared);		\
-	     _root;							\
-	     _root = tdp_mmu_next_root(_kvm, _root, _shared))		\
-		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
+#define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, _only_valid)\
+	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, _only_valid);	\
+	     _root;								\
+	     _root = tdp_mmu_next_root(_kvm, _root, _shared, _only_valid))	\
+		if (kvm_mmu_page_as_id(_root) != _as_id) {			\
 		} else
 
+#define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
+	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, true)
+
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)		\
+	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, false)
+
 #define for_each_tdp_mmu_root(_kvm, _root, _as_id)				\
 	list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link,		\
 				lockdep_is_held_type(&kvm->mmu_lock, 0) ||	\
@@ -1224,7 +1233,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
+	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
 		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
 			     slot->base_gfn + slot->npages, min_level);
 
@@ -1294,7 +1303,7 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
+	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
 		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
 
@@ -1419,7 +1428,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(s
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
+	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
 		zap_collapsible_spte_range(kvm, root, slot);
 }
 


