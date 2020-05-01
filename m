Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881351C15FF
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730968AbgEANhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:37:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728892AbgEANhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:37:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFED924958;
        Fri,  1 May 2020 13:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340257;
        bh=KsWMYPxMlZON7DQw1Q3Z0jbq0/A30rq39ijzdlF+zSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/Kcfhds2jirWz7LvuG3oUWm+m+WZYzFR5OpdjQ4C00M+1U+W16+W2M8WPWpBE7qm
         ZCxnzNf3gJL5pjNNah+5r7HqSohIs/NSyHeAcowzgqEO1lsa/C3Cgsc1OrkS+laY/u
         P7OdctzcH6dhuOh9D7QMYt2dtplx/irjwDtIRX+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Wang YanQing <udknight@gmail.com>
Subject: [PATCH 4.19 44/46] bpf, x86_32: Fix clobbering of dst for BPF_JSET
Date:   Fri,  1 May 2020 15:23:09 +0200
Message-Id: <20200501131513.858153421@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke Nelson <lukenels@cs.washington.edu>

commit 50fe7ebb6475711c15b3397467e6424e20026d94 upstream.

The current JIT clobbers the destination register for BPF_JSET BPF_X
and BPF_K by using "and" and "or" instructions. This is fine when the
destination register is a temporary loaded from a register stored on
the stack but not otherwise.

This patch fixes the problem (for both BPF_K and BPF_X) by always loading
the destination register into temporaries since BPF_JSET should not
modify the destination register.

This bug may not be currently triggerable as BPF_REG_AX is the only
register not stored on the stack and the verifier uses it in a limited
way.

Fixes: 03f5781be2c7b ("bpf, x86_32: add eBPF JIT compiler for ia32")
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Wang YanQing <udknight@gmail.com>
Link: https://lore.kernel.org/bpf/20200422173630.8351-2-luke.r.nels@gmail.com
Signed-off-by: Wang YanQing <udknight@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/net/bpf_jit_comp32.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -1970,8 +1970,8 @@ static int do_jit(struct bpf_prog *bpf_p
 			goto emit_cond_jmp_signed;
 		}
 		case BPF_JMP | BPF_JSET | BPF_X: {
-			u8 dreg_lo = dstk ? IA32_EAX : dst_lo;
-			u8 dreg_hi = dstk ? IA32_EDX : dst_hi;
+			u8 dreg_lo = IA32_EAX;
+			u8 dreg_hi = IA32_EDX;
 			u8 sreg_lo = sstk ? IA32_ECX : src_lo;
 			u8 sreg_hi = sstk ? IA32_EBX : src_hi;
 
@@ -1980,6 +1980,12 @@ static int do_jit(struct bpf_prog *bpf_p
 				      STACK_VAR(dst_lo));
 				EMIT3(0x8B, add_2reg(0x40, IA32_EBP, IA32_EDX),
 				      STACK_VAR(dst_hi));
+			} else {
+				/* mov dreg_lo,dst_lo */
+				EMIT2(0x89, add_2reg(0xC0, dreg_lo, dst_lo));
+				/* mov dreg_hi,dst_hi */
+				EMIT2(0x89,
+				      add_2reg(0xC0, dreg_hi, dst_hi));
 			}
 
 			if (sstk) {
@@ -1998,8 +2004,8 @@ static int do_jit(struct bpf_prog *bpf_p
 		}
 		case BPF_JMP | BPF_JSET | BPF_K: {
 			u32 hi;
-			u8 dreg_lo = dstk ? IA32_EAX : dst_lo;
-			u8 dreg_hi = dstk ? IA32_EDX : dst_hi;
+			u8 dreg_lo = IA32_EAX;
+			u8 dreg_hi = IA32_EDX;
 			u8 sreg_lo = IA32_ECX;
 			u8 sreg_hi = IA32_EBX;
 
@@ -2008,6 +2014,12 @@ static int do_jit(struct bpf_prog *bpf_p
 				      STACK_VAR(dst_lo));
 				EMIT3(0x8B, add_2reg(0x40, IA32_EBP, IA32_EDX),
 				      STACK_VAR(dst_hi));
+			} else {
+				/* mov dreg_lo,dst_lo */
+				EMIT2(0x89, add_2reg(0xC0, dreg_lo, dst_lo));
+				/* mov dreg_hi,dst_hi */
+				EMIT2(0x89,
+				      add_2reg(0xC0, dreg_hi, dst_hi));
 			}
 			hi = imm32 & (1<<31) ? (u32)~0 : 0;
 


