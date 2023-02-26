Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0276A302D
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 15:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBZOr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 09:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjBZOrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:47:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767A113DDB;
        Sun, 26 Feb 2023 06:46:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 299EA60B93;
        Sun, 26 Feb 2023 14:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C10C433D2;
        Sun, 26 Feb 2023 14:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422738;
        bh=EMReRnjEZ1rks1B504mit7FlnxMLCUFiF3SQGwR5mNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3ok/42qWxzYimcdOcfWrtJJsBfBN/gzY+UzuxQpcGMXwCVGfOvxkroQ3iIM/faf5
         6CrliZ0TFUxnbNj/38dHkCgh9coG8TnALLPDOyH1gkN5n1MgyULSbM2g3qLwoyAm7/
         K7HbJ296HRwRsJ3ca/3j8KZlKdtMQLx1sJSHOqHS5QpWT7Kdw4oxFg6fAHS0MjERZm
         Q+yDlgK2Oa0WiT5fSQlWdavXGH0+jwzv4kZUAfyrqi0E4pCFp55oG49WsenZNnf37H
         CO1RqPvw9AMyf8PUfZ21hlQhpjNkWk51l6zTxcz4hzLmKsokqOd78Bi0Hg5fv1qHTI
         7SxqnSZi8uaqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Florent Revest <revest@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Will Deacon <will@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, nathan@kernel.org,
        keescook@chromium.org, ast@kernel.org, akpm@linux-foundation.org,
        yhs@fb.com, haoluo@google.com, samitolvanen@google.com,
        linux@rasmusvillemoes.dk, ebiederm@xmission.com, mcgrof@kernel.org,
        oleg@redhat.com, npiggin@gmail.com, jannh@google.com,
        mingo@kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.2 20/53] Compiler attributes: GCC cold function alignment workarounds
Date:   Sun, 26 Feb 2023 09:44:12 -0500
Message-Id: <20230226144446.824580-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144446.824580-1-sashal@kernel.org>
References: <20230226144446.824580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit c27cd083cfb9d392f304657ed00fcde1136704e7 ]

Contemporary versions of GCC (e.g. GCC 12.2.0) drop the alignment
specified by '-falign-functions=N' for functions marked with the
__cold__ attribute, and potentially for callees of __cold__ functions as
these may be implicitly marked as __cold__ by the compiler. LLVM appears
to respect '-falign-functions=N' in such cases.

This has been reported to GCC in bug 88345:

  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=88345

... which also covers alignment being dropped when '-Os' is used, which
will be addressed in a separate patch.

Currently, use of '-falign-functions=N' is limited to
CONFIG_FUNCTION_ALIGNMENT, which is largely used for performance and/or
analysis reasons (e.g. with CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B), but
isn't necessary for correct functionality. However, this dropped
alignment isn't great for the performance and/or analysis cases.

Subsequent patches will use CONFIG_FUNCTION_ALIGNMENT as part of arm64's
ftrace implementation, which will require all instrumented functions to
be aligned to at least 8-bytes.

This patch works around the dropped alignment by avoiding the use of the
__cold__ attribute when CONFIG_FUNCTION_ALIGNMENT is non-zero, and by
specifically aligning abort(), which GCC implicitly marks as __cold__.
As the __cold macro is now dependent upon config options (which is
against the policy described at the top of compiler_attributes.h), it is
moved into compiler_types.h.

I've tested this by building and booting a kernel configured with
defconfig + CONFIG_EXPERT=y + CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B=y,
and looking for misaligned text symbols in /proc/kallsyms:

* arm64:

  Before:
    # uname -rm
    6.2.0-rc3 aarch64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    5009

  After:
    # uname -rm
    6.2.0-rc3-00001-g2a2bedf8bfa9 aarch64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    919

* x86_64:

  Before:
    # uname -rm
    6.2.0-rc3 x86_64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    11537

  After:
    # uname -rm
    6.2.0-rc3-00001-g2a2bedf8bfa9 x86_64
    # grep ' [Tt] ' /proc/kallsyms | grep -iv '[048c]0 [Tt] ' | wc -l
    2805

There's clearly a substantial reduction in the number of misaligned
symbols. From manual inspection, the remaining unaligned text labels are
a combination of ACPICA functions (due to the use of '-Os'), static call
trampolines, and non-function labels in assembly, which will be dealt
with in subsequent patches.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20230123134603.1064407-3-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler_attributes.h |  6 ------
 include/linux/compiler_types.h      | 27 +++++++++++++++++++++++++++
 kernel/exit.c                       |  9 ++++++++-
 3 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index 898b3458b24a0..b83126452c651 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -75,12 +75,6 @@
 # define __assume_aligned(a, ...)
 #endif
 
-/*
- *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-cold-function-attribute
- *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Label-Attributes.html#index-cold-label-attribute
- */
-#define __cold                          __attribute__((__cold__))
-
 /*
  * Note the long name.
  *
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 7c1afe0f4129c..aab34e30128e9 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -79,6 +79,33 @@ static inline void __chk_io_ptr(const volatile void __iomem *ptr) { }
 /* Attributes */
 #include <linux/compiler_attributes.h>
 
+#if CONFIG_FUNCTION_ALIGNMENT > 0
+#define __function_aligned		__aligned(CONFIG_FUNCTION_ALIGNMENT)
+#else
+#define __function_aligned
+#endif
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-cold-function-attribute
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Label-Attributes.html#index-cold-label-attribute
+ *
+ * When -falign-functions=N is in use, we must avoid the cold attribute as
+ * contemporary versions of GCC drop the alignment for cold functions. Worse,
+ * GCC can implicitly mark callees of cold functions as cold themselves, so
+ * it's not sufficient to add __function_aligned here as that will not ensure
+ * that callees are correctly aligned.
+ *
+ * See:
+ *
+ *   https://lore.kernel.org/lkml/Y77%2FqVgvaJidFpYt@FVFF77S0Q05N
+ *   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=88345#c9
+ */
+#if !defined(CONFIG_CC_IS_GCC) || (CONFIG_FUNCTION_ALIGNMENT == 0)
+#define __cold				__attribute__((__cold__))
+#else
+#define __cold
+#endif
+
 /* Builtins */
 
 /*
diff --git a/kernel/exit.c b/kernel/exit.c
index 15dc2ec80c467..c8e0375705f48 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1898,7 +1898,14 @@ bool thread_group_exited(struct pid *pid)
 }
 EXPORT_SYMBOL(thread_group_exited);
 
-__weak void abort(void)
+/*
+ * This needs to be __function_aligned as GCC implicitly makes any
+ * implementation of abort() cold and drops alignment specified by
+ * -falign-functions=N.
+ *
+ * See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=88345#c11
+ */
+__weak __function_aligned void abort(void)
 {
 	BUG();
 
-- 
2.39.0

