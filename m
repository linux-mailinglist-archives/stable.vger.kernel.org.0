Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D525106CE1
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730525AbfKVKz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:55:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:43254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729860AbfKVKzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:55:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FF7420637;
        Fri, 22 Nov 2019 10:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420153;
        bh=RPAAjHkX6Jz9F4rm+4mdrbY+L234J7mVJrQvrjHijEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYhFkKQ2Y10WKHc/qW0iwC3xAGqjy/cwrwsEHxt18t3scJZpHNucmUn8nRAdtmKTp
         RmeDXsDhmtKmzk7SDegz2nUn/KBtp7sjBstNmiNo7QrzegvQhD21gzQbDgr757NRja
         cdstBSA6Ab6aW5rLhvNFpnuP70/7kdyZO82kyh04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wang YanQing <udknight@gmail.com>
Subject: [PATCH 4.19 012/220] bpf, x32: Fix bug with ALU64 {LSH, RSH, ARSH} BPF_X shift by 0
Date:   Fri, 22 Nov 2019 11:26:17 +0100
Message-Id: <20191122100913.512221429@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke Nelson <lukenels@cs.washington.edu>

commit 68a8357ec15bdce55266e9fba8b8b3b8143fa7d2 upstream.

The current x32 BPF JIT for shift operations is not correct when the
shift amount in a register is 0. The expected behavior is a no-op, whereas
the current implementation changes bits in the destination register.

The following example demonstrates the bug. The expected result of this
program is 1, but the current JITed code returns 2.

  r0 = 1
  r1 = 1
  r2 = 0
  r1 <<= r2
  if r1 == 1 goto end
  r0 = 2
end:
  exit

The bug is caused by an incorrect assumption by the JIT that a shift by
32 clear the register. On x32 however, shifts use the lower 5 bits of
the source, making a shift by 32 equivalent to a shift by 0.

This patch fixes the bug using double-precision shifts, which also
simplifies the code.

Fixes: 03f5781be2c7 ("bpf, x86_32: add eBPF JIT compiler for ia32")
Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Wang YanQing <udknight@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/net/bpf_jit_comp32.c |  221 ++++--------------------------------------
 1 file changed, 23 insertions(+), 198 deletions(-)

--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -722,9 +722,6 @@ static inline void emit_ia32_lsh_r64(con
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
-	static int jmp_label1 = -1;
-	static int jmp_label2 = -1;
-	static int jmp_label3 = -1;
 	u8 dreg_lo = dstk ? IA32_EAX : dst_lo;
 	u8 dreg_hi = dstk ? IA32_EDX : dst_hi;
 
@@ -743,79 +740,23 @@ static inline void emit_ia32_lsh_r64(con
 		/* mov ecx,src_lo */
 		EMIT2(0x8B, add_2reg(0xC0, src_lo, IA32_ECX));
 
-	/* cmp ecx,32 */
-	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 32);
-	/* Jumps when >= 32 */
-	if (is_imm8(jmp_label(jmp_label1, 2)))
-		EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));
-	else
-		EMIT2_off32(0x0F, IA32_JAE + 0x10, jmp_label(jmp_label1, 6));
-
-	/* < 32 */
-	/* shl dreg_hi,cl */
-	EMIT2(0xD3, add_1reg(0xE0, dreg_hi));
-	/* mov ebx,dreg_lo */
-	EMIT2(0x8B, add_2reg(0xC0, dreg_lo, IA32_EBX));
+	/* shld dreg_hi,dreg_lo,cl */
+	EMIT3(0x0F, 0xA5, add_2reg(0xC0, dreg_hi, dreg_lo));
 	/* shl dreg_lo,cl */
 	EMIT2(0xD3, add_1reg(0xE0, dreg_lo));
 
