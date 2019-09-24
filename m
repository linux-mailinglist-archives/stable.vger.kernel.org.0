Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62E9BCFBE
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409879AbfIXQoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409865AbfIXQom (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:44:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF42B21841;
        Tue, 24 Sep 2019 16:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343481;
        bh=io5E/XLC2xLF3oDgetiVEl84yoGCYv5MMRcAAKaWvBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5I3YHypVx4M5taxa4Boc1AwjMAVHIp2UFQiN8btIwGrgBlCIPhWEMDZ+HuzyUgBG
         F/DGj/T/445lxjpn68lmpfiDG0T0d3N/5cQeilQppq3peKr3fuNxFZopSuanppuA7Z
         v0wrCiUG3NdI6DYAsd0C6A6LD8JVKJgV8nB4un3U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.3 64/87] kbuild: Do not enable -Wimplicit-fallthrough for clang for now
Date:   Tue, 24 Sep 2019 12:41:20 -0400
Message-Id: <20190924164144.25591-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit e2079e93f562c7f7a030eb7642017ee5eabaaa10 ]

This functionally reverts commit bfd77145f35c ("Makefile: Convert
-Wimplicit-fallthrough=3 to just -Wimplicit-fallthrough for clang").

clang enabled support for -Wimplicit-fallthrough in C in r369414 [1],
which causes a lot of warnings when building the kernel for two reasons:

1. Clang does not support the /* fall through */ comments. There seems
   to be a general consensus in the LLVM community that this is not
   something they want to support. Joe Perches wrote a script to convert
   all of the comments to a "fallthrough" keyword that will be added to
   compiler_attributes.h [2] [3], which catches the vast majority of the
   comments. There doesn't appear to be any consensus in the kernel
   community when to do this conversion.

2. Clang and GCC disagree about falling through to final case statements
   with no content or cases that simply break:

   https://godbolt.org/z/c8csDu

   This difference contributes at least 50 warnings in an allyesconfig
   build for x86, not considering other architectures. This difference
   will need to be discussed to see which compiler is right [4] [5].

[1]: https://github.com/llvm/llvm-project/commit/1e0affb6e564b7361b0aadb38805f26deff4ecfc
[2]: https://lore.kernel.org/lkml/61ddbb86d5e68a15e24ccb06d9b399bbf5ce2da7.camel@perches.com/
[3]: https://lore.kernel.org/lkml/1d2830aadbe9d8151728a7df5b88528fc72a0095.1564549413.git.joe@perches.com/
[4]: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91432
[5]: https://github.com/ClangBuiltLinux/linux/issues/636

Given these two problems need discussion and coordination, do not enable
-Wimplicit-fallthrough with clang right now. Add a comment to explain
what is going on as well. This commit should be reverted once these two
issues are fully flushed out and resolved.

Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index f32e8d2e09c36..23703ecb8fdd0 100644
--- a/Makefile
+++ b/Makefile
@@ -751,6 +751,11 @@ else
 # These warnings generated too much noise in a regular build.
 # Use make W=1 to enable them (see scripts/Makefile.extrawarn)
 KBUILD_CFLAGS += -Wno-unused-but-set-variable
+
+# Warn about unmarked fall-throughs in switch statement.
+# Disabled for clang while comment to attribute conversion happens and
+# https://github.com/ClangBuiltLinux/linux/issues/636 is discussed.
+KBUILD_CFLAGS += $(call cc-option,-Wimplicit-fallthrough,)
 endif
 
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-const-variable)
@@ -845,9 +850,6 @@ NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
 # warn about C99 declaration after statement
 KBUILD_CFLAGS += -Wdeclaration-after-statement
 
-# Warn about unmarked fall-throughs in switch statement.
-KBUILD_CFLAGS += $(call cc-option,-Wimplicit-fallthrough,)
-
 # Variable Length Arrays (VLAs) should not be used anywhere in the kernel
 KBUILD_CFLAGS += -Wvla
 
-- 
2.20.1

