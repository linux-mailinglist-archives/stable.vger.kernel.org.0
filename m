Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C5132D72A
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 16:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235996AbhCDPx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 10:53:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235992AbhCDPxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 10:53:53 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 124FqSXG174208;
        Thu, 4 Mar 2021 10:53:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nm/7QRyG9cSHInDtgZ0XE6MxqGoj2F6Mm3sI75HfBRs=;
 b=hl2M8ggFJlcK9rd6x0KkE8WBEqMar2HKQHREqHUMlvqRATu2Szlnzm98JE9Ew80asGjn
 oYjjMIujZZ2gEm73lWW5QcxVsvkPuE6FsrOUeg/juBgXnIB5qHK6wLi04Hn2hmDnOaUD
 db6Z+Pcbi9+CGYheW+OuZ+G93i+TBbzq34wpqer/Xeb7hbxpwFwdNtXKqdfjBKWbYeMs
 7d1bsW0sBlPfT7TMXPLokfK9Z/DuztY2AUOiwCWZUSSAvZ1eO0wjTx4H3TvgzKJ6xqUd
 PbXjspoU12PEaJ0jV5N1raHCAWFKse9jAL+pHTJcjdNLoeTzkw4hXcuDB6rJEtdq+AUH GQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3732jxr0e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 10:53:07 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 124FXi3h028749;
        Thu, 4 Mar 2021 15:53:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3712v51hyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 15:53:04 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 124FqlkS27459922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Mar 2021 15:52:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 768B542049;
        Thu,  4 Mar 2021 15:53:01 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD59A42041;
        Thu,  4 Mar 2021 15:52:59 +0000 (GMT)
Received: from DESKTOP-TDPLP67.localdomain (unknown [9.85.101.115])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  4 Mar 2021 15:52:59 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     <stable@vger.kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sandipan Das <sandipan@linux.ibm.com>
Subject: [PATCH 5.10 1/2] powerpc/sstep: Check instruction validity against ISA version before emulation
Date:   Thu,  4 Mar 2021 00:08:44 +0530
Message-Id: <20210303183845.13996-1-naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <161462540422642@kroah.com>
References: <161462540422642@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-04_05:2021-03-03,2021-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 bulkscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1011 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040075
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@linux.ibm.com>

[ Upstream commit 8813ff49607eab3caaf40fe8929b0ce7dc68e85f ]

We currently unconditionally try to emulate newer instructions on older
Power versions that could cause issues. Gate it.

Fixes: 350779a29f11 ("powerpc: Handle most loads and stores in instruction emulation code")
Signed-off-by: Ananth N Mavinakayanahalli <ananth@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/161157995977.64773.13794501093457185080.stgit@thinktux.local
[Dropped a few missing hunks for the backport to v5.10]
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/powerpc/lib/sstep.c | 72 ++++++++++++++++++++++++++++++++--------
 1 file changed, 59 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index b18bce1a209fad..2f9ece48b49a09 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -1241,9 +1241,11 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 		if ((word & 0xfe2) == 2)
 			op->type = SYSCALL;
 		else if (IS_ENABLED(CONFIG_PPC_BOOK3S_64) &&
-				(word & 0xfe3) == 1)
+				(word & 0xfe3) == 1) {	/* scv */
 			op->type = SYSCALL_VECTORED_0;
-		else
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
+		} else
 			op->type = UNKNOWN;
 		return 0;
 #endif
@@ -1347,7 +1349,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 #ifdef __powerpc64__
 	case 1:
 		if (!cpu_has_feature(CPU_FTR_ARCH_31))
-			return -1;
+			goto unknown_opcode;
 
 		prefix_r = GET_PREFIX_R(word);
 		ra = GET_PREFIX_RA(suffix);
@@ -1381,7 +1383,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 #ifdef __powerpc64__
 	case 4:
 		if (!cpu_has_feature(CPU_FTR_ARCH_300))
