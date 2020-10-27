Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95D029B907
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802156AbgJ0Ppr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798662AbgJ0P3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:29:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2096920728;
        Tue, 27 Oct 2020 15:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812573;
        bh=eFMSU6djPfqs5qY5i1d/PlLUBIEnhdXNi8ib5BX6DLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNO92uQqfLU/i1KqmKj+BaqXsg/6pRxNQk8fakEh36N+tMn3El4NZ1XSe3fibfafL
         E7cpxCSksWfd4F4j4fW8Jzgsz4vqEw163eO5HspGmSfhAlftGRH2m2+mq29rv2LwYP
         4LLURqgDdd3pBUExXfZXzpHls73HC0gwisJhzC94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 258/757] s390/bpf: Fix multiple tail calls
Date:   Tue, 27 Oct 2020 14:48:28 +0100
Message-Id: <20201027135502.677997448@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit d72714c1da138e6755d3bd14662dc5b7f17fae7f ]

In order to branch around tail calls (due to out-of-bounds index,
exceeding tail call count or missing tail call target), JIT uses
label[0] field, which contains the address of the instruction following
the tail call. When there are multiple tail calls, label[0] value comes
from handling of a previous tail call, which is incorrect.

Fix by getting rid of label array and resolving the label address
locally: for all 3 branches that jump to it, emit 0 offsets at the
beginning, and then backpatch them with the correct value.

Also, do not use the long jump infrastructure: the tail call sequence
is known to be short, so make all 3 jumps short.

Fixes: 6651ee070b31 ("s390/bpf: implement bpf_tail_call() helper")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200909232141.3099367-1-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 61 ++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 34 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index be4b8532dd3c4..0a41827928769 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -50,7 +50,6 @@ struct bpf_jit {
 	int r14_thunk_ip;	/* Address of expoline thunk for 'br %r14' */
 	int tail_call_start;	/* Tail call start offset */
 	int excnt;		/* Number of exception table entries */
-	int labels[1];		/* Labels for local jumps */
 };
 
 #define SEEN_MEM	BIT(0)		/* use mem[] for temporary storage */
@@ -229,18 +228,18 @@ static inline void reg_set_seen(struct bpf_jit *jit, u32 b1)
 	REG_SET_SEEN(b3);					\
 })
 
-#define EMIT6_PCREL_LABEL(op1, op2, b1, b2, label, mask)	\
+#define EMIT6_PCREL_RIEB(op1, op2, b1, b2, mask, target)	\
 ({								\
-	int rel = (jit->labels[label] - jit->prg) >> 1;		\
+	unsigned int rel = (int)((target) - jit->prg) / 2;	\
 	_EMIT6((op1) | reg(b1, b2) << 16 | (rel & 0xffff),	\
 	       (op2) | (mask) << 12);				\
 	REG_SET_SEEN(b1);					\
 	REG_SET_SEEN(b2);					\
 })
 
