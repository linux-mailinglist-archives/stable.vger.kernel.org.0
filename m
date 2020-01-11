Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC18138004
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbgAKKZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:25:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730755AbgAKKZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:25:09 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C277B24656;
        Sat, 11 Jan 2020 10:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738308;
        bh=/HIwhlNmpl78m/mcuJJ4q/f+IzAoDcULwkDxvESQ+wM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtCLGCTQ3nVeTwrIAWSVLBYiGiTBnE8Su2sPeTLgXl7lgiOKlcE8gAMVlnw2lUbo4
         3iai3uPFtKNmt1gf6AzGhc3KITJstrT56ZCuIZlAtnBo6UPdEGygaQTpnu6Gw7nvnE
         mSI00bdt5I5+BQAUm3dDIXHHiwerDYJqexP05fwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mahshid Khezri <khezri.mahshid@gmail.com>,
        Paul Chaignon <paul.chaignon@orange.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/165] bpf, mips: Limit to 33 tail calls
Date:   Sat, 11 Jan 2020 10:49:33 +0100
Message-Id: <20200111094925.829562564@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Chaignon <paul.chaignon@orange.com>

[ Upstream commit e49e6f6db04e915dccb494ae10fa14888fea6f89 ]

All BPF JIT compilers except RISC-V's and MIPS' enforce a 33-tail calls
limit at runtime.  In addition, a test was recently added, in tailcalls2,
to check this limit.

This patch updates the tail call limit in MIPS' JIT compiler to allow
33 tail calls.

Fixes: b6bd53f9c4e8 ("MIPS: Add missing file for eBPF JIT.")
Reported-by: Mahshid Khezri <khezri.mahshid@gmail.com>
Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/b8eb2caac1c25453c539248e56ca22f74b5316af.1575916815.git.paul.chaignon@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/net/ebpf_jit.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index a2405d5f7d1e..561154cbcc40 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -604,6 +604,7 @@ static void emit_const_to_reg(struct jit_ctx *ctx, int dst, u64 value)
 static int emit_bpf_tail_call(struct jit_ctx *ctx, int this_idx)
 {
 	int off, b_off;
+	int tcc_reg;
 
 	ctx->flags |= EBPF_SEEN_TC;
 	/*
@@ -616,14 +617,14 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int this_idx)
 	b_off = b_imm(this_idx + 1, ctx);
 	emit_instr(ctx, bne, MIPS_R_AT, MIPS_R_ZERO, b_off);
 	/*
-	 * if (--TCC < 0)
+	 * if (TCC-- < 0)
 	 *     goto out;
 	 */
 	/* Delay slot */
-	emit_instr(ctx, daddiu, MIPS_R_T5,
-		   (ctx->flags & EBPF_TCC_IN_V1) ? MIPS_R_V1 : MIPS_R_S4, -1);
+	tcc_reg = (ctx->flags & EBPF_TCC_IN_V1) ? MIPS_R_V1 : MIPS_R_S4;
+	emit_instr(ctx, daddiu, MIPS_R_T5, tcc_reg, -1);
 	b_off = b_imm(this_idx + 1, ctx);
-	emit_instr(ctx, bltz, MIPS_R_T5, b_off);
+	emit_instr(ctx, bltz, tcc_reg, b_off);
 	/*
 	 * prog = array->ptrs[index];
 	 * if (prog == NULL)
-- 
2.20.1



