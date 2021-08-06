Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C0B3E2581
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244174AbhHFIUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244309AbhHFITi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:19:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2813A611CC;
        Fri,  6 Aug 2021 08:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237962;
        bh=WgGFNB0by/o0tZJMUhbCCDx0k0P6Tv3LHWjxYp0E5QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DAPowUjoDfSEU+wBFBlrvOXJhLYfFl7e/5YvEWt95rSHu+ZZ6K+Nx+uM2feDcee5+
         vQrUoX0EoBvDdEuS93M4CoWxu03qmNzuZPHQNr1TC1u5CNDXfDILG01s5RhizlMAeI
         o/yQXmwOW9e2jeUUufN0ZQW9j717TFvn1SdD3Zrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrei Matei <andreimatei1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 30/30] selftest/bpf: Verifier tests for var-off access
Date:   Fri,  6 Aug 2021 10:17:08 +0200
Message-Id: <20210806081114.153605077@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
References: <20210806081113.126861800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Matei <andreimatei1@gmail.com>

commit 7a22930c4179b51352f2ec9feb35167cbe79afd9 upstream

Add tests for the new functionality - reading and writing to the stack
through a variable-offset pointer.

Signed-off-by: Andrei Matei <andreimatei1@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210207011027.676572-4-andreimatei1@gmail.com
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/verifier/var_off.c |   99 ++++++++++++++++++++++++-
 1 file changed, 97 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/bpf/verifier/var_off.c
+++ b/tools/testing/selftests/bpf/verifier/var_off.c
@@ -31,15 +31,110 @@
 	 * we don't know which
 	 */
 	BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
-	/* dereference it */
+	/* dereference it for a stack read */
 	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.result_unpriv = REJECT,
+	.errstr_unpriv = "R2 variable stack access prohibited for !root",
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+},
+{
+	"variable-offset stack read, uninitialized",
+	.insns = {
+	/* Get an unknown value */
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
+	/* Make it small and 4-byte aligned */
+	BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 4),
+	BPF_ALU64_IMM(BPF_SUB, BPF_REG_2, 8),
+	/* add it to fp.  We now have either fp-4 or fp-8, but
+	 * we don't know which
+	 */
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
+	/* dereference it for a stack read */
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "variable stack access var_off=(0xfffffffffffffff8; 0x4)",
 	.result = REJECT,
+	.errstr = "invalid variable-offset read from stack R2",
 	.prog_type = BPF_PROG_TYPE_LWT_IN,
 },
 {
+	"variable-offset stack write, priv vs unpriv",
+	.insns = {
+	/* Get an unknown value */
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
+	/* Make it small and 8-byte aligned */
+	BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 8),
+	BPF_ALU64_IMM(BPF_SUB, BPF_REG_2, 16),
+	/* Add it to fp.  We now have either fp-8 or fp-16, but
+	 * we don't know which
+	 */
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
+	/* Dereference it for a stack write */
+	BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
+	/* Now read from the address we just wrote. This shows
+	 * that, after a variable-offset write, a priviledged
+	 * program can read the slots that were in the range of
+	 * that write (even if the verifier doesn't actually know
+	 * if the slot being read was really written to or not.
+	 */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	/* Variable stack access is rejected for unprivileged.
+	 */
+	.errstr_unpriv = "R2 variable stack access prohibited for !root",
+	.result_unpriv = REJECT,
+	.result = ACCEPT,
+},
+{
+	"variable-offset stack write clobbers spilled regs",
+	.insns = {
+	/* Dummy instruction; needed because we need to patch the next one
+	 * and we can't patch the first instruction.
+	 */
+	BPF_MOV64_IMM(BPF_REG_6, 0),
+	/* Make R0 a map ptr */
+	BPF_LD_MAP_FD(BPF_REG_0, 0),
+	/* Get an unknown value */
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
+	/* Make it small and 8-byte aligned */
+	BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 8),
+	BPF_ALU64_IMM(BPF_SUB, BPF_REG_2, 16),
+	/* Add it to fp. We now have either fp-8 or fp-16, but
+	 * we don't know which.
+	 */
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
+	/* Spill R0(map ptr) into stack */
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -8),
+	/* Dereference the unknown value for a stack write */
+	BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
+	/* Fill the register back into R2 */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_10, -8),
+	/* Try to dereference R2 for a memory load */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 8),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_8b = { 1 },
+	/* The unpriviledged case is not too interesting; variable
+	 * stack access is rejected.
+	 */
+	.errstr_unpriv = "R2 variable stack access prohibited for !root",
+	.result_unpriv = REJECT,
+	/* In the priviledged case, dereferencing a spilled-and-then-filled
+	 * register is rejected because the previous variable offset stack
+	 * write might have overwritten the spilled pointer (i.e. we lose track
+	 * of the spilled register when we analyze the write).
+	 */
+	.errstr = "R2 invalid mem access 'inv'",
+	.result = REJECT,
+},
+{
 	"indirect variable-offset stack access, unbounded",
 	.insns = {
 	BPF_MOV64_IMM(BPF_REG_2, 6),


