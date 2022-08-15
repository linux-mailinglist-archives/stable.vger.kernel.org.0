Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE66593870
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245274AbiHOTSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344436AbiHOTQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:16:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7373B948;
        Mon, 15 Aug 2022 11:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 495876113C;
        Mon, 15 Aug 2022 18:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CA2C433D6;
        Mon, 15 Aug 2022 18:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588691;
        bh=Ga/6TRQVXydterssJTD+D053cn3SGBoDDM0IrgKoMtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFNnCEYGSsG0mlMu330pIrDa5w7TLer4Tg6DUvJnAb4Ki/lo5UwaY3BWb1tOx+W6g
         x7xeqiQv/ET2IiFgM5DrS30grsxcWm9ZqvD6jEgJJayg7I52AhZf/+7Bm1NQGuA9cL
         prkwztBQHbb1cq7k5Ty5HIp9Ub3a3QtRoLSRNPUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 484/779] KVM: s390: pv: leak the topmost page table when destroy fails
Date:   Mon, 15 Aug 2022 20:02:08 +0200
Message-Id: <20220815180357.953709589@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit faa2f72cb3569256480c5540d242c84e99965160 ]

Each secure guest must have a unique ASCE (address space control
element); we must avoid that new guests use the same page for their
ASCE, to avoid errors.

Since the ASCE mostly consists of the address of the topmost page table
(plus some flags), we must not return that memory to the pool unless
the ASCE is no longer in use.

Only a successful Destroy Secure Configuration UVC will make the ASCE
reusable again.

If the Destroy Configuration UVC fails, the ASCE cannot be reused for a
secure guest (either for the ASCE or for other memory areas). To avoid
a collision, it must not be used again. This is a permanent error and
the page becomes in practice unusable, so we set it aside and leak it.
On failure we already leak other memory that belongs to the ultravisor
(i.e. the variable and base storage for a guest) and not leaking the
topmost page table was an oversight.

This error (and thus the leakage) should not happen unless the hardware
is broken or KVM has some unknown serious bug.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 29b40f105ec8d55 ("KVM: s390: protvirt: Add initial vm and cpu lifecycle handling")
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20220628135619.32410-2-imbrenda@linux.ibm.com
Message-Id: <20220628135619.32410-2-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/gmap.h |  2 +
 arch/s390/kvm/pv.c           |  9 ++--
 arch/s390/mm/gmap.c          | 86 ++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 40264f60b0da..f4073106e1f3 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -148,4 +148,6 @@ void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
 			     unsigned long gaddr, unsigned long vmaddr);
 int gmap_mark_unmergeable(void);
 void s390_reset_acc(struct mm_struct *mm);
+void s390_unlist_old_asce(struct gmap *gmap);
+int s390_replace_asce(struct gmap *gmap);
 #endif /* _ASM_S390_GMAP_H */
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 00d272d134c2..b906658ffc2e 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -168,10 +168,13 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	atomic_set(&kvm->mm->context.is_protected, 0);
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
 	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
-	/* Inteded memory leak on "impossible" error */
-	if (!cc)
+	/* Intended memory leak on "impossible" error */
+	if (!cc) {
 		kvm_s390_pv_dealloc_vm(kvm);
-	return cc ? -EIO : 0;
+		return 0;
+	}
+	s390_replace_asce(kvm->arch.gmap);
+	return -EIO;
 }
 
 int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 4ce3a2f01c91..ff40bf92db43 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2726,3 +2726,89 @@ void s390_reset_acc(struct mm_struct *mm)
 	mmput(mm);
 }
 EXPORT_SYMBOL_GPL(s390_reset_acc);
+
+/**
+ * s390_unlist_old_asce - Remove the topmost level of page tables from the
+ * list of page tables of the gmap.
+ * @gmap: the gmap whose table is to be removed
+ *
+ * On s390x, KVM keeps a list of all pages containing the page tables of the
+ * gmap (the CRST list). This list is used at tear down time to free all
+ * pages that are now not needed anymore.
+ *
+ * This function removes the topmost page of the tree (the one pointed to by
+ * the ASCE) from the CRST list.
+ *
+ * This means that it will not be freed when the VM is torn down, and needs
+ * to be handled separately by the caller, unless a leak is actually
+ * intended. Notice that this function will only remove the page from the
+ * list, the page will still be used as a top level page table (and ASCE).
+ */
+void s390_unlist_old_asce(struct gmap *gmap)
+{
+	struct page *old;
+
+	old = virt_to_page(gmap->table);
+	spin_lock(&gmap->guest_table_lock);
+	list_del(&old->lru);
+	/*
+	 * Sometimes the topmost page might need to be "removed" multiple
+	 * times, for example if the VM is rebooted into secure mode several
+	 * times concurrently, or if s390_replace_asce fails after calling
+	 * s390_remove_old_asce and is attempted again later. In that case
+	 * the old asce has been removed from the list, and therefore it
+	 * will not be freed when the VM terminates, but the ASCE is still
+	 * in use and still pointed to.
+	 * A subsequent call to replace_asce will follow the pointer and try
+	 * to remove the same page from the list again.
+	 * Therefore it's necessary that the page of the ASCE has valid
+	 * pointers, so list_del can work (and do nothing) without
+	 * dereferencing stale or invalid pointers.
+	 */
+	INIT_LIST_HEAD(&old->lru);
+	spin_unlock(&gmap->guest_table_lock);
+}
+EXPORT_SYMBOL_GPL(s390_unlist_old_asce);
+
+/**
+ * s390_replace_asce - Try to replace the current ASCE of a gmap with a copy
+ * @gmap: the gmap whose ASCE needs to be replaced
+ *
+ * If the allocation of the new top level page table fails, the ASCE is not
+ * replaced.
+ * In any case, the old ASCE is always removed from the gmap CRST list.
+ * Therefore the caller has to make sure to save a pointer to it
+ * beforehand, unless a leak is actually intended.
+ */
+int s390_replace_asce(struct gmap *gmap)
+{
+	unsigned long asce;
+	struct page *page;
+	void *table;
+
+	s390_unlist_old_asce(gmap);
+
+	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
+	if (!page)
+		return -ENOMEM;
+	table = page_to_virt(page);
+	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
+
+	/*
+	 * The caller has to deal with the old ASCE, but here we make sure
+	 * the new one is properly added to the CRST list, so that
+	 * it will be freed when the VM is torn down.
+	 */
+	spin_lock(&gmap->guest_table_lock);
+	list_add(&page->lru, &gmap->crst_list);
+	spin_unlock(&gmap->guest_table_lock);
+
+	/* Set new table origin while preserving existing ASCE control bits */
+	asce = (gmap->asce & ~_ASCE_ORIGIN) | __pa(table);
+	WRITE_ONCE(gmap->asce, asce);
+	WRITE_ONCE(gmap->mm->context.gmap_asce, asce);
+	WRITE_ONCE(gmap->table, table);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(s390_replace_asce);
-- 
2.35.1



