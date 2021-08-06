Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156F83E2590
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243789AbhHFIUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243890AbhHFITy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:19:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CF5B611EF;
        Fri,  6 Aug 2021 08:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237978;
        bh=O306JDF6f3bDg/11RMNAQRPYsUftC0y+IZIZX4/g/pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4KsOZznLj4ul9yL167qbrDHn8MvKIZ2XKsyb/CtP2oNm5AXbP5/NX/Au3rEZEfJ8
         Rk7pRFx1EwP5MhC+dnz5D8/74O00gh5oZuYT+SXfDnNnr43tkgULvWURALR7Ap1yHN
         qu3OGnmNTOkNucHsktFlQsZmJiz0wBk+R7+XNWGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrei Matei <andreimatei1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 26/30] selftest/bpf: Adjust expected verifier errors
Date:   Fri,  6 Aug 2021 10:17:04 +0200
Message-Id: <20210806081114.013548851@linuxfoundation.org>
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

commit a680cb3d8e3f4f84205720b90c926579d04eedb6 upstream

The verifier errors around stack accesses have changed slightly in the
previous commit (generally for the better).

Signed-off-by: Andrei Matei <andreimatei1@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210207011027.676572-3-andreimatei1@gmail.com
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/verifier/basic_stack.c           |    2 -
 tools/testing/selftests/bpf/verifier/calls.c                 |    4 +-
 tools/testing/selftests/bpf/verifier/const_or.c              |    4 +-
 tools/testing/selftests/bpf/verifier/helper_access_var_len.c |   12 +++---
 tools/testing/selftests/bpf/verifier/int_ptr.c               |    6 +--
 tools/testing/selftests/bpf/verifier/raw_stack.c             |   10 ++---
 tools/testing/selftests/bpf/verifier/stack_ptr.c             |   22 ++++++-----
 tools/testing/selftests/bpf/verifier/unpriv.c                |    2 -
 tools/testing/selftests/bpf/verifier/var_off.c               |   16 ++++----
 9 files changed, 41 insertions(+), 37 deletions(-)

--- a/tools/testing/selftests/bpf/verifier/basic_stack.c
+++ b/tools/testing/selftests/bpf/verifier/basic_stack.c
@@ -4,7 +4,7 @@
 	BPF_ST_MEM(BPF_DW, BPF_REG_10, 8, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid stack",
+	.errstr = "invalid write to stack",
 	.result = REJECT,
 },
 {
--- a/tools/testing/selftests/bpf/verifier/calls.c
+++ b/tools/testing/selftests/bpf/verifier/calls.c
@@ -1228,7 +1228,7 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 	.fixup_map_hash_8b = { 23 },
 	.result = REJECT,
-	.errstr = "invalid read from stack off -16+0 size 8",
+	.errstr = "invalid read from stack R7 off=-16 size=8",
 },
 {
 	"calls: two calls that receive map_value via arg=ptr_stack_of_caller. test1",
@@ -1958,7 +1958,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_48b = { 6 },
-	.errstr = "invalid indirect read from stack off -8+0 size 8",
+	.errstr = "invalid indirect read from stack R2 off -8+0 size 8",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_XDP,
 },
--- a/tools/testing/selftests/bpf/verifier/const_or.c
+++ b/tools/testing/selftests/bpf/verifier/const_or.c
@@ -23,7 +23,7 @@
 	BPF_EMIT_CALL(BPF_FUNC_probe_read_kernel),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid stack type R1 off=-48 access_size=58",
+	.errstr = "invalid indirect access to stack R1 off=-48 size=58",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
@@ -54,7 +54,7 @@
 	BPF_EMIT_CALL(BPF_FUNC_probe_read_kernel),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid stack type R1 off=-48 access_size=58",
+	.errstr = "invalid indirect access to stack R1 off=-48 size=58",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
--- a/tools/testing/selftests/bpf/verifier/helper_access_var_len.c
+++ b/tools/testing/selftests/bpf/verifier/helper_access_var_len.c
@@ -39,7 +39,7 @@
 	BPF_EMIT_CALL(BPF_FUNC_probe_read_kernel),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid indirect read from stack off -64+0 size 64",
