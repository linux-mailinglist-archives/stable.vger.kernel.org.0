Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320AC49E9B3
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242912AbiA0SJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244595AbiA0SI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:08:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E12C061749;
        Thu, 27 Jan 2022 10:08:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0346761CEC;
        Thu, 27 Jan 2022 18:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A36C340E4;
        Thu, 27 Jan 2022 18:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306936;
        bh=pjUps12VKNP/f4t1N2fmXT17o0v4/hjN1mtcgEZrecs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmnXaOWu45Uu/7vZru6IsrnP0yl049s4Mf4Zfa3fpAUR9WjL/BRBPDcOdPfgYYDx4
         DTpzVcUoe5OzSqPYA9XaFj43ylxiuViM0pa1OZeVsyoyLdyYo3t44bJa0mn4nWuD6m
         5QihQ3IJrzV1kk2UvT6rXu8izox2lOyZmewM5LuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 5/9] KVM: X86: MMU: Use the correct inherited permissions to get shadow page
Date:   Thu, 27 Jan 2022 19:08:23 +0100
Message-Id: <20220127180257.391063648@linuxfoundation.org>
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

From: Lai Jiangshan <laijs@linux.alibaba.com>

commit b1bd5cba3306691c771d558e94baa73e8b0b96b7 upstream.

When computing the access permissions of a shadow page, use the effective
permissions of the walk up to that point, i.e. the logic AND of its parents'
permissions.  Two guest PxE entries that point at the same table gfn need to
be shadowed with different shadow pages if their parents' permissions are
different.  KVM currently uses the effective permissions of the last
non-leaf entry for all non-leaf entries.  Because all non-leaf SPTEs have
full ("uwx") permissions, and the effective permissions are recorded only
in role.access and merged into the leaves, this can lead to incorrect
reuse of a shadow page and eventually to a missing guest protection page
fault.

For example, here is a shared pagetable:

   pgd[]   pud[]        pmd[]            virtual address pointers
                     /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
        /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
   pgd-|           (shared pmd[] as above)
        \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
                     \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)

  pud1 and pud2 point to the same pmd table, so:
  - ptr1 and ptr3 points to the same page.
  - ptr2 and ptr4 points to the same page.

(pud1 and pud2 here are pud entries, while pmd1 and pmd2 here are pmd entries)

- First, the guest reads from ptr1 first and KVM prepares a shadow
  page table with role.access=u--, from ptr1's pud1 and ptr1's pmd1.
  "u--" comes from the effective permissions of pgd, pud1 and
  pmd1, which are stored in pt->access.  "u--" is used also to get
  the pagetable for pud1, instead of "uw-".

- Then the guest writes to ptr2 and KVM reuses pud1 which is present.
  The hypervisor set up a shadow page for ptr2 with pt->access is "uw-"
  even though the pud1 pmd (because of the incorrect argument to
  kvm_mmu_get_page in the previous step) has role.access="u--".

- Then the guest reads from ptr3.  The hypervisor reuses pud1's
  shadow pmd for pud2, because both use "u--" for their permissions.
  Thus, the shadow pmd already includes entries for both pmd1 and pmd2.

- At last, the guest writes to ptr4.  This causes no vmexit or pagefault,
  because pud1's shadow page structures included an "uw-" page even though
  its role.access was "u--".

Any kind of shared pagetable might have the similar problem when in
virtual machine without TDP enabled if the permissions are different
from different ancestors.

In order to fix the problem, we change pt->access to be an array, and
any access in it will not include permissions ANDed from child ptes.

The test code is: https://lore.kernel.org/kvm/20210603050537.19605-1-jiangshanlai@gmail.com/
Remember to test it with TDP disabled.

The problem had existed long before the commit 41074d07c78b ("KVM: MMU:
Fix inherited permissions for emulated guest pte updates"), and it
is hard to find which is the culprit.  So there is no fixes tag here.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20210603052455.21023-1-jiangshanlai@gmail.com>
Cc: stable@vger.kernel.org
Fixes: cea0f0e7ea54 ("[PATCH] KVM: MMU: Shadow page table caching")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 4.9:
 - Keep passing vcpu argument to gpte_access functions
 - Adjust filenames, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/virtual/kvm/mmu.txt |    4 ++--
 arch/x86/kvm/paging_tmpl.h        |   14 +++++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -152,8 +152,8 @@ Shadow pages contain the following infor
     shadow pages) so role.quadrant takes values in the range 0..3.  Each
     quadrant maps 1GB virtual address space.
   role.access:
-    Inherited guest access permissions in the form uwx.  Note execute
-    permission is positive, not negative.
+    Inherited guest access permissions from the parent ptes in the form uwx.
+    Note execute permission is positive, not negative.
   role.invalid:
     The page is invalid and should not be used.  It is a root page that is
     currently pinned (by a cpu hardware register pointing to it); once it is
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -100,8 +100,8 @@ struct guest_walker {
 	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
 	pt_element_t __user *ptep_user[PT_MAX_FULL_LEVELS];
 	bool pte_writable[PT_MAX_FULL_LEVELS];
-	unsigned pt_access;
-	unsigned pte_access;
+	unsigned int pt_access[PT_MAX_FULL_LEVELS];
+	unsigned int pte_access;
 	gfn_t gfn;
 	struct x86_exception fault;
 };
@@ -380,13 +380,15 @@ retry_walk:
 		}
 
 		walker->ptes[walker->level - 1] = pte;
+
+		/* Convert to ACC_*_MASK flags for struct guest_walker.  */
+		walker->pt_access[walker->level - 1] = FNAME(gpte_access)(vcpu, pt_access ^ walk_nx_mask);
 	} while (!is_last_gpte(mmu, walker->level, pte));
 
 	pte_pkey = FNAME(gpte_pkeys)(vcpu, pte);
 	accessed_dirty = pte_access & PT_GUEST_ACCESSED_MASK;
 
 	/* Convert to ACC_*_MASK flags for struct guest_walker.  */
-	walker->pt_access = FNAME(gpte_access)(vcpu, pt_access ^ walk_nx_mask);
 	walker->pte_access = FNAME(gpte_access)(vcpu, pte_access ^ walk_nx_mask);
 	errcode = permission_fault(vcpu, mmu, walker->pte_access, pte_pkey, access);
 	if (unlikely(errcode))
@@ -424,7 +426,8 @@ retry_walk:
 	}
 
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
+		 __func__, (u64)pte, walker->pte_access,
+		 walker->pt_access[walker->level - 1]);
 	return 1;
 
 error:
@@ -586,7 +589,7 @@ static int FNAME(fetch)(struct kvm_vcpu
 {
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
-	unsigned direct_access, access = gw->pt_access;
+	unsigned int direct_access, access;
 	int top_level, ret;
 	gfn_t gfn, base_gfn;
 
@@ -618,6 +621,7 @@ static int FNAME(fetch)(struct kvm_vcpu
 		sp = NULL;
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn = gw->table_gfn[it.level - 2];
+			access = gw->pt_access[it.level - 2];
 			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
 					      false, access);
 		}