-			return -1;
+			goto unknown_opcode;
 
 		switch (word & 0x3f) {
 		case 48:	/* maddhd */
@@ -1467,6 +1469,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 	case 19:
 		if (((word >> 1) & 0x1f) == 2) {
 			/* addpcis */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			imm = (short) (word & 0xffc1);	/* d0 + d2 fields */
 			imm |= (word >> 15) & 0x3e;	/* d1 field */
 			op->val = regs->nip + (imm << 16) + 4;
@@ -1779,7 +1783,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 #ifdef __powerpc64__
 		case 265:	/* modud */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			op->val = regs->gpr[ra] % regs->gpr[rb];
 			goto compute_done;
 #endif
@@ -1789,7 +1793,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 
 		case 267:	/* moduw */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			op->val = (unsigned int) regs->gpr[ra] %
 				(unsigned int) regs->gpr[rb];
 			goto compute_done;
@@ -1826,7 +1830,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 #endif
 		case 755:	/* darn */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			switch (ra & 0x3) {
 			case 0:
 				/* 32-bit conditioned */
@@ -1848,14 +1852,14 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 #ifdef __powerpc64__
 		case 777:	/* modsd */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			op->val = (long int) regs->gpr[ra] %
 				(long int) regs->gpr[rb];
 			goto compute_done;
 #endif
 		case 779:	/* modsw */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			op->val = (int) regs->gpr[ra] %
 				(int) regs->gpr[rb];
 			goto compute_done;
@@ -1932,14 +1936,14 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 #endif
 		case 538:	/* cnttzw */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			val = (unsigned int) regs->gpr[rd];
 			op->val = (val ? __builtin_ctz(val) : 32);
 			goto logical_done;
 #ifdef __powerpc64__
 		case 570:	/* cnttzd */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			val = regs->gpr[rd];
 			op->val = (val ? __builtin_ctzl(val) : 64);
 			goto logical_done;
@@ -2049,7 +2053,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 		case 890:	/* extswsli with sh_5 = 0 */
 		case 891:	/* extswsli with sh_5 = 1 */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			op->type = COMPUTE + SETREG;
 			sh = rb | ((word & 2) << 4);
 			val = (signed int) regs->gpr[rd];
@@ -2376,6 +2380,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 268:	/* lxvx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 16);
 			op->element_size = 16;
@@ -2385,6 +2391,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 		case 269:	/* lxvl */
 		case 301: {	/* lxvll */
 			int nb;
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->ea = ra ? regs->gpr[ra] : 0;
 			nb = regs->gpr[rb] & 0xff;
@@ -2404,6 +2412,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 364:	/* lxvwsx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 4);
 			op->element_size = 4;
@@ -2411,6 +2421,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 396:	/* stxvx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(STORE_VSX, 0, 16);
 			op->element_size = 16;
@@ -2420,6 +2432,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 		case 397:	/* stxvl */
 		case 429: {	/* stxvll */
 			int nb;
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->ea = ra ? regs->gpr[ra] : 0;
 			nb = regs->gpr[rb] & 0xff;
@@ -2464,6 +2478,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 781:	/* lxsibzx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 1);
 			op->element_size = 8;
@@ -2471,6 +2487,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 812:	/* lxvh8x */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 16);
 			op->element_size = 2;
@@ -2478,6 +2496,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 813:	/* lxsihzx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 2);
 			op->element_size = 8;
@@ -2491,6 +2511,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 876:	/* lxvb16x */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 16);
 			op->element_size = 1;
@@ -2504,6 +2526,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 909:	/* stxsibx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(STORE_VSX, 0, 1);
 			op->element_size = 8;
@@ -2511,6 +2535,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 940:	/* stxvh8x */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(STORE_VSX, 0, 16);
 			op->element_size = 2;
@@ -2518,6 +2544,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 941:	/* stxsihx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(STORE_VSX, 0, 2);
 			op->element_size = 8;
@@ -2531,6 +2559,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 1004:	/* stxvb16x */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(STORE_VSX, 0, 16);
 			op->element_size = 1;
@@ -2639,12 +2669,16 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			op->type = MKOP(LOAD_FP, 0, 16);
 			break;
 		case 2:		/* lxsd */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd + 32;
 			op->type = MKOP(LOAD_VSX, 0, 8);
 			op->element_size = 8;
 			op->vsx_flags = VSX_CHECK_VEC;
 			break;
 		case 3:		/* lxssp */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd + 32;
 			op->type = MKOP(LOAD_VSX, 0, 4);
 			op->element_size = 8;
@@ -2681,6 +2715,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 1:		/* lxv */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->ea = dqform_ea(word, regs);
 			if (word & 8)
 				op->reg = rd + 32;
@@ -2691,6 +2727,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 
 		case 2:		/* stxsd with LSB of DS field = 0 */
 		case 6:		/* stxsd with LSB of DS field = 1 */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->ea = dsform_ea(word, regs);
 			op->reg = rd + 32;
 			op->type = MKOP(STORE_VSX, 0, 8);
@@ -2700,6 +2738,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 
 		case 3:		/* stxssp with LSB of DS field = 0 */
 		case 7:		/* stxssp with LSB of DS field = 1 */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->ea = dsform_ea(word, regs);
 			op->reg = rd + 32;
 			op->type = MKOP(STORE_VSX, 0, 4);
@@ -2708,6 +2748,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 5:		/* stxv */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->ea = dqform_ea(word, regs);
 			if (word & 8)
 				op->reg = rd + 32;
@@ -2737,7 +2779,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 		break;
 	case 1: /* Prefixed instructions */
 		if (!cpu_has_feature(CPU_FTR_ARCH_31))
-			return -1;
+			goto unknown_opcode;
 
 		prefix_r = GET_PREFIX_R(word);
 		ra = GET_PREFIX_RA(suffix);
@@ -2872,6 +2914,10 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 
 	return 0;
 
+ unknown_opcode:
+	op->type = UNKNOWN;
+	return 0;
+
  logical_done:
 	if (word & 1)
 		set_cr0(regs, op);

base-commit: 83be32b6c9e55d5b04181fc9788591d5611d4a96
-- 
2.25.1

