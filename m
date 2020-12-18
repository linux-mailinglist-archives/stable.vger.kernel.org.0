Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311CE2DE3D7
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 15:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgLROTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 09:19:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42526 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726047AbgLROTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Dec 2020 09:19:00 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BIE31Bx063640;
        Fri, 18 Dec 2020 09:18:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=TfbnlqyNfW5YJJ7mzLhRypVA0089I6ipr+CSsWxxKq8=;
 b=NEGDfbg2go61ylUBMyCI+jxEx/pe24cDhMhRJVcENfkINQB+0Zg4wnHaaTx/pmo1/8Ei
 QbmIWB7ftr644p8inYNImUdXI819G3Ac0A0BKoCg2XrXTAdDoL+jYnvv4UXy4BwYfsF2
 zgcn+nPJsIjsWAe5JRI9rDn1X8lTEVAOpwX5KoFENq8r4ZO0PyMv6NmIGIXDHmPTM8xi
 XJDBcRVPEXJd7T4WiHG9NedavlISSa7G76rEZQnDAHN5fKYEOTRtmaG0jPMCuDQEGZHH
 eGVFb6qoUP30okgoNgTnColsXHLNnXuzL4xCp0XU4lK2Fr5KafvT+O6S5vOX+Qdt8VMG og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35gwk7h2bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 09:18:18 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BIE3ftp067502;
        Fri, 18 Dec 2020 09:18:18 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35gwk7h2b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 09:18:18 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BIEIGpl012367;
        Fri, 18 Dec 2020 14:18:16 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 35cng889nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 14:18:16 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BIEIDST48103764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 14:18:13 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89D57A4060;
        Fri, 18 Dec 2020 14:18:13 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FB8AA4066;
        Fri, 18 Dec 2020 14:18:13 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.12.102])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Dec 2020 14:18:13 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v1 3/4] s390/kvm: add kvm_s390_vsie_mvpg_check needed for VSIE MVPG
Date:   Fri, 18 Dec 2020 15:18:10 +0100
Message-Id: <20201218141811.310267-4-imbrenda@linux.ibm.com>
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

Add kvm_s390_vsie_mvpg_check to perform the necessary checks in case an
MVPG instruction intercepts in a VSIE guest.

Cc: stable@vger.kernel.org
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c | 55 +++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/gaccess.h |  3 +++
 2 files changed, 58 insertions(+)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 8e256a233583..90e9baff6eac 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -1228,3 +1228,58 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
 	mmap_read_unlock(sg->mm);
 	return rc;
 }
+
+static int kvm_s390_mvpg_check_one(struct kvm_vcpu *vcpu, unsigned long *addr,
+			     const int edat, const union asce asce,
+			     const enum gacc_mode mode, unsigned long *pteptr)
+{
+	enum prot_type prot;
+	int rc;
+
+	rc = guest_translate(vcpu, *addr, addr, asce, mode, &prot, pteptr);
+	if (rc <= 0)
+		return rc;
+
+	switch (rc) {
+	case PGM_REGION_FIRST_TRANS:
+	case PGM_REGION_SECOND_TRANS:
+	case PGM_REGION_THIRD_TRANS:
+	case PGM_SEGMENT_TRANSLATION:
+		if (!edat)
+			return trans_exc(vcpu, rc, *addr, 0, mode, prot);
+		*pteptr |= 4;
+		fallthrough;
+	case PGM_PAGE_TRANSLATION:
+		return -ENOENT;
+	default:
+		return rc;
+	}
+}
+
+int kvm_s390_vsie_mvpg_check(struct kvm_vcpu *vcpu, unsigned long r1,
+			     unsigned long r2, void *gpei)
+{
+	unsigned long pei[2] = {0};
+	union ctlreg0 cr0;
+	union asce cr1;
+	int edat, rc1, rc2;
+
+	cr0.val = vcpu->arch.sie_block->gcr[0];
+	cr1.val = vcpu->arch.sie_block->gcr[1];
+	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
+
+	rc1 = kvm_s390_mvpg_check_one(vcpu, &r1, edat, cr1, GACC_FETCH, pei);
+	rc2 = kvm_s390_mvpg_check_one(vcpu, &r2, edat, cr1, GACC_STORE, pei + 1);
+
+	if (rc1 == -ENOENT || rc2 == -ENOENT) {
+		memcpy(gpei, pei, sizeof(pei));
+		return -ENOENT;
+	}
+
+	if (rc2 < 0)
+		return rc2;
+	if (rc1 < 0)
+		return rc1;
+
+	return 0;
+}
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index f4c51756c462..2c53cee3b29f 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -166,6 +166,9 @@ int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 		 unsigned long len, enum gacc_mode mode);
 
+int kvm_s390_vsie_mvpg_check(struct kvm_vcpu *vcpu, unsigned long r1,
+			     unsigned long r2, void *gpei);
+
 int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 		      void *data, unsigned long len, enum gacc_mode mode);
 
-- 
2.26.2

