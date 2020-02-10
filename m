Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81DFF157585
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbgBJMlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729748AbgBJMlb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:31 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8203D2051A;
        Mon, 10 Feb 2020 12:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338490;
        bh=D6uoj4PRnQCG1GEmvqvvvARPcugQlVcd6IEyO5hiYT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v23l6t4V1ChDZ3AftcXKn+7YCJxqHRXcagxfhG35RPBcpeTFDZGwsB0gjIKt6vk6n
         pSu2c176sy1dhfeRTMgg407LfKs5aV0L5PQJNfK2q/RBFfzBeyBxDsMsbLSOTHxH51
         8eaSYC+vjyJuDZ5g7EBZqR0ZEkl2U50SMFBWwGpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 248/367] x86/kvm: Cache gfn to pfn translation
Date:   Mon, 10 Feb 2020 04:32:41 -0800
Message-Id: <20200210122447.090562879@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

commit 917248144db5d7320655dbb41d3af0b8a0f3d589 upstream.

__kvm_map_gfn()'s call to gfn_to_pfn_memslot() is
* relatively expensive
* in certain cases (such as when done from atomic context) cannot be called

Stashing gfn-to-pfn mapping should help with both cases.

This is part of CVE-2019-3016.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    1 
 arch/x86/kvm/x86.c              |   10 ++++
 include/linux/kvm_host.h        |    7 ++
 include/linux/kvm_types.h       |    9 +++
 virt/kvm/kvm_main.c             |   98 ++++++++++++++++++++++++++++++++--------
 5 files changed, 103 insertions(+), 22 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -689,6 +689,7 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		struct gfn_to_hva_cache stime;
 		struct kvm_steal_time steal;
+		struct gfn_to_pfn_cache cache;
 	} st;
 
 	u64 tsc_offset;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9111,6 +9111,9 @@ static void fx_init(struct kvm_vcpu *vcp
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	void *wbinvd_dirty_mask = vcpu->arch.wbinvd_dirty_mask;
+	struct gfn_to_pfn_cache *cache = &vcpu->arch.st.cache;
+
+	kvm_release_pfn(cache->pfn, cache->dirty, cache);
 
 	kvmclock_reset(vcpu);
 
@@ -9784,11 +9787,18 @@ out_free:
 
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 {
+	struct kvm_vcpu *vcpu;
+	int i;
+
 	/*
 	 * memslots->generation has been incremented.
 	 * mmio generation may have reached its maximum value.
 	 */
 	kvm_mmu_invalidate_mmio_sptes(kvm, gen);
+
+	/* Force re-initialization of steal_time cache */
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_vcpu_kick(vcpu);
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -723,6 +723,7 @@ void kvm_set_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_accessed(kvm_pfn_t pfn);
 void kvm_get_pfn(kvm_pfn_t pfn);
 
+void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
 int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
@@ -775,10 +776,12 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map);
-int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map);
+int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
+		struct gfn_to_pfn_cache *cache, bool atomic);
 struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn);
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
-int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
+int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
+		  struct gfn_to_pfn_cache *cache, bool dirty, bool atomic);
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
 int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data, int offset,
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -18,7 +18,7 @@ struct kvm_memslots;
 
 enum kvm_mr_change;
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 /*
  * Address types:
@@ -51,4 +51,11 @@ struct gfn_to_hva_cache {
 	struct kvm_memory_slot *memslot;
 };
 
+struct gfn_to_pfn_cache {
+	u64 generation;
+	gfn_t gfn;
+	kvm_pfn_t pfn;
+	bool dirty;
+};
+
 #endif /* __KVM_TYPES_H__ */
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1821,27 +1821,72 @@ struct page *gfn_to_page(struct kvm *kvm
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
+void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache)
+{
+	if (pfn == 0)
+		return;
+
+	if (cache)
+		cache->pfn = cache->gfn = 0;
+
+	if (dirty)
+		kvm_release_pfn_dirty(pfn);
+	else
+		kvm_release_pfn_clean(pfn);
+}
+
+static void kvm_cache_gfn_to_pfn(struct kvm_memory_slot *slot, gfn_t gfn,
+				 struct gfn_to_pfn_cache *cache, u64 gen)
+{
+	kvm_release_pfn(cache->pfn, cache->dirty, cache);
+
+	cache->pfn = gfn_to_pfn_memslot(slot, gfn);
+	cache->gfn = gfn;
+	cache->dirty = false;
+	cache->generation = gen;
+}
+
 static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
