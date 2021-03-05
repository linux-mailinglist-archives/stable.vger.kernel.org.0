Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2149B32E95E
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhCEMc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:32:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:42244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231652AbhCEMb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:31:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44C1265004;
        Fri,  5 Mar 2021 12:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947517;
        bh=EoxocRsBpA2vzprPILBLtHPVeUnUdZ4iq8JNqgAtIVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+J75kSM/vhv0LjFO/7W78142KLpDsE49BT2PszbWoezWz7aVeCI7jXaEzdPrv/HZ
         uv/9DOmZ/U0PWiViEWOnjjjmBmYUv9RIWfgW1taT8ixbv1UEfKgd8hEtBRNbzpAx0Z
         wWoCO9koLgGGMslTm3N0nVUDqRJ5ys1OZ3BhG1YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: [PATCH 5.10 092/102] powerpc/sstep: Check instruction validity against ISA version before emulation
Date:   Fri,  5 Mar 2021 13:21:51 +0100
Message-Id: <20210305120907.805315406@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@linux.ibm.com>

commit 8813ff49607eab3caaf40fe8929b0ce7dc68e85f upstream.

We currently unconditionally try to emulate newer instructions on older
Power versions that could cause issues. Gate it.

Fixes: 350779a29f11 ("powerpc: Handle most loads and stores in instruction emulation code")
Signed-off-by: Ananth N Mavinakayanahalli <ananth@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/161157995977.64773.13794501093457185080.stgit@thinktux.local
[Dropped a few missing hunks for the backport to v5.10]
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/lib/sstep.c |   72 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 59 insertions(+), 13 deletions(-)

