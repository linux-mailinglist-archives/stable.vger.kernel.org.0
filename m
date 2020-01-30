Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB9614E06B
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgA3SCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:02:07 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38886 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727705AbgA3SCF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 13:02:05 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so5263167wrh.5;
        Thu, 30 Jan 2020 10:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MQodCAH6wfYLAMn58d99eqZo/Hm0Q1FcN2SsIIw9nvM=;
        b=Ob7N0NO20YjrDdZfjtoCPe6LkB/IgzjgLb8vb6Uu1DnpFm2952o90qTie2bCtPDnlo
         Rt45VBcbZl8ARuA3SJMk39ukwzfx9gZQtxHUcDiUDljFkMAWY+bB30jYdcVY+b6/PFJM
         KKUEfjPAdLxriKQX+FMNy4ROs8X/Fhg+48JMYtlOE7IrkXWAwloRKBHKrOhBUyRyGj6e
         1NQvzk3AiAFl8XTDvcilBz/JBPbbeP7TDmfBejqWUhA56vuRGDoZ+kpxWla6LwzodsLH
         Uxga61dtrAyjthVjGFGzyTbwJ903uozMS9lNk/J2RTSfupzN3/W6Xz01Y7KnOm0aOlPe
         7/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=MQodCAH6wfYLAMn58d99eqZo/Hm0Q1FcN2SsIIw9nvM=;
        b=Z2h9S/3wGwbhYe/AVuWG3KOVpOs/4T74L06stbE4nVIGEpYD9KNCOqX4YOQ74OAwkp
         Y2N1UV8uKUDht5nxR6Sgbu7uMkZOE7hBOuB9z15CVApcrqZqYXzkpDpjQwJRSzfqgF7o
         or8bVTRb5S+bD7BZtsHiGN4cxGP3kBxxmon5IQN83rBoYWU1STTnYtsUVvSHOxr2LkjR
         na1dKmIsN/YTV6jpuSwAFH+59QC0rovWyznvQ4yszssDo0bswfFj1s4udJpXp/e9gul0
         OpJZ40zGrU/pXIphUatAJWTjGG68Fvndkdf/zwrXdru7+nyoBlEOq2+WY7sj/9l3XUfD
         DASA==
X-Gm-Message-State: APjAAAW3FkzalQs7mpRz2JQkGekXxum+Br1Hw+KUi+5Iz+X3cLPUUl3D
        Q1d4Aqz3PtpAP95FBCXiORwWprvc7ns=
X-Google-Smtp-Source: APXvYqx2c2y6AfsCqAyWaujgsqRVHMlgLQNYiGKfAXxAOTMkDVCurqZbOHqui56Nsz2bP+3ZjDYbTA==
X-Received: by 2002:a5d:4f8e:: with SMTP id d14mr6818014wru.112.1580407322281;
        Thu, 30 Jan 2020 10:02:02 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w19sm6956878wmc.22.2020.01.30.10.02.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2020 10:02:01 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        stable@vger.kernel.org
Subject: [FYI PATCH 2/5] x86/kvm: Introduce kvm_(un)map_gfn()
Date:   Thu, 30 Jan 2020 19:01:53 +0100
Message-Id: <1580407316-11391-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580407316-11391-1-git-send-email-pbonzini@redhat.com>
References: <1580407316-11391-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

kvm_vcpu_(un)map operates on gfns from any current address space.
In certain cases we want to make sure we are not mapping SMRAM
and for that we can use kvm_(un)map_gfn() that we are introducing
in this patch.

This is part of CVE-2019-3016.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 29 ++++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 538c25e..0cb78f5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -775,8 +775,10 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
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
index 0026829..9ef58a2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1821,12 +1821,13 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
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
@@ -1855,14 +1856,20 @@ static int __kvm_map_gfn(struct kvm_memory_slot *slot, gfn_t gfn,
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
@@ -1878,7 +1885,7 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
 #endif
 
 	if (dirty) {
-		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
+		mark_page_dirty_in_slot(memslot, map->gfn);
 		kvm_release_pfn_dirty(map->pfn);
 	} else {
 		kvm_release_pfn_clean(map->pfn);
@@ -1887,6 +1894,18 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
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
1.8.3.1

