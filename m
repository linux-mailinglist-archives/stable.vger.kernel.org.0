Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D0232B242
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343531AbhCCAxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52208 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1580883AbhCBSWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 13:22:11 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122HfHdq144663;
        Tue, 2 Mar 2021 12:44:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1cE9khy75oU83lu8wyMDxQ8z9MewDjMD8OjM3nj/glA=;
 b=hjIbu0Ad/Pi5g95Yzy8H9E+6mV4odt6ygc73PVrWseQ8GYnZ1NPrndTOZqKTQdzpyKfb
 7Zjm6XhB0i5tC2rFYSVndZZxkgi4wzDKBZ5U7mu5p99v3OASh4ZfNwKTU4UILkqfLjEI
 c2rM8E5C2wibyUUQJ2QpgIbGdfNEHSiItbhsa/IjmIo95mylm756mmFfho9w4KHBSwBM
 cOlilqPq6DvXV5PmMoCr9pe1S+bOqZ8d/64qO77Z3eM8lOFlrmfHIGQrmb9MCajOqXqt
 W8aBh2LhCCsdoUovqdVIHaE0fZPb6iA+dtFm3MiKq5vueceYU/QwtLXfopj72Mrs2MkB Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 371rwfa1y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 12:44:50 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 122HfJfX144796;
        Tue, 2 Mar 2021 12:44:49 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 371rwfa1xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 12:44:49 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 122Hgqb7025442;
        Tue, 2 Mar 2021 17:44:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 370c59t465-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 17:44:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 122Hijmf47513962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 17:44:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA1705204E;
        Tue,  2 Mar 2021 17:44:44 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.194])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 888C552052;
        Tue,  2 Mar 2021 17:44:44 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v5 3/3] s390/kvm: VSIE: correctly handle MVPG when in VSIE
Date:   Tue,  2 Mar 2021 18:44:43 +0100
Message-Id: <20210302174443.514363-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210302174443.514363-1-imbrenda@linux.ibm.com>
References: <20210302174443.514363-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020136
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Correctly handle the MVPG instruction when issued by a VSIE guest.

Fixes: a3508fbe9dc6d ("KVM: s390: vsie: initial support for nested virtualization")
Cc: stable@vger.kernel.org
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/kvm/vsie.c | 98 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 93 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 78b604326016..48aab6290a77 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -417,11 +417,6 @@ static void unshadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
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
@@ -983,6 +978,95 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	return 0;
 }
 
+/*
+ * Get a register for a nested guest.
+ * @vcpu the vcpu of the guest
+ * @vsie_page the vsie_page for the nested guest
+ * @reg the register number, the upper 4 bits are ignored.
+ * returns: the value of the register.
+ */
+static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, u8 reg)
+{
+	/* no need to validate the parameter and/or perform error handling */
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
+	unsigned long pei_dest, pei_src, src, dest, mask;
+	u64 *pei_block = &vsie_page->scb_o->mcic;
+	int edat, rc_dest, rc_src;
+	union ctlreg0 cr0;
+
+	cr0.val = vcpu->arch.sie_block->gcr[0];
+	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
+	mask = _kvm_s390_logical_to_effective(&scb_s->gpsw, PAGE_MASK);
+
+	dest = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
+	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 20) & mask;
+
+	rc_dest = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, dest, &pei_dest);
+	rc_src = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, src, &pei_src);
+	/*
+	 * Either everything went well, or something non-critical went wrong
+	 * e.g. because of a race. In either case, simply retry.
+	 */
+	if (rc_dest == -EAGAIN || rc_src == -EAGAIN || (!rc_dest && !rc_src)) {
+		retry_vsie_icpt(vsie_page);
+		return -EAGAIN;
+	}
+	/* Something more serious went wrong, propagate the error */
+	if (rc_dest < 0)
+		return rc_dest;
+	if (rc_src < 0)
+		return rc_src;
+
+	/* The only possible suppressing exception: just deliver it */
+	if (rc_dest == PGM_TRANSLATION_SPEC || rc_src == PGM_TRANSLATION_SPEC) {
+		clear_vsie_icpt(vsie_page);
+		rc_dest = kvm_s390_inject_program_int(vcpu, PGM_TRANSLATION_SPEC);
+		WARN_ON_ONCE(rc_dest);
+		return 1;
+	}
+
+	/*
+	 * Forward the PEI intercept to the guest if it was a page fault, or
+	 * also for segment and region table faults if EDAT applies.
+	 */
+	if (edat) {
+		rc_dest = rc_dest == PGM_ASCE_TYPE ? rc_dest : 0;
+		rc_src = rc_src == PGM_ASCE_TYPE ? rc_src : 0;
+	} else {
+		rc_dest = rc_dest != PGM_PAGE_TRANSLATION ? rc_dest : 0;
+		rc_src = rc_src != PGM_PAGE_TRANSLATION ? rc_src : 0;
+	}
+	if (!rc_dest && !rc_src) {
+		pei_block[0] = pei_dest;
+		pei_block[1] = pei_src;
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
+	if (rc_dest)
+		return inject_fault(vcpu, rc_dest, dest, 1);
+	return inject_fault(vcpu, rc_src, src, 0);
+}
+
 /*
  * Run the vsie on a shadow scb and a shadow gmap, without any further
  * sanity checks, handling SIE faults.
@@ -1071,6 +1155,10 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
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

