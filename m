Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0625E1D39ED
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 20:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgENSw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728510AbgENSw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:52:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 012B52065F;
        Thu, 14 May 2020 18:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482377;
        bh=iYOKdNcutYidCxHGWJIfBepkfclK6/2LI0QUfCIk4Pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ieHITNlybZun7CQFpZ6tdKFstkC1PNZDpa7J4UlV78UEFK5YZ8q/NmwtroQikswKd
         6Uktq6pCEScgRlzWgluBL1p60dPbRuvRFdyDCrhbNCGx6sKVi+EOlV+UubqvJdWc3d
         lt7NGcUNLluvaZ+pAcej2ugfqSkO23XureBNyVpc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 54/62] Stop the ad-hoc games with -Wno-maybe-initialized
Date:   Thu, 14 May 2020 14:51:39 -0400
Message-Id: <20200514185147.19716-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 78a5255ffb6a1af189a83e493d916ba1c54d8c75 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile             |  7 +++----
 init/Kconfig         | 18 ------------------
 kernel/trace/Kconfig |  1 -
 3 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/Makefile b/Makefile
index 744245f0c96cf..d226ec8bd167f 100644
--- a/Makefile
+++ b/Makefile
@@ -708,10 +708,6 @@ else ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
 KBUILD_CFLAGS += -Os
 endif
 
-ifdef CONFIG_CC_DISABLE_WARN_MAYBE_UNINITIALIZED
-KBUILD_CFLAGS   += -Wno-maybe-uninitialized
-endif
-
 # Tell gcc to never replace conditional load with a non-conditional one
 KBUILD_CFLAGS	+= $(call cc-option,--param=allow-store-data-races=0)
 KBUILD_CFLAGS	+= $(call cc-option,-fno-allow-store-data-races)
@@ -862,6 +858,9 @@ KBUILD_CFLAGS += -Wno-pointer-sign
 # disable stringop warnings in gcc 8+
 KBUILD_CFLAGS += $(call cc-disable-warning, stringop-truncation)
 
+# Enabled with W=2, disabled by default as noisy
+KBUILD_CFLAGS += $(call cc-disable-warning, maybe-uninitialized)
+
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
 
diff --git a/init/Kconfig b/init/Kconfig
index 4f717bfdbfe2d..ef59c5c36cdb5 100644
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
@@ -1249,14 +1233,12 @@ config CC_OPTIMIZE_FOR_PERFORMANCE
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
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 402eef84c859a..743647005f64e 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -466,7 +466,6 @@ config PROFILE_ANNOTATED_BRANCHES
 config PROFILE_ALL_BRANCHES
 	bool "Profile all if conditionals" if !FORTIFY_SOURCE
 	select TRACE_BRANCH_PROFILING
-	imply CC_DISABLE_WARN_MAYBE_UNINITIALIZED  # avoid false positives
 	help
 	  This tracer profiles all branch conditions. Every if ()
 	  taken in the kernel is recorded whether it hit or miss.
-- 
2.20.1

