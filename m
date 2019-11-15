Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76949FD633
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbfKOGWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:22:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbfKOGWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:23 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DDD62081E;
        Fri, 15 Nov 2019 06:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798943;
        bh=q1GF1yG6zWlTOILmKVCGAMY9CFw+S/DW18hdKZTr1yM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5yP8UhLVDj/7VQLlEgGvcSB9+k7gNN9+iSckviiDlU1kaa8VT7ZptfwMjUVWHVVO
         2GlSfUbAkpOh9SqXpdOAamfZWSBTWL1HU0JU7qR4oavcELZWPgFaNEvhFK/EVHWqvG
         Zcl9PaxB7evCUE+Z9W+M+rl5szFNcVnjqnX/GP60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 21/31] KVM: x86: remove now unneeded hugepage gfn adjustment
Date:   Fri, 15 Nov 2019 14:20:50 +0800
Message-Id: <20191115062017.892821068@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
References: <20191115062009.813108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit d679b32611c0102ce33b9e1a4e4b94854ed1812a upstream.

After the previous patch, the low bits of the gfn are masked in
both FNAME(fetch) and __direct_map, so we do not need to clear them
in transparent_hugepage_adjust.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu.c         |    9 +++------
 arch/x86/kvm/paging_tmpl.h |    2 +-
 2 files changed, 4 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2824,11 +2824,10 @@ static int kvm_handle_bad_page(struct kv
 }
 
 static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
-					gfn_t *gfnp, kvm_pfn_t *pfnp,
+					gfn_t gfn, kvm_pfn_t *pfnp,
 					int *levelp)
 {
 	kvm_pfn_t pfn = *pfnp;
-	gfn_t gfn = *gfnp;
 	int level = *levelp;
 
 	/*
@@ -2855,8 +2854,6 @@ static void transparent_hugepage_adjust(
 		mask = KVM_PAGES_PER_HPAGE(level) - 1;
 		VM_BUG_ON((gfn & mask) != (pfn & mask));
 		if (pfn & mask) {
-			gfn &= ~mask;
-			*gfnp = gfn;
 			kvm_release_pfn_clean(pfn);
 			pfn &= ~mask;
 			kvm_get_pfn(pfn);
@@ -3060,7 +3057,7 @@ static int nonpaging_map(struct kvm_vcpu
 		goto out_unlock;
 	make_mmu_pages_available(vcpu);
 	if (likely(!force_pt_level))
-		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
+		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
 	r = __direct_map(vcpu, v, write, map_writable, level, pfn, prefault);
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
@@ -3595,7 +3592,7 @@ static int tdp_page_fault(struct kvm_vcp
 		goto out_unlock;
 	make_mmu_pages_available(vcpu);
 	if (likely(!force_pt_level))
-		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
+		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
 	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn, prefault);
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -806,7 +806,7 @@ static int FNAME(page_fault)(struct kvm_
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	make_mmu_pages_available(vcpu);
 	if (!force_pt_level)
-		transparent_hugepage_adjust(vcpu, &walker.gfn, &pfn, &level);
+		transparent_hugepage_adjust(vcpu, walker.gfn, &pfn, &level);
 	r = FNAME(fetch)(vcpu, addr, &walker, write_fault,
 			 level, pfn, map_writable, prefault);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);


