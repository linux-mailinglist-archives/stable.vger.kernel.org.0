Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B13A428FAF
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238295AbhJKOAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237787AbhJKN7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:59:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7AC2611C3;
        Mon, 11 Oct 2021 13:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960533;
        bh=k/rFIUyOkql9VEApBtg14qShAinv3cD69+Va4UWDdvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vzL+ET1j49FPaIIMvfJXrdtS2yvp31b8W/BssTLhoZPfB7HZ/Lrbk6LaH5IanZGF8
         2H2E7mL+cbnB8EssCaAq/ifNW/VCD4vM4VMsXegVB3AvkB9T9sOfd/bxZ2FRW1FQ34
         br7CxpqW520QNHfz3MTUAAPeornhVrvXvPUSVTEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 74/83] powerpc/bpf: Fix BPF_SUB when imm == 0x80000000
Date:   Mon, 11 Oct 2021 15:46:34 +0200
Message-Id: <20211011134510.938865273@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
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
index e79f9eae2bc0..a2750d6ffd0f 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -347,18 +347,25 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
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



