Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2181BCB4C
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729787AbgD1Szu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729741AbgD1Sbu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:31:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 232CE20B80;
        Tue, 28 Apr 2020 18:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098709;
        bh=ZCSTh/6AgXCmaSmJzyiH3TXBjskx75nrZXromOV6LOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2cXBUKbXxBjTRoY239wSsX87dar9CIipVDVlReV5mtlF4mTiIy0wrCjQxDkItCfMw
         X5XPJdKtLI71w1KyWILWJ8hzIhD1CucdeTD6NWkwZIbLh4zZBMt2Op2oDuRR+D+MR0
         E4ICMl55q4UFHkKyt2LCa0ts5k1efHQJGpPWCwLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, KarimAllah Ahmed <karahmed@amazon.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/131] KVM: Introduce a new guest mapping API
Date:   Tue, 28 Apr 2020 20:24:16 +0200
Message-Id: <20200428182230.590133855@linuxfoundation.org>
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

From: KarimAllah Ahmed <karahmed@amazon.de>

commit e45adf665a53df0db37f784ed87c6b57ddd81885 upstream.

In KVM, specially for nested guests, there is a dominant pattern of:

	=> map guest memory -> do_something -> unmap guest memory

In addition to all this unnecessarily noise in the code due to boiler plate
code, most of the time the mapping function does not properly handle memory
that is not backed by "struct page". This new guest mapping API encapsulate
most of this boiler plate code and also handles guest memory that is not
backed by "struct page".

The current implementation of this API is using memremap for memory that is
not backed by a "struct page" which would lead to a huge slow-down if it
was used for high-frequency mapping operations. The API does not have any
effect on current setups where guest memory is backed by a "struct page".
Further patches are going to also introduce a pfn-cache which would
significantly improve the performance of the memremap case.

Signed-off-by: KarimAllah Ahmed <karahmed@amazon.de>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 4.19 as dependency of commit 1eff70a9abd4
 "x86/kvm: Introduce kvm_(un)map_gfn()"]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kvm_host.h | 28 ++++++++++++++++++
 virt/kvm/kvm_main.c      | 64 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0f99ecc01bc7d..bef95dba14e8b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -206,6 +206,32 @@ enum {
 	READING_SHADOW_PAGE_TABLES,
 };
 
+#define KVM_UNMAPPED_PAGE	((void *) 0x500 + POISON_POINTER_DELTA)
+
+struct kvm_host_map {
+	/*
+	 * Only valid if the 'pfn' is managed by the host kernel (i.e. There is
+	 * a 'struct page' for it. When using mem= kernel parameter some memory
+	 * can be used as guest memory but they are not managed by host
+	 * kernel).
+	 * If 'pfn' is not managed by the host kernel, this field is
+	 * initialized to KVM_UNMAPPED_PAGE.
+	 */
+	struct page *page;
+	void *hva;
+	kvm_pfn_t pfn;
+	kvm_pfn_t gfn;
+};
+
+/*
+ * Used to check if the mapping is valid or not. Never use 'kvm_host_map'
+ * directly to check for that.
+ */
+static inline bool kvm_vcpu_mapped(struct kvm_host_map *map)
+{
+	return !!map->hva;
+}
+
 /*
  * Sometimes a large or cross-page mmio needs to be broken up into separate
  * exits for userspace servicing.
@@ -711,7 +737,9 @@ struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
+int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map);
 struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn);
+void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
 int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data, int offset,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4e499b78569b7..ec1479abb29de 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1705,6 +1705,70 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
+static int __kvm_map_gfn(struct kvm_memory_slot *slot, gfn_t gfn,
+			 struct kvm_host_map *map)
+{
+	kvm_pfn_t pfn;
+	void *hva = NULL;
+	struct page *page = KVM_UNMAPPED_PAGE;
+
+	if (!map)
+		return -EINVAL;
+
+	pfn = gfn_to_pfn_memslot(slot, gfn);
+	if (is_error_noslot_pfn(pfn))
+		return -EINVAL;
+
+	if (pfn_valid(pfn)) {
+		page = pfn_to_page(pfn);
+		hva = kmap(page);
+	} else {
+		hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
+	}
+
+	if (!hva)
+		return -EFAULT;
+
+	map->page = page;
+	map->hva = hva;
+	map->pfn = pfn;
+	map->gfn = gfn;
+
+	return 0;
+}
+
+int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
+{
+	return __kvm_map_gfn(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn, map);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_map);
+
+void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
+		    bool dirty)
+{
+	if (!map)
+		return;
+
+	if (!map->hva)
+		return;
+
+	if (map->page)
+		kunmap(map->page);
+	else
+		memunmap(map->hva);
+
+	if (dirty) {
+		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
+		kvm_release_pfn_dirty(map->pfn);
+	} else {
+		kvm_release_pfn_clean(map->pfn);
+	}
+
+	map->hva = NULL;
+	map->page = NULL;
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
+
 struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	kvm_pfn_t pfn;
-- 
2.20.1



