Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8264F3191
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348860AbiDEKt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344105AbiDEJmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:42:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF66BD2FC;
        Tue,  5 Apr 2022 02:27:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C8D4B81CAF;
        Tue,  5 Apr 2022 09:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B9BC385A2;
        Tue,  5 Apr 2022 09:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150852;
        bh=HA4HSF/J+nRdjbcp1S15eTKIy9yKc9WCMNOb4KCX3L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLI/yZ/nTbSQGixRnXzUnAbTl21oAEhRGPz/4jNQgytBrdXvYb7CJ176Bea0HcaJK
         eWKTsFuMMwdmqDCxvzi+I2R+T761homJPAjZVIn7rnzZE9aPl2XO6MscaKw2ogR/sq
         nGdlononPDAe/w2H04fwtHUk/Uvg14hl78x+uDm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Elver <elver@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 203/913] stack: Constrain and fix stack offset randomization with Clang builds
Date:   Tue,  5 Apr 2022 09:21:05 +0200
Message-Id: <20220405070345.944099127@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit efa90c11f62e6b7252fb75efe2787056872a627c ]

All supported versions of Clang perform auto-init of __builtin_alloca()
when stack auto-init is on (CONFIG_INIT_STACK_ALL_{ZERO,PATTERN}).

add_random_kstack_offset() uses __builtin_alloca() to add a stack
offset. This means, when CONFIG_INIT_STACK_ALL_{ZERO,PATTERN} is
enabled, add_random_kstack_offset() will auto-init that unused portion
of the stack used to add an offset.

There are several problems with this:

	1. These offsets can be as large as 1023 bytes. Performing
	   memset() on them isn't exactly cheap, and this is done on
	   every syscall entry.

	2. Architectures adding add_random_kstack_offset() to syscall
	   entry implemented in C require them to be 'noinstr' (e.g. see
	   x86 and s390). The potential problem here is that a call to
	   memset may occur, which is not noinstr.

A x86_64 defconfig kernel with Clang 11 and CONFIG_VMLINUX_VALIDATION shows:

 | vmlinux.o: warning: objtool: do_syscall_64()+0x9d: call to memset() leaves .noinstr.text section
 | vmlinux.o: warning: objtool: do_int80_syscall_32()+0xab: call to memset() leaves .noinstr.text section
 | vmlinux.o: warning: objtool: __do_fast_syscall_32()+0xe2: call to memset() leaves .noinstr.text section
 | vmlinux.o: warning: objtool: fixup_bad_iret()+0x2f: call to memset() leaves .noinstr.text section

Clang 14 (unreleased) will introduce a way to skip alloca initialization
via __builtin_alloca_uninitialized() (https://reviews.llvm.org/D115440).

Constrain RANDOMIZE_KSTACK_OFFSET to only be enabled if no stack
auto-init is enabled, the compiler is GCC, or Clang is version 14+. Use
__builtin_alloca_uninitialized() if the compiler provides it, as is done
by Clang 14.

Link: https://lkml.kernel.org/r/YbHTKUjEejZCLyhX@elver.google.com
Fixes: 39218ff4c625 ("stack: Optionally randomize kernel stack offset each syscall")
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220131090521.1947110-2-elver@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/Kconfig                     |  1 +
 include/linux/randomize_kstack.h | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index d1e69d6e8498..191589f26b1a 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1141,6 +1141,7 @@ config HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 config RANDOMIZE_KSTACK_OFFSET_DEFAULT
 	bool "Randomize kernel stack offset on syscall entry"
 	depends on HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
+	depends on INIT_STACK_NONE || !CC_IS_CLANG || CLANG_VERSION >= 140000
 	help
 	  The kernel stack offset can be randomized (after pt_regs) by
 	  roughly 5 bits of entropy, frustrating memory corruption
diff --git a/include/linux/randomize_kstack.h b/include/linux/randomize_kstack.h
index bebc911161b6..d373f1bcbf7c 100644
--- a/include/linux/randomize_kstack.h
+++ b/include/linux/randomize_kstack.h
@@ -16,8 +16,20 @@ DECLARE_PER_CPU(u32, kstack_offset);
  * alignment. Also, since this use is being explicitly masked to a max of
  * 10 bits, stack-clash style attacks are unlikely. For more details see
  * "VLAs" in Documentation/process/deprecated.rst
+ *
+ * The normal __builtin_alloca() is initialized with INIT_STACK_ALL (currently
+ * only with Clang and not GCC). Initializing the unused area on each syscall
+ * entry is expensive, and generating an implicit call to memset() may also be
+ * problematic (such as in noinstr functions). Therefore, if the compiler
+ * supports it (which it should if it initializes allocas), always use the
+ * "uninitialized" variant of the builtin.
  */
-void *__builtin_alloca(size_t size);
+#if __has_builtin(__builtin_alloca_uninitialized)
+#define __kstack_alloca __builtin_alloca_uninitialized
+#else
+#define __kstack_alloca __builtin_alloca
+#endif
+
 /*
  * Use, at most, 10 bits of entropy. We explicitly cap this to keep the
  * "VLA" from being unbounded (see above). 10 bits leaves enough room for
@@ -36,7 +48,7 @@ void *__builtin_alloca(size_t size);
 	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
 				&randomize_kstack_offset)) {		\
 		u32 offset = raw_cpu_read(kstack_offset);		\
-		u8 *ptr = __builtin_alloca(KSTACK_OFFSET_MAX(offset));	\
+		u8 *ptr = __kstack_alloca(KSTACK_OFFSET_MAX(offset));	\
 		/* Keep allocation even after "ptr" loses scope. */	\
 		asm volatile("" :: "r"(ptr) : "memory");		\
 	}								\
-- 
2.34.1



