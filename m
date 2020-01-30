Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C40CD14E074
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgA3SCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:02:25 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39666 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbgA3SCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 13:02:06 -0500
Received: by mail-wm1-f66.google.com with SMTP id c84so5391166wme.4;
        Thu, 30 Jan 2020 10:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yIbW9YDM3fXXDaRKof5ecTwvnqF9EfXeFFSFKVaRZmM=;
        b=Jise2j/F2B79iqoVgyrZd17XB5gCPfRcSwfbpCZeY2FyyWmjOgDiMuPpCLrnBeOhCH
         hNZ88A4oaZBaTnTyz3tccWm3tzNXXHlexWQiLwsSqjCdAA3JCU4HcODX9VoqQNbM0PKe
         tAGgmb+zZL0g6/dqTKY0BOD0GaeRn8ASJ+UT9LeLrnzVZ8WrlkfyvaTOp9t3oSJgt04/
         ap0MlxAVfYcgzaIY1kdw+/W4f5Fv+VDU8GxHPbsPKCN7n1n7YAyZIlY416Hbue22KoFb
         lKCHA3ceIfpT3OlB+t8znvIl4IPXyCsiRY7bX/ofVXU4GrE0Ia4nW6kr+Ikq/YlEHLFZ
         HJnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=yIbW9YDM3fXXDaRKof5ecTwvnqF9EfXeFFSFKVaRZmM=;
        b=KmVNkxg3rdr5nb/0PLFKCXPTpj1LGzvvNawp+axzmvMCGO4SwwzoHXjMlz8FMGqVvQ
         /cv6GhBzviVicBTQ+UtxG+tbyGepggz9zA6b37Y1p6IZx4TNJSoNMamgAcHDPVVFKZxO
         u6c7ddFCbBB2gHya/vt5kCLA29WXIKvi1IaRdJD+stxgNfu2k3iyZcgVo6Dk4YQI0YNA
         jE074Pn+qbunmgkDU24QPmLeAABZGP8JYXV7p8WWb5R+s7m4vHblEVs1BLeH0N/C+Nh0
         itbcrJyom+797xnx6wjLZ/ZCQnj7WcQq4FrFX+hXnWIIK/HgypM9kM1gXMUJX0+wvXsP
         C5tg==
X-Gm-Message-State: APjAAAVyxON93qZ/GNT0fbJho5qxL6dLJ/zGfEMRuppuPIRGcS2+hMg+
        q9leDNX0lPwx/No816lXmJN/PqhEGXk=
X-Google-Smtp-Source: APXvYqxdk6OQOhA4fao7YM49X+fr6spLzmdf+a+Z0++bn+Xc/w9eVrVrEZJ2ZvWMdFsGHvEFUtvkWA==
X-Received: by 2002:a1c:4c8:: with SMTP id 191mr6713562wme.148.1580407323288;
        Thu, 30 Jan 2020 10:02:03 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w19sm6956878wmc.22.2020.01.30.10.02.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2020 10:02:02 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        stable@vger.kernel.org
Subject: [FYI PATCH 3/5] x86/kvm: Cache gfn to pfn translation
Date:   Thu, 30 Jan 2020 19:01:54 +0100
Message-Id: <1580407316-11391-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580407316-11391-1-git-send-email-pbonzini@redhat.com>
References: <1580407316-11391-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

__kvm_map_gfn()'s call to gfn_to_pfn_memslot() is
* relatively expensive
* in certain cases (such as when done from atomic context) cannot be called

Stashing gfn-to-pfn mapping should help with both cases.

This is part of CVE-2019-3016.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 10 +++++
 include/linux/kvm_host.h        |  7 ++-
 include/linux/kvm_types.h       |  9 +++-
 virt/kvm/kvm_main.c             | 98 +++++++++++++++++++++++++++++++++--------
 5 files changed, 103 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b79cd6a..f48a306e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -689,6 +689,7 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		struct gfn_to_hva_cache stime;
 		struct kvm_steal_time steal;
+		struct gfn_to_pfn_cache cache;
 	} st;
 
 	u64 tsc_offset;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8c93691..0795bc8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9088,6 +9088,9 @@ static void fx_init(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	void *wbinvd_dirty_mask = vcpu->arch.wbinvd_dirty_mask;
+	struct gfn_to_pfn_cache *cache = &vcpu->arch.st.cache;
+
+	kvm_release_pfn(cache->pfn, cache->dirty, cache);
 
 	kvmclock_reset(vcpu);
 
@@ -9761,11 +9764,18 @@ int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 
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
index 0cb78f5..71cb9cc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -723,6 +723,7 @@ kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 void kvm_set_pfn_accessed(kvm_pfn_t pfn);
 void kvm_get_pfn(kvm_pfn_t pfn);
 
+void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
 int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
@@ -775,10 +776,12 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
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
index 1c88e69..68e84cf 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -18,7 +18,7 @@
 
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
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9ef58a2..67eb302 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1821,27 +1821,72 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
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
 
@@ -1856,20 +1901,25 @@ static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
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
@@ -1877,34 +1927,44 @@ static void __kvm_unmap_gfn(struct kvm_memory_slot *memslot,
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
1.8.3.1

