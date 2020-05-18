Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4346A1D85CA
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbgERRwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730925AbgERRwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:52:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04F7D20826;
        Mon, 18 May 2020 17:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824324;
        bh=H3lARfiaXtBGdgWpOv2deCtz4iA5GbK5Cy1r8oPgU3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BU7QVo2BevLFvqCm4OpzlOL5asmiAYM1WyRL8ikgSwCdC0kb/p3GJKhtAUf6w/5ZS
         Oct7NP3t2B6K+AYQfQphR86AhEcgOOf2kRZtNmzYGTyDoNdYqSH2qedjR0lJbCoQYV
         RhOowsggt7nULcQp3nW1jrBhOZXtSll/nBCdiXZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.19 46/80] kbuild: compute false-positive -Wmaybe-uninitialized cases in Kconfig
Date:   Mon, 18 May 2020 19:37:04 +0200
Message-Id: <20200518173459.723033759@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit b303c6df80c9f8f13785aa83a0471fca7e38b24d upstream.

Since -Wmaybe-uninitialized was introduced by GCC 4.7, we have patched
various false positives:

 - commit e74fc973b6e5 ("Turn off -Wmaybe-uninitialized when building
   with -Os") turned off this option for -Os.

 - commit 815eb71e7149 ("Kbuild: disable 'maybe-uninitialized' warning
   for CONFIG_PROFILE_ALL_BRANCHES") turned off this option for
   CONFIG_PROFILE_ALL_BRANCHES

 - commit a76bcf557ef4 ("Kbuild: enable -Wmaybe-uninitialized warning
   for "make W=1"") turned off this option for GCC < 4.9
   Arnd provided more explanation in https://lkml.org/lkml/2017/3/14/903

I think this looks better by shifting the logic from Makefile to Kconfig.

Link: https://github.com/ClangBuiltLinux/linux/issues/350
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile             |   11 ++++-------
 init/Kconfig         |   17 +++++++++++++++++
 kernel/trace/Kconfig |    1 +
 3 files changed, 22 insertions(+), 7 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -657,17 +657,14 @@ KBUILD_CFLAGS	+= $(call cc-disable-warni
 KBUILD_CFLAGS	+= $(call cc-disable-warning, address-of-packed-member)
 
 ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
-KBUILD_CFLAGS	+= -Os $(call cc-disable-warning,maybe-uninitialized,)
-else
-ifdef CONFIG_PROFILE_ALL_BRANCHES
-KBUILD_CFLAGS	+= -O2 $(call cc-disable-warning,maybe-uninitialized,)
+KBUILD_CFLAGS   += -Os
 else
 KBUILD_CFLAGS   += -O2
 endif
-endif
 
-KBUILD_CFLAGS += $(call cc-ifversion, -lt, 0409, \
-			$(call cc-disable-warning,maybe-uninitialized,))
+ifdef CONFIG_CC_DISABLE_WARN_MAYBE_UNINITIALIZED
+KBUILD_CFLAGS   += -Wno-maybe-uninitialized
+endif
 
 # Tell gcc to never replace conditional load with a non-conditional one
 KBUILD_CFLAGS	+= $(call cc-option,--param=allow-store-data-races=0)
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -26,6 +26,22 @@ config CLANG_VERSION
 config CC_HAS_ASM_GOTO
 	def_bool $(success,$(srctree)/scripts/gcc-goto.sh $(CC))
 
+config CC_HAS_WARN_MAYBE_UNINITIALIZED
+	def_bool $(cc-option,-Wmaybe-uninitialized)
+	help
+	  GCC >= 4.7 supports this option.
+
+config CC_DISABLE_WARN_MAYBE_UNINITIALIZED
+	bool
+	depends on CC_HAS_WARN_MAYBE_UNINITIALIZED
+	default CC_IS_GCC && GCC_VERSION < 40900  # unreliable for GCC < 4.9
+	help
+	  GCC's -Wmaybe-uninitialized is not reliable by definition.
+	  Lots of false positive warnings are produced in some cases.
+
+	  If this option is enabled, -Wno-maybe-uninitialzed is passed
+	  to the compiler to suppress maybe-uninitialized warnings.
+
 config CONSTRUCTORS
 	bool
 	depends on !UML
@@ -1083,6 +1099,7 @@ config CC_OPTIMIZE_FOR_PERFORMANCE
 
 config CC_OPTIMIZE_FOR_SIZE
 	bool "Optimize for size"
+	imply CC_DISABLE_WARN_MAYBE_UNINITIALIZED  # avoid false positives
 	help
 	  Enabling this option will pass "-Os" instead of "-O2" to
 	  your compiler resulting in a smaller kernel.
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -370,6 +370,7 @@ config PROFILE_ANNOTATED_BRANCHES
 config PROFILE_ALL_BRANCHES
 	bool "Profile all if conditionals" if !FORTIFY_SOURCE
 	select TRACE_BRANCH_PROFILING
+	imply CC_DISABLE_WARN_MAYBE_UNINITIALIZED  # avoid false positives
 	help
 	  This tracer profiles all branch conditions. Every if ()
 	  taken in the kernel is recorded whether it hit or miss.


