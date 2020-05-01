Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234221C1590
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbgEANaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729926AbgEANaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:30:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D163208D6;
        Fri,  1 May 2020 13:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339822;
        bh=8/a0r3F1U8WWAHijZNM8omks4R6aGZPSjeg1fCxd/Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgQuktGNgPimQDkDks4/yXB93XnCKme4Jr6EZGSkS2zE6U1Jtwgim8ptvK7462Xx4
         O7WIx8RbskwPEXbg4bdKUeeERCnuSc5WBqsMzjKhmc+D2KSfqO0Hgpa1r7vZEtm0jn
         dbhkrFR4N6cIRtsCBZPCPbO3fsvbkt3TX/po6EIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 66/80] bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX BPF_B
Date:   Fri,  1 May 2020 15:22:00 +0200
Message-Id: <20200501131534.755425596@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke Nelson <lukenels@cs.washington.edu>

[ Upstream commit aee194b14dd2b2bde6252b3acf57d36dccfc743a ]

This patch fixes an encoding bug in emit_stx for BPF_B when the source
register is BPF_REG_FP.

The current implementation for BPF_STX BPF_B in emit_stx saves one REX
byte when the operands can be encoded using Mod-R/M alone. The lower 8
bits of registers %rax, %rbx, %rcx, and %rdx can be accessed without using
a REX prefix via %al, %bl, %cl, and %dl, respectively. Other registers,
(e.g., %rsi, %rdi, %rbp, %rsp) require a REX prefix to use their 8-bit
equivalents (%sil, %dil, %bpl, %spl).

The current code checks if the source for BPF_STX BPF_B is BPF_REG_1
or BPF_REG_2 (which map to %rdi and %rsi), in which case it emits the
required REX prefix. However, it misses the case when the source is
BPF_REG_FP (mapped to %rbp).

The result is that BPF_STX BPF_B with BPF_REG_FP as the source operand
will read from register %ch instead of the correct %bpl. This patch fixes
the problem by fixing and refactoring the check on which registers need
the extra REX byte. Since no BPF registers map to %rsp, there is no need
to handle %spl.

Fixes: 622582786c9e0 ("net: filter: x86: internal BPF JIT")
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200418232655.23870-1-luke.r.nels@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index d9dabd0c31fc4..eb5734112cb49 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -150,6 +150,19 @@ static bool is_ereg(u32 reg)
 			     BIT(BPF_REG_AX));
 }
 
+/*
+ * is_ereg_8l() == true if BPF register 'reg' is mapped to access x86-64
+ * lower 8-bit registers dil,sil,bpl,spl,r8b..r15b, which need extra byte
+ * of encoding. al,cl,dl,bl have simpler encoding.
+ */
+static bool is_ereg_8l(u32 reg)
+{
+	return is_ereg(reg) ||
+	    (1 << reg) & (BIT(BPF_REG_1) |
+			  BIT(BPF_REG_2) |
+			  BIT(BPF_REG_FP));
+}
+
 /* add modifiers if 'reg' maps to x64 registers r8..r15 */
 static u8 add_1mod(u8 byte, u32 reg)
 {
@@ -771,9 +784,8 @@ st:			if (is_imm8(insn->off))
 			/* STX: *(u8*)(dst_reg + off) = src_reg */
 		case BPF_STX | BPF_MEM | BPF_B:
 			/* emit 'mov byte ptr [rax + off], al' */
-			if (is_ereg(dst_reg) || is_ereg(src_reg) ||
-			    /* have to add extra byte for x86 SIL, DIL regs */
-			    src_reg == BPF_REG_1 || src_reg == BPF_REG_2)
+			if (is_ereg(dst_reg) || is_ereg_8l(src_reg))
+				/* Add extra byte for eregs or SIL,DIL,BPL in src_reg */
 				EMIT2(add_2mod(0x40, dst_reg, src_reg), 0x88);
 			else
 				EMIT1(0x88);
-- 
2.20.1



