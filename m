Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97247450316
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 12:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhKOLJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 06:09:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6202 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237748AbhKOLIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 06:08:52 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFA5J6R009784;
        Mon, 15 Nov 2021 11:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=XowE8hQ6M59secF9AG5Ql+irz6IsBJjAiXnlReZmvvE=;
 b=O8DNkemtGVF8oUmsWAX9ukWJIgKQgPhwRtMyn/81YExS/v49Zkme6Xmg5NXSnTIlDdoP
 8qv3rsBX0OpuRNzQS82kzu3DUlp2Ard01AbbzrFAWbutt+5tacDVbnlUq640xC7Xv0yn
 QRwwVGRiCnSPJPTtbz1sgVBZ9SFXBBVs1dth6t12wbpgy/LE4e8T+7gYhlyKI9cvZtb4
 Txz7Xu0OuxqA8wVq0Em8luNxHBKksbrXY3LJ8cJ0McUb+9c0RQmLNPa75shca9qhv/g5
 +g/tIc73eQ3TFM2SNGAhymIGt0B1/vJf4AmhcdtWBTCQ5LUXlj8Rj1HNIX+CR7oCC4+a 1g== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cbjqn4s4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:05:43 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFB1ZJD008090;
        Mon, 15 Nov 2021 11:05:41 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3ca509mj7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:05:41 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFB5dr655837098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 11:05:39 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2AF85A406B;
        Mon, 15 Nov 2021 11:05:39 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF6A8A4081;
        Mon, 15 Nov 2021 11:05:37 +0000 (GMT)
Received: from naverao1-tp.ibm.com (unknown [9.43.37.229])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Nov 2021 11:05:37 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     <stable@vger.kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.19 1/5] powerpc/lib: Add helper to check if offset is within conditional branch range
Date:   Mon, 15 Nov 2021 16:35:28 +0530
Message-Id: <7b757e056b85dc60a0ab84dafb6b648d017a02ea.1636968020.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636968020.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1636968020.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: G0jkVn0rpjv2E6TCVxRTLbzMV_8qIcn1
X-Proofpoint-GUID: G0jkVn0rpjv2E6TCVxRTLbzMV_8qIcn1
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111150061
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

upstream commit 4549c3ea3160fa8b3f37dfe2f957657bb265eda9

Add a helper to check if a given offset is within the branch range for a
powerpc conditional branch instruction, and update some sites to use the
new helper.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/442b69a34ced32ca346a0d9a855f3f6cfdbbbd41.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/code-patching.h | 1 +
 arch/powerpc/lib/code-patching.c         | 7 ++++++-
 arch/powerpc/net/bpf_jit.h               | 7 +------
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/code-patching.h b/arch/powerpc/include/asm/code-patching.h
index 4cd6e19ee90f43..537d94fabbd05e 100644
--- a/arch/powerpc/include/asm/code-patching.h
+++ b/arch/powerpc/include/asm/code-patching.h
@@ -26,6 +26,7 @@
 #define BRANCH_ABSOLUTE	0x2
 
 bool is_offset_in_branch_range(long offset);
+bool is_offset_in_cond_branch_range(long offset);
 unsigned int create_branch(const unsigned int *addr,
 			   unsigned long target, int flags);
 unsigned int create_cond_branch(const unsigned int *addr,
diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index 5ffee298745fe4..bb245dbf6c57b7 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -243,6 +243,11 @@ bool is_offset_in_branch_range(long offset)
 	return (offset >= -0x2000000 && offset <= 0x1fffffc && !(offset & 0x3));
 }
 
+bool is_offset_in_cond_branch_range(long offset)
+{
+	return offset >= -0x8000 && offset <= 0x7fff && !(offset & 0x3);
+}
+
 /*
  * Helper to check if a given instruction is a conditional branch
  * Derived from the conditional checks in analyse_instr()
@@ -296,7 +301,7 @@ unsigned int create_cond_branch(const unsigned int *addr,
 		offset = offset - (unsigned long)addr;
 
 	/* Check we can represent the target in the instruction format */
-	if (offset < -0x8000 || offset > 0x7FFF || offset & 0x3)
+	if (!is_offset_in_cond_branch_range(offset))
 		return 0;
 
 	/* Mask out the flags and target, so they don't step on each other. */
diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index e5c1d30ee968b4..d2bf99183aab86 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -221,11 +221,6 @@
 #define PPC_FUNC_ADDR(d,i) do { PPC_LI32(d, i); } while(0)
 #endif
 
-static inline bool is_nearbranch(int offset)
-{
-	return (offset < 32768) && (offset >= -32768);
-}
-
 /*
  * The fly in the ointment of code size changing from pass to pass is
  * avoided by padding the short branch case with a NOP.	 If code size differs
@@ -234,7 +229,7 @@ static inline bool is_nearbranch(int offset)
  * state.
  */
 #define PPC_BCC(cond, dest)	do {					      \
-		if (is_nearbranch((dest) - (ctx->idx * 4))) {		      \
+		if (is_offset_in_cond_branch_range((long)(dest) - (ctx->idx * 4))) {	\
 			PPC_BCC_SHORT(cond, dest);			      \
 			PPC_NOP();					      \
 		} else {						      \
-- 
2.33.1

