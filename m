Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D501B40F0
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbgDVKtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:49:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbgDVKNj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:13:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED8EF20776;
        Wed, 22 Apr 2020 10:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550418;
        bh=brI1eFVheBp82O1Mm9OtdOwC6ysMUp1xIN/FwyHk7UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbVqB4dp5Fppz8q1STY5FEliXutVkIBDfecrzfYzhyjINMDCPgE7Hz1VMTDnuoPj8
         RVK4MELGY2iGp0Hec6MspUsrehCCxeH0otas+XY0lidYaS/xgalvPZmiI2B0ucsymf
         xW1f3Z/iXjB9z4hVrXByLwSMlhmHVzO/gI7SdLks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.19 01/64] arm, bpf: Fix offset overflow for BPF_MEM BPF_DW
Date:   Wed, 22 Apr 2020 11:56:45 +0200
Message-Id: <20200422095012.107035823@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke Nelson <lukenels@cs.washington.edu>

commit 4178417cc5359c329790a4a8f4a6604612338cca upstream.

This patch fixes an incorrect check in how immediate memory offsets are
computed for BPF_DW on arm.

For BPF_LDX/ST/STX + BPF_DW, the 32-bit arm JIT breaks down an 8-byte
access into two separate 4-byte accesses using off+0 and off+4. If off
fits in imm12, the JIT emits a ldr/str instruction with the immediate
and avoids the use of a temporary register. While the current check off
<= 0xfff ensures that the first immediate off+0 doesn't overflow imm12,
it's not sufficient for the second immediate off+4, which may cause the
second access of BPF_DW to read/write the wrong address.

This patch fixes the problem by changing the check to
off <= 0xfff - 4 for BPF_DW, ensuring off+4 will never overflow.

A side effect of simplifying the check is that it now allows using
negative immediate offsets in ldr/str. This means that small negative
offsets can also avoid the use of a temporary register.

This patch introduces no new failures in test_verifier or test_bpf.c.

Fixes: c5eae692571d6 ("ARM: net: bpf: improve 64-bit store implementation")
Fixes: ec19e02b343db ("ARM: net: bpf: fix LDX instructions")
Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20200409221752.28448-1-luke.r.nels@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/net/bpf_jit_32.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -993,21 +993,35 @@ static inline void emit_a32_mul_r64(cons
 	arm_bpf_put_reg32(dst_hi, rd[0], ctx);
 }
 
+static bool is_ldst_imm(s16 off, const u8 size)
+{
+	s16 off_max = 0;
+
+	switch (size) {
+	case BPF_B:
+	case BPF_W:
+		off_max = 0xfff;
+		break;
+	case BPF_H:
+		off_max = 0xff;
+		break;
+	case BPF_DW:
+		/* Need to make sure off+4 does not overflow. */
+		off_max = 0xfff - 4;
+		break;
+	}
+	return -off_max <= off && off <= off_max;
+}
+
 /* *(size *)(dst + off) = src */
 static inline void emit_str_r(const s8 dst, const s8 src[],
-			      s32 off, struct jit_ctx *ctx, const u8 sz){
+			      s16 off, struct jit_ctx *ctx, const u8 sz){
 	const s8 *tmp = bpf2a32[TMP_REG_1];
-	s32 off_max;
 	s8 rd;
 
 	rd = arm_bpf_get_reg32(dst, tmp[1], ctx);
 
-	if (sz == BPF_H)
-		off_max = 0xff;
-	else
-		off_max = 0xfff;
-
-	if (off < 0 || off > off_max) {
+	if (!is_ldst_imm(off, sz)) {
 		emit_a32_mov_i(tmp[0], off, ctx);
 		emit(ARM_ADD_R(tmp[0], tmp[0], rd), ctx);
 		rd = tmp[0];
@@ -1036,18 +1050,12 @@ static inline void emit_str_r(const s8 d
 
 /* dst = *(size*)(src + off) */
 static inline void emit_ldx_r(const s8 dst[], const s8 src,
-			      s32 off, struct jit_ctx *ctx, const u8 sz){
+			      s16 off, struct jit_ctx *ctx, const u8 sz){
 	const s8 *tmp = bpf2a32[TMP_REG_1];
 	const s8 *rd = is_stacked(dst_lo) ? tmp : dst;
 	s8 rm = src;
-	s32 off_max;
-
-	if (sz == BPF_H)
-		off_max = 0xff;
-	else
-		off_max = 0xfff;
 
-	if (off < 0 || off > off_max) {
+	if (!is_ldst_imm(off, sz)) {
 		emit_a32_mov_i(tmp[0], off, ctx);
 		emit(ARM_ADD_R(tmp[0], tmp[0], src), ctx);
 		rm = tmp[0];


