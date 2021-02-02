Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2EC30C8F9
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238040AbhBBSGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:06:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41840 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237970AbhBBSBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 13:01:17 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 112HiMQP101171;
        Tue, 2 Feb 2021 13:00:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kRbD+R3HK3p+/OMassjuz02AQxvlGXtSjaBE52qMDjY=;
 b=mfshyzT17J2IG5wkNntxKJaZEhfckhamp4mIfHvN7aEPpDDgx+pS5S+dJ7COSpHcDhgJ
 w8/MaGpxlEifK7I6Wzey+6k0mqqEyLHWOd2txCHUc2DPXBZQ9sdP4vskSkU2VhA0hU67
 HC0mnDw3wDx03YzJo0Gx4nI0O+6IllC2rfeCnEW0FbrxnnazZ1XwqiVQtpw+DmPyIUEV
 8Bt0B10pmer/J9BWmt1kN6KcdjvYjXgJwI0G7O6Ck75oxDsGwADl7dDYF/55IjERDkyn
 3S4EeHXl4L2bk1zChPIq5EK0VnsUkllumjSiXmoGsN0BZwrLHworCymtZK6aoedmF6hT ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36fbd40ejf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 13:00:35 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 112HlArN110009;
        Tue, 2 Feb 2021 13:00:35 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36fbd40eh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 13:00:35 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 112Hq9cT021680;
        Tue, 2 Feb 2021 18:00:33 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 36er8y8wpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 18:00:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 112I0LJP27590998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Feb 2021 18:00:21 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 490B8AE045;
        Tue,  2 Feb 2021 18:00:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2259AE05F;
        Tue,  2 Feb 2021 18:00:29 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.15.83])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Feb 2021 18:00:29 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2 2/2] s390/kvm: VSIE: correctly handle MVPG when in VSIE
Date:   Tue,  2 Feb 2021 19:00:28 +0100
Message-Id: <20210202180028.876888-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210202180028.876888-1-imbrenda@linux.ibm.com>
References: <20210202180028.876888-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-02_09:2021-02-02,2021-02-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020115
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Correctly handle the MVPG instruction when issued by a VSIE guest.

Fixes: a3508fbe9dc6d ("KVM: s390: vsie: initial support for nested virtualization")
Cc: stable@vger.kernel.org
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 94 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 89 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 7db022141db3..2db49749e27b 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -416,11 +416,6 @@ static void unshadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		memcpy((void *)((u64)scb_o + 0xc0),
 		       (void *)((u64)scb_s + 0xc0), 0xf0 - 0xc0);
 		break;
-	case ICPT_PARTEXEC:
-		/* MVPG only */
-		memcpy((void *)((u64)scb_o + 0xc0),
-		       (void *)((u64)scb_s + 0xc0), 0xd0 - 0xc0);
-		break;
 	}
 
 	if (scb_s->ihcpu != 0xffffU)
@@ -982,6 +977,91 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	return 0;
 }
 
+static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, u8 reg)
+{
+	reg &= 0xf;
+	switch (reg) {
+	case 15:
+		return vsie_page->scb_s.gg15;
+	case 14:
+		return vsie_page->scb_s.gg14;
+	default:
+		return vcpu->run->s.regs.gprs[reg];
+	}
+}
+
+static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
+{
+	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
+	unsigned long pei1, pei2, src, dest, mask = PAGE_MASK;
+	u64 *pei_block = &vsie_page->scb_o->mcic;
+	int edat, rc1, rc2;
+	union ctlreg0 cr0;
+
+	cr0.val = vcpu->arch.sie_block->gcr[0];
+	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
+	if (psw_bits(scb_s->gpsw).eaba == PSW_BITS_AMODE_24BIT)
+		mask = 0xfff000;
+	else if (psw_bits(scb_s->gpsw).eaba == PSW_BITS_AMODE_31BIT)
+		mask = 0x7ffff000;
+
+	dest = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
+	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 20) & mask;
+
+	rc1 = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, dest, &pei1);
+	rc2 = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, src, &pei2);
+	/*
+	 * Either everything went well, or something non-critical went wrong
+	 * e.g. beause of a race. In either case, simply retry.
+	 */
+	if (rc1 == -EAGAIN || rc2 == -EAGAIN || (!rc1 && !rc2)) {
+		retry_vsie_icpt(vsie_page);
+		return -EAGAIN;
+	}
+	/* Something more serious went wrong, propagate the error */
+	if (rc1 < 0)
+		return rc1;
+	if (rc2 < 0)
+		return rc2;
+
+	/* The only possible suppressing exception: just deliver it */
+	if (rc1 == PGM_TRANSLATION_SPEC || rc2 == PGM_TRANSLATION_SPEC) {
+		clear_vsie_icpt(vsie_page);
+		rc1 = kvm_s390_inject_program_int(vcpu, PGM_TRANSLATION_SPEC);
+		WARN_ON_ONCE(rc1);
+		return 1;
+	}
+
+	/*
+	 * Forward the PEI intercept to the guest if it was a page fault, or
+	 * also for segment and region table faults if EDAT applies.
+	 */
+	if (edat) {
+		rc1 = rc1 == PGM_ASCE_TYPE ? rc1 : 0;
+		rc2 = rc2 == PGM_ASCE_TYPE ? rc2 : 0;
+	}
+	if ((!rc1 || rc1 == PGM_PAGE_TRANSLATION) && (!rc2 || rc2 == PGM_PAGE_TRANSLATION)) {
+		pei_block[0] = pei1;
+		pei_block[1] = pei2;
+		return 1;
+	}
+
+	retry_vsie_icpt(vsie_page);
+
+	/*
+	 * The host has edat, and the guest does not, or it was an ASCE type
+	 * exception. The host needs to inject the appropriate DAT interrupts
+	 * into the guest.
+	 */
+	if (rc1)
+		return inject_fault(vcpu, rc1, dest, 1);
+	if (rc2)
+		return inject_fault(vcpu, rc2, src, 0);
+
+	/* This should never be reached */
+	return 0;
+}
+
 /*
  * Run the vsie on a shadow scb and a shadow gmap, without any further
  * sanity checks, handling SIE faults.
@@ -1068,6 +1148,10 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		if ((scb_s->ipa & 0xf000) != 0xf000)
 			scb_s->ipa += 0x1000;
 		break;
+	case ICPT_PARTEXEC:
+		if (scb_s->ipa == 0xb254)
+			rc = vsie_handle_mvpg(vcpu, vsie_page);
+		break;
 	}
 	return rc;
 }
-- 
2.26.2

