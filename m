Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB6D49E9B2
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239583AbiA0SI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242604AbiA0SIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:08:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30678C061747;
        Thu, 27 Jan 2022 10:08:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C239461D03;
        Thu, 27 Jan 2022 18:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A77C340E4;
        Thu, 27 Jan 2022 18:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306933;
        bh=AuodGIedKb1Vynw841LEP4b/zCRYPGByTRwZbxXfTxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYyRpOPJPr3k6ET2qIiNT/7EdQ7Iteu73ncuEMQ8uF7aBKjNBm3/8/M1H6fztDtrh
         zh5islKBs5VOlCHENG2NGggd4c+kqEJAzkUEiEJx2nXl4ArubQLgiElSz/qsWXRnso
         +tRbKpcmS85RFn6SoDGPFsVekCwEBE+xH8zScnlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Xiao Guangrong <xiaoguangrong@tencent.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 4/9] KVM: nVMX: fix EPT permissions as reported in exit qualification
Date:   Thu, 27 Jan 2022 19:08:22 +0100
Message-Id: <20220127180257.361803246@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180257.225641300@linuxfoundation.org>
References: <20220127180257.225641300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 0780516a18f87e881e42ed815f189279b0a1743c upstream.

This fixes the new ept_access_test_read_only and ept_access_test_read_write
testcases from vmx.flat.

The problem is that gpte_access moves bits around to switch from EPT
bit order (XWR) to ACC_*_MASK bit order (RWX).  This results in an
incorrect exit qualification.  To fix this, make pt_access and
pte_access operate on raw PTE values (only with NX flipped to mean
"can execute") and call gpte_access at the end of the walk.  This
lets us use pte_access to compute the exit qualification with XWR
bit order.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Xiao Guangrong <xiaoguangrong@tencent.com>
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
[bwh: Backported to 4.9:
 - There's no support for EPT accessed/dirty bits, so do not use
   have_ad flag
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/paging_tmpl.h |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -285,9 +285,11 @@ static int FNAME(walk_addr_generic)(stru
 	pt_element_t pte;
 	pt_element_t __user *uninitialized_var(ptep_user);
 	gfn_t table_gfn;
-	unsigned index, pt_access, pte_access, accessed_dirty, pte_pkey;
+	u64 pt_access, pte_access;
+	unsigned index, accessed_dirty, pte_pkey;
 	gpa_t pte_gpa;
 	int offset;
+	u64 walk_nx_mask = 0;
 	const int write_fault = access & PFERR_WRITE_MASK;
 	const int user_fault  = access & PFERR_USER_MASK;
 	const int fetch_fault = access & PFERR_FETCH_MASK;
@@ -301,6 +303,7 @@ retry_walk:
 	pte           = mmu->get_cr3(vcpu);
 
 #if PTTYPE == 64
+	walk_nx_mask = 1ULL << PT64_NX_SHIFT;
 	if (walker->level == PT32E_ROOT_LEVEL) {
 		pte = mmu->get_pdptr(vcpu, (addr >> 30) & 3);
 		trace_kvm_mmu_paging_element(pte, walker->level);
@@ -312,15 +315,14 @@ retry_walk:
 	walker->max_level = walker->level;
 	ASSERT(!(is_long_mode(vcpu) && !is_pae(vcpu)));
 
-	accessed_dirty = PT_GUEST_ACCESSED_MASK;
-	pt_access = pte_access = ACC_ALL;
+	pte_access = ~0;
 	++walker->level;
 
 	do {
 		gfn_t real_gfn;
 		unsigned long host_addr;
 
-		pt_access &= pte_access;
+		pt_access = pte_access;
 		--walker->level;
 
 		index = PT_INDEX(addr, walker->level);
@@ -363,6 +365,12 @@ retry_walk:
 
 		trace_kvm_mmu_paging_element(pte, walker->level);
 
+		/*
+		 * Inverting the NX it lets us AND it like other
+		 * permission bits.
+		 */
+		pte_access = pt_access & (pte ^ walk_nx_mask);
+
 		if (unlikely(!FNAME(is_present_gpte)(pte)))
 			goto error;
 
@@ -371,14 +379,16 @@ retry_walk:
 			goto error;
 		}
 
-		accessed_dirty &= pte;
-		pte_access = pt_access & FNAME(gpte_access)(vcpu, pte);
-
 		walker->ptes[walker->level - 1] = pte;
 	} while (!is_last_gpte(mmu, walker->level, pte));
 
 	pte_pkey = FNAME(gpte_pkeys)(vcpu, pte);
-	errcode = permission_fault(vcpu, mmu, pte_access, pte_pkey, access);
+	accessed_dirty = pte_access & PT_GUEST_ACCESSED_MASK;
+
+	/* Convert to ACC_*_MASK flags for struct guest_walker.  */
+	walker->pt_access = FNAME(gpte_access)(vcpu, pt_access ^ walk_nx_mask);
+	walker->pte_access = FNAME(gpte_access)(vcpu, pte_access ^ walk_nx_mask);
+	errcode = permission_fault(vcpu, mmu, walker->pte_access, pte_pkey, access);
 	if (unlikely(errcode))
 		goto error;
 
@@ -395,7 +405,7 @@ retry_walk:
 	walker->gfn = real_gpa >> PAGE_SHIFT;
 
 	if (!write_fault)
-		FNAME(protect_clean_gpte)(&pte_access, pte);
+		FNAME(protect_clean_gpte)(&walker->pte_access, pte);
 	else
 		/*
 		 * On a write fault, fold the dirty bit into accessed_dirty.
@@ -413,10 +423,8 @@ retry_walk:
 			goto retry_walk;
 	}
 
-	walker->pt_access = pt_access;
-	walker->pte_access = pte_access;
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-		 __func__, (u64)pte, pte_access, pt_access);
+		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
 	return 1;
 
 error:
@@ -444,7 +452,7 @@ error:
 	 */
 	if (!(errcode & PFERR_RSVD_MASK)) {
 		vcpu->arch.exit_qualification &= 0x187;
-		vcpu->arch.exit_qualification |= ((pt_access & pte) & 0x7) << 3;
+		vcpu->arch.exit_qualification |= (pte_access & 0x7) << 3;
 	}
 #endif
 	walker->fault.address = addr;