+	.errstr = "invalid indirect read from stack R1 off -64+0 size 64",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
@@ -59,7 +59,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid stack type R1 off=-64 access_size=65",
+	.errstr = "invalid indirect access to stack R1 off=-64 size=65",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
@@ -136,7 +136,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid stack type R1 off=-64 access_size=65",
+	.errstr = "invalid indirect access to stack R1 off=-64 size=65",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
@@ -156,7 +156,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid stack type R1 off=-64 access_size=65",
+	.errstr = "invalid indirect access to stack R1 off=-64 size=65",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
@@ -194,7 +194,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid indirect read from stack off -64+0 size 64",
+	.errstr = "invalid indirect read from stack R1 off -64+0 size 64",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
@@ -584,7 +584,7 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_10, -16),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid indirect read from stack off -64+32 size 64",
+	.errstr = "invalid indirect read from stack R1 off -64+32 size 64",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
--- a/tools/testing/selftests/bpf/verifier/int_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/int_ptr.c
@@ -27,7 +27,7 @@
 	},
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_CGROUP_SYSCTL,
-	.errstr = "invalid indirect read from stack off -16+0 size 8",
+	.errstr = "invalid indirect read from stack R4 off -16+0 size 8",
 },
 {
 	"ARG_PTR_TO_LONG half-uninitialized",
@@ -59,7 +59,7 @@
 	},
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_CGROUP_SYSCTL,
-	.errstr = "invalid indirect read from stack off -16+4 size 8",
+	.errstr = "invalid indirect read from stack R4 off -16+4 size 8",
 },
 {
 	"ARG_PTR_TO_LONG misaligned",
@@ -125,7 +125,7 @@
 	},
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_CGROUP_SYSCTL,
-	.errstr = "invalid stack type R4 off=-4 access_size=8",
+	.errstr = "invalid indirect access to stack R4 off=-4 size=8",
 },
 {
 	"ARG_PTR_TO_LONG initialized",
--- a/tools/testing/selftests/bpf/verifier/raw_stack.c
+++ b/tools/testing/selftests/bpf/verifier/raw_stack.c
@@ -11,7 +11,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid read from stack off -8+0 size 8",
+	.errstr = "invalid read from stack R6 off=-8 size=8",
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 },
 {
@@ -59,7 +59,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack type R3",
+	.errstr = "invalid zero-sized read",
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 },
 {
@@ -205,7 +205,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack type R3 off=-513 access_size=8",
+	.errstr = "invalid indirect access to stack R3 off=-513 size=8",
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 },
 {
@@ -221,7 +221,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack type R3 off=-1 access_size=8",
+	.errstr = "invalid indirect access to stack R3 off=-1 size=8",
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 },
 {
@@ -285,7 +285,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack type R3 off=-512 access_size=0",
+	.errstr = "invalid zero-sized read",
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 },
 {
--- a/tools/testing/selftests/bpf/verifier/stack_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/stack_ptr.c
@@ -44,7 +44,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack off=-79992 size=8",
+	.errstr = "invalid write to stack R1 off=-79992 size=8",
 	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 },
 {
@@ -57,7 +57,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack off=0 size=8",
+	.errstr = "invalid write to stack R1 off=0 size=8",
 },
 {
 	"PTR_TO_STACK check high 1",
@@ -106,7 +106,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
-	.errstr = "invalid stack off=0 size=1",
+	.errstr = "invalid write to stack R1 off=0 size=1",
 	.result = REJECT,
 },
 {
@@ -119,7 +119,8 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack off",
+	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
+	.errstr = "invalid write to stack R1",
 },
 {
 	"PTR_TO_STACK check high 6",
@@ -131,7 +132,8 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack off",
+	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
+	.errstr = "invalid write to stack",
 },
 {
 	"PTR_TO_STACK check high 7",
@@ -183,7 +185,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
-	.errstr = "invalid stack off=-513 size=1",
+	.errstr = "invalid write to stack R1 off=-513 size=1",
 	.result = REJECT,
 },
 {
@@ -208,7 +210,8 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack off",
+	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
+	.errstr = "invalid write to stack",
 },
 {
 	"PTR_TO_STACK check low 6",
@@ -220,7 +223,8 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack off",
+	.errstr = "invalid write to stack",
+	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 },
 {
 	"PTR_TO_STACK check low 7",
@@ -292,7 +296,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "invalid stack off=0 size=1",
+	.errstr_unpriv = "invalid write to stack R1 off=0 size=1",
 	.result = ACCEPT,
 	.retval = 42,
 },
--- a/tools/testing/selftests/bpf/verifier/unpriv.c
+++ b/tools/testing/selftests/bpf/verifier/unpriv.c
@@ -108,7 +108,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 3 },
-	.errstr_unpriv = "invalid indirect read from stack off -8+0 size 8",
+	.errstr_unpriv = "invalid indirect read from stack R2 off -8+0 size 8",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
--- a/tools/testing/selftests/bpf/verifier/var_off.c
+++ b/tools/testing/selftests/bpf/verifier/var_off.c
@@ -18,7 +18,7 @@
 	.prog_type = BPF_PROG_TYPE_LWT_IN,
 },
 {
-	"variable-offset stack access",
+	"variable-offset stack read, priv vs unpriv",
 	.insns = {
 	/* Fill the top 8 bytes of the stack */
 	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
@@ -63,7 +63,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "R4 unbounded indirect variable offset stack access",
+	.errstr = "invalid unbounded variable-offset indirect access to stack R4",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
 },
@@ -88,7 +88,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 5 },
-	.errstr = "R2 max value is outside of stack bound",
+	.errstr = "invalid variable-offset indirect access to stack R2",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_LWT_IN,
 },
@@ -113,7 +113,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 5 },
-	.errstr = "R2 min value is outside of stack bound",
+	.errstr = "invalid variable-offset indirect access to stack R2",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_LWT_IN,
 },
@@ -138,7 +138,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 5 },
-	.errstr = "invalid indirect read from stack var_off",
+	.errstr = "invalid indirect read from stack R2 var_off",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_LWT_IN,
 },
@@ -163,7 +163,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 5 },
-	.errstr = "invalid indirect read from stack var_off",
+	.errstr = "invalid indirect read from stack R2 var_off",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_LWT_IN,
 },
@@ -189,7 +189,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 6 },
-	.errstr_unpriv = "R2 stack pointer arithmetic goes out of range, prohibited for !root",
+	.errstr_unpriv = "R2 variable stack access prohibited for !root",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
@@ -217,7 +217,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid indirect read from stack var_off",
+	.errstr = "invalid indirect read from stack R4 var_off",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
 },


