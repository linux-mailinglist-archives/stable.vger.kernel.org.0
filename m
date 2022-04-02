Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4614F01C3
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 14:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239980AbiDBM61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 08:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235201AbiDBM60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 08:58:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760B153716
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 05:56:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 133066144B
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 12:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF61C340EC;
        Sat,  2 Apr 2022 12:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648904193;
        bh=dzQpbawxWRK8Sv9AikeWAMzXvazuCmEeIdTJ/9jO0XM=;
        h=Subject:To:Cc:From:Date:From;
        b=lYGPeM23+OsJqGUE7aLzW9uoMMAYumP12ig7Y1e4ljQ4vHhQzGy01TxwM38uq/viv
         hw4+sW6xCwoxuhbJQVL8eJtJQy+lnhopAaaR+ZAbActAlDqjUaCPw4FuN1lhSwAKwv
         WKJCJdb2UwlTzmuJKWKL1+HRXqE25idzCJiw0klo=
Subject: FAILED: patch "[PATCH] KVM: use __vcalloc for very large allocations" failed to apply to 5.15-stable tree
To:     pbonzini@redhat.com, david@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 14:56:30 +0200
Message-ID: <164890419089185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 37b2a6510a48ca361ced679f92682b7b7d7d0330 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 8 Mar 2022 04:49:37 -0500
Subject: [PATCH] KVM: use __vcalloc for very large allocations

Allocations whose size is related to the memslot size can be arbitrarily
large.  Do not use kvzalloc/kvcalloc, as those are limited to "not crazy"
sizes that fit in 32 bits.

Cc: stable@vger.kernel.org
Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index e414ca44839f..be441403925b 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -251,7 +251,7 @@ int kvmppc_uvmem_slot_init(struct kvm *kvm, const struct kvm_memory_slot *slot)
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
-	p->pfns = vzalloc(array_size(slot->npages, sizeof(*p->pfns)));
+	p->pfns = vcalloc(slot->npages, sizeof(*p->pfns));
 	if (!p->pfns) {
 		kfree(p);
 		return -ENOMEM;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 68eb1fb548b6..2e09d1b6249f 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -47,8 +47,8 @@ int kvm_page_track_create_memslot(struct kvm *kvm,
 			continue;
 
 		slot->arch.gfn_track[i] =
-			kvcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
-				 GFP_KERNEL_ACCOUNT);
+			__vcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
+				  GFP_KERNEL_ACCOUNT);
 		if (!slot->arch.gfn_track[i])
 			goto track_free;
 	}
@@ -75,7 +75,8 @@ int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot)
 	if (slot->arch.gfn_track[KVM_PAGE_TRACK_WRITE])
 		return 0;
 
-	gfn_track = kvcalloc(slot->npages, sizeof(*gfn_track), GFP_KERNEL_ACCOUNT);
+	gfn_track = __vcalloc(slot->npages, sizeof(*gfn_track),
+			      GFP_KERNEL_ACCOUNT);
 	if (gfn_track == NULL)
 		return -ENOMEM;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f79bf4552082..4fa4d8269e5b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11838,7 +11838,7 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages)
 		if (slot->arch.rmap[i])
 			continue;
 
-		slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
+		slot->arch.rmap[i] = __vcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
 		if (!slot->arch.rmap[i]) {
 			memslot_rmap_free(slot);
 			return -ENOMEM;
@@ -11875,7 +11875,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 
 		lpages = __kvm_mmu_slot_lpages(slot, npages, level);
 
-		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
+		linfo = __vcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
 		if (!linfo)
 			goto out_free;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c941b97fa133..69c318fdff61 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1274,9 +1274,9 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
  */
 static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
 {
-	unsigned long dirty_bytes = 2 * kvm_dirty_bitmap_bytes(memslot);
+	unsigned long dirty_bytes = kvm_dirty_bitmap_bytes(memslot);
 
-	memslot->dirty_bitmap = kvzalloc(dirty_bytes, GFP_KERNEL_ACCOUNT);
+	memslot->dirty_bitmap = __vcalloc(2, dirty_bytes, GFP_KERNEL_ACCOUNT);
 	if (!memslot->dirty_bitmap)
 		return -ENOMEM;
 

