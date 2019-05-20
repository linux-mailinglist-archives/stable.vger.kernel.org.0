Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABADC233A8
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731597AbfETMTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:19:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387801AbfETMTR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:19:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F59C20815;
        Mon, 20 May 2019 12:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354756;
        bh=nkjVUnaYiahUX1ExbUzV/31xwNKk5fVHRqckHsd1opo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+DSeOxqOT//I61+S+O/i5OYJx5qZ40gPNM3/IPK2P5OztegDj8vgE3mgRlf9PA7+
         qZlvdls4dfcLYmK+sHB9yzlbG+MIIxo9cFugABXLC/RFU1FdDRQ1q1CDK/4kuuZMHz
         h6HFzLuw9L76W8a1UYK5FLpGJQHR+xl+p8Nc616g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.14 31/63] bpf, arm64: remove prefetch insn in xadd mapping
Date:   Mon, 20 May 2019 14:14:10 +0200
Message-Id: <20190520115234.777269637@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
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
@@ -712,7 +712,6 @@ emit_cond_jmp:
 	case BPF_STX | BPF_XADD | BPF_DW:
 		emit_a64_mov_i(1, tmp, off, ctx);
 		emit(A64_ADD(1, tmp, tmp, dst), ctx);
-		emit(A64_PRFM(tmp, PST, L1, STRM), ctx);
 		emit(A64_LDXR(isdw, tmp2, tmp), ctx);
 		emit(A64_ADD(isdw, tmp2, tmp2, src), ctx);
 		emit(A64_STXR(isdw, tmp2, tmp, tmp3), ctx);


