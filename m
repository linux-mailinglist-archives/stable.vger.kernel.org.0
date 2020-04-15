Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B4B1AA16D
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369972AbgDOMkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:40:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63968 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S369967AbgDOMkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 08:40:21 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FCYU5v110890
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 08:40:19 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30e0wjjv4w-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 08:40:19 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <ajd@linux.ibm.com>;
        Wed, 15 Apr 2020 13:39:41 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 Apr 2020 13:39:40 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03FCeFGr55443674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 12:40:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BE7BA405F;
        Wed, 15 Apr 2020 12:40:15 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08006A405B;
        Wed, 15 Apr 2020 12:40:15 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 Apr 2020 12:40:14 +0000 (GMT)
Received: from intelligence.ibm.com (unknown [9.206.128.45])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 3F193A00A5;
        Wed, 15 Apr 2020 22:40:09 +1000 (AEST)
From:   Andrew Donnellan <ajd@linux.ibm.com>
To:     stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19] powerpc/powernv/idle: Restore AMR/UAMOR/AMOR after idle
Date:   Wed, 15 Apr 2020 22:40:05 +1000
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20041512-0016-0000-0000-00000304FCA8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041512-0017-0000-0000-00003368FACF
Message-Id: <20200415124005.26920-1-ajd@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_03:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=869 spamscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150091
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 53a712bae5dd919521a58d7bad773b949358add0 upstream.

In order to implement KUAP (Kernel Userspace Access Protection) on
Power9 we will be using the AMR, and therefore indirectly the
UAMOR/AMOR.

So save/restore these regs in the idle code.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
[ajd: Backport to 4.19 tree, CVE-2020-11669]
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
 arch/powerpc/kernel/idle_book3s.S | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/idle_book3s.S b/arch/powerpc/kernel/idle_book3s.S
index 36178000a2f2..4a860d3b9229 100644
--- a/arch/powerpc/kernel/idle_book3s.S
+++ b/arch/powerpc/kernel/idle_book3s.S
@@ -170,8 +170,11 @@ core_idle_lock_held:
 	bne-	core_idle_lock_held
 	blr
 
-/* Reuse an unused pt_regs slot for IAMR */
+/* Reuse some unused pt_regs slots for AMR/IAMR/UAMOR/UAMOR */
+#define PNV_POWERSAVE_AMR	_TRAP
 #define PNV_POWERSAVE_IAMR	_DAR
+#define PNV_POWERSAVE_UAMOR	_DSISR
+#define PNV_POWERSAVE_AMOR	RESULT
 
 /*
  * Pass requested state in r3:
@@ -205,8 +208,16 @@ pnv_powersave_common:
 	SAVE_NVGPRS(r1)
 
 BEGIN_FTR_SECTION
+	mfspr	r4, SPRN_AMR
 	mfspr	r5, SPRN_IAMR
+	mfspr	r6, SPRN_UAMOR
+	std	r4, PNV_POWERSAVE_AMR(r1)
 	std	r5, PNV_POWERSAVE_IAMR(r1)
+	std	r6, PNV_POWERSAVE_UAMOR(r1)
+BEGIN_FTR_SECTION_NESTED(42)
+	mfspr	r7, SPRN_AMOR
+	std	r7, PNV_POWERSAVE_AMOR(r1)
+END_FTR_SECTION_NESTED_IFSET(CPU_FTR_HVMODE, 42)
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 
 	mfcr	r5
@@ -935,12 +946,20 @@ END_FTR_SECTION_IFSET(CPU_FTR_HVMODE)
 	REST_GPR(2, r1)
 
 BEGIN_FTR_SECTION
-	/* IAMR was saved in pnv_powersave_common() */
+	/* These regs were saved in pnv_powersave_common() */
+	ld	r4, PNV_POWERSAVE_AMR(r1)
 	ld	r5, PNV_POWERSAVE_IAMR(r1)
+	ld	r6, PNV_POWERSAVE_UAMOR(r1)
+	mtspr	SPRN_AMR, r4
 	mtspr	SPRN_IAMR, r5
+	mtspr	SPRN_UAMOR, r6
+BEGIN_FTR_SECTION_NESTED(42)
+	ld	r7, PNV_POWERSAVE_AMOR(r1)
+	mtspr	SPRN_AMOR, r7
+END_FTR_SECTION_NESTED_IFSET(CPU_FTR_HVMODE, 42)
 	/*
-	 * We don't need an isync here because the upcoming mtmsrd is
-	 * execution synchronizing.
+	 * We don't need an isync here after restoring IAMR because the upcoming
+	 * mtmsrd is execution synchronizing.
 	 */
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 
-- 
2.20.1

