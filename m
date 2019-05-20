Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2489423606
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387530AbfETMm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390041AbfETMaK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:30:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E4A821479;
        Mon, 20 May 2019 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355410;
        bh=W0oY8n1wZzk02zCfdndXOv6JwnP2410FS28E60iwQiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIbrwc4aNosJEDhQUwF9C6ECglQ0YrqTr2WWK4shOxODHSUUnlOqPYoTEv88v2Twv
         QL7CtaVmvNQmOcyen/+3+HaGhAgaLyR1xIIFOpDKzFcKpPjO9J4aeiRaJDtKufOh29
         1aCc2BgVKzNts6Vi19/v9xLBB5L9gYiqAFsOI/LM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.0 057/123] bpf, arm64: remove prefetch insn in xadd mapping
Date:   Mon, 20 May 2019 14:13:57 +0200
Message-Id: <20190520115248.555156585@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 8968c67a82ab7501bc3b9439c3624a49b42fe54c upstream.

Prefetch-with-intent-to-write is currently part of the XADD mapping in
the AArch64 JIT and follows the kernel's implementation of atomic_add.
This may interfere with other threads executing the LDXR/STXR loop,
leading to potential starvation and fairness issues. Drop the optional
prefetch instruction.

Fixes: 85f68fe89832 ("bpf, arm64: implement jiting of BPF_XADD")
Reported-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/net/bpf_jit.h      |    6 ------
 arch/arm64/net/bpf_jit_comp.c |    1 -
 2 files changed, 7 deletions(-)

--- a/arch/arm64/net/bpf_jit.h
+++ b/arch/arm64/net/bpf_jit.h
@@ -100,12 +100,6 @@
 #define A64_STXR(sf, Rt, Rn, Rs) \
 	A64_LSX(sf, Rt, Rn, Rs, STORE_EX)
 
-/* Prefetch */
-#define A64_PRFM(Rn, type, target, policy) \
-	aarch64_insn_gen_prefetch(Rn, AARCH64_INSN_PRFM_TYPE_##type, \
-				  AARCH64_INSN_PRFM_TARGET_##target, \
-				  AARCH64_INSN_PRFM_POLICY_##policy)
-
 /* Add/subtract (immediate) */
 #define A64_ADDSUB_IMM(sf, Rd, Rn, imm12, type) \
 	aarch64_insn_gen_add_sub_imm(Rd, Rn, imm12, \
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -739,7 +739,6 @@ emit_cond_jmp:
 	case BPF_STX | BPF_XADD | BPF_DW:
 		emit_a64_mov_i(1, tmp, off, ctx);
 		emit(A64_ADD(1, tmp, tmp, dst), ctx);
-		emit(A64_PRFM(tmp, PST, L1, STRM), ctx);
 		emit(A64_LDXR(isdw, tmp2, tmp), ctx);
 		emit(A64_ADD(isdw, tmp2, tmp2, src), ctx);
 		emit(A64_STXR(isdw, tmp2, tmp, tmp3), ctx);


