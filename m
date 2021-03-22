Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417B23446A5
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 15:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhCVOG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 10:06:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63584 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230467AbhCVOGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 10:06:07 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ME4CZT118087;
        Mon, 22 Mar 2021 10:06:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/FH/BY9cKHJnsdtLem9lZfE4bqb2oejz5WbHJAJtWLo=;
 b=o9AydZfQWQduFxlcHOSE+1ikbUG78EIYLh4rXAHnVY9AsdgkvI1KuFg8hFUU6Pleas5q
 bIvfsVZL7ObDLZ0TqBS3lCvKv81r9xb1GCdHSqgSxk8uUjnZi4A56fTft4wIA73nCmzs
 HhWs2p1Y0V7gUpQw05ZYvUyAnvk9yz+PEQLvBycra1g1eXirZo/+nAnrKu9oqEAHz+4H
 iBe1hDboNwKrOUNUfUoXvPqwj8hEiW4Iz9GWOJ/u6/ToZ0+a+XHepHjcNLdiShsoSFbo
 6PPqEl0AbaAUwDj0BtkfPR5jA+IWZ4y+obAv+PTKz2CsYYX27/1j29IHYpEXyq2RINtN OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ef8b2t8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 10:06:05 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12ME5TZ2128701;
        Mon, 22 Mar 2021 10:06:05 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ef8b2t86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 10:06:05 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12ME3OaA010532;
        Mon, 22 Mar 2021 14:06:03 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 37df68a0p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 14:06:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12ME601949021314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 14:06:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF2BE4C04A;
        Mon, 22 Mar 2021 14:06:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5ABCD4C052;
        Mon, 22 Mar 2021 14:06:00 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.2.56])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Mar 2021 14:06:00 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org, Thomas Huth <thuth@redhat.com>
Subject: [PATCH v2 1/2] s390/kvm: split kvm_s390_real_to_abs
Date:   Mon, 22 Mar 2021 15:05:58 +0100
Message-Id: <20210322140559.500716-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210322140559.500716-1-imbrenda@linux.ibm.com>
References: <20210322140559.500716-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-22_07:2021-03-22,2021-03-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103220103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A new function _kvm_s390_real_to_abs will apply prefixing to a real address
with a given prefix value.

The old kvm_s390_real_to_abs becomes now a wrapper around the new function.

This is needed to avoid code duplication in vSIE.

Cc: stable@vger.kernel.org
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
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

