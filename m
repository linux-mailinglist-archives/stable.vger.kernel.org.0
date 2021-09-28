Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8773441A7C7
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239169AbhI1F7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239199AbhI1F6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1997461266;
        Tue, 28 Sep 2021 05:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808604;
        bh=9XYhxWHvugaXUYp0Mrx7sZwFT1FDnAgQlbvApNOr2+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDbTbR77lowQ2y9htl4J/sbn6KqjUvqZekyjAm8wYjt/QdCkzNErko4DiRpx6sr5v
         bh5G7/tuLopx3nfHvAeqqjdZMwrd+IKeFT5j5bi9yXmedYq3DR51Y9odX/CN3Z4JsC
         iMxWblqa2Yxc+UKULmal7Jo/XBA/UAEu4C0BU6sZuUyBS/E0Jv9MbVIXHwvkEifTm8
         4pCQKwj8NAJ3NOR1mPy7jmN6yym49vUGA/WsuwGV6fx/k3qB1TvBpYn+a6bAQLyL5k
         mrDjid7AC8oZBZydkNYQzlDWqxt7sGVjd2ni1npb3Dim/vOYqbOcK9+eO7fA743ZT4
         pwW3wl/Fl7uKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Marco Elver <elver@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, masahiroy@kernel.org,
        michal.lkml@markovi.net, kasan-dev@googlegroups.com,
        linux-kbuild@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.14 40/40] kasan: always respect CONFIG_KASAN_STACK
Date:   Tue, 28 Sep 2021 01:55:24 -0400
Message-Id: <20210928055524.172051-40-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 19532869feb9b0a97d17ddc14609d1e53a5b60db ]

Currently, the asan-stack parameter is only passed along if
CFLAGS_KASAN_SHADOW is not empty, which requires KASAN_SHADOW_OFFSET to
be defined in Kconfig so that the value can be checked.  In RISC-V's
case, KASAN_SHADOW_OFFSET is not defined in Kconfig, which means that
asan-stack does not get disabled with clang even when CONFIG_KASAN_STACK
is disabled, resulting in large stack warnings with allmodconfig:

  drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:117:12: error: stack frame size (14400) exceeds limit (2048) in function 'lb035q02_connect' [-Werror,-Wframe-larger-than]
  static int lb035q02_connect(struct omap_dss_device *dssdev)
             ^
  1 error generated.

Ensure that the value of CONFIG_KASAN_STACK is always passed along to
the compiler so that these warnings do not happen when
CONFIG_KASAN_STACK is disabled.

Link: https://github.com/ClangBuiltLinux/linux/issues/1453
References: 6baec880d7a5 ("kasan: turn off asan-stack for clang-8 and earlier")
Link: https://lkml.kernel.org/r/20210922205525.570068-1-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.kasan | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.kasan b/scripts/Makefile.kasan
index 801c415bac59..b9e94c5e7097 100644
--- a/scripts/Makefile.kasan
+++ b/scripts/Makefile.kasan
@@ -33,10 +33,11 @@ else
 	CFLAGS_KASAN := $(CFLAGS_KASAN_SHADOW) \
 	 $(call cc-param,asan-globals=1) \
 	 $(call cc-param,asan-instrumentation-with-call-threshold=$(call_threshold)) \
-	 $(call cc-param,asan-stack=$(stack_enable)) \
 	 $(call cc-param,asan-instrument-allocas=1)
 endif
 
+CFLAGS_KASAN += $(call cc-param,asan-stack=$(stack_enable))
+
 endif # CONFIG_KASAN_GENERIC
 
 ifdef CONFIG_KASAN_SW_TAGS
-- 
2.33.0

