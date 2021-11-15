Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476D545031A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 12:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237593AbhKOLJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 06:09:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54174 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237758AbhKOLIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 06:08:55 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFA9ZcN019537;
        Mon, 15 Nov 2021 11:05:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=mCqRgzGQnhVD9msLQSjKV1UmjPmQoJcYUO8Fij8Qitk=;
 b=CyEZcc+Kq3728u0sXaV2QDmHYf9PRQex11t/ySlXy/Pc8wj32bHO/XzHQvMcLljzryww
 PEgTQnKXkuUvoT0khQaU7Y2vd0kZxOL8KLZ0a8Z0d2AcUO2utNxafhHnAd6LExXPFDS6
 1HIIMg51tAx/m+6kO3t8L4ojkEpe1OikAR1j/ljqgtzEmbZZ7KQbIH+BkSyZwpzHzhnv
 1Is0d/ZjPJVY/4UobR2ycShF4nTzdTbqI4yKk/sOuqjU/oAPFWH9Zpr2V7P1aBYexEPp
 kodlTUwH4lU3yujhjqWOj/0TcnHHCNj/j6jkTJRjRJGmwWXQozjEsBTC/UeHNayZ4WN1 cQ== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cbf32ryxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:05:46 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFB3fOr001979;
        Mon, 15 Nov 2021 11:05:44 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3ca509kwve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:05:44 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFAwqaF64815364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 10:58:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5425EA4082;
        Mon, 15 Nov 2021 11:05:42 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2306BA407C;
        Mon, 15 Nov 2021 11:05:41 +0000 (GMT)
Received: from naverao1-tp.ibm.com (unknown [9.43.37.229])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Nov 2021 11:05:40 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     <stable@vger.kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.19 3/5] powerpc/bpf: Fix BPF_SUB when imm == 0x80000000
Date:   Mon, 15 Nov 2021 16:35:30 +0530
Message-Id: <5e5c7b933e9da0cb509a1172b7a2c2d17796e952.1636968020.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636968020.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1636968020.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hVuy9oyQaSqyIqGIUpn8-9LSGipTk9yy
X-Proofpoint-ORIG-GUID: hVuy9oyQaSqyIqGIUpn8-9LSGipTk9yy
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
index b0abf59cc6a27d..9cec2744f4118c 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -326,18 +326,25 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
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

