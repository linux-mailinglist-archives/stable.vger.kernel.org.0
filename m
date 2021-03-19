Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092CF342648
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 20:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhCSTeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 15:34:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10302 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230484AbhCSTeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 15:34:02 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JJXZeS163337;
        Fri, 19 Mar 2021 15:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EL0EXsKdn+CdnE+hMLx4Kn1Qd6h/HPL7TktJ9faigO8=;
 b=VKky4RZmsxfliRmKcwXy7F7ujTPFAoGO3EOqPH/IwpQxtH0ozTsb1Rd+Z7nrSF2POpYT
 U1/4n9phA3jYIHKwoNVvwAESYOGHcFEgI7K8JPZYXOWM3NbzueNSgs9Skkp06+SFC/P7
 c+hZprAIXgz48TQhiMkS7972XTAI/VYqbaKe3/FH3DRdH7c4z6eD7+aOoYRWGf+CKZUH
 odoYBti19bdcIHVBvJfSB1y93gczC66HVycLtVouU1ggGk46yCV6OtO25KJ08sB8LlUz
 NHiPYFu8kVB0agQ8nihMc9iMxv66LZPH7WDw03X7lNeh9k4OV+fSRYbaKmyDPUURDqff pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c2vqn2gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 15:34:01 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12JJXwH2164925;
        Fri, 19 Mar 2021 15:34:01 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c2vqn2g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 15:34:01 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12JJWWuu018953;
        Fri, 19 Mar 2021 19:33:59 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 378n18b649-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 19:33:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12JJXthC35062160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 19:33:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFB05A4054;
        Fri, 19 Mar 2021 19:33:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A596A405F;
        Fri, 19 Mar 2021 19:33:55 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.2.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Mar 2021 19:33:55 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v1 1/2] s390/kvm: split kvm_s390_real_to_abs
Date:   Fri, 19 Mar 2021 20:33:53 +0100
Message-Id: <20210319193354.399587-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210319193354.399587-1-imbrenda@linux.ibm.com>
References: <20210319193354.399587-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_10:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 mlxlogscore=974 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190130
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A new function _kvm_s390_real_to_abs will apply prefixing to a real address
with a given prefix value.

The old kvm_s390_real_to_abs becomes now a wrapper around the new function.

This is needed to avoid code duplication in vSIE.

Cc: stable@vger.kernel.org
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gaccess.h | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index daba10f76936..7c72a5e3449f 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -18,17 +18,14 @@
 
 /**
  * kvm_s390_real_to_abs - convert guest real address to guest absolute address
- * @vcpu - guest virtual cpu
+ * @prefix - guest prefix
  * @gra - guest real address
  *
  * Returns the guest absolute address that corresponds to the passed guest real
- * address @gra of a virtual guest cpu by applying its prefix.
+ * address @gra of by applying the given prefix.
  */
-static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
-						 unsigned long gra)
+static inline unsigned long _kvm_s390_real_to_abs(u32 prefix, unsigned long gra)
 {
-	unsigned long prefix  = kvm_s390_get_prefix(vcpu);
-
 	if (gra < 2 * PAGE_SIZE)
 		gra += prefix;
 	else if (gra >= prefix && gra < prefix + 2 * PAGE_SIZE)
@@ -36,6 +33,20 @@ static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
 	return gra;
 }
 
+/**
+ * kvm_s390_real_to_abs - convert guest real address to guest absolute address
+ * @vcpu - guest virtual cpu
+ * @gra - guest real address
+ *
+ * Returns the guest absolute address that corresponds to the passed guest real
+ * address @gra of a virtual guest cpu by applying its prefix.
+ */
+static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
+						 unsigned long gra)
+{
+	return _kvm_s390_real_to_abs(kvm_s390_get_prefix(vcpu), gra);
+}
+
 /**
  * _kvm_s390_logical_to_effective - convert guest logical to effective address
  * @psw: psw of the guest
-- 
2.26.2

