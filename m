Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE182DE3D8
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 15:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgLROTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 09:19:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5082 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725911AbgLROTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Dec 2020 09:19:00 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BIE2xYK063507;
        Fri, 18 Dec 2020 09:18:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=THKVBcdGhN1X/toN+0kOB7VjP8oEr99mpBGOO2BGxNU=;
 b=SUR3pHHwMRsxRvzmliOhvCAL/IVoF7ahriolPt9egrMHxx5rOk6l+qs2rIv/aTGLHxuJ
 DPntxLzcQ5JzyWsyDUnH1p1WH33NSkV9J6Km7hAcBa2Qpsj2Sljm6WGF2nEF+AGpD1gF
 67crGqZmHpy2I9eVw++MZlv3a8rTt9laX6VuG3T0SK/JOmqpidh5y5KAcK5D/8PwyfIV
 IBvp0qzq5LVdXFcMPXiCy4LA+0rRFM+Cvf+F56HFgGS+s3SkKxi+oTboZFyStdRx35MU
 qpbQbPl5lMkFWcAKuOpv9XdBhVVCJMqPSqovGqJ6/ziyj5nlOABdNrFC0l0iIQt8T3k4 yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35gwk7h2bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 09:18:18 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BIE57Do076147;
        Fri, 18 Dec 2020 09:18:18 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35gwk7h2aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 09:18:18 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BIEGle6015069;
        Fri, 18 Dec 2020 14:18:16 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 35cng8bbw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 14:18:16 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BIEIDU850987518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 14:18:13 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E22BA4062;
        Fri, 18 Dec 2020 14:18:13 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B40FCA4060;
        Fri, 18 Dec 2020 14:18:12 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.12.102])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Dec 2020 14:18:12 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v1 2/4] s390/kvm: extend guest_translate for MVPG interpretation
Date:   Fri, 18 Dec 2020 15:18:09 +0100
Message-Id: <20201218141811.310267-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201218141811.310267-1-imbrenda@linux.ibm.com>
References: <20201218141811.310267-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_09:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180095
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Extend guest_translate to optionally return the address of the guest
DAT table which caused the exception, and change the return value to int.

Also return the appropriate values in the low order bits of the address
indicating protection or EDAT.

Cc: stable@vger.kernel.org
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 6d6b57059493..8e256a233583 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -598,6 +598,10 @@ static int deref_table(struct kvm *kvm, unsigned long gpa, unsigned long *val)
  * @asce: effective asce
  * @mode: indicates the access mode to be used
  * @prot: returns the type for protection exceptions
+ * @entryptr: returns the physical address of the last DAT table entry
+ *            processed, additionally setting a few flags in the lower bits
+ *            to indicate whether a translation exception or a protection
+ *            exception were encountered during the address translation.
  *
  * Translate a guest virtual address into a guest absolute address by means
  * of dynamic address translation as specified by the architecture.
@@ -611,9 +615,10 @@ static int deref_table(struct kvm *kvm, unsigned long gpa, unsigned long *val)
  *	      the returned value is the program interruption code as defined
  *	      by the architecture
  */
