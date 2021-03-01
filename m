Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F19328FEF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbhCAT7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:59:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241232AbhCATtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:49:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1546D650DE;
        Mon,  1 Mar 2021 17:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621098;
        bh=aVSJvRQsHg1zRLeuazM8goIKzW6MWfYd4E1aRcwkLlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JVy/BEjnIpUfDSVx8ljTdsHx3OTkvuDKUX8T7MgdPrRDdGDoqgrh58lN5Sq+iYTT
         8gFSoZX6oJ3ALGRQENFP9BJg6duiegQ047x5c99qEKb3TNww1pXaIiG19p9Ztv4cqJ
         8/iaHI3GOrFYRZEa4Quc9RLZAplN7bo+bODZhidE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 392/775] powerpc/sstep: Check instruction validity against ISA version before emulation
Date:   Mon,  1 Mar 2021 17:09:20 +0100
Message-Id: <20210301161220.970484940@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/lib/sstep.c | 78 +++++++++++++++++++++++++++++++---------
 1 file changed, 62 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index ede093e962347..5e725ed24d772 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -1306,9 +1306,11 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
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
@@ -1412,7 +1414,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 #ifdef __powerpc64__
 	case 1:
 		if (!cpu_has_feature(CPU_FTR_ARCH_31))
-			return -1;
+			goto unknown_opcode;
 
 		prefix_r = GET_PREFIX_R(word);
 		ra = GET_PREFIX_RA(suffix);
@@ -1446,7 +1448,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 #ifdef __powerpc64__
 	case 4:
 		if (!cpu_has_feature(CPU_FTR_ARCH_300))
