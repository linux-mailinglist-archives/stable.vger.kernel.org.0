Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 161AFFD615
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbfKOGWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:22:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727643AbfKOGWR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:17 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EEEB2053B;
        Fri, 15 Nov 2019 06:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798936;
        bh=5szIoT4JzoYsv4oE8NhLFcI0OGc97tKI2jysUgm1QiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWTAAkxlPJsKwmCcEzqz8F81WNPxmRHjm9gf+0QZT4rpmyhnYTy40YTlYsm9zZV10
         5lHr1jP0keFIuVWQkkK3KkPoef4IE0iXkb3zAslMQvC4Or1JU+UFjD+2r39pAaYHq1
         za6EFXzpz1R/6kLNRgICWhUmQfhmYeXi25Efl3vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 19/31] kvm: x86: Do not release the page inside mmu_set_spte()
Date:   Fri, 15 Nov 2019 14:20:48 +0800
Message-Id: <20191115062017.497957102@linuxfoundation.org>
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

From: Junaid Shahid <junaids@google.com>

commit 43fdcda96e2550c6d1c46fb8a78801aa2f7276ed upstream.

Release the page at the call-site where it was originally acquired.
This makes the exit code cleaner for most call sites, since they
do not need to duplicate code between success and the failure
label.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu.c         |   18 +++++++-----------
 arch/x86/kvm/paging_tmpl.h |    8 +++-----
 2 files changed, 10 insertions(+), 16 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2671,8 +2671,6 @@ static int mmu_set_spte(struct kvm_vcpu
 		}
 	}
 
-	kvm_release_pfn_clean(pfn);
-
 	return ret;
 }
 
@@ -2707,9 +2705,11 @@ static int direct_pte_prefetch_many(stru
 	if (ret <= 0)
 		return -1;
 
-	for (i = 0; i < ret; i++, gfn++, start++)
+	for (i = 0; i < ret; i++, gfn++, start++) {
 		mmu_set_spte(vcpu, start, access, 0, sp->role.level, gfn,
 			     page_to_pfn(pages[i]), true, true);
+		put_page(pages[i]);
+	}
 
 	return 0;
 }
@@ -3055,6 +3055,7 @@ static int nonpaging_map(struct kvm_vcpu
 	if (handle_abnormal_pfn(vcpu, v, gfn, pfn, ACC_ALL, &r))
 		return r;
 
+	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
@@ -3062,14 +3063,11 @@ static int nonpaging_map(struct kvm_vcpu
 	if (likely(!force_pt_level))
 		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
 	r = __direct_map(vcpu, write, map_writable, level, gfn, pfn, prefault);
-	spin_unlock(&vcpu->kvm->mmu_lock);
-
-	return r;
 
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
-	return RET_PF_RETRY;
+	return r;
 }
 
 
@@ -3593,6 +3591,7 @@ static int tdp_page_fault(struct kvm_vcp
 	if (handle_abnormal_pfn(vcpu, 0, gfn, pfn, ACC_ALL, &r))
 		return r;
 
+	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
@@ -3600,14 +3599,11 @@ static int tdp_page_fault(struct kvm_vcp
 	if (likely(!force_pt_level))
 		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
 	r = __direct_map(vcpu, write, map_writable, level, gfn, pfn, prefault);
-	spin_unlock(&vcpu->kvm->mmu_lock);
-
-	return r;
 
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
-	return RET_PF_RETRY;
+	return r;
 }
 
 static void nonpaging_init_context(struct kvm_vcpu *vcpu,
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -499,6 +499,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vc
 	mmu_set_spte(vcpu, spte, pte_access, 0, PT_PAGE_TABLE_LEVEL, gfn, pfn,
 		     true, true);
 
+	kvm_release_pfn_clean(pfn);
 	return true;
 }
 
@@ -650,7 +651,6 @@ static int FNAME(fetch)(struct kvm_vcpu
 	return ret;
 
 out_gpte_changed:
-	kvm_release_pfn_clean(pfn);
 	return RET_PF_RETRY;
 }
 
@@ -799,6 +799,7 @@ static int FNAME(page_fault)(struct kvm_
 			walker.pte_access &= ~ACC_EXEC_MASK;
 	}
 
+	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
@@ -811,14 +812,11 @@ static int FNAME(page_fault)(struct kvm_
 			 level, pfn, map_writable, prefault);
 	++vcpu->stat.pf_fixed;
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
-	spin_unlock(&vcpu->kvm->mmu_lock);
-
-	return r;
 
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
-	return RET_PF_RETRY;
+	return r;
 }
 
 static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)