--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -1241,9 +1241,11 @@ int analyse_instr(struct instruction_op
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
@@ -1347,7 +1349,7 @@ int analyse_instr(struct instruction_op
 #ifdef __powerpc64__
 	case 1:
 		if (!cpu_has_feature(CPU_FTR_ARCH_31))
-			return -1;
+			goto unknown_opcode;
 
 		prefix_r = GET_PREFIX_R(word);
 		ra = GET_PREFIX_RA(suffix);
@@ -1381,7 +1383,7 @@ int analyse_instr(struct instruction_op
 #ifdef __powerpc64__
 	case 4:
 		if (!cpu_has_feature(CPU_FTR_ARCH_300))
-			return -1;
+			goto unknown_opcode;
 
 		switch (word & 0x3f) {
 		case 48:	/* maddhd */
@@ -1467,6 +1469,8 @@ int analyse_instr(struct instruction_op
 	case 19:
 		if (((word >> 1) & 0x1f) == 2) {
 			/* addpcis */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			imm = (short) (word & 0xffc1);	/* d0 + d2 fields */
 			imm |= (word >> 15) & 0x3e;	/* d1 field */
 			op->val = regs->nip + (imm << 16) + 4;
@@ -1779,7 +1783,7 @@ int analyse_instr(struct instruction_op
 #ifdef __powerpc64__
 		case 265:	/* modud */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			op->val = regs->gpr[ra] % regs->gpr[rb];
 			goto compute_done;
 #endif
@@ -1789,7 +1793,7 @@ int analyse_instr(struct instruction_op
 
 		case 267:	/* moduw */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			op->val = (unsigned int) regs->gpr[ra] %
 				(unsigned int) regs->gpr[rb];
 			goto compute_done;
@@ -1826,7 +1830,7 @@ int analyse_instr(struct instruction_op
 #endif
 		case 755:	/* darn */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			switch (ra & 0x3) {
 			case 0:
 				/* 32-bit conditioned */
@@ -1848,14 +1852,14 @@ int analyse_instr(struct instruction_op
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
@@ -1932,14 +1936,14 @@ int analyse_instr(struct instruction_op
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
@@ -2049,7 +2053,7 @@ int analyse_instr(struct instruction_op
 		case 890:	/* extswsli with sh_5 = 0 */
 		case 891:	/* extswsli with sh_5 = 1 */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			op->type = COMPUTE + SETREG;
 			sh = rb | ((word & 2) << 4);
 			val = (signed int) regs->gpr[rd];
@@ -2376,6 +2380,8 @@ int analyse_instr(struct instruction_op
 			break;
 
 		case 268:	/* lxvx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 16);
 			op->element_size = 16;
@@ -2385,6 +2391,8 @@ int analyse_instr(struct instruction_op
 		case 269:	/* lxvl */
 		case 301: {	/* lxvll */
 			int nb;
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->ea = ra ? regs->gpr[ra] : 0;
 			nb = regs->gpr[rb] & 0xff;
@@ -2404,6 +2412,8 @@ int analyse_instr(struct instruction_op
 			break;
 
 		case 364:	/* lxvwsx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 4);
 			op->element_size = 4;
@@ -2411,6 +2421,8 @@ int analyse_instr(struct instruction_op
 			break;
 
 		case 396:	/* stxvx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(STORE_VSX, 0, 16);
 			op->element_size = 16;
@@ -2420,6 +2432,8 @@ int analyse_instr(struct instruction_op
 		case 397:	/* stxvl */
 		case 429: {	/* stxvll */
 			int nb;
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->ea = ra ? regs->gpr[ra] : 0;
 			nb = regs->gpr[rb] & 0xff;
@@ -2464,6 +2478,8 @@ int analyse_instr(struct instruction_op
 			break;
 
 		case 781:	/* lxsibzx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 1);
 			op->element_size = 8;
@@ -2471,6 +2487,8 @@ int analyse_instr(struct instruction_op
 			break;
 
 		case 812:	/* lxvh8x */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 16);
 			op->element_size = 2;
@@ -2478,6 +2496,8 @@ int analyse_instr(struct instruction_op
 			break;
 
 		case 813:	/* lxsihzx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 2);
 			op->element_size = 8;
@@ -2491,6 +2511,8 @@ int analyse_instr(struct instruction_op
 			break;
 
 		case 876:	/* lxvb16x */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 16);
 			op->element_size = 1;
@@ -2504,6 +2526,8 @@ int analyse_instr(struct instruction_op
 			break;
 
 		case 909:	/* stxsibx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(STORE_VSX, 0, 1);
 			op->element_size = 8;
@@ -2511,6 +2535,8 @@ int analyse_instr(struct instruction_op
 			break;
 
 		case 940:	/* stxvh8x */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(STORE_VSX, 0, 16);
 			op->element_size = 2;
@@ -2518,6 +2544,8 @@ int analyse_instr(struct instruction_op
 			break;
 
 		case 941:	/* stxsihx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(STORE_VSX, 0, 2);
 			op->element_size = 8;
@@ -2531,6 +2559,8 @@ int analyse_instr(struct instruction_op
 			break;
 
 		case 1004:	/* stxvb16x */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(STORE_VSX, 0, 16);
 			op->element_size = 1;
@@ -2639,12 +2669,16 @@ int analyse_instr(struct instruction_op
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
@@ -2681,6 +2715,8 @@ int analyse_instr(struct instruction_op
 			break;
 
 		case 1:		/* lxv */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->ea = dqform_ea(word, regs);
 			if (word & 8)
 				op->reg = rd + 32;
@@ -2691,6 +2727,8 @@ int analyse_instr(struct instruction_op
 
 		case 2:		/* stxsd with LSB of DS field = 0 */
 		case 6:		/* stxsd with LSB of DS field = 1 */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->ea = dsform_ea(word, regs);
 			op->reg = rd + 32;
 			op->type = MKOP(STORE_VSX, 0, 8);
@@ -2700,6 +2738,8 @@ int analyse_instr(struct instruction_op
 
 		case 3:		/* stxssp with LSB of DS field = 0 */
 		case 7:		/* stxssp with LSB of DS field = 1 */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->ea = dsform_ea(word, regs);
 			op->reg = rd + 32;
 			op->type = MKOP(STORE_VSX, 0, 4);
@@ -2708,6 +2748,8 @@ int analyse_instr(struct instruction_op
 			break;
 
 		case 5:		/* stxv */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->ea = dqform_ea(word, regs);
 			if (word & 8)
 				op->reg = rd + 32;
@@ -2737,7 +2779,7 @@ int analyse_instr(struct instruction_op
 		break;
 	case 1: /* Prefixed instructions */
 		if (!cpu_has_feature(CPU_FTR_ARCH_31))
-			return -1;
+			goto unknown_opcode;
 
 		prefix_r = GET_PREFIX_R(word);
 		ra = GET_PREFIX_RA(suffix);
@@ -2872,6 +2914,10 @@ int analyse_instr(struct instruction_op
 
 	return 0;
 
+ unknown_opcode:
+	op->type = UNKNOWN;
+	return 0;
+
  logical_done:
 	if (word & 1)
 		set_cr0(regs, op);


