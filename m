Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6DC1D828D
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730769AbgERR50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:57:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731257AbgERR5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:57:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1033207C4;
        Mon, 18 May 2020 17:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824645;
        bh=n7/Jy8yngkl5+iE5tSrau/6Npt5wz5PgvgKrbzn52bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2EgJnq1z/WDBwN3giTr/Z/wXwp31Qab+HjCbTiy/6eAbdwqm6J9DiOmH6G3oxof1F
         x6yDKefDTDuTqrHKQ8+SPaODLf8Lk/MwYBPRmSzDwikNaVNewbL44UWR8EW8YEWLBE
         P3kex+cM/e2Psjyg00hpfLZX5sDYTFy0WCPxOy6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 095/147] Stop the ad-hoc games with -Wno-maybe-initialized
Date:   Mon, 18 May 2020 19:36:58 +0200
Message-Id: <20200518173525.364053200@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 78a5255ffb6a1af189a83e493d916ba1c54d8c75 upstream.

We have some rather random rules about when we accept the
"maybe-initialized" warnings, and when we don't.

For example, we consider it unreliable for gcc versions < 4.9, but also
if -O3 is enabled, or if optimizing for size.  And then various kernel
config options disabled it, because they know that they trigger that
warning by confusing gcc sufficiently (ie PROFILE_ALL_BRANCHES).

And now gcc-10 seems to be introducing a lot of those warnings too, so
it falls under the same heading as 4.9 did.

At the same time, we have a very straightforward way to _enable_ that
warning when wanted: use "W=2" to enable more warnings.

So stop playing these ad-hoc games, and just disable that warning by
default, with the known and straight-forward "if you want to work on the
extra compiler warnings, use W=123".

Would it be great to have code that is always so obvious that it never
confuses the compiler whether a variable is used initialized or not?
Yes, it would.  In a perfect world, the compilers would be smarter, and
our source code would be simpler.

That's currently not the world we live in, though.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile             |    7 +++----
 init/Kconfig         |   18 ------------------
 kernel/trace/Kconfig |    1 -
 3 files changed, 3 insertions(+), 23 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -707,10 +707,6 @@ else ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
 KBUILD_CFLAGS += -Os
 endif
 
-ifdef CONFIG_CC_DISABLE_WARN_MAYBE_UNINITIALIZED
-KBUILD_CFLAGS   += -Wno-maybe-uninitialized
-endif
-
 # Tell gcc to never replace conditional load with a non-conditional one
 KBUILD_CFLAGS	+= $(call cc-option,--param=allow-store-data-races=0)
 
@@ -860,6 +856,9 @@ KBUILD_CFLAGS += -Wno-pointer-sign
 # disable stringop warnings in gcc 8+
 KBUILD_CFLAGS += $(call cc-disable-warning, stringop-truncation)
 
+# Enabled with W=2, disabled by default as noisy
+KBUILD_CFLAGS += $(call cc-disable-warning, maybe-uninitialized)
+
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
 
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -36,22 +36,6 @@ config TOOLS_SUPPORT_RELR
 config CC_HAS_ASM_INLINE
 	def_bool $(success,echo 'void foo(void) { asm inline (""); }' | $(CC) -x c - -c -o /dev/null)
 
-config CC_HAS_WARN_MAYBE_UNINITIALIZED
-	def_bool $(cc-option,-Wmaybe-uninitialized)
-	help
-	  GCC >= 4.7 supports this option.
-
-config CC_DISABLE_WARN_MAYBE_UNINITIALIZED
-	bool
-	depends on CC_HAS_WARN_MAYBE_UNINITIALIZED
-	default CC_IS_GCC && GCC_VERSION < 40900  # unreliable for GCC < 4.9
-	help
-	  GCC's -Wmaybe-uninitialized is not reliable by definition.
-	  Lots of false positive warnings are produced in some cases.
-
-	  If this option is enabled, -Wno-maybe-uninitialzed is passed
-	  to the compiler to suppress maybe-uninitialized warnings.
-
 config CONSTRUCTORS
 	bool
 	depends on !UML
@@ -1226,14 +1210,12 @@ config CC_OPTIMIZE_FOR_PERFORMANCE
 config CC_OPTIMIZE_FOR_PERFORMANCE_O3
 	bool "Optimize more for performance (-O3)"
 	depends on ARC
-	imply CC_DISABLE_WARN_MAYBE_UNINITIALIZED  # avoid false positives
 	help
 	  Choosing this option will pass "-O3" to your compiler to optimize
 	  the kernel yet more for performance.
 
 config CC_OPTIMIZE_FOR_SIZE
 	bool "Optimize for size (-Os)"
-	imply CC_DISABLE_WARN_MAYBE_UNINITIALIZED  # avoid false positives
 	help
 	  Choosing this option will pass "-Os" to your compiler resulting
 	  in a smaller kernel.
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -371,7 +371,6 @@ config PROFILE_ANNOTATED_BRANCHES
 config PROFILE_ALL_BRANCHES
 	bool "Profile all if conditionals" if !FORTIFY_SOURCE
 	select TRACE_BRANCH_PROFILING
-	imply CC_DISABLE_WARN_MAYBE_UNINITIALIZED  # avoid false positives
 	help
 	  This tracer profiles all branch conditions. Every if ()
 	  taken in the kernel is recorded whether it hit or miss.