-static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
-				     unsigned long *gpa, const union asce asce,
-				     enum gacc_mode mode, enum prot_type *prot)
+static int guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
+			   unsigned long *gpa, const union asce asce,
+			   enum gacc_mode mode, enum prot_type *prot,
+			   unsigned long *entryptr)
 {
 	union vaddress vaddr = {.addr = gva};
 	union raddress raddr = {.addr = gva};
@@ -628,6 +633,8 @@ static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
 	edat1 = ctlreg0.edat && test_kvm_facility(vcpu->kvm, 8);
 	edat2 = edat1 && test_kvm_facility(vcpu->kvm, 78);
 	iep = ctlreg0.iep && test_kvm_facility(vcpu->kvm, 130);
+	if (entryptr)
+		*entryptr = 0;
 	if (asce.r)
 		goto real_address;
 	ptr = asce.origin * PAGE_SIZE;
@@ -667,6 +674,8 @@ static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
 			return PGM_ADDRESSING;
 		if (deref_table(vcpu->kvm, ptr, &rfte.val))
 			return -EFAULT;
+		if (entryptr)
+			*entryptr = ptr;
 		if (rfte.i)
 			return PGM_REGION_FIRST_TRANS;
 		if (rfte.tt != TABLE_TYPE_REGION1)
@@ -685,6 +694,8 @@ static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
 			return PGM_ADDRESSING;
 		if (deref_table(vcpu->kvm, ptr, &rste.val))
 			return -EFAULT;
+		if (entryptr)
+			*entryptr = ptr;
 		if (rste.i)
 			return PGM_REGION_SECOND_TRANS;
 		if (rste.tt != TABLE_TYPE_REGION2)
@@ -703,6 +714,8 @@ static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
 			return PGM_ADDRESSING;
 		if (deref_table(vcpu->kvm, ptr, &rtte.val))
 			return -EFAULT;
+		if (entryptr)
+			*entryptr = ptr;
 		if (rtte.i)
 			return PGM_REGION_THIRD_TRANS;
 		if (rtte.tt != TABLE_TYPE_REGION3)
@@ -713,6 +726,8 @@ static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
 			dat_protection |= rtte.fc1.p;
 			iep_protection = rtte.fc1.iep;
 			raddr.rfaa = rtte.fc1.rfaa;
+			if (entryptr)
+				*entryptr |= dat_protection ? 6 : 4;
 			goto absolute_address;
 		}
 		if (vaddr.sx01 < rtte.fc0.tf)
@@ -731,6 +746,8 @@ static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
 			return PGM_ADDRESSING;
 		if (deref_table(vcpu->kvm, ptr, &ste.val))
 			return -EFAULT;
+		if (entryptr)
+			*entryptr = ptr;
 		if (ste.i)
 			return PGM_SEGMENT_TRANSLATION;
 		if (ste.tt != TABLE_TYPE_SEGMENT)
@@ -741,6 +758,8 @@ static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
 			dat_protection |= ste.fc1.p;
 			iep_protection = ste.fc1.iep;
 			raddr.sfaa = ste.fc1.sfaa;
+			if (entryptr)
+				*entryptr |= dat_protection ? 6 : 4;
 			goto absolute_address;
 		}
 		dat_protection |= ste.fc0.p;
@@ -751,10 +770,14 @@ static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
 		return PGM_ADDRESSING;
 	if (deref_table(vcpu->kvm, ptr, &pte.val))
 		return -EFAULT;
+	if (entryptr)
+		*entryptr = ptr;
 	if (pte.i)
 		return PGM_PAGE_TRANSLATION;
 	if (pte.z)
 		return PGM_TRANSLATION_SPEC;
+	if (entryptr && dat_protection)
+		*entryptr |= 2;
 	dat_protection |= pte.p;
 	iep_protection = pte.iep;
 	raddr.pfra = pte.pfra;
@@ -810,7 +833,7 @@ static int guest_page_range(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 					 PROT_TYPE_LA);
 		ga &= PAGE_MASK;
 		if (psw_bits(*psw).dat) {
-			rc = guest_translate(vcpu, ga, pages, asce, mode, &prot);
+			rc = guest_translate(vcpu, ga, pages, asce, mode, &prot, NULL);
 			if (rc < 0)
 				return rc;
 		} else {
@@ -920,7 +943,7 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 	}
 
 	if (psw_bits(*psw).dat && !asce.r) {	/* Use DAT? */
-		rc = guest_translate(vcpu, gva, gpa, asce, mode, &prot);
+		rc = guest_translate(vcpu, gva, gpa, asce, mode, &prot, NULL);
 		if (rc > 0)
 			return trans_exc(vcpu, rc, gva, 0, mode, prot);
 	} else {
-- 
2.26.2