-			return -1;
+			goto unknown_opcode;
 
 		switch (word & 0x3f) {
 		case 48:	/* maddhd */
@@ -1532,6 +1534,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 	case 19:
 		if (((word >> 1) & 0x1f) == 2) {
 			/* addpcis */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			imm = (short) (word & 0xffc1);	/* d0 + d2 fields */
 			imm |= (word >> 15) & 0x3e;	/* d1 field */
 			op->val = regs->nip + (imm << 16) + 4;
@@ -1844,7 +1848,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 #ifdef __powerpc64__
 		case 265:	/* modud */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			op->val = regs->gpr[ra] % regs->gpr[rb];
 			goto compute_done;
 #endif
@@ -1854,7 +1858,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 
 		case 267:	/* moduw */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			op->val = (unsigned int) regs->gpr[ra] %
 				(unsigned int) regs->gpr[rb];
 			goto compute_done;
@@ -1891,7 +1895,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 #endif
 		case 755:	/* darn */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			switch (ra & 0x3) {
 			case 0:
 				/* 32-bit conditioned */
@@ -1913,14 +1917,14 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
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
@@ -1997,14 +2001,14 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
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
@@ -2114,7 +2118,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 		case 890:	/* extswsli with sh_5 = 0 */
 		case 891:	/* extswsli with sh_5 = 1 */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-				return -1;
+				goto unknown_opcode;
 			op->type = COMPUTE + SETREG;
 			sh = rb | ((word & 2) << 4);
 			val = (signed int) regs->gpr[rd];
@@ -2441,6 +2445,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 268:	/* lxvx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 16);
 			op->element_size = 16;
@@ -2450,6 +2456,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 		case 269:	/* lxvl */
 		case 301: {	/* lxvll */
 			int nb;
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->ea = ra ? regs->gpr[ra] : 0;
 			nb = regs->gpr[rb] & 0xff;
@@ -2470,13 +2478,15 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 
 		case 333:       /* lxvpx */
 			if (!cpu_has_feature(CPU_FTR_ARCH_31))
-				return -1;
+				goto unknown_opcode;
 			op->reg = VSX_REGISTER_XTP(rd);
 			op->type = MKOP(LOAD_VSX, 0, 32);
 			op->element_size = 32;
 			break;
 
 		case 364:	/* lxvwsx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 4);
 			op->element_size = 4;
@@ -2484,6 +2494,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 396:	/* stxvx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(STORE_VSX, 0, 16);
 			op->element_size = 16;
@@ -2493,6 +2505,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 		case 397:	/* stxvl */
 		case 429: {	/* stxvll */
 			int nb;
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->ea = ra ? regs->gpr[ra] : 0;
 			nb = regs->gpr[rb] & 0xff;
@@ -2506,7 +2520,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 		}
 		case 461:       /* stxvpx */
 			if (!cpu_has_feature(CPU_FTR_ARCH_31))
-				return -1;
+				goto unknown_opcode;
 			op->reg = VSX_REGISTER_XTP(rd);
 			op->type = MKOP(STORE_VSX, 0, 32);
 			op->element_size = 32;
@@ -2544,6 +2558,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 781:	/* lxsibzx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 1);
 			op->element_size = 8;
@@ -2551,6 +2567,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 812:	/* lxvh8x */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 16);
 			op->element_size = 2;
@@ -2558,6 +2576,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 813:	/* lxsihzx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 2);
 			op->element_size = 8;
@@ -2571,6 +2591,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 876:	/* lxvb16x */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(LOAD_VSX, 0, 16);
 			op->element_size = 1;
@@ -2584,6 +2606,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 909:	/* stxsibx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(STORE_VSX, 0, 1);
 			op->element_size = 8;
@@ -2591,6 +2615,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 940:	/* stxvh8x */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(STORE_VSX, 0, 16);
 			op->element_size = 2;
@@ -2598,6 +2624,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 941:	/* stxsihx */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(STORE_VSX, 0, 2);
 			op->element_size = 8;
@@ -2611,6 +2639,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 1004:	/* stxvb16x */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->reg = rd | ((word & 1) << 5);
 			op->type = MKOP(STORE_VSX, 0, 16);
 			op->element_size = 1;
@@ -2719,12 +2749,16 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
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
@@ -2754,7 +2788,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 #ifdef CONFIG_VSX
 	case 6:
 		if (!cpu_has_feature(CPU_FTR_ARCH_31))
-			return -1;
+			goto unknown_opcode;
 		op->ea = dqform_ea(word, regs);
 		op->reg = VSX_REGISTER_XTP(rd);
 		op->element_size = 32;
@@ -2777,6 +2811,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 1:		/* lxv */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->ea = dqform_ea(word, regs);
 			if (word & 8)
 				op->reg = rd + 32;
@@ -2787,6 +2823,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 
 		case 2:		/* stxsd with LSB of DS field = 0 */
 		case 6:		/* stxsd with LSB of DS field = 1 */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->ea = dsform_ea(word, regs);
 			op->reg = rd + 32;
 			op->type = MKOP(STORE_VSX, 0, 8);
@@ -2796,6 +2834,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 
 		case 3:		/* stxssp with LSB of DS field = 0 */
 		case 7:		/* stxssp with LSB of DS field = 1 */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->ea = dsform_ea(word, regs);
 			op->reg = rd + 32;
 			op->type = MKOP(STORE_VSX, 0, 4);
@@ -2804,6 +2844,8 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			break;
 
 		case 5:		/* stxv */
+			if (!cpu_has_feature(CPU_FTR_ARCH_300))
+				goto unknown_opcode;
 			op->ea = dqform_ea(word, regs);
 			if (word & 8)
 				op->reg = rd + 32;
@@ -2833,7 +2875,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 		break;
 	case 1: /* Prefixed instructions */
 		if (!cpu_has_feature(CPU_FTR_ARCH_31))
-			return -1;
+			goto unknown_opcode;
 
 		prefix_r = GET_PREFIX_R(word);
 		ra = GET_PREFIX_RA(suffix);
@@ -2982,6 +3024,10 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 
 	return 0;
 
+ unknown_opcode:
+	op->type = UNKNOWN;
+	return 0;
+
  logical_done:
 	if (word & 1)
 		set_cr0(regs, op);
-- 
2.27.0



