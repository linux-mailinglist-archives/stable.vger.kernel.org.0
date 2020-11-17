Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB3A2B633D
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732568AbgKQNgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:36:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732545AbgKQNgR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:36:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC45E2078E;
        Tue, 17 Nov 2020 13:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620176;
        bh=NC35hXBDqVmOra7LEEt4Nw2bIAPG/RJucXLw7P0pROQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMEBH1u3aHQdQEMBuOGCf5El8gu+NreLJAu/UcjeKfUbHCdGRnhu/rsJlhryZM+Bv
         6jfYU0E04lBi3xc8dDXy9IldajO7vjX/zACGLUbxQSoeNLGgJdohlSzrk+3hKiCl6m
         BZFEbbZLS5S7oZm6i4Be0zQBHGZSuPu9/OvshmxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 132/255] bpf: Dont rely on GCC __attribute__((optimize)) to disable GCSE
Date:   Tue, 17 Nov 2020 14:04:32 +0100
Message-Id: <20201117122145.359391854@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 080b6f40763565f65ebb9540219c71ce885cf568 ]

Commit 3193c0836 ("bpf: Disable GCC -fgcse optimization for
___bpf_prog_run()") introduced a __no_fgcse macro that expands to a
function scope __attribute__((optimize("-fno-gcse"))), to disable a
GCC specific optimization that was causing trouble on x86 builds, and
was not expected to have any positive effect in the first place.

However, as the GCC manual documents, __attribute__((optimize))
is not for production use, and results in all other optimization
options to be forgotten for the function in question. This can
cause all kinds of trouble, but in one particular reported case,
it causes -fno-asynchronous-unwind-tables to be disregarded,
resulting in .eh_frame info to be emitted for the function.

This reverts commit 3193c0836, and instead, it disables the -fgcse
optimization for the entire source file, but only when building for
X86 using GCC with CONFIG_BPF_JIT_ALWAYS_ON disabled. Note that the
original commit states that CONFIG_RETPOLINE=n triggers the issue,
whereas CONFIG_RETPOLINE=y performs better without the optimization,
so it is kept disabled in both cases.

Fixes: 3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/lkml/CAMuHMdUg0WJHEcq6to0-eODpXPOywLot6UD2=GFHpzoj_hCoBQ@mail.gmail.com/
Link: https://lore.kernel.org/bpf/20201028171506.15682-2-ardb@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler-gcc.h   | 2 --
 include/linux/compiler_types.h | 4 ----
 kernel/bpf/Makefile            | 6 +++++-
 kernel/bpf/core.c              | 2 +-
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 7a3769040d7dc..3017ebd400546 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -175,5 +175,3 @@
 #else
 #define __diag_GCC_8(s)
 #endif
-
-#define __no_fgcse __attribute__((optimize("-fno-gcse")))
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 6e390d58a9f8c..ac3fa37a84f94 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -247,10 +247,6 @@ struct ftrace_likely_data {
 #define asm_inline asm
 #endif
 
-#ifndef __no_fgcse
-# define __no_fgcse
-#endif
-
 /* Are two types/vars the same type (ignoring qualifiers)? */
 #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index e6eb9c0402dab..0cc0de72163dc 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -1,6 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-y := core.o
-CFLAGS_core.o += $(call cc-disable-warning, override-init)
+ifneq ($(CONFIG_BPF_JIT_ALWAYS_ON),y)
+# ___bpf_prog_run() needs GCSE disabled on x86; see 3193c0836f203 for details
+cflags-nogcse-$(CONFIG_X86)$(CONFIG_CC_IS_GCC) := -fno-gcse
+endif
+CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
 
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ed0b3578867c0..3cb26e82549ac 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1364,7 +1364,7 @@ u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
  *
  * Decode and execute eBPF instructions.
  */
-static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
+static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 {
 #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
 #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
-- 
2.27.0



