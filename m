Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571C445BE37
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245358AbhKXMpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:45:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345620AbhKXMn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:43:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C332D61407;
        Wed, 24 Nov 2021 12:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756748;
        bh=zJzrMPNKLG59spI4CEQFBfM90LhD9BeR/UUez+YvwO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSkVA2wjNd81+IGbrAOzG3feebGnpnzxmv65c+clTmD0VN6cxZq2lvr+W5yJwNOEp
         kt8G8ER7zcqsYjL9QvuyCIZhzlfI2av0OSjip+CHtrZEQIaAmbbLRCOXfwtTJ1ifrv
         PU6dQVPnC0rnt9aBhpCjkqR7vUS2zrKK+TuP35WA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 4.14 192/251] powerpc/bpf: Validate branch ranges
Date:   Wed, 24 Nov 2021 12:57:14 +0100
Message-Id: <20211124115716.951273837@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

upstream commit 3832ba4e283d7052b783dab8311df7e3590fed93

Add checks to ensure that we never emit branch instructions with
truncated branch offsets.

Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Tested-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/71d33a6b7603ec1013c9734dd8bdd4ff5e929142.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
[include header, drop ppc32 changes]
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/net/bpf_jit.h        |   26 ++++++++++++++++++++------
 arch/powerpc/net/bpf_jit_comp64.c |   10 +++++++---
 2 files changed, 27 insertions(+), 9 deletions(-)

--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -15,6 +15,7 @@
 #ifndef __ASSEMBLY__
 
 #include <asm/types.h>
+#include <asm/code-patching.h>
 
 #ifdef PPC64_ELF_ABI_v1
 #define FUNCTION_DESCR_SIZE	24
@@ -176,13 +177,26 @@
 #define PPC_NEG(d, a)		EMIT(PPC_INST_NEG | ___PPC_RT(d) | ___PPC_RA(a))
 
 /* Long jump; (unconditional 'branch') */
-#define PPC_JMP(dest)		EMIT(PPC_INST_BRANCH |			      \
-				     (((dest) - (ctx->idx * 4)) & 0x03fffffc))
+#define PPC_JMP(dest)							      \
+	do {								      \
+		long offset = (long)(dest) - (ctx->idx * 4);		      \
+		if (!is_offset_in_branch_range(offset)) {		      \
+			pr_err_ratelimited("Branch offset 0x%lx (@%u) out of range\n", offset, ctx->idx);			\
+			return -ERANGE;					      \
+		}							      \
+		EMIT(PPC_INST_BRANCH | (offset & 0x03fffffc));		      \
+	} while (0)
 /* "cond" here covers BO:BI fields. */
-#define PPC_BCC_SHORT(cond, dest)	EMIT(PPC_INST_BRANCH_COND |	      \
-					     (((cond) & 0x3ff) << 16) |	      \
-					     (((dest) - (ctx->idx * 4)) &     \
-					      0xfffc))
+#define PPC_BCC_SHORT(cond, dest)					      \
+	do {								      \
+		long offset = (long)(dest) - (ctx->idx * 4);		      \
+		if (!is_offset_in_cond_branch_range(offset)) {		      \
+			pr_err_ratelimited("Conditional branch offset 0x%lx (@%u) out of range\n", offset, ctx->idx);		\
+			return -ERANGE;					      \
+		}							      \
+		EMIT(PPC_INST_BRANCH_COND | (((cond) & 0x3ff) << 16) | (offset & 0xfffc));					\
+	} while (0)
+
 /* Sign-extended 32-bit immediate load */
 #define PPC_LI32(d, i)		do {					      \
 		if ((int)(uintptr_t)(i) >= -32768 &&			      \
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -235,7 +235,7 @@ static void bpf_jit_emit_func_call(u32 *
 	PPC_BLRL();
 }
 
-static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 out)
+static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 out)
 {
 	/*
 	 * By now, the eBPF program has already setup parameters in r3, r4 and r5
@@ -296,7 +296,9 @@ static void bpf_jit_emit_tail_call(u32 *
 	bpf_jit_emit_common_epilogue(image, ctx);
 
 	PPC_BCTR();
+
 	/* out: */
+	return 0;
 }
 
 /* Assemble the body code between the prologue & epilogue */
@@ -306,7 +308,7 @@ static int bpf_jit_build_body(struct bpf
 {
 	const struct bpf_insn *insn = fp->insnsi;
 	int flen = fp->len;
-	int i;
+	int i, ret;
 
 	/* Start of epilogue code - will only be valid 2nd pass onwards */
 	u32 exit_addr = addrs[flen];
@@ -956,7 +958,9 @@ common_load:
 		 */
 		case BPF_JMP | BPF_TAIL_CALL:
 			ctx->seen |= SEEN_TAILCALL;
-			bpf_jit_emit_tail_call(image, ctx, addrs[i + 1]);
+			ret = bpf_jit_emit_tail_call(image, ctx, addrs[i + 1]);
+			if (ret < 0)
+				return ret;
 			break;
 
 		default:


