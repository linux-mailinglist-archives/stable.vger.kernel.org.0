Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0B1121283
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbfLPRxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:53:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbfLPRxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:53:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2435206D3;
        Mon, 16 Dec 2019 17:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518794;
        bh=KE/AxhjaBXCBBb9qFu3IbAIk253Jp0xmyfJ1IatDtZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5wBMv9Ct2PKDFOPnB98p7clTuTKXJLZRX/6MJTDDQAPDZk5B5SEsme3IO94a9stC
         sIdPAs0bX2qEvgA9EWPkeotVaSO7Wprym7rBQYXmFJIqrn6/u6InGvoAjVdJlibooY
         f+brHM1by3nhdK+PB4QVXDMQRHWv2DpjJGUDIPdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 070/267] sparc: Correct ctx->saw_frame_pointer logic.
Date:   Mon, 16 Dec 2019 18:46:36 +0100
Message-Id: <20191216174856.417853888@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Miller <davem@davemloft.net>

[ Upstream commit e2ac579a7a18bcd9e8cf14cf42eac0b8a2ba6c4b ]

We need to initialize the frame pointer register not just if it is
seen as a source operand, but also if it is seen as the destination
operand of a store or an atomic instruction (which effectively is a
source operand).

This is exercised by test_verifier's "non-invalid fp arithmetic"

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/net/bpf_jit_comp_64.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/sparc/net/bpf_jit_comp_64.c b/arch/sparc/net/bpf_jit_comp_64.c
index adfb4581bd809..dfb1a62abe932 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -1326,6 +1326,9 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		const u8 tmp2 = bpf2sparc[TMP_REG_2];
 		u32 opcode = 0, rs2;
 
+		if (insn->dst_reg == BPF_REG_FP)
+			ctx->saw_frame_pointer = true;
+
 		ctx->tmp_2_used = true;
 		emit_loadimm(imm, tmp2, ctx);
 
@@ -1364,6 +1367,9 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		const u8 tmp = bpf2sparc[TMP_REG_1];
 		u32 opcode = 0, rs2;
 
+		if (insn->dst_reg == BPF_REG_FP)
+			ctx->saw_frame_pointer = true;
+
 		switch (BPF_SIZE(code)) {
 		case BPF_W:
 			opcode = ST32;
@@ -1396,6 +1402,9 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		const u8 tmp2 = bpf2sparc[TMP_REG_2];
 		const u8 tmp3 = bpf2sparc[TMP_REG_3];
 
+		if (insn->dst_reg == BPF_REG_FP)
+			ctx->saw_frame_pointer = true;
+
 		ctx->tmp_1_used = true;
 		ctx->tmp_2_used = true;
 		ctx->tmp_3_used = true;
@@ -1416,6 +1425,9 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		const u8 tmp2 = bpf2sparc[TMP_REG_2];
 		const u8 tmp3 = bpf2sparc[TMP_REG_3];
 
+		if (insn->dst_reg == BPF_REG_FP)
+			ctx->saw_frame_pointer = true;
+
 		ctx->tmp_1_used = true;
 		ctx->tmp_2_used = true;
 		ctx->tmp_3_used = true;
-- 
2.20.1