-	/* IA32_ECX = -IA32_ECX + 32 */
-	/* neg ecx */
-	EMIT2(0xF7, add_1reg(0xD8, IA32_ECX));
-	/* add ecx,32 */
-	EMIT3(0x83, add_1reg(0xC0, IA32_ECX), 32);
-
-	/* shr ebx,cl */
-	EMIT2(0xD3, add_1reg(0xE8, IA32_EBX));
-	/* or dreg_hi,ebx */
-	EMIT2(0x09, add_2reg(0xC0, dreg_hi, IA32_EBX));
-
-	/* goto out; */
-	if (is_imm8(jmp_label(jmp_label3, 2)))
-		EMIT2(0xEB, jmp_label(jmp_label3, 2));
-	else
-		EMIT1_off32(0xE9, jmp_label(jmp_label3, 5));
+	/* if ecx >= 32, mov dreg_lo into dreg_hi and clear dreg_lo */
 
-	/* >= 32 */
-	if (jmp_label1 == -1)
-		jmp_label1 = cnt;
-
-	/* cmp ecx,64 */
-	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 64);
-	/* Jumps when >= 64 */
-	if (is_imm8(jmp_label(jmp_label2, 2)))
-		EMIT2(IA32_JAE, jmp_label(jmp_label2, 2));
-	else
-		EMIT2_off32(0x0F, IA32_JAE + 0x10, jmp_label(jmp_label2, 6));
+	/* cmp ecx,32 */
+	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 32);
+	/* skip the next two instructions (4 bytes) when < 32 */
+	EMIT2(IA32_JB, 4);
 
-	/* >= 32 && < 64 */
-	/* sub ecx,32 */
-	EMIT3(0x83, add_1reg(0xE8, IA32_ECX), 32);
-	/* shl dreg_lo,cl */
-	EMIT2(0xD3, add_1reg(0xE0, dreg_lo));
 	/* mov dreg_hi,dreg_lo */
 	EMIT2(0x89, add_2reg(0xC0, dreg_hi, dreg_lo));
-
 	/* xor dreg_lo,dreg_lo */
 	EMIT2(0x33, add_2reg(0xC0, dreg_lo, dreg_lo));
 
-	/* goto out; */
-	if (is_imm8(jmp_label(jmp_label3, 2)))
-		EMIT2(0xEB, jmp_label(jmp_label3, 2));
-	else
-		EMIT1_off32(0xE9, jmp_label(jmp_label3, 5));
-
-	/* >= 64 */
-	if (jmp_label2 == -1)
-		jmp_label2 = cnt;
-	/* xor dreg_lo,dreg_lo */
-	EMIT2(0x33, add_2reg(0xC0, dreg_lo, dreg_lo));
-	/* xor dreg_hi,dreg_hi */
-	EMIT2(0x33, add_2reg(0xC0, dreg_hi, dreg_hi));
-
-	if (jmp_label3 == -1)
-		jmp_label3 = cnt;
-
 	if (dstk) {
 		/* mov dword ptr [ebp+off],dreg_lo */
 		EMIT3(0x89, add_2reg(0x40, IA32_EBP, dreg_lo),
@@ -834,9 +775,6 @@ static inline void emit_ia32_arsh_r64(co
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
-	static int jmp_label1 = -1;
-	static int jmp_label2 = -1;
-	static int jmp_label3 = -1;
 	u8 dreg_lo = dstk ? IA32_EAX : dst_lo;
 	u8 dreg_hi = dstk ? IA32_EDX : dst_hi;
 
@@ -855,79 +793,23 @@ static inline void emit_ia32_arsh_r64(co
 		/* mov ecx,src_lo */
 		EMIT2(0x8B, add_2reg(0xC0, src_lo, IA32_ECX));
 
-	/* cmp ecx,32 */
-	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 32);
-	/* Jumps when >= 32 */
-	if (is_imm8(jmp_label(jmp_label1, 2)))
-		EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));
-	else
-		EMIT2_off32(0x0F, IA32_JAE + 0x10, jmp_label(jmp_label1, 6));
-
-	/* < 32 */
-	/* lshr dreg_lo,cl */
-	EMIT2(0xD3, add_1reg(0xE8, dreg_lo));
-	/* mov ebx,dreg_hi */
-	EMIT2(0x8B, add_2reg(0xC0, dreg_hi, IA32_EBX));
-	/* ashr dreg_hi,cl */
+	/* shrd dreg_lo,dreg_hi,cl */
+	EMIT3(0x0F, 0xAD, add_2reg(0xC0, dreg_lo, dreg_hi));
+	/* sar dreg_hi,cl */
 	EMIT2(0xD3, add_1reg(0xF8, dreg_hi));
 
-	/* IA32_ECX = -IA32_ECX + 32 */
-	/* neg ecx */
-	EMIT2(0xF7, add_1reg(0xD8, IA32_ECX));
-	/* add ecx,32 */
-	EMIT3(0x83, add_1reg(0xC0, IA32_ECX), 32);
-
-	/* shl ebx,cl */
-	EMIT2(0xD3, add_1reg(0xE0, IA32_EBX));
-	/* or dreg_lo,ebx */
-	EMIT2(0x09, add_2reg(0xC0, dreg_lo, IA32_EBX));
-
-	/* goto out; */
-	if (is_imm8(jmp_label(jmp_label3, 2)))
-		EMIT2(0xEB, jmp_label(jmp_label3, 2));
-	else
-		EMIT1_off32(0xE9, jmp_label(jmp_label3, 5));
+	/* if ecx >= 32, mov dreg_hi to dreg_lo and set/clear dreg_hi depending on sign */
 
-	/* >= 32 */
-	if (jmp_label1 == -1)
-		jmp_label1 = cnt;
-
-	/* cmp ecx,64 */
-	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 64);
-	/* Jumps when >= 64 */
-	if (is_imm8(jmp_label(jmp_label2, 2)))
-		EMIT2(IA32_JAE, jmp_label(jmp_label2, 2));
-	else
-		EMIT2_off32(0x0F, IA32_JAE + 0x10, jmp_label(jmp_label2, 6));
+	/* cmp ecx,32 */
+	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 32);
+	/* skip the next two instructions (5 bytes) when < 32 */
+	EMIT2(IA32_JB, 5);
 
