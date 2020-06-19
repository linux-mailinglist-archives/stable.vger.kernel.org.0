Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEBA201282
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393055AbgFSPWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393044AbgFSPWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:22:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2708A2158C;
        Fri, 19 Jun 2020 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580161;
        bh=fK82cI40GO1yH3Ip1kLba1zXWfkLTxYg+MFpEbXh69w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ymUUSl98qY5c/StJ3YtNAM7VctWsuQuOBXIfFn2QzQaOK/qGnY2rCbN/KEny7EB6j
         EhyE8mdao804h0WpoRwk5K9qf21jxVXrN9ohWyNLhvQLF0tF4g2CRF/FWvfK24fp6s
         NXzsWbTAwywf3RoN1cwAvUrefdYhPmET3yreoLRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luke Nelson <luke.r.nels@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Xi Wang <xi.wang@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 115/376] bpf, riscv: Fix tail call count off by one in RV32 BPF JIT
Date:   Fri, 19 Jun 2020 16:30:33 +0200
Message-Id: <20200619141715.790006142@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke Nelson <lukenels@cs.washington.edu>

[ Upstream commit 745abfaa9eafa597d31fdf24a3249e5206a98768 ]

This patch fixes an off by one error in the RV32 JIT handling for BPF
tail call. Currently, the code decrements TCC before checking if it
is less than zero. This limits the maximum number of tail calls to 32
instead of 33 as in other JITs. The fix is to instead check the old
value of TCC before decrementing.

Fixes: 5f316b65e99f ("riscv, bpf: Add RV32G eBPF JIT")
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Xi Wang <xi.wang@gmail.com>
Link: https://lore.kernel.org/bpf/20200421002804.5118-1-luke.r.nels@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp32.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_comp32.c
index 302934177760..11083d4d5f2d 100644
--- a/arch/riscv/net/bpf_jit_comp32.c
+++ b/arch/riscv/net/bpf_jit_comp32.c
@@ -770,12 +770,13 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	emit_bcc(BPF_JGE, lo(idx_reg), RV_REG_T1, off, ctx);
 
 	/*
-	 * if ((temp_tcc = tcc - 1) < 0)
+	 * temp_tcc = tcc - 1;
+	 * if (tcc < 0)
 	 *   goto out;
 	 */
 	emit(rv_addi(RV_REG_T1, RV_REG_TCC, -1), ctx);
 	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
-	emit_bcc(BPF_JSLT, RV_REG_T1, RV_REG_ZERO, off, ctx);
+	emit_bcc(BPF_JSLT, RV_REG_TCC, RV_REG_ZERO, off, ctx);
 
 	/*
 	 * prog = array->ptrs[index];
-- 
2.25.1



