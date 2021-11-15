Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933C2450306
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 12:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbhKOLFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 06:05:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24836 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237905AbhKOLEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 06:04:12 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFAb3si010212;
        Mon, 15 Nov 2021 11:00:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=L/UqaeoKlyhDPnGmKqY0Fghn+lThNpefpsMuEB7phTo=;
 b=Lg1kiK9UPDiqpD5WhLykcWxPC5gdGXzaTSvwC2b8YtIKS1QFvUiKTGG6UfkukO0AJKIk
 WE0KbUgw8B5duVNW/rl0fzWFsZGGwlqQ7es6PjVZosUQKHaCVfPtPj1pBLuod7402IDW
 WQaCCbZg+1Q6/RqnbWTTD6pLUu6R5VhNNpVMQw/uCVycxm6fu/eOBzN05yFI9Ifc9frB
 6RNbKnB/Wi0mLc8RQ94xfrl4UoXM/H/FBYOWoN66ukc5yy6kUQSt3L69lGEi9wZgK1JJ
 6oWbDAReFYNweEwfOxvP0hXN0FH6FWYHbPY1G4nvShA1nuShKguZCZTKAZGcY0hxTHEM HQ== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cbk6pv39y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:00:57 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFAweiS026835;
        Mon, 15 Nov 2021 11:00:49 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3ca509bveb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:00:49 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFB0k4K60490026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 11:00:46 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2BEC5204E;
        Mon, 15 Nov 2021 11:00:45 +0000 (GMT)
Received: from naverao1-tp.ibm.com (unknown [9.43.37.229])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8D8045205F;
        Mon, 15 Nov 2021 11:00:44 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     <stable@vger.kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.9 2/2] powerpc/bpf: Fix BPF_SUB when imm == 0x80000000
Date:   Mon, 15 Nov 2021 16:30:37 +0530
Message-Id: <552698f49119e7682a578f84d841c505ad4e976b.1636969865.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636969865.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1636969865.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vJw9jJK-9ZIbPGwL9LTL3Sxp2-NhYlm2
X-Proofpoint-GUID: vJw9jJK-9ZIbPGwL9LTL3Sxp2-NhYlm2
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
index 3f867e79dfaa75..5a834e34c5b4d8 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -363,18 +363,25 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
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

