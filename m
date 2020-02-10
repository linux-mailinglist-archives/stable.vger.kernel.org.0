Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9B14157513
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbgBJMiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:38:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729129AbgBJMiX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:23 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31FD920733;
        Mon, 10 Feb 2020 12:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338303;
        bh=yT39T1LfOvJDm+YcHJ0W//J7FONSZAxa/7T50mD0S1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGqYUJUOxtBkuyWd4VJ0YfvHqDwhCq08NVVVoBvHa8loMOT86ueIriCOxZHSj2Xhi
         QZvCn33DYpvXEEpEhcYjLUdmLk/8ZrB+gtIHi3QwERHsjXjp5moE8QoXWJBkTJDd/y
         OLYQumHeC5fHruqKWCq1tSsSytCLcdUyyxEaszQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 215/309] x86/kvm: Introduce kvm_(un)map_gfn()
Date:   Mon, 10 Feb 2020 04:32:51 -0800
Message-Id: <20200210122427.201624924@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
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
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/kvm_host.h |    2 ++
 virt/kvm/kvm_main.c      |   29 ++++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -758,8 +758,10 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_
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
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1809,12 +1809,13 @@ struct page *gfn_to_page(struct kvm *kvm
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
@@ -1843,14 +1844,20 @@ static int __kvm_map_gfn(struct kvm_memo
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
@@ -1866,7 +1873,7 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcp
 #endif
 
 	if (dirty) {
-		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
+		mark_page_dirty_in_slot(memslot, map->gfn);
 		kvm_release_pfn_dirty(map->pfn);
 	} else {
 		kvm_release_pfn_clean(map->pfn);
@@ -1875,6 +1882,18 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcp
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


