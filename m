Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E858450311
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 12:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhKOLIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 06:08:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17382 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237743AbhKOLIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 06:08:36 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFAnYJQ008956;
        Mon, 15 Nov 2021 11:05:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=RoIyEYJ0lcI3+dkFpdqCbjHtEERUYgU570ZfJk2dwos=;
 b=QwtLGZxLW+02G6QzI6eqR1x3OQagFIvl+3iHFRaYNUi1NoXlfbubuEF+b9eIQiub/QHQ
 /dH7r1C6Gi6L4+if979nRqlWgOm69VrR3aWFO/HW1VTvlxC1miyube0I20/ogxwAWbG/
 Ly8aq0+Mw4iorJOO2EsQ0nsK5Kv2vuT8aS2E4P7dEDfKNpS5nFL5vzxgQfLdoWa4eZmJ
 B5MpkJBeYTXIjZ7TP9vHi3whJusGuCjV8awToWdmsT0NeJvjlY4p/dUDheGEJ8PWrqgI
 Wyaj98O6FoPJWfp/pB89FnN+pHPGBkTAHIWeuxdjRml2hFlfrt3JF3K1l3GGCsOupKGf Xg== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cbp4uga8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:05:22 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFB2dHg002907;
        Mon, 15 Nov 2021 11:05:20 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3ca509bwy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:05:20 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFB5Gg266519480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 11:05:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C92B7A4089;
        Mon, 15 Nov 2021 11:05:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97E8BA407C;
        Mon, 15 Nov 2021 11:05:15 +0000 (GMT)
Received: from naverao1-tp.ibm.com (unknown [9.43.37.229])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Nov 2021 11:05:15 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     <stable@vger.kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.14 3/3] powerpc/bpf: Fix BPF_SUB when imm == 0x80000000
Date:   Mon, 15 Nov 2021 16:35:08 +0530
Message-Id: <5679896bb270f8a7bbbd5d2b2b7588a820231a21.1636968906.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636968906.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1636968906.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JyezJWJMKp3Otjfn8ZDJY3c1MwLGIE5H
X-Proofpoint-GUID: JyezJWJMKp3Otjfn8ZDJY3c1MwLGIE5H
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111150061
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

upstream commit 5855c4c1f415ca3ba1046e77c0b3d3dfc96c9025

We aren't handling subtraction involving an immediate value of
0x80000000 properly. Fix the same.

Fixes: 156d0e290e969c ("powerpc/ebpf/jit: Implement JIT compiler for extended BPF")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Fold in fix from Naveen to use imm <= 32768]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/fc4b1276eb10761fd7ce0814c8dd089da2815251.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
[adjust macros to account for commits 0654186510a40e and 3a181237916310]
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/powerpc/net/bpf_jit_comp64.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index c38cba170c38c2..c504d5bc7d432c 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -359,18 +359,25 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 			PPC_SUB(dst_reg, dst_reg, src_reg);
 			goto bpf_alu32_trunc;
 		case BPF_ALU | BPF_ADD | BPF_K: /* (u32) dst += (u32) imm */
-		case BPF_ALU | BPF_SUB | BPF_K: /* (u32) dst -= (u32) imm */
 		case BPF_ALU64 | BPF_ADD | BPF_K: /* dst += imm */
+			if (!imm) {
+				goto bpf_alu32_trunc;
+			} else if (imm >= -32768 && imm < 32768) {
+				PPC_ADDI(dst_reg, dst_reg, IMM_L(imm));
+			} else {
+				PPC_LI32(b2p[TMP_REG_1], imm);
+				PPC_ADD(dst_reg, dst_reg, b2p[TMP_REG_1]);
+			}
+			goto bpf_alu32_trunc;
+		case BPF_ALU | BPF_SUB | BPF_K: /* (u32) dst -= (u32) imm */
 		case BPF_ALU64 | BPF_SUB | BPF_K: /* dst -= imm */
-			if (BPF_OP(code) == BPF_SUB)
-				imm = -imm;
-			if (imm) {
-				if (imm >= -32768 && imm < 32768)
-					PPC_ADDI(dst_reg, dst_reg, IMM_L(imm));
-				else {
-					PPC_LI32(b2p[TMP_REG_1], imm);
-					PPC_ADD(dst_reg, dst_reg, b2p[TMP_REG_1]);
-				}
+			if (!imm) {
+				goto bpf_alu32_trunc;
+			} else if (imm > -32768 && imm <= 32768) {
+				PPC_ADDI(dst_reg, dst_reg, IMM_L(-imm));
+			} else {
+				PPC_LI32(b2p[TMP_REG_1], imm);
+				PPC_SUB(dst_reg, dst_reg, b2p[TMP_REG_1]);
 			}
 			goto bpf_alu32_trunc;
 		case BPF_ALU | BPF_MUL | BPF_X: /* (u32) dst *= (u32) src */
-- 
2.33.1