-#define EMIT6_PCREL_IMM_LABEL(op1, op2, b1, imm, label, mask)	\
+#define EMIT6_PCREL_RIEC(op1, op2, b1, imm, mask, target)	\
 ({								\
-	int rel = (jit->labels[label] - jit->prg) >> 1;		\
+	unsigned int rel = (int)((target) - jit->prg) / 2;	\
 	_EMIT6((op1) | (reg_high(b1) | (mask)) << 16 |		\
 		(rel & 0xffff), (op2) | ((imm) & 0xff) << 8);	\
 	REG_SET_SEEN(b1);					\
@@ -1282,7 +1281,9 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 		EMIT4(0xb9040000, BPF_REG_0, REG_2);
 		break;
 	}
-	case BPF_JMP | BPF_TAIL_CALL:
+	case BPF_JMP | BPF_TAIL_CALL: {
+		int patch_1_clrj, patch_2_clij, patch_3_brc;
+
 		/*
 		 * Implicit input:
 		 *  B1: pointer to ctx
@@ -1300,16 +1301,10 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 		EMIT6_DISP_LH(0xe3000000, 0x0016, REG_W1, REG_0, BPF_REG_2,
 			      offsetof(struct bpf_array, map.max_entries));
 		/* if ((u32)%b3 >= (u32)%w1) goto out; */
-		if (!is_first_pass(jit) && can_use_rel(jit, jit->labels[0])) {
-			/* clrj %b3,%w1,0xa,label0 */
-			EMIT6_PCREL_LABEL(0xec000000, 0x0077, BPF_REG_3,
-					  REG_W1, 0, 0xa);
-		} else {
-			/* clr %b3,%w1 */
-			EMIT2(0x1500, BPF_REG_3, REG_W1);
-			/* brcl 0xa,label0 */
-			EMIT6_PCREL_RILC(0xc0040000, 0xa, jit->labels[0]);
-		}
+		/* clrj %b3,%w1,0xa,out */
+		patch_1_clrj = jit->prg;
+		EMIT6_PCREL_RIEB(0xec000000, 0x0077, BPF_REG_3, REG_W1, 0xa,
+				 jit->prg);
 
 		/*
 		 * if (tail_call_cnt++ > MAX_TAIL_CALL_CNT)
@@ -1324,16 +1319,10 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 		EMIT4_IMM(0xa7080000, REG_W0, 1);
 		/* laal %w1,%w0,off(%r15) */
 		EMIT6_DISP_LH(0xeb000000, 0x00fa, REG_W1, REG_W0, REG_15, off);
-		if (!is_first_pass(jit) && can_use_rel(jit, jit->labels[0])) {
-			/* clij %w1,MAX_TAIL_CALL_CNT,0x2,label0 */
-			EMIT6_PCREL_IMM_LABEL(0xec000000, 0x007f, REG_W1,
-					      MAX_TAIL_CALL_CNT, 0, 0x2);
-		} else {
-			/* clfi %w1,MAX_TAIL_CALL_CNT */
-			EMIT6_IMM(0xc20f0000, REG_W1, MAX_TAIL_CALL_CNT);
-			/* brcl 0x2,label0 */
-			EMIT6_PCREL_RILC(0xc0040000, 0x2, jit->labels[0]);
-		}
+		/* clij %w1,MAX_TAIL_CALL_CNT,0x2,out */
+		patch_2_clij = jit->prg;
+		EMIT6_PCREL_RIEC(0xec000000, 0x007f, REG_W1, MAX_TAIL_CALL_CNT,
+				 2, jit->prg);
 
 		/*
 		 * prog = array->ptrs[index];
@@ -1348,13 +1337,9 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 		/* ltg %r1,prog(%b2,%r1) */
 		EMIT6_DISP_LH(0xe3000000, 0x0002, REG_1, BPF_REG_2,
 			      REG_1, offsetof(struct bpf_array, ptrs));
-		if (!is_first_pass(jit) && can_use_rel(jit, jit->labels[0])) {
-			/* brc 0x8,label0 */
-			EMIT4_PCREL_RIC(0xa7040000, 0x8, jit->labels[0]);
-		} else {
-			/* brcl 0x8,label0 */
-			EMIT6_PCREL_RILC(0xc0040000, 0x8, jit->labels[0]);
-		}
+		/* brc 0x8,out */
+		patch_3_brc = jit->prg;
+		EMIT4_PCREL_RIC(0xa7040000, 8, jit->prg);
 
 		/*
 		 * Restore registers before calling function
@@ -1371,8 +1356,16 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 		/* bc 0xf,tail_call_start(%r1) */
 		_EMIT4(0x47f01000 + jit->tail_call_start);
 		/* out: */
-		jit->labels[0] = jit->prg;
+		if (jit->prg_buf) {
+			*(u16 *)(jit->prg_buf + patch_1_clrj + 2) =
+				(jit->prg - patch_1_clrj) >> 1;
+			*(u16 *)(jit->prg_buf + patch_2_clij + 2) =
+				(jit->prg - patch_2_clij) >> 1;
+			*(u16 *)(jit->prg_buf + patch_3_brc + 2) =
+				(jit->prg - patch_3_brc) >> 1;
+		}
 		break;
+	}
 	case BPF_JMP | BPF_EXIT: /* return b0 */
 		last = (i == fp->len - 1) ? 1 : 0;
 		if (last)
-- 
2.25.1



