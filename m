Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F9850867
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730866AbfFXKRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729631AbfFXKRD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:17:03 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D13C20645;
        Mon, 24 Jun 2019 10:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371422;
        bh=2JSS8IKH4OmQiltOgzRLBWCt9V9Lbb5J6fFkHC+io+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJ3FPi/xKEL6plCP6JGv199eMoQgfgqezuJ0lcU40+qLCVbg20Q0qzvgU9y26115o
         A2Zhrvh9JPhoQFRJFwcQeVnMSVs/jGbVk1mtUMTFK6qKC5pq+Q0GuXWCLhAII8/1Oi
         NnhUug/Pz0FfpWDQYxOR8nMcnsuROPrWbZyOzScQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.1 097/121] powerpc/bpf: use unsigned division instruction for 64-bit operations
Date:   Mon, 24 Jun 2019 17:57:09 +0800
Message-Id: <20190624092325.708652754@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit 758f2046ea040773ae8ea7f72dd3bbd8fa984501 upstream.

BPF_ALU64 div/mod operations are currently using signed division, unlike
BPF_ALU32 operations. Fix the same. DIV64 and MOD64 overflow tests pass
with this fix.

Fixes: 156d0e290e969c ("powerpc/ebpf/jit: Implement JIT compiler for extended BPF")
Cc: stable@vger.kernel.org # v4.8+
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/ppc-opcode.h |    1 +
 arch/powerpc/net/bpf_jit.h            |    2 +-
 arch/powerpc/net/bpf_jit_comp64.c     |    8 ++++----
 3 files changed, 6 insertions(+), 5 deletions(-)

--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -342,6 +342,7 @@
 #define PPC_INST_MADDLD			0x10000033
 #define PPC_INST_DIVWU			0x7c000396
 #define PPC_INST_DIVD			0x7c0003d2
+#define PPC_INST_DIVDU			0x7c000392
 #define PPC_INST_RLWINM			0x54000000
 #define PPC_INST_RLWINM_DOT		0x54000001
 #define PPC_INST_RLWIMI			0x50000000
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -116,7 +116,7 @@
 				     ___PPC_RA(a) | IMM_L(i))
 #define PPC_DIVWU(d, a, b)	EMIT(PPC_INST_DIVWU | ___PPC_RT(d) |	      \
 				     ___PPC_RA(a) | ___PPC_RB(b))
-#define PPC_DIVD(d, a, b)	EMIT(PPC_INST_DIVD | ___PPC_RT(d) |	      \
+#define PPC_DIVDU(d, a, b)	EMIT(PPC_INST_DIVDU | ___PPC_RT(d) |	      \
 				     ___PPC_RA(a) | ___PPC_RB(b))
 #define PPC_AND(d, a, b)	EMIT(PPC_INST_AND | ___PPC_RA(d) |	      \
 				     ___PPC_RS(a) | ___PPC_RB(b))
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -399,12 +399,12 @@ static int bpf_jit_build_body(struct bpf
 		case BPF_ALU64 | BPF_DIV | BPF_X: /* dst /= src */
 		case BPF_ALU64 | BPF_MOD | BPF_X: /* dst %= src */
 			if (BPF_OP(code) == BPF_MOD) {
-				PPC_DIVD(b2p[TMP_REG_1], dst_reg, src_reg);
+				PPC_DIVDU(b2p[TMP_REG_1], dst_reg, src_reg);
 				PPC_MULD(b2p[TMP_REG_1], src_reg,
 						b2p[TMP_REG_1]);
 				PPC_SUB(dst_reg, dst_reg, b2p[TMP_REG_1]);
 			} else
-				PPC_DIVD(dst_reg, dst_reg, src_reg);
+				PPC_DIVDU(dst_reg, dst_reg, src_reg);
 			break;
 		case BPF_ALU | BPF_MOD | BPF_K: /* (u32) dst %= (u32) imm */
 		case BPF_ALU | BPF_DIV | BPF_K: /* (u32) dst /= (u32) imm */
@@ -432,7 +432,7 @@ static int bpf_jit_build_body(struct bpf
 				break;
 			case BPF_ALU64:
 				if (BPF_OP(code) == BPF_MOD) {
-					PPC_DIVD(b2p[TMP_REG_2], dst_reg,
+					PPC_DIVDU(b2p[TMP_REG_2], dst_reg,
 							b2p[TMP_REG_1]);
 					PPC_MULD(b2p[TMP_REG_1],
 							b2p[TMP_REG_1],
@@ -440,7 +440,7 @@ static int bpf_jit_build_body(struct bpf
 					PPC_SUB(dst_reg, dst_reg,
 							b2p[TMP_REG_1]);
 				} else
-					PPC_DIVD(dst_reg, dst_reg,
+					PPC_DIVDU(dst_reg, dst_reg,
 							b2p[TMP_REG_1]);
 				break;
 			}


