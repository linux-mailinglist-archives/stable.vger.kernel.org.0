Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B1D417253
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343842AbhIXMrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:47:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343877AbhIXMqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:46:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54D9F61265;
        Fri, 24 Sep 2021 12:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487514;
        bh=O65/TwJwL6G9qlsCEOSRgte/7eQWnvnSBC8Pkrn/7uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WAQpQ35KOoBwWPwyfbNCabXFKPtMiPanNFOQ8WoXU9mfGM0s+pqaEQ9rIZCePDE1p
         w9ueNVZhs2G59lLGFxhvugDlOeSXgykfBCxLzqVXm976ufj7Xq70BICyqYAU1Y75ym
         Skjrch9TZdhTRJMtNo2nzLjkDDSlA3ir53BPBj7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.9 01/26] s390/bpf: Fix optimizing out zero-extensions
Date:   Fri, 24 Sep 2021 14:43:49 +0200
Message-Id: <20210924124328.389145834@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124328.336953942@linuxfoundation.org>
References: <20210924124328.336953942@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit db7bee653859ef7179be933e7d1384644f795f26 upstream.

Currently the JIT completely removes things like `reg32 += 0`,
however, the BPF_ALU semantics requires the target register to be
zero-extended in such cases.

Fix by optimizing out only the arithmetic operation, but not the
subsequent zero-extension.

Reported-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Fixes: 054623105728 ("s390/bpf: Add s390x eBPF JIT compiler backend")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/net/bpf_jit_comp.c |   50 ++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -591,10 +591,10 @@ static noinline int bpf_jit_insn(struct
 		EMIT4(0xb9080000, dst_reg, src_reg);
 		break;
 	case BPF_ALU | BPF_ADD | BPF_K: /* dst = (u32) dst + (u32) imm */
-		if (!imm)
-			break;
-		/* alfi %dst,imm */
-		EMIT6_IMM(0xc20b0000, dst_reg, imm);
+		if (imm != 0) {
+			/* alfi %dst,imm */
+			EMIT6_IMM(0xc20b0000, dst_reg, imm);
+		}
 		EMIT_ZERO(dst_reg);
 		break;
 	case BPF_ALU64 | BPF_ADD | BPF_K: /* dst = dst + imm */
@@ -616,10 +616,10 @@ static noinline int bpf_jit_insn(struct
 		EMIT4(0xb9090000, dst_reg, src_reg);
 		break;
 	case BPF_ALU | BPF_SUB | BPF_K: /* dst = (u32) dst - (u32) imm */
-		if (!imm)
-			break;
-		/* alfi %dst,-imm */
-		EMIT6_IMM(0xc20b0000, dst_reg, -imm);
+		if (imm != 0) {
+			/* alfi %dst,-imm */
+			EMIT6_IMM(0xc20b0000, dst_reg, -imm);
+		}
 		EMIT_ZERO(dst_reg);
 		break;
 	case BPF_ALU64 | BPF_SUB | BPF_K: /* dst = dst - imm */
@@ -646,10 +646,10 @@ static noinline int bpf_jit_insn(struct
 		EMIT4(0xb90c0000, dst_reg, src_reg);
 		break;
 	case BPF_ALU | BPF_MUL | BPF_K: /* dst = (u32) dst * (u32) imm */
-		if (imm == 1)
-			break;
-		/* msfi %r5,imm */
-		EMIT6_IMM(0xc2010000, dst_reg, imm);
+		if (imm != 1) {
+			/* msfi %r5,imm */
+			EMIT6_IMM(0xc2010000, dst_reg, imm);
+		}
 		EMIT_ZERO(dst_reg);
 		break;
 	case BPF_ALU64 | BPF_MUL | BPF_K: /* dst = dst * imm */
@@ -710,6 +710,8 @@ static noinline int bpf_jit_insn(struct
 			if (BPF_OP(insn->code) == BPF_MOD)
 				/* lhgi %dst,0 */
 				EMIT4_IMM(0xa7090000, dst_reg, 0);
+			else
+				EMIT_ZERO(dst_reg);
 			break;
 		}
 		/* lhi %w0,0 */
@@ -802,10 +804,10 @@ static noinline int bpf_jit_insn(struct
 		EMIT4(0xb9820000, dst_reg, src_reg);
 		break;
 	case BPF_ALU | BPF_XOR | BPF_K: /* dst = (u32) dst ^ (u32) imm */
-		if (!imm)
-			break;
-		/* xilf %dst,imm */
-		EMIT6_IMM(0xc0070000, dst_reg, imm);
+		if (imm != 0) {
+			/* xilf %dst,imm */
+			EMIT6_IMM(0xc0070000, dst_reg, imm);
+		}
 		EMIT_ZERO(dst_reg);
 		break;
 	case BPF_ALU64 | BPF_XOR | BPF_K: /* dst = dst ^ imm */
@@ -826,10 +828,10 @@ static noinline int bpf_jit_insn(struct
 		EMIT6_DISP_LH(0xeb000000, 0x000d, dst_reg, dst_reg, src_reg, 0);
 		break;
 	case BPF_ALU | BPF_LSH | BPF_K: /* dst = (u32) dst << (u32) imm */
-		if (imm == 0)
-			break;
-		/* sll %dst,imm(%r0) */
-		EMIT4_DISP(0x89000000, dst_reg, REG_0, imm);
+		if (imm != 0) {
+			/* sll %dst,imm(%r0) */
+			EMIT4_DISP(0x89000000, dst_reg, REG_0, imm);
+		}
 		EMIT_ZERO(dst_reg);
 		break;
 	case BPF_ALU64 | BPF_LSH | BPF_K: /* dst = dst << imm */
@@ -851,10 +853,10 @@ static noinline int bpf_jit_insn(struct
 		EMIT6_DISP_LH(0xeb000000, 0x000c, dst_reg, dst_reg, src_reg, 0);
 		break;
 	case BPF_ALU | BPF_RSH | BPF_K: /* dst = (u32) dst >> (u32) imm */
-		if (imm == 0)
-			break;
-		/* srl %dst,imm(%r0) */
-		EMIT4_DISP(0x88000000, dst_reg, REG_0, imm);
+		if (imm != 0) {
+			/* srl %dst,imm(%r0) */
+			EMIT4_DISP(0x88000000, dst_reg, REG_0, imm);
+		}
 		EMIT_ZERO(dst_reg);
 		break;
 	case BPF_ALU64 | BPF_RSH | BPF_K: /* dst = dst >> imm */


