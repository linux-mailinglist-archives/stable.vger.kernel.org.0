Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E3554A502
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353017AbiFNCMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352765AbiFNCLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:11:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565D437A29;
        Mon, 13 Jun 2022 19:07:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4721E60B66;
        Tue, 14 Jun 2022 02:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FEFC34114;
        Tue, 14 Jun 2022 02:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172413;
        bh=uwHDzuN9Io+WZTJmeh6rxLC/HiVmn2fIrdS5XUeVtj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxl/ySSUcWdlr0Ts7Rr/fyvAmcmQQ/rpbvwJKb5MaVBgrCkjigtcmu9zjaM/g6AL0
         oVLqe/mISsrztJ5Z+0t1q9/8LbH3gnBNv+BMTayoWmJxb6H+p3Ft0JIpKaSNQO+6oR
         O/SCKybkMsu1Ujz7oXbIOEup4THItgS9IDpcVnhJoBpUMh0Jb8A48d+PLIq+vVeYCo
         hlmU6lPOC16+YJyXebT59EC+utEC7UE3NSUjMW0CebH9WW36F5/RAnNTGTexAZFPQz
         UgDq7VE8+3uFgZ8xOH5ejwy5bT/CHywvvxYMDp8NhG9/TRpdIXlw+w/nv8fRybhjsT
         AL3EvRcRcuNfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mmarek@suse.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        gregkh@linuxfoundation.org, fllinden@amazon.com, ast@kernel.org,
        daniel@iogearbox.net, linux-kbuild@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 34/43] gcc-12: disable '-Warray-bounds' universally for now
Date:   Mon, 13 Jun 2022 22:05:53 -0400
Message-Id: <20220614020602.1098943-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020602.1098943-1-sashal@kernel.org>
References: <20220614020602.1098943-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit f0be87c42cbd341d436d06da4792e6b0c83c3aeb ]

In commit 8b202ee21839 ("s390: disable -Warray-bounds") the s390 people
disabled the '-Warray-bounds' warning for gcc-12, because the new logic
in gcc would cause warnings for their use of the S390_lowcore macro,
which accesses absolute pointers.

It turns out gcc-12 has many other issues in this area, so this takes
that s390 warning disable logic, and turns it into a kernel build config
entry instead.

Part of the intent is that we can make this all much more targeted, and
use this conflig flag to disable it in only particular configurations
that cause problems, with the s390 case as an example:

        select GCC12_NO_ARRAY_BOUNDS

and we could do that for other configuration cases that cause issues.

Or we could possibly use the CONFIG_CC_NO_ARRAY_BOUNDS thing in a more
targeted way, and disable the warning only for particular uses: again
the s390 case as an example:

  KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_CC_NO_ARRAY_BOUNDS),-Wno-array-bounds)

but this ends up just doing it globally in the top-level Makefile, since
the current issues are spread fairly widely all over:

  KBUILD_CFLAGS-$(CONFIG_CC_NO_ARRAY_BOUNDS) += -Wno-array-bounds

We'll try to limit this later, since the gcc-12 problems are rare enough
that *much* of the kernel can be built with it without disabling this
warning.

Cc: Kees Cook <keescook@chromium.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile           |  1 +
 arch/s390/Kconfig  |  1 +
 arch/s390/Makefile | 10 +---------
 init/Kconfig       |  9 +++++++++
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index e2a1832681e7..0a344db643b1 100644
--- a/Makefile
+++ b/Makefile
@@ -778,6 +778,7 @@ stackp-flags-$(CONFIG_STACKPROTECTOR_STRONG)      := -fstack-protector-strong
 KBUILD_CFLAGS += $(stackp-flags-y)
 
 KBUILD_CFLAGS-$(CONFIG_WERROR) += -Werror
+KBUILD_CFLAGS-$(CONFIG_CC_NO_ARRAY_BOUNDS) += -Wno-array-bounds
 KBUILD_CFLAGS += $(KBUILD_CFLAGS-y) $(CONFIG_CC_IMPLICIT_FALLTHROUGH)
 
 ifdef CONFIG_CC_IS_CLANG
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index be9f39fd06df..b14a18ac2e71 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -123,6 +123,7 @@ config S390
 	select CPU_NO_EFFICIENT_FFS if !HAVE_MARCH_Z9_109_FEATURES
 	select DMA_OPS if PCI
 	select DYNAMIC_FTRACE if FUNCTION_TRACER
+	select GCC12_NO_ARRAY_BOUNDS
 	select GENERIC_ALLOCATOR
 	select GENERIC_CPU_AUTOPROBE
 	select GENERIC_CPU_VULNERABILITIES
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 6e42252214dd..82a44f60ad3c 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -30,15 +30,7 @@ KBUILD_CFLAGS_DECOMPRESSOR += -fno-stack-protector
 KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-disable-warning, address-of-packed-member)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO),-g)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO_DWARF4), $(call cc-option, -gdwarf-4,))
-
-ifdef CONFIG_CC_IS_GCC
-	ifeq ($(call cc-ifversion, -ge, 1200, y), y)
-		ifeq ($(call cc-ifversion, -lt, 1300, y), y)
-			KBUILD_CFLAGS += $(call cc-disable-warning, array-bounds)
-			KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-disable-warning, array-bounds)
-		endif
-	endif
-endif
+KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_CC_NO_ARRAY_BOUNDS),-Wno-array-bounds)
 
 UTS_MACHINE	:= s390x
 STACK_SIZE	:= $(if $(CONFIG_KASAN),65536,16384)
diff --git a/init/Kconfig b/init/Kconfig
index 4a7a569706c5..cbe094645917 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -895,6 +895,15 @@ config CC_IMPLICIT_FALLTHROUGH
 	default "-Wimplicit-fallthrough=5" if CC_IS_GCC && $(cc-option,-Wimplicit-fallthrough=5)
 	default "-Wimplicit-fallthrough" if CC_IS_CLANG && $(cc-option,-Wunreachable-code-fallthrough)
 
+# Currently, disable gcc-12 array-bounds globally.
+# We may want to target only particular configurations some day.
+config GCC12_NO_ARRAY_BOUNDS
+	def_bool y
+
+config CC_NO_ARRAY_BOUNDS
+	bool
+	default y if CC_IS_GCC && GCC_VERSION >= 120000 && GCC_VERSION < 130000 && GCC12_NO_ARRAY_BOUNDS
+
 #
 # For architectures that know their GCC __int128 support is sound
 #
-- 
2.35.1

