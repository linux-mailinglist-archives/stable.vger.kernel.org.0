Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E761BC86D
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgD1Scd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:32:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729807AbgD1Sc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:32:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15E9020B80;
        Tue, 28 Apr 2020 18:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098748;
        bh=nmu8Hw54SRfd3QF6XgfWN9PLfa+RVpM9YtS3Uj4lcog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYqtOY7RoJO9LH4yhKq+LqqgmwJoz3/vIwdrkTqRMY60bb5CanLk0N79ojyk4ZCZ/
         zZ/tdyITqoNSBWt5ofsi/r91VrEZe9UZzjQk+dZiIPrvGr0U2Osp9NDRszDoQm6m9j
         TGgO0iGSn4xdKnnd+oPfUJWLlMzbmv1Dqq+PuJB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/131] x86/kvm: Introduce kvm_(un)map_gfn()
Date:   Tue, 28 Apr 2020 20:24:21 +0200
Message-Id: <20200428182231.170541022@linuxfoundation.org>
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

commit 1eff70a9abd46f175defafd29bc17ad456f398a7 upstream.

kvm_vcpu_(un)map operates on gfns from any current address space.
In certain cases we want to make sure we are not mapping SMRAM
and for that we can use kvm_(un)map_gfn() that we are introducing
in this patch.

This is part of CVE-2019-3016.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 29 ++++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bef95dba14e8b..303c1a6916cea 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -738,8 +738,10 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map);
+int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map);
 struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn);
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
+int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
 int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data, int offset,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 33b288469c70c..8e29b2e0bf2eb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1705,12 +1705,13 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
-static int __kvm_map_gfn(struct kvm_memory_slot *slot, gfn_t gfn,
+static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
 			 struct kvm_host_map *map)
 {
 	kvm_pfn_t pfn;
 	void *hva = NULL;
 	struct page *page = KVM_UNMAPPED_PAGE;
+	struct kvm_memory_slot *slot = __gfn_to_memslot(slots, gfn);
 
 	if (!map)
 		return -EINVAL;
@@ -1739,14 +1740,20 @@ static int __kvm_map_gfn(struct kvm_memory_slot *slot, gfn_t gfn,
 	return 0;
 }
 
+int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
+{
+	return __kvm_map_gfn(kvm_memslots(vcpu->kvm), gfn, map);
+}
+EXPORT_SYMBOL_GPL(kvm_map_gfn);
+
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 {
-	return __kvm_map_gfn(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn, map);
+	return __kvm_map_gfn(kvm_vcpu_memslots(vcpu), gfn, map);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_map);
 
-void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
-		    bool dirty)
+static void __kvm_unmap_gfn(struct kvm_memory_slot *memslot,
+			struct kvm_host_map *map, bool dirty)
 {
 	if (!map)
 		return;
@@ -1762,7 +1769,7 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
 #endif
 
 	if (dirty) {
-		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
+		mark_page_dirty_in_slot(memslot, map->gfn);
 		kvm_release_pfn_dirty(map->pfn);
 	} else {
 		kvm_release_pfn_clean(map->pfn);
@@ -1771,6 +1778,18 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
 	map->hva = NULL;
 	map->page = NULL;
 }
+
+int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
+{
+	__kvm_unmap_gfn(gfn_to_memslot(vcpu->kvm, map->gfn), map, dirty);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_unmap_gfn);
+
+void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
+{
+	__kvm_unmap_gfn(kvm_vcpu_gfn_to_memslot(vcpu, map->gfn), map, dirty);
+}
 EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
 struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn)
-- 
2.20.1