-	/* >= 32 && < 64 */
-	/* sub ecx,32 */
-	EMIT3(0x83, add_1reg(0xE8, IA32_ECX), 32);
-	/* ashr dreg_hi,cl */
-	EMIT2(0xD3, add_1reg(0xF8, dreg_hi));
 	/* mov dreg_lo,dreg_hi */
 	EMIT2(0x89, add_2reg(0xC0, dreg_lo, dreg_hi));
-
-	/* ashr dreg_hi,imm8 */
+	/* sar dreg_hi,31 */
 	EMIT3(0xC1, add_1reg(0xF8, dreg_hi), 31);
 
-	/* goto out; */
-	if (is_imm8(jmp_label(jmp_label3, 2)))
-		EMIT2(0xEB, jmp_label(jmp_label3, 2));
-	else
-		EMIT1_off32(0xE9, jmp_label(jmp_label3, 5));
-
-	/* >= 64 */
-	if (jmp_label2 == -1)
-		jmp_label2 = cnt;
-	/* ashr dreg_hi,imm8 */
-	EMIT3(0xC1, add_1reg(0xF8, dreg_hi), 31);
-	/* mov dreg_lo,dreg_hi */
-	EMIT2(0x89, add_2reg(0xC0, dreg_lo, dreg_hi));
-
-	if (jmp_label3 == -1)
-		jmp_label3 = cnt;
-
 	if (dstk) {
 		/* mov dword ptr [ebp+off],dreg_lo */
 		EMIT3(0x89, add_2reg(0x40, IA32_EBP, dreg_lo),
@@ -946,9 +828,6 @@ static inline void emit_ia32_rsh_r64(con
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
-	static int jmp_label1 = -1;
-	static int jmp_label2 = -1;
-	static int jmp_label3 = -1;
 	u8 dreg_lo = dstk ? IA32_EAX : dst_lo;
 	u8 dreg_hi = dstk ? IA32_EDX : dst_hi;
 
@@ -967,77 +846,23 @@ static inline void emit_ia32_rsh_r64(con
 		/* mov ecx,src_lo */
 		EMIT2(0x8B, add_2reg(0xC0, src_lo, IA32_ECX));
 
-	/* cmp ecx,32 */
-	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 32);
-	/* Jumps when >= 32 */
-	if (is_imm8(jmp_label(jmp_label1, 2)))
-		EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));
-	else
-		EMIT2_off32(0x0F, IA32_JAE + 0x10, jmp_label(jmp_label1, 6));
-
-	/* < 32 */
-	/* lshr dreg_lo,cl */
-	EMIT2(0xD3, add_1reg(0xE8, dreg_lo));
-	/* mov ebx,dreg_hi */
-	EMIT2(0x8B, add_2reg(0xC0, dreg_hi, IA32_EBX));
+	/* shrd dreg_lo,dreg_hi,cl */
+	EMIT3(0x0F, 0xAD, add_2reg(0xC0, dreg_lo, dreg_hi));
 	/* shr dreg_hi,cl */
 	EMIT2(0xD3, add_1reg(0xE8, dreg_hi));
 
-	/* IA32_ECX = -IA32_ECX + 32 */
-	/* neg ecx */
-	EMIT2(0xF7, add_1reg(0xD8, IA32_ECX));
-	/* add ecx,32 */
-	EMIT3(0x83, add_1reg(0xC0, IA32_ECX), 32);
-
-	/* shl ebx,cl */
-	EMIT2(0xD3, add_1reg(0xE0, IA32_EBX));
-	/* or dreg_lo,ebx */
-	EMIT2(0x09, add_2reg(0xC0, dreg_lo, IA32_EBX));
-
-	/* goto out; */
-	if (is_imm8(jmp_label(jmp_label3, 2)))
-		EMIT2(0xEB, jmp_label(jmp_label3, 2));
-	else
-		EMIT1_off32(0xE9, jmp_label(jmp_label3, 5));
+	/* if ecx >= 32, mov dreg_hi to dreg_lo and clear dreg_hi */
 
-	/* >= 32 */
-	if (jmp_label1 == -1)
-		jmp_label1 = cnt;
-	/* cmp ecx,64 */
-	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 64);
-	/* Jumps when >= 64 */
-	if (is_imm8(jmp_label(jmp_label2, 2)))
-		EMIT2(IA32_JAE, jmp_label(jmp_label2, 2));
-	else
-		EMIT2_off32(0x0F, IA32_JAE + 0x10, jmp_label(jmp_label2, 6));
+	/* cmp ecx,32 */
+	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), 32);
+	/* skip the next two instructions (4 bytes) when < 32 */
+	EMIT2(IA32_JB, 4);
 
