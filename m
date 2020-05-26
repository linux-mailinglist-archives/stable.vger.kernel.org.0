Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F85B1BC8D1
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730329AbgD1SgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730326AbgD1SgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:36:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E147320575;
        Tue, 28 Apr 2020 18:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098959;
        bh=/tGjsABS3VKwLPcvS162bURwLAO6A1ezE3LODtZwHsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIP9RCD+2FvOe2iJIWVx4mPwYNVoszSGlZ9POfjVGH2/hPEWYKwMbnLjP2zU6+8/s
         91gmdjAmrnD2KO9Fi1bNQzHWedgMdY1wj8Q8q6TwLTMLL9yRz9LNLNjBFgJKPFS+ah
         TiGx7ovdUiVkAjQ0C4LXHhOMqAhYmtWCIxELyZNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 050/131] x86/kvm: Cache gfn to pfn translation
Date:   Tue, 28 Apr 2020 20:24:22 +0200
Message-Id: <20200428182231.282097727@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
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
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 10 ++++
 include/linux/kvm_host.h        |  7 ++-
 include/linux/kvm_types.h       |  9 ++-
 virt/kvm/kvm_main.c             | 98 ++++++++++++++++++++++++++-------
 5 files changed, 103 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5c99b9bfce045..ca9c7110b99dd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -626,6 +626,7 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		struct gfn_to_hva_cache stime;
 		struct kvm_steal_time steal;
+		struct gfn_to_pfn_cache cache;
 	} st;
 
 	u64 tsc_offset;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1a6e1aa2fb297..6916f46909ab0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8634,6 +8634,9 @@ static void fx_init(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	void *wbinvd_dirty_mask = vcpu->arch.wbinvd_dirty_mask;
+	struct gfn_to_pfn_cache *cache = &vcpu->arch.st.cache;
+
+	kvm_release_pfn(cache->pfn, cache->dirty, cache);
 
 	kvmclock_reset(vcpu);
 
@@ -9298,11 +9301,18 @@ int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 
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
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 303c1a6916cea..dabb60f907269 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -708,6 +708,7 @@ void kvm_set_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_accessed(kvm_pfn_t pfn);
 void kvm_get_pfn(kvm_pfn_t pfn);
 
+void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
 int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
@@ -738,10 +739,12 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
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
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 8bf259dae9f6c..a38729c8296f4 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -32,7 +32,7 @@ struct kvm_memslots;
 
 enum kvm_mr_change;
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 /*
  * Address types:
@@ -63,4 +63,11 @@ struct gfn_to_hva_cache {
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
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8e29b2e0bf2eb..aca15bd1cc4cd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1705,27 +1705,72 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
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
 
@@ -1740,20 +1785,25 @@ static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
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
@@ -1761,34 +1811,44 @@ static void __kvm_unmap_gfn(struct kvm_memory_slot *memslot,
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
 
-- 
2.20.1



