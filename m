Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8D4138001
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730735AbgAKKZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:25:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731011AbgAKKY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:24:57 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F71A2082E;
        Sat, 11 Jan 2020 10:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738296;
        bh=sA28e4/Vn28o0eBK2OtFILC07rU4A36VwG070Roqi1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqE39Rqrv/b1aQ+qjm2sR0uDC+8kFXI9j2gwEMunZ1z9ZkJDgvltWvr2GXGmM+sQr
         8UD7Z2/BneFPODvUZY2daxYdnp14YnhT1Vtubr92sQijS0oiC2ah3iyS1EIYwLhWPy
         UGr9ixSo2WZ7QP4Zx7lEDA8nr9gsB0TXLGE4a31s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mahshid Khezri <khezri.mahshid@gmail.com>,
        Paul Chaignon <paul.chaignon@orange.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/165] bpf, riscv: Limit to 33 tail calls
Date:   Sat, 11 Jan 2020 10:49:32 +0100
Message-Id: <20200111094925.775463225@linuxfoundation.org>
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

[ Upstream commit 96bc4432f5ade1045521f3b247f516b1478166bd ]

All BPF JIT compilers except RISC-V's and MIPS' enforce a 33-tail calls
limit at runtime.  In addition, a test was recently added, in tailcalls2,
to check this limit.

This patch updates the tail call limit in RISC-V's JIT compiler to allow
33 tail calls.  I tested it using the above selftest on an emulated
RISCV64.

Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
Reported-by: Mahshid Khezri <khezri.mahshid@gmail.com>
Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn.topel@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/966fe384383bf23a0ee1efe8d7291c78a3fb832b.1575916815.git.paul.chaignon@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index 5451ef3845f2..7fbf56aab661 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -631,14 +631,14 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 		return -1;
 	emit(rv_bgeu(RV_REG_A2, RV_REG_T1, off >> 1), ctx);
 
-	/* if (--TCC < 0)
+	/* if (TCC-- < 0)
 	 *     goto out;
 	 */
 	emit(rv_addi(RV_REG_T1, tcc, -1), ctx);
 	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
 	if (is_13b_check(off, insn))
 		return -1;
-	emit(rv_blt(RV_REG_T1, RV_REG_ZERO, off >> 1), ctx);
+	emit(rv_blt(tcc, RV_REG_ZERO, off >> 1), ctx);
 
 	/* prog = array->ptrs[index];
 	 * if (!prog)
-- 
2.20.1



