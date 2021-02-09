Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BCA315306
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 16:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhBIPnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 10:43:55 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39156 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232235AbhBIPnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 10:43:51 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119FgwSb024734;
        Tue, 9 Feb 2021 10:43:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mOqYbFkzDQwH/O1c3r8AZ/mp3+k7PftizoLE+846B2Y=;
 b=K1M3eIZgYcTeKQAagu0cJ1fDE2KZaWnSgN2ZHlGKb2P2wvKPUJ3NczDN4Bj0S2ZOEzdP
 RFFWzFwkl9mXvW0FOrTb9xnK1/7PPJ1Oerey57PMDkbTZ1s5SvtmGvTlV0egaNFBoFXH
 P7tM0Z1mkzY1tcjQ+MJrUDoyLK7DoWaZWHeNjvJzAUJ0oWobC5xtaT/7RFuMYA9O3jKS
 pSHcJp3b31Klwd9OL+reYu8SMkLtN6A4mbR0+YGJ+/kGjkAqMxX38z39sXWHiZvWSxqp
 PpwJ12KVk2skSCv/9B79A8lxQxuzB1gxd2442ACp5MYAjf3PbKFYgQsQNUbBIK4A0AG9 wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36kw9c006x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 10:43:08 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119Fh8vj028733;
        Tue, 9 Feb 2021 10:43:08 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36kw9c0069-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 10:43:08 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119FbScD005071;
        Tue, 9 Feb 2021 15:43:06 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 36hjr89tpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 15:43:06 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119Fh3N437945610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 15:43:03 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E1D5AE045;
        Tue,  9 Feb 2021 15:43:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3767FAE057;
        Tue,  9 Feb 2021 15:43:03 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.1.216])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 15:43:03 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v3 1/2] s390/kvm: extend kvm_s390_shadow_fault to return entry pointer
Date:   Tue,  9 Feb 2021 16:43:01 +0100
Message-Id: <20210209154302.1033165-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209154302.1033165-1-imbrenda@linux.ibm.com>
References: <20210209154302.1033165-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 spamscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090079
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Extend kvm_s390_shadow_fault to return the pointer to the valid leaf
DAT table entry, or to the invalid entry.

Also return some flags in the lower bits of the address:
DAT_PROT: indicates that DAT protection applies because of the
          protection bit in the segment (or, if EDAT, region) tables
NOT_PTE: indicates that the address of the DAT table entry returned
         does not refer to a PTE, but to a segment or region table.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: stable@vger.kernel.org
---
 arch/s390/kvm/gaccess.c | 30 +++++++++++++++++++++++++-----
 arch/s390/kvm/gaccess.h |  5 ++++-
 arch/s390/kvm/vsie.c    |  8 ++++----
 3 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 6d6b57059493..e0ab83f051d2 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -976,7 +976,9 @@ int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra)
  * kvm_s390_shadow_tables - walk the guest page table and create shadow tables
  * @sg: pointer to the shadow guest address space structure
  * @saddr: faulting address in the shadow gmap
- * @pgt: pointer to the page table address result
+ * @pgt: pointer to the beginning of the page table for the given address if
+ *       successful (return value 0), or to the first invalid DAT entry in
+ *       case of exceptions (return value > 0)
  * @fake: pgt references contiguous guest memory block, not a pgtable
  */
 static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
@@ -1034,6 +1036,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 			rfte.val = ptr;
 			goto shadow_r2t;
 		}
+		*pgt = ptr + vaddr.rfx * 8;
 		rc = gmap_read_table(parent, ptr + vaddr.rfx * 8, &rfte.val);
 		if (rc)
 			return rc;
@@ -1060,6 +1063,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 			rste.val = ptr;
 			goto shadow_r3t;
 		}
+		*pgt = ptr + vaddr.rsx * 8;
 		rc = gmap_read_table(parent, ptr + vaddr.rsx * 8, &rste.val);
 		if (rc)
 			return rc;
@@ -1087,6 +1091,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 			rtte.val = ptr;
 			goto shadow_sgt;
 		}
+		*pgt = ptr + vaddr.rtx * 8;
 		rc = gmap_read_table(parent, ptr + vaddr.rtx * 8, &rtte.val);
 		if (rc)
 			return rc;
@@ -1123,6 +1128,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 			ste.val = ptr;
 			goto shadow_pgt;
 		}
+		*pgt = ptr + vaddr.sx * 8;
 		rc = gmap_read_table(parent, ptr + vaddr.sx * 8, &ste.val);
 		if (rc)
 			return rc;
@@ -1157,6 +1163,8 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
  * @vcpu: virtual cpu
  * @sg: pointer to the shadow guest address space structure
  * @saddr: faulting address in the shadow gmap
+ * @datptr: will contain the address of the faulting DAT table entry, or of
+ *          the valid leaf, plus some flags
  *
  * Returns: - 0 if the shadow fault was successfully resolved
  *	    - > 0 (pgm exception code) on exceptions while faulting
@@ -1165,11 +1173,11 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
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
 
@@ -1191,8 +1199,20 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
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
+		pgt |= NOT_PTE;
+		break;
+	case 0:
+		pgt += vaddr.px * 8;
+		rc = gmap_read_table(sg->parent, pgt, &pte.val);
+	}
+	if (*datptr)
+		*datptr = pgt | dat_protection * DAT_PROT;
 	if (!rc && pte.i)
 		rc = PGM_PAGE_TRANSLATION;
 	if (!rc && pte.z)
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index f4c51756c462..fec26bbb17ba 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -359,7 +359,10 @@ void ipte_unlock(struct kvm_vcpu *vcpu);
 int ipte_lock_held(struct kvm_vcpu *vcpu);
 int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra);
 
+#define DAT_PROT 2
+#define NOT_PTE 4
+
 int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *shadow,
-			  unsigned long saddr);
+			  unsigned long saddr, unsigned long *datptr);
 
 #endif /* __KVM_S390_GACCESS_H */
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index c5d0a58b2c29..7db022141db3 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -619,10 +619,10 @@ static int map_prefix(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
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
@@ -913,7 +913,7 @@ static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 				    current->thread.gmap_addr, 1);
 
 	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-				   current->thread.gmap_addr);
+				   current->thread.gmap_addr, NULL);
 	if (rc > 0) {
 		rc = inject_fault(vcpu, rc,
 				  current->thread.gmap_addr,
@@ -935,7 +935,7 @@ static void handle_last_fault(struct kvm_vcpu *vcpu,
 {
 	if (vsie_page->fault_addr)
 		kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-				      vsie_page->fault_addr);
+				      vsie_page->fault_addr, NULL);
 	vsie_page->fault_addr = 0;
 }
 
-- 
2.26.2

