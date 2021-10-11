Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4E04290EB
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbhJKOOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237247AbhJKOLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:11:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA55C610CC;
        Mon, 11 Oct 2021 14:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960991;
        bh=pLRsYKaMqarwCKxFkFreH+Nhi/r4PmXapsfOIzrZAXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sp6vLkuGH7d+dkVQSI5d4i2ZNVJRHdRqtX14hi/rnq7xCZYozATHi4iokjax7c/6p
         u3LH1hoNdzKfxYrRQoEXf5o/ewN1IxwjhpVy1Xdzqc/Ox7Rhkm/o05Y5ryeshKpxHy
         robg0PpbXN4Fn2W/SIU8MMhxvoIJybD5kUNKDXl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 134/151] powerpc/bpf: Fix BPF_SUB when imm == 0x80000000
Date:   Mon, 11 Oct 2021 15:46:46 +0200
Message-Id: <20211011134522.134724225@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

[ Upstream commit 5855c4c1f415ca3ba1046e77c0b3d3dfc96c9025 ]

We aren't handling subtraction involving an immediate value of
0x80000000 properly. Fix the same.

Fixes: 156d0e290e969c ("powerpc/ebpf/jit: Implement JIT compiler for extended BPF")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Fold in fix from Naveen to use imm <= 32768]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/fc4b1276eb10761fd7ce0814c8dd089da2815251.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/net/bpf_jit_comp64.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index d16b97179646..dff4a2930970 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -328,18 +328,25 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 			EMIT(PPC_RAW_SUB(dst_reg, dst_reg, src_reg));
 			goto bpf_alu32_trunc;
 		case BPF_ALU | BPF_ADD | BPF_K: /* (u32) dst += (u32) imm */
-		case BPF_ALU | BPF_SUB | BPF_K: /* (u32) dst -= (u32) imm */
 		case BPF_ALU64 | BPF_ADD | BPF_K: /* dst += imm */
+			if (!imm) {
+				goto bpf_alu32_trunc;
+			} else if (imm >= -32768 && imm < 32768) {
+				EMIT(PPC_RAW_ADDI(dst_reg, dst_reg, IMM_L(imm)));
+			} else {
+				PPC_LI32(b2p[TMP_REG_1], imm);
+				EMIT(PPC_RAW_ADD(dst_reg, dst_reg, b2p[TMP_REG_1]));
+			}
+			goto bpf_alu32_trunc;
+		case BPF_ALU | BPF_SUB | BPF_K: /* (u32) dst -= (u32) imm */
 		case BPF_ALU64 | BPF_SUB | BPF_K: /* dst -= imm */
-			if (BPF_OP(code) == BPF_SUB)
-				imm = -imm;
-			if (imm) {
-				if (imm >= -32768 && imm < 32768)
-					EMIT(PPC_RAW_ADDI(dst_reg, dst_reg, IMM_L(imm)));
-				else {
-					PPC_LI32(b2p[TMP_REG_1], imm);
-					EMIT(PPC_RAW_ADD(dst_reg, dst_reg, b2p[TMP_REG_1]));
-				}
+			if (!imm) {
+				goto bpf_alu32_trunc;
+			} else if (imm > -32768 && imm <= 32768) {
+				EMIT(PPC_RAW_ADDI(dst_reg, dst_reg, IMM_L(-imm)));
+			} else {
+				PPC_LI32(b2p[TMP_REG_1], imm);
+				EMIT(PPC_RAW_SUB(dst_reg, dst_reg, b2p[TMP_REG_1]));
 			}
 			goto bpf_alu32_trunc;
 		case BPF_ALU | BPF_MUL | BPF_X: /* (u32) dst *= (u32) src */
-- 
2.33.0



