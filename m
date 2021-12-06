Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A18469DD8
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376293AbhLFPd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:33:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34702 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377440AbhLFP2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:28:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66C12B81139;
        Mon,  6 Dec 2021 15:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC12C34901;
        Mon,  6 Dec 2021 15:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804322;
        bh=lZaopSE4MOHJhCbeois7StknvQvQN2F4ASvxIU0Wjzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bjdAQie4pJsbaGY2EU6WpjtNc/vcZSzAML+dlO85yThVNceBPXIpse4AhPHt/dQ22
         sqvNNiCpUgV1Q9IXPnnq9z5Y8u7ieW1LGK1ATgSeP21ul/GDpX5+gcjMCAyN+NaLBN
         gYpIKyhCbD9RKQkANX3DaSv+lZp9+1u1AEYWZP6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 073/207] KVM: Ensure local memslot copies operate on up-to-date arch-specific data
Date:   Mon,  6 Dec 2021 15:55:27 +0100
Message-Id: <20211206145612.761947819@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit bda44d844758c70c8dc1478e6fc9c25efa90c5a7 upstream.

When modifying memslots, snapshot the "old" memslot and copy it to the
"new" memslot's arch data after (re)acquiring slots_arch_lock.  x86 can
change a memslot's arch data while memslot updates are in-progress so
long as it holds slots_arch_lock, thus snapshotting a memslot without
holding the lock can result in the consumption of stale data.

Fixes: b10a038e84d1 ("KVM: mmu: Add slots_arch_lock for memslot arch fields")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211104002531.1176691-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1523,11 +1523,10 @@ static struct kvm_memslots *kvm_dup_mems
 
 static int kvm_set_memslot(struct kvm *kvm,
 			   const struct kvm_userspace_memory_region *mem,
-			   struct kvm_memory_slot *old,
 			   struct kvm_memory_slot *new, int as_id,
 			   enum kvm_mr_change change)
 {
-	struct kvm_memory_slot *slot;
+	struct kvm_memory_slot *slot, old;
 	struct kvm_memslots *slots;
 	int r;
 
@@ -1558,7 +1557,7 @@ static int kvm_set_memslot(struct kvm *k
 		 * Note, the INVALID flag needs to be in the appropriate entry
 		 * in the freshly allocated memslots, not in @old or @new.
 		 */
-		slot = id_to_memslot(slots, old->id);
+		slot = id_to_memslot(slots, new->id);
 		slot->flags |= KVM_MEMSLOT_INVALID;
 
 		/*
@@ -1589,6 +1588,26 @@ static int kvm_set_memslot(struct kvm *k
 		kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
 	}
 
+	/*
+	 * Make a full copy of the old memslot, the pointer will become stale
+	 * when the memslots are re-sorted by update_memslots(), and the old
+	 * memslot needs to be referenced after calling update_memslots(), e.g.
+	 * to free its resources and for arch specific behavior.  This needs to
+	 * happen *after* (re)acquiring slots_arch_lock.
+	 */
+	slot = id_to_memslot(slots, new->id);
+	if (slot) {
+		old = *slot;
+	} else {
+		WARN_ON_ONCE(change != KVM_MR_CREATE);
+		memset(&old, 0, sizeof(old));
+		old.id = new->id;
+		old.as_id = as_id;
+	}
+
+	/* Copy the arch-specific data, again after (re)acquiring slots_arch_lock. */
+	memcpy(&new->arch, &old.arch, sizeof(old.arch));
+
 	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
 	if (r)
 		goto out_slots;
@@ -1596,14 +1615,18 @@ static int kvm_set_memslot(struct kvm *k
 	update_memslots(slots, new, change);
 	slots = install_new_memslots(kvm, as_id, slots);
 
-	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
+	kvm_arch_commit_memory_region(kvm, mem, &old, new, change);
+
+	/* Free the old memslot's metadata.  Note, this is the full copy!!! */
+	if (change == KVM_MR_DELETE)
+		kvm_free_memslot(kvm, &old);
 
 	kvfree(slots);
 	return 0;
 
 out_slots:
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
-		slot = id_to_memslot(slots, old->id);
+		slot = id_to_memslot(slots, new->id);
 		slot->flags &= ~KVM_MEMSLOT_INVALID;
 		slots = install_new_memslots(kvm, as_id, slots);
 	} else {
@@ -1618,7 +1641,6 @@ static int kvm_delete_memslot(struct kvm
 			      struct kvm_memory_slot *old, int as_id)
 {
 	struct kvm_memory_slot new;
-	int r;
 
 	if (!old->npages)
 		return -EINVAL;
@@ -1631,12 +1653,7 @@ static int kvm_delete_memslot(struct kvm
 	 */
 	new.as_id = as_id;
 
-	r = kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
-	if (r)
-		return r;
-
-	kvm_free_memslot(kvm, old);
-	return 0;
+	return kvm_set_memslot(kvm, mem, &new, as_id, KVM_MR_DELETE);
 }
 
 /*
@@ -1711,7 +1728,6 @@ int __kvm_set_memory_region(struct kvm *
 	if (!old.npages) {
 		change = KVM_MR_CREATE;
 		new.dirty_bitmap = NULL;
-		memset(&new.arch, 0, sizeof(new.arch));
 	} else { /* Modify an existing slot. */
 		if ((new.userspace_addr != old.userspace_addr) ||
 		    (new.npages != old.npages) ||
@@ -1725,9 +1741,8 @@ int __kvm_set_memory_region(struct kvm *
 		else /* Nothing to change. */
 			return 0;
 
-		/* Copy dirty_bitmap and arch from the current memslot. */
+		/* Copy dirty_bitmap from the current memslot. */
 		new.dirty_bitmap = old.dirty_bitmap;
-		memcpy(&new.arch, &old.arch, sizeof(new.arch));
 	}
 
 	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
@@ -1753,7 +1768,7 @@ int __kvm_set_memory_region(struct kvm *
 			bitmap_set(new.dirty_bitmap, 0, new.npages);
 	}
 
-	r = kvm_set_memslot(kvm, mem, &old, &new, as_id, change);
+	r = kvm_set_memslot(kvm, mem, &new, as_id, change);
 	if (r)
 		goto out_bitmap;
 


