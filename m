Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04691C164E
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbgEANn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731676AbgEANnu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:43:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8900D208C3;
        Fri,  1 May 2020 13:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340630;
        bh=LW7y78RcRNuq2ClolLmtCwJG48Op+BFKTQuN2fe/mjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Htt2JQvcTbckHymzU9p1RgFvCreY3wuXDp/XkbNXzKVff+OJVCIe1/r6saQmogcZ7
         ZRJxy22X/4n4THne/Mw583OQdOlOv3VZp0V9aAVIaiSiAwi4ppB+/YqmwURhlN00ca
         HrpjcTB6fCR02FZTcnGGkZV+bcIyYmJR1NgkBQ7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.6 060/106] bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX BPF_B
Date:   Fri,  1 May 2020 15:23:33 +0200
Message-Id: <20200501131550.798901859@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke Nelson <lukenels@cs.washington.edu>

commit aee194b14dd2b2bde6252b3acf57d36dccfc743a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/net/bpf_jit_comp.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -158,6 +158,19 @@ static bool is_ereg(u32 reg)
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
 static bool is_axreg(u32 reg)
 {
 	return reg == BPF_REG_0;
@@ -598,9 +611,8 @@ static void emit_stx(u8 **pprog, u32 siz
 	switch (size) {
 	case BPF_B:
 		/* Emit 'mov byte ptr [rax + off], al' */
-		if (is_ereg(dst_reg) || is_ereg(src_reg) ||
-		    /* We have to add extra byte for x86 SIL, DIL regs */
-		    src_reg == BPF_REG_1 || src_reg == BPF_REG_2)
+		if (is_ereg(dst_reg) || is_ereg_8l(src_reg))
+			/* Add extra byte for eregs or SIL,DIL,BPL in src_reg */
 			EMIT2(add_2mod(0x40, dst_reg, src_reg), 0x88);
 		else
 			EMIT1(0x88);


