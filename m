Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6986432B231
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241352AbhCCAww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:52:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45616 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347523AbhCBRt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 12:49:28 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122HZ5wD045499;
        Tue, 2 Mar 2021 12:44:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=51f9USJRNe5/Dw4IR9bEzcSsqDV7pi67ofwYMedkrQ8=;
 b=XTGIczHjPvjy/RijlW2Evd1tftNxRp/MX9ZnnSC+SAitktZ1ItOeBTvV9ZPeJEPDhPDc
 iI6rvl/OBmFaNDYUDncdZhwjGnFIr/MqU2G8MqwF+dU1B8kmVv3UokkRhcaYay707AeH
 RvcmkdtbnoODTFaXN8kR/CkNBliNJTQGGvcgUendV0GnT3JTWJ10rKKq++z4abv+ZoQE
 wAizZ21fyOoTXBCkKXxBqiGiUdlEaxiS+xNgJeI81mO+5t4wrYgqeDSApoXjzx5LZTgG
 VAVdS4jCq00Y//X5A2ieKC9KXsW3q0bpSbTxxyu1s87kELjW6xOsAoYkwKunrRm3ICWa HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371qdk6273-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 12:44:51 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 122HbMjU057353;
        Tue, 2 Mar 2021 12:44:50 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371qdk626g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 12:44:50 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 122HfSs8005399;
        Tue, 2 Mar 2021 17:44:48 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3713s9rhfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 17:44:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 122HiiWr21627388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 17:44:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8296052050;
        Tue,  2 Mar 2021 17:44:44 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.194])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1BAB952057;
        Tue,  2 Mar 2021 17:44:44 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org, Janosch Frank <frankja@de.ibm.com>
Subject: [PATCH v5 2/3] s390/kvm: extend kvm_s390_shadow_fault to return entry pointer
Date:   Tue,  2 Mar 2021 18:44:42 +0100
Message-Id: <20210302174443.514363-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210302174443.514363-1-imbrenda@linux.ibm.com>
References: <20210302174443.514363-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 mlxscore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020136
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/s390/kvm/gaccess.c | 30 +++++++++++++++++++++++++-----
 arch/s390/kvm/gaccess.h |  6 +++++-
 arch/s390/kvm/vsie.c    |  8 ++++----
 3 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 6d6b57059493..33a03e518640 100644
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
+		pgt |= PEI_NOT_PTE;
+		break;
+	case 0:
+		pgt += vaddr.px * 8;
+		rc = gmap_read_table(sg->parent, pgt, &pte.val);
+	}
+	if (*datptr)
+		*datptr = pgt | dat_protection * PEI_DAT_PROT;
 	if (!rc && pte.i)
 		rc = PGM_PAGE_TRANSLATION;
 	if (!rc && pte.z)
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index 107fdfd2eadd..df4014f09e26 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -378,7 +378,11 @@ void ipte_unlock(struct kvm_vcpu *vcpu);
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
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index bd803e091918..78b604326016 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -620,10 +620,10 @@ static int map_prefix(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
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
@@ -914,7 +914,7 @@ static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 				    current->thread.gmap_addr, 1);
 
 	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-				   current->thread.gmap_addr);
+				   current->thread.gmap_addr, NULL);
 	if (rc > 0) {
 		rc = inject_fault(vcpu, rc,
 				  current->thread.gmap_addr,
@@ -936,7 +936,7 @@ static void handle_last_fault(struct kvm_vcpu *vcpu,
 {
 	if (vsie_page->fault_addr)
 		kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-				      vsie_page->fault_addr);
+				      vsie_page->fault_addr, NULL);
 	vsie_page->fault_addr = 0;
 }
 
-- 
2.26.2

