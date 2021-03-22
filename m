Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE08A3446A7
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 15:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhCVOG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 10:06:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15370 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230476AbhCVOGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 10:06:07 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ME2foj101684;
        Mon, 22 Mar 2021 10:06:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=o5/ezRrykEsCBPB8OHmDFl4egzAK3Hsh2HBBwP1sOPo=;
 b=TChO1LnzZrA/PhCh+G3q/0DKx7ChW+tJ03cFFei8AVTn4553ggt5sERBZ2kHde12ye/g
 g7kcnuSbtL/9HJI+Os+Q/ALIoKBY7W1Gvco6TIAetp/6zxNhVZhin1zdxVWrNPW22Xxp
 gVy5DHbto+sqOJbkvfnnToUP5NmmNV0py9k28nZGycKMh8TiRPuu4oi2xrsayqEdETlW
 aqQ625ghFWLYxg3Qr2vDDRQzyY5VCu7BJMCdLsWpLaJKU96E/3umhXXHuTCwf8x29IbV
 +Msz9QFWyXJic+liP5g6s7nY/R5PAAEeC8WennDvUtl8xNmq4gnqEjLlR/zLmtM+b+j5 PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37dx4a2622-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 10:06:07 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12ME2jql102017;
        Mon, 22 Mar 2021 10:06:06 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37dx4a2613-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 10:06:06 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12ME3AZY004990;
        Mon, 22 Mar 2021 14:06:04 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 37d99radsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 14:06:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12ME61QH38666502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 14:06:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45DAB4C05A;
        Mon, 22 Mar 2021 14:06:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE26A4C04E;
        Mon, 22 Mar 2021 14:06:00 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.2.56])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Mar 2021 14:06:00 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2 2/2] s390/kvm: VSIE: fix MVPG handling for prefixing and MSO
Date:   Mon, 22 Mar 2021 15:05:59 +0100
Message-Id: <20210322140559.500716-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210322140559.500716-1-imbrenda@linux.ibm.com>
References: <20210322140559.500716-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-22_07:2021-03-22,2021-03-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Prefixing needs to be applied to the guest real address to translate it
into a guest absolute address.

The value of MSO needs to be added to a guest-absolute address in order to
obtain the host-virtual.

Fixes: 223ea46de9e79 ("s390/kvm: VSIE: correctly handle MVPG when in VSIE")
Cc: stable@vger.kernel.org
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reported-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 48aab6290a77..ac86f11e46dc 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1002,7 +1002,7 @@ static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 {
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
-	unsigned long pei_dest, pei_src, src, dest, mask;
+	unsigned long pei_dest, pei_src, dest, src, mask, mso, prefix;
 	u64 *pei_block = &vsie_page->scb_o->mcic;
 	int edat, rc_dest, rc_src;
 	union ctlreg0 cr0;
@@ -1010,9 +1010,13 @@ static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	cr0.val = vcpu->arch.sie_block->gcr[0];
 	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
 	mask = _kvm_s390_logical_to_effective(&scb_s->gpsw, PAGE_MASK);
+	mso = scb_s->mso & ~(1UL << 20);
+	prefix = scb_s->prefix << GUEST_PREFIX_SHIFT;
 
 	dest = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
+	dest = _kvm_s390_real_to_abs(prefix, dest) + mso;
 	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 20) & mask;
+	src = _kvm_s390_real_to_abs(prefix, src) + mso;
 
 	rc_dest = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, dest, &pei_dest);
 	rc_src = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, src, &pei_src);
-- 
2.26.2