-	/* >= 32 && < 64 */
-	/* sub ecx,32 */
-	EMIT3(0x83, add_1reg(0xE8, IA32_ECX), 32);
-	/* shr dreg_hi,cl */
-	EMIT2(0xD3, add_1reg(0xE8, dreg_hi));
 	/* mov dreg_lo,dreg_hi */
 	EMIT2(0x89, add_2reg(0xC0, dreg_lo, dreg_hi));
 	/* xor dreg_hi,dreg_hi */
 	EMIT2(0x33, add_2reg(0xC0, dreg_hi, dreg_hi));
 
-	/* goto out; */
-	if (is_imm8(jmp_label(jmp_label3, 2)))
-		EMIT2(0xEB, jmp_label(jmp_label3, 2));
-	else
-		EMIT1_off32(0xE9, jmp_label(jmp_label3, 5));
-
-	/* >= 64 */
-	if (jmp_label2 == -1)
-		jmp_label2 = cnt;
-	/* xor dreg_lo,dreg_lo */
-	EMIT2(0x33, add_2reg(0xC0, dreg_lo, dreg_lo));
-	/* xor dreg_hi,dreg_hi */
-	EMIT2(0x33, add_2reg(0xC0, dreg_hi, dreg_hi));
-
-	if (jmp_label3 == -1)
-		jmp_label3 = cnt;
-
 	if (dstk) {
 		/* mov dword ptr [ebp+off],dreg_lo */
 		EMIT3(0x89, add_2reg(0x40, IA32_EBP, dreg_lo),


