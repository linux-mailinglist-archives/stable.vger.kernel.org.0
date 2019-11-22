Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51EE5106F0C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbfKVKz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:55:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:43326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730529AbfKVKz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:55:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B8ED20706;
        Fri, 22 Nov 2019 10:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420156;
        bh=hoi0A6doKosz05TOcHyTBS65f5NrBZQ6y2IQFRS7R6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZUDVT8FIIlIw5QiU2ie0psjVe3Kxtb2swUEJ7wyOwSAA8vAYvS5aItcynGxF2HNu
         GkFW7tCZbTdRxWh2CPQDfkCTxzhgIkiXxm1zJrmE/8SncunCtWcQPCIkw8K7eO9qEL
         mWITSMasHXvnUeBmml+4YJTNpSfFh4V/1bafksME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wang YanQing <udknight@gmail.com>
Subject: [PATCH 4.19 013/220] bpf, x32: Fix bug with ALU64 {LSH, RSH, ARSH} BPF_K shift by 0
Date:   Fri, 22 Nov 2019 11:26:18 +0100
Message-Id: <20191122100913.566226388@linuxfoundation.org>
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

commit 6fa632e719eec4d1b1ebf3ddc0b2d667997b057b upstream.

The current x32 BPF JIT does not correctly compile shift operations when
the immediate shift amount is 0. The expected behavior is for this to
be a no-op.

The following program demonstrates the bug. The expexceted result is 1,
but the current JITed code returns 2.

  r0 = 1
  r1 = 1
  r1 <<= 0
  if r1 == 1 goto end
  r0 = 2
end:
  exit

This patch simplifies the code and fixes the bug.

Fixes: 03f5781be2c7 ("bpf, x86_32: add eBPF JIT compiler for ia32")
Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Wang YanQing <udknight@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/net/bpf_jit_comp32.c |   63 ++++--------------------------------------
 1 file changed, 6 insertions(+), 57 deletions(-)

--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -892,27 +892,10 @@ static inline void emit_ia32_lsh_i64(con
 	}
 	/* Do LSH operation */
 	if (val < 32) {
-		/* shl dreg_hi,imm8 */
-		EMIT3(0xC1, add_1reg(0xE0, dreg_hi), val);
-		/* mov ebx,dreg_lo */
-		EMIT2(0x8B, add_2reg(0xC0, dreg_lo, IA32_EBX));
+		/* shld dreg_hi,dreg_lo,imm8 */
+		EMIT4(0x0F, 0xA4, add_2reg(0xC0, dreg_hi, dreg_lo), val);
 		/* shl dreg_lo,imm8 */
 		EMIT3(0xC1, add_1reg(0xE0, dreg_lo), val);
-
-		/* IA32_ECX = 32 - val */
-		/* mov ecx,val */
-		EMIT2(0xB1, val);
-		/* movzx ecx,ecx */
-		EMIT3(0x0F, 0xB6, add_2reg(0xC0, IA32_ECX, IA32_ECX));
-		/* neg ecx */
-		EMIT2(0xF7, add_1reg(0xD8, IA32_ECX));
-		/* add ecx,32 */
-		EMIT3(0x83, add_1reg(0xC0, IA32_ECX), 32);
-
-		/* shr ebx,cl */
-		EMIT2(0xD3, add_1reg(0xE8, IA32_EBX));
-		/* or dreg_hi,ebx */
-		EMIT2(0x09, add_2reg(0xC0, dreg_hi, IA32_EBX));
 	} else if (val >= 32 && val < 64) {
 		u32 value = val - 32;
 
@@ -958,27 +941,10 @@ static inline void emit_ia32_rsh_i64(con
 
 	/* Do RSH operation */
 	if (val < 32) {
-		/* shr dreg_lo,imm8 */
-		EMIT3(0xC1, add_1reg(0xE8, dreg_lo), val);
-		/* mov ebx,dreg_hi */
-		EMIT2(0x8B, add_2reg(0xC0, dreg_hi, IA32_EBX));
+		/* shrd dreg_lo,dreg_hi,imm8 */
+		EMIT4(0x0F, 0xAC, add_2reg(0xC0, dreg_lo, dreg_hi), val);
 		/* shr dreg_hi,imm8 */
 		EMIT3(0xC1, add_1reg(0xE8, dreg_hi), val);
-
-		/* IA32_ECX = 32 - val */
-		/* mov ecx,val */
-		EMIT2(0xB1, val);
-		/* movzx ecx,ecx */
-		EMIT3(0x0F, 0xB6, add_2reg(0xC0, IA32_ECX, IA32_ECX));
-		/* neg ecx */
-		EMIT2(0xF7, add_1reg(0xD8, IA32_ECX));
-		/* add ecx,32 */
-		EMIT3(0x83, add_1reg(0xC0, IA32_ECX), 32);
-
-		/* shl ebx,cl */
-		EMIT2(0xD3, add_1reg(0xE0, IA32_EBX));
-		/* or dreg_lo,ebx */
-		EMIT2(0x09, add_2reg(0xC0, dreg_lo, IA32_EBX));
 	} else if (val >= 32 && val < 64) {
 		u32 value = val - 32;
 
@@ -1023,27 +989,10 @@ static inline void emit_ia32_arsh_i64(co
 	}
 	/* Do RSH operation */
 	if (val < 32) {
-		/* shr dreg_lo,imm8 */
-		EMIT3(0xC1, add_1reg(0xE8, dreg_lo), val);
-		/* mov ebx,dreg_hi */
-		EMIT2(0x8B, add_2reg(0xC0, dreg_hi, IA32_EBX));
+		/* shrd dreg_lo,dreg_hi,imm8 */
+		EMIT4(0x0F, 0xAC, add_2reg(0xC0, dreg_lo, dreg_hi), val);
 		/* ashr dreg_hi,imm8 */
 		EMIT3(0xC1, add_1reg(0xF8, dreg_hi), val);
-
-		/* IA32_ECX = 32 - val */
-		/* mov ecx,val */
-		EMIT2(0xB1, val);
-		/* movzx ecx,ecx */
-		EMIT3(0x0F, 0xB6, add_2reg(0xC0, IA32_ECX, IA32_ECX));
-		/* neg ecx */
-		EMIT2(0xF7, add_1reg(0xD8, IA32_ECX));
-		/* add ecx,32 */
-		EMIT3(0x83, add_1reg(0xC0, IA32_ECX), 32);
-
-		/* shl ebx,cl */
-		EMIT2(0xD3, add_1reg(0xE0, IA32_EBX));
-		/* or dreg_lo,ebx */
-		EMIT2(0x09, add_2reg(0xC0, dreg_lo, IA32_EBX));
 	} else if (val >= 32 && val < 64) {
 		u32 value = val - 32;
 