-			 struct kvm_host_map *map)
+			 struct kvm_host_map *map,
+			 struct gfn_to_pfn_cache *cache,
+			 bool atomic)
 {
 	kvm_pfn_t pfn;
 	void *hva = NULL;
 	struct page *page = KVM_UNMAPPED_PAGE;
 	struct kvm_memory_slot *slot = __gfn_to_memslot(slots, gfn);
+	u64 gen = slots->generation;
 
 	if (!map)
 		return -EINVAL;
 
-	pfn = gfn_to_pfn_memslot(slot, gfn);
+	if (cache) {
+		if (!cache->pfn || cache->gfn != gfn ||
+			cache->generation != gen) {
+			if (atomic)
+				return -EAGAIN;
+			kvm_cache_gfn_to_pfn(slot, gfn, cache, gen);
+		}
+		pfn = cache->pfn;
+	} else {
+		if (atomic)
+			return -EAGAIN;
+		pfn = gfn_to_pfn_memslot(slot, gfn);
+	}
 	if (is_error_noslot_pfn(pfn))
 		return -EINVAL;
 
 	if (pfn_valid(pfn)) {
 		page = pfn_to_page(pfn);
-		hva = kmap(page);
+		if (atomic)
+			hva = kmap_atomic(page);
+		else
+			hva = kmap(page);
 #ifdef CONFIG_HAS_IOMEM
-	} else {
+	} else if (!atomic) {
 		hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
+	} else {
+		return -EINVAL;
 #endif
 	}
 
@@ -1856,20 +1901,25 @@ static int __kvm_map_gfn(struct kvm_mems
 	return 0;
 }
 
-int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
+int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
+		struct gfn_to_pfn_cache *cache, bool atomic)
 {
-	return __kvm_map_gfn(kvm_memslots(vcpu->kvm), gfn, map);
+	return __kvm_map_gfn(kvm_memslots(vcpu->kvm), gfn, map,
+			cache, atomic);
 }
 EXPORT_SYMBOL_GPL(kvm_map_gfn);
 
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 {
-	return __kvm_map_gfn(kvm_vcpu_memslots(vcpu), gfn, map);
+	return __kvm_map_gfn(kvm_vcpu_memslots(vcpu), gfn, map,
+		NULL, false);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_map);
 
 static void __kvm_unmap_gfn(struct kvm_memory_slot *memslot,
-			struct kvm_host_map *map, bool dirty)
+			struct kvm_host_map *map,
+			struct gfn_to_pfn_cache *cache,
+			bool dirty, bool atomic)
 {
 	if (!map)
 		return;
@@ -1877,34 +1927,44 @@ static void __kvm_unmap_gfn(struct kvm_m
 	if (!map->hva)
 		return;
 
-	if (map->page != KVM_UNMAPPED_PAGE)
-		kunmap(map->page);
+	if (map->page != KVM_UNMAPPED_PAGE) {
+		if (atomic)
+			kunmap_atomic(map->hva);
+		else
+			kunmap(map->page);
+	}
 #ifdef CONFIG_HAS_IOMEM
-	else
+	else if (!atomic)
 		memunmap(map->hva);
+	else
+		WARN_ONCE(1, "Unexpected unmapping in atomic context");
 #endif
 
-	if (dirty) {
+	if (dirty)
 		mark_page_dirty_in_slot(memslot, map->gfn);
-		kvm_release_pfn_dirty(map->pfn);
-	} else {
-		kvm_release_pfn_clean(map->pfn);
-	}
+
+	if (cache)
+		cache->dirty |= dirty;
+	else
+		kvm_release_pfn(map->pfn, dirty, NULL);
 
 	map->hva = NULL;
 	map->page = NULL;
 }
 
-int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
+int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
+		  struct gfn_to_pfn_cache *cache, bool dirty, bool atomic)
 {
-	__kvm_unmap_gfn(gfn_to_memslot(vcpu->kvm, map->gfn), map, dirty);
+	__kvm_unmap_gfn(gfn_to_memslot(vcpu->kvm, map->gfn), map,
+			cache, dirty, atomic);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_unmap_gfn);
 
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
 {
-	__kvm_unmap_gfn(kvm_vcpu_gfn_to_memslot(vcpu, map->gfn), map, dirty);
+	__kvm_unmap_gfn(kvm_vcpu_gfn_to_memslot(vcpu, map->gfn), map, NULL,
+			dirty, false);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 


