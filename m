Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D9C37C7CC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhELQCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237747AbhELP4T (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96DEF61C1B;
        Wed, 12 May 2021 15:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833304;
        bh=zhEgzhIXfJT9eFfqa+xBCeSWw5pQewWSZZWVL+QszpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+9EGNMYASd1Xc9DY3RLsKlFWqBY8K1+kI7L7sMhxizVq3rsa1QbDFmvssBglnHel
         Be0TMS0wkoSxazuGaJwjPWgli8nI6QlRQ9HF+5uZK1UgowO+hhgNalBJSZdcr/ETgS
         c69sDgv/r9KjPYy11cY7CXw064dS/5oSvnaNsTC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5.11 095/601] KVM: s390: extend kvm_s390_shadow_fault to return entry pointer
Date:   Wed, 12 May 2021 16:42:52 +0200
Message-Id: <20210512144830.958434349@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

commit 5ac14bac08ae827b619f21bcceaaac3b8c497e31 upstream.

Extend kvm_s390_shadow_fault to return the pointer to the valid leaf
DAT table entry, or to the invalid entry.

Also return some flags in the lower bits of the address:
PEI_DAT_PROT: indicates that DAT protection applies because of the
              protection bit in the segment (or, if EDAT, region) tables.
PEI_NOT_PTE: indicates that the address of the DAT table entry returned
             does not refer to a PTE, but to a segment or region table.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: stable@vger.kernel.org
Reviewed-by: Janosch Frank <frankja@de.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Link: https://lore.kernel.org/r/20210302174443.514363-3-imbrenda@linux.ibm.com
[borntraeger@de.ibm.com: fold in a fix from Claudio]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/gaccess.c |   30 +++++++++++++++++++++++++-----
 arch/s390/kvm/gaccess.h |    6 +++++-
 arch/s390/kvm/vsie.c    |    8 ++++----
 3 files changed, 34 insertions(+), 10 deletions(-)

--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -976,7 +976,9 @@ int kvm_s390_check_low_addr_prot_real(st
  * kvm_s390_shadow_tables - walk the guest page table and create shadow tables
  * @sg: pointer to the shadow guest address space structure
  * @saddr: faulting address in the shadow gmap
- * @pgt: pointer to the page table address result
+ * @pgt: pointer to the beginning of the page table for the given address if
+ *	 successful (return value 0), or to the first invalid DAT entry in
+ *	 case of exceptions (return value > 0)
  * @fake: pgt references contiguous guest memory block, not a pgtable
  */
 static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
@@ -1034,6 +1036,7 @@ static int kvm_s390_shadow_tables(struct
 			rfte.val = ptr;
 			goto shadow_r2t;
 		}
+		*pgt = ptr + vaddr.rfx * 8;
 		rc = gmap_read_table(parent, ptr + vaddr.rfx * 8, &rfte.val);
 		if (rc)
 			return rc;
@@ -1060,6 +1063,7 @@ shadow_r2t:
 			rste.val = ptr;
 			goto shadow_r3t;
 		}
+		*pgt = ptr + vaddr.rsx * 8;
 		rc = gmap_read_table(parent, ptr + vaddr.rsx * 8, &rste.val);
 		if (rc)
 			return rc;
@@ -1087,6 +1091,7 @@ shadow_r3t:
 			rtte.val = ptr;
 			goto shadow_sgt;
 		}
+		*pgt = ptr + vaddr.rtx * 8;
 		rc = gmap_read_table(parent, ptr + vaddr.rtx * 8, &rtte.val);
 		if (rc)
 			return rc;
@@ -1123,6 +1128,7 @@ shadow_sgt:
 			ste.val = ptr;
 			goto shadow_pgt;
 		}
+		*pgt = ptr + vaddr.sx * 8;
 		rc = gmap_read_table(parent, ptr + vaddr.sx * 8, &ste.val);
 		if (rc)
 			return rc;
@@ -1157,6 +1163,8 @@ shadow_pgt:
  * @vcpu: virtual cpu
  * @sg: pointer to the shadow guest address space structure
  * @saddr: faulting address in the shadow gmap
+ * @datptr: will contain the address of the faulting DAT table entry, or of
+ *	    the valid leaf, plus some flags
  *
  * Returns: - 0 if the shadow fault was successfully resolved
  *	    - > 0 (pgm exception code) on exceptions while faulting
@@ -1165,11 +1173,11 @@ shadow_pgt:
  *	    - -ENOMEM if out of memory
  */
 int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
-			  unsigned long saddr)
+			  unsigned long saddr, unsigned long *datptr)
 {
 	union vaddress vaddr;
 	union page_table_entry pte;
-	unsigned long pgt;
+	unsigned long pgt = 0;
 	int dat_protection, fake;
 	int rc;
 
@@ -1191,8 +1199,20 @@ int kvm_s390_shadow_fault(struct kvm_vcp
 		pte.val = pgt + vaddr.px * PAGE_SIZE;
 		goto shadow_page;
 	}
-	if (!rc)
-		rc = gmap_read_table(sg->parent, pgt + vaddr.px * 8, &pte.val);
+
+	switch (rc) {
+	case PGM_SEGMENT_TRANSLATION:
+	case PGM_REGION_THIRD_TRANS:
+	case PGM_REGION_SECOND_TRANS:
+	case PGM_REGION_FIRST_TRANS:
+		pgt |= PEI_NOT_PTE;
+		break;
+	case 0:
+		pgt += vaddr.px * 8;
+		rc = gmap_read_table(sg->parent, pgt, &pte.val);
+	}
+	if (datptr)
+		*datptr = pgt | dat_protection * PEI_DAT_PROT;
 	if (!rc && pte.i)
 		rc = PGM_PAGE_TRANSLATION;
 	if (!rc && pte.z)
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -387,7 +387,11 @@ void ipte_unlock(struct kvm_vcpu *vcpu);
 int ipte_lock_held(struct kvm_vcpu *vcpu);
 int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra);
 
+/* MVPG PEI indication bits */
+#define PEI_DAT_PROT 2
+#define PEI_NOT_PTE 4
+
 int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *shadow,
-			  unsigned long saddr);
+			  unsigned long saddr, unsigned long *datptr);
 
 #endif /* __KVM_S390_GACCESS_H */
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -614,10 +614,10 @@ static int map_prefix(struct kvm_vcpu *v
 	/* with mso/msl, the prefix lies at offset *mso* */
 	prefix += scb_s->mso;
 
-	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, prefix);
+	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, prefix, NULL);
 	if (!rc && (scb_s->ecb & ECB_TE))
 		rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-					   prefix + PAGE_SIZE);
+					   prefix + PAGE_SIZE, NULL);
 	/*
 	 * We don't have to mprotect, we will be called for all unshadows.
 	 * SIE will detect if protection applies and trigger a validity.
@@ -908,7 +908,7 @@ static int handle_fault(struct kvm_vcpu
 				    current->thread.gmap_addr, 1);
 
 	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-				   current->thread.gmap_addr);
+				   current->thread.gmap_addr, NULL);
 	if (rc > 0) {
 		rc = inject_fault(vcpu, rc,
 				  current->thread.gmap_addr,
@@ -930,7 +930,7 @@ static void handle_last_fault(struct kvm
 {
 	if (vsie_page->fault_addr)
 		kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-				      vsie_page->fault_addr);
+				      vsie_page->fault_addr, NULL);
 	vsie_page->fault_addr = 0;
 }
 


