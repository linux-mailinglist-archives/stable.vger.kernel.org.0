Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637532B6236
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbgKQN0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:26:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730990AbgKQN03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:26:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 356192078E;
        Tue, 17 Nov 2020 13:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619588;
        bh=jjq+3ou+Q8x7/h7egQyh14GGXwSApBEOv1ZKbwbJfws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCNVSJtuEfR78zc26v59shorZ6m+Xgr1f1HMH1QBmL6QpnHG5tLKcXfD0qNx/Z4lg
         4N20ns+CMQVVDIEjB0BuIcTK/RiE0QxmQEXC2ETxR7KmUZUsJj6/oX6PVazVxRwZTr
         cWp7+0E1gFciWAbOqQe7GpsFNG3dXUXA01ZuLVNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/151] bpf: Dont rely on GCC __attribute__((optimize)) to disable GCSE
Date:   Tue, 17 Nov 2020 14:05:19 +0100
Message-Id: <20201117122125.743587370@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
index d7ee4c6bad482..e8579412ad214 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -170,5 +170,3 @@
 #else
 #define __diag_GCC_8(s)
 #endif
-
-#define __no_fgcse __attribute__((optimize("-fno-gcse")))
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 72393a8c1a6c5..77433633572e4 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -212,10 +212,6 @@ struct ftrace_likely_data {
 #define asm_inline asm
 #endif
 
-#ifndef __no_fgcse
-# define __no_fgcse
-#endif
-
 /* Are two types/vars the same type (ignoring qualifiers)? */
 #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index e1d9adb212f93..b0d78bc0b1979 100644
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
 
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ef0e1e3e66f4a..56bc96f5ad208 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1299,7 +1299,7 @@ bool bpf_opcode_in_insntable(u8 code)
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



