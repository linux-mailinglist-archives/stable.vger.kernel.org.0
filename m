Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2F2420FDD
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237520AbhJDNjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:39:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237896AbhJDNh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:37:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9B026137C;
        Mon,  4 Oct 2021 13:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353413;
        bh=okpSI5uHUsz6apGwzSIq0jUtOZdruxPoDtTAu0pt6N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrnvIwxaTSkn2bzYHgU8FkLICXckJaVLbR3lgH/yZ7fEdhRSyvzouEOeurEIjreQE
         NvWzX+I2ge8dNnOSFOMt8D/uhDJr4LBEdDlV3+7SB+4fByY9Pil7SxzHIShctSBo03
         bdL1O5any2LCVDD8g21yKl0kLb7KXRDWbGTgrszE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Brendan Jackman <jackmanb@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 118/172] bpf, x86: Fix bpf mapping of atomic fetch implementation
Date:   Mon,  4 Oct 2021 14:52:48 +0200
Message-Id: <20211004125048.790393291@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit ced185824c89b60e65b5a2606954c098320cdfb8 ]

Fix the case where the dst register maps to %rax as otherwise this produces
an incorrect mapping with the implementation in 981f94c3e921 ("bpf: Add
bitwise atomic instructions") as %rax is clobbered given it's part of the
cmpxchg as operand.

The issue is similar to b29dd96b905f ("bpf, x86: Fix BPF_FETCH atomic and/or/
xor with r0 as src") just that the case of dst register was missed.

Before, dst=r0 (%rax) src=r2 (%rsi):

  [...]
  c5:   mov    %rax,%r10
  c8:   mov    0x0(%rax),%rax       <---+ (broken)
  cc:   mov    %rax,%r11                |
  cf:   and    %rsi,%r11                |
  d2:   lock cmpxchg %r11,0x0(%rax) <---+
  d8:   jne    0x00000000000000c8       |
  da:   mov    %rax,%rsi                |
  dd:   mov    %r10,%rax                |
  [...]                                 |
                                        |
After, dst=r0 (%rax) src=r2 (%rsi):     |
                                        |
  [...]                                 |
  da:	mov    %rax,%r10                |
  dd:	mov    0x0(%r10),%rax       <---+ (fixed)
  e1:	mov    %rax,%r11                |
  e4:	and    %rsi,%r11                |
  e7:	lock cmpxchg %r11,0x0(%r10) <---+
  ed:	jne    0x00000000000000dd
  ef:	mov    %rax,%rsi
  f2:	mov    %r10,%rax
  [...]

The remaining combinations were fine as-is though:

After, dst=r9 (%r15) src=r0 (%rax):

  [...]
  dc:	mov    %rax,%r10
  df:	mov    0x0(%r15),%rax
  e3:	mov    %rax,%r11
  e6:	and    %r10,%r11
  e9:	lock cmpxchg %r11,0x0(%r15)
  ef:	jne    0x00000000000000df      _
  f1:	mov    %rax,%r10                | (unneeded, but
  f4:	mov    %r10,%rax               _|  not a problem)
  [...]

After, dst=r9 (%r15) src=r4 (%rcx):

  [...]
  de:	mov    %rax,%r10
  e1:	mov    0x0(%r15),%rax
  e5:	mov    %rax,%r11
  e8:	and    %rcx,%r11
  eb:	lock cmpxchg %r11,0x0(%r15)
  f1:	jne    0x00000000000000e1
  f3:	mov    %rax,%rcx
  f6:	mov    %r10,%rax
  [...]

The case of dst == src register is rejected by the verifier and
therefore not supported, but x86 JIT also handles this case just
fine.

After, dst=r0 (%rax) src=r0 (%rax):

  [...]
  eb:	mov    %rax,%r10
  ee:	mov    0x0(%r10),%rax
  f2:	mov    %rax,%r11
  f5:	and    %r10,%r11
  f8:	lock cmpxchg %r11,0x0(%r10)
  fe:	jne    0x00000000000000ee
 100:	mov    %rax,%r10
 103:	mov    %r10,%rax
  [...]

Fixes: 981f94c3e921 ("bpf: Add bitwise atomic instructions")
Reported-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Co-developed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Brendan Jackman <jackmanb@google.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 47780844598a..ffcc4d29ad50 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1341,9 +1341,10 @@ st:			if (is_imm8(insn->off))
 			if (insn->imm == (BPF_AND | BPF_FETCH) ||
 			    insn->imm == (BPF_OR | BPF_FETCH) ||
 			    insn->imm == (BPF_XOR | BPF_FETCH)) {
-				u8 *branch_target;
 				bool is64 = BPF_SIZE(insn->code) == BPF_DW;
 				u32 real_src_reg = src_reg;
+				u32 real_dst_reg = dst_reg;
+				u8 *branch_target;
 
 				/*
 				 * Can't be implemented with a single x86 insn.
@@ -1354,11 +1355,13 @@ st:			if (is_imm8(insn->off))
 				emit_mov_reg(&prog, true, BPF_REG_AX, BPF_REG_0);
 				if (src_reg == BPF_REG_0)
 					real_src_reg = BPF_REG_AX;
+				if (dst_reg == BPF_REG_0)
+					real_dst_reg = BPF_REG_AX;
 
 				branch_target = prog;
 				/* Load old value */
 				emit_ldx(&prog, BPF_SIZE(insn->code),
-					 BPF_REG_0, dst_reg, insn->off);
+					 BPF_REG_0, real_dst_reg, insn->off);
 				/*
 				 * Perform the (commutative) operation locally,
 				 * put the result in the AUX_REG.
@@ -1369,7 +1372,8 @@ st:			if (is_imm8(insn->off))
 				      add_2reg(0xC0, AUX_REG, real_src_reg));
 				/* Attempt to swap in new value */
 				err = emit_atomic(&prog, BPF_CMPXCHG,
-						  dst_reg, AUX_REG, insn->off,
+						  real_dst_reg, AUX_REG,
+						  insn->off,
 						  BPF_SIZE(insn->code));
 				if (WARN_ON(err))
 					return err;
@@ -1383,11 +1387,10 @@ st:			if (is_imm8(insn->off))
 				/* Restore R0 after clobbering RAX */
 				emit_mov_reg(&prog, true, BPF_REG_0, BPF_REG_AX);
 				break;
-
 			}
 
 			err = emit_atomic(&prog, insn->imm, dst_reg, src_reg,
-						  insn->off, BPF_SIZE(insn->code));
+					  insn->off, BPF_SIZE(insn->code));
 			if (err)
 				return err;
 			break;
-- 
2.33.0



