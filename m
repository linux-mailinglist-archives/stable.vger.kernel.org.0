Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB3E1CA8D1
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390306AbfJCQd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:33:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404066AbfJCQdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:33:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2CA620830;
        Thu,  3 Oct 2019 16:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120403;
        bh=gvv0LsompVGXjpuBgj9I67q5B+fRbpqCxYEYavnNq64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUTpc35BEGi5yUjGB+wSkqQ3+NXsh1dsqYEXRgLhKg/VzHMhja+OPM4BKJrzbFY9D
         HqQibdxppNgJTEcvBGI2XYYMKsQ70sowHksdt5r/O1nYKMwpcPp67d7SnSEzRMaGXz
         RGhCQOUPWav7z13C0NOiZmNxaot3ncxli8P0nyF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Palecek <jpalecek@web.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 210/313] kvm: Nested KVM MMUs need PAE root too
Date:   Thu,  3 Oct 2019 17:53:08 +0200
Message-Id: <20191003154553.658097188@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiří Paleček <jpalecek@web.de>

[ Upstream commit 1cfff4d9a5d01fa61e5768a6afffc81ae1c8ecb9 ]

On AMD processors, in PAE 32bit mode, nested KVM instances don't
work. The L0 host get a kernel OOPS, which is related to
arch.mmu->pae_root being NULL.

The reason for this is that when setting up nested KVM instance,
arch.mmu is set to &arch.guest_mmu (while normally, it would be
&arch.root_mmu). However, the initialization and allocation of
pae_root only creates it in root_mmu. KVM code (ie. in
mmu_alloc_shadow_roots) then accesses arch.mmu->pae_root, which is the
unallocated arch.guest_mmu->pae_root.

This fix just allocates (and frees) pae_root in both guest_mmu and
root_mmu (and also lm_root if it was allocated). The allocation is
subject to previous restrictions ie. it won't allocate anything on
64-bit and AFAIK not on Intel.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=203923
Fixes: 14c07ad89f4d ("x86/kvm/mmu: introduce guest_mmu")
Signed-off-by: Jiri Palecek <jpalecek@web.de>
Tested-by: Jiri Palecek <jpalecek@web.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 66055ca29b6b4..9130152d5ed83 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5607,13 +5607,13 @@ slot_handle_leaf(struct kvm *kvm, struct kvm_memory_slot *memslot,
 				 PT_PAGE_TABLE_LEVEL, lock_flush_tlb);
 }
 
-static void free_mmu_pages(struct kvm_vcpu *vcpu)
+static void free_mmu_pages(struct kvm_mmu *mmu)
 {
-	free_page((unsigned long)vcpu->arch.mmu->pae_root);
-	free_page((unsigned long)vcpu->arch.mmu->lm_root);
+	free_page((unsigned long)mmu->pae_root);
+	free_page((unsigned long)mmu->lm_root);
 }
 
-static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
+static int alloc_mmu_pages(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 {
 	struct page *page;
 	int i;
@@ -5634,9 +5634,9 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 	if (!page)
 		return -ENOMEM;
 
-	vcpu->arch.mmu->pae_root = page_address(page);
+	mmu->pae_root = page_address(page);
 	for (i = 0; i < 4; ++i)
-		vcpu->arch.mmu->pae_root[i] = INVALID_PAGE;
+		mmu->pae_root[i] = INVALID_PAGE;
 
 	return 0;
 }
@@ -5644,6 +5644,7 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 int kvm_mmu_create(struct kvm_vcpu *vcpu)
 {
 	uint i;
+	int ret;
 
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
@@ -5661,7 +5662,19 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 		vcpu->arch.guest_mmu.prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 
 	vcpu->arch.nested_mmu.translate_gpa = translate_nested_gpa;
-	return alloc_mmu_pages(vcpu);
+
+	ret = alloc_mmu_pages(vcpu, &vcpu->arch.guest_mmu);
+	if (ret)
+		return ret;
+
+	ret = alloc_mmu_pages(vcpu, &vcpu->arch.root_mmu);
+	if (ret)
+		goto fail_allocate_root;
+
+	return ret;
+ fail_allocate_root:
+	free_mmu_pages(&vcpu->arch.guest_mmu);
+	return ret;
 }
 
 
@@ -6134,7 +6147,8 @@ unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
-	free_mmu_pages(vcpu);
+	free_mmu_pages(&vcpu->arch.root_mmu);
+	free_mmu_pages(&vcpu->arch.guest_mmu);
 	mmu_free_memory_caches(vcpu);
 }
 
-- 
2.20.1



