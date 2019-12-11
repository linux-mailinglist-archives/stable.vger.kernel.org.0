Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1D011B52D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732370AbfLKPUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:20:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732355AbfLKPUp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:20:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EB9822B48;
        Wed, 11 Dec 2019 15:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077644;
        bh=Vk4CO8RoK4QK13syaTDZhMeKWRUm1nOGUOYrePS8LYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrzhCD37Q+fooAAD9B0V0iiaTK4N+DBo+JeldK8y1K7G4FtjV+/7cjbwdQX/PRnlC
         fU0xYOdoY0YF5KMy5ZVljMjkLJeytUoKFaPJVJAS82N6Ows2MBJZrCJspYEfscOCY5
         HbDmL222c3F/OcMbdKJvgjx5eHUsdL95JtTyYdn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 109/243] sparc: Correct ctx->saw_frame_pointer logic.
Date:   Wed, 11 Dec 2019 16:04:31 +0100
Message-Id: <20191211150346.490033245@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
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
index 7217d63596431..ec4da4dc98f12 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -1270,6 +1270,9 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		const u8 tmp2 = bpf2sparc[TMP_REG_2];
 		u32 opcode = 0, rs2;
 
+		if (insn->dst_reg == BPF_REG_FP)
+			ctx->saw_frame_pointer = true;
+
 		ctx->tmp_2_used = true;
 		emit_loadimm(imm, tmp2, ctx);
 
@@ -1308,6 +1311,9 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		const u8 tmp = bpf2sparc[TMP_REG_1];
 		u32 opcode = 0, rs2;
 
+		if (insn->dst_reg == BPF_REG_FP)
+			ctx->saw_frame_pointer = true;
+
 		switch (BPF_SIZE(code)) {
 		case BPF_W:
 			opcode = ST32;
@@ -1340,6 +1346,9 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		const u8 tmp2 = bpf2sparc[TMP_REG_2];
 		const u8 tmp3 = bpf2sparc[TMP_REG_3];
 
+		if (insn->dst_reg == BPF_REG_FP)
+			ctx->saw_frame_pointer = true;
+
 		ctx->tmp_1_used = true;
 		ctx->tmp_2_used = true;
 		ctx->tmp_3_used = true;
@@ -1360,6 +1369,9 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
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



