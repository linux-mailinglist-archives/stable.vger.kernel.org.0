Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EB21D8642
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgERRs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:48:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730378AbgERRs2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:48:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0665720674;
        Mon, 18 May 2020 17:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824107;
        bh=dZwCggNU1iIC/ycO4FJK+Rssc7UHLIkc2O8HyfRQyI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyC42pnhy2xKirTGTKK8ksisqmcRhOBnzQ0j4C6iqvQH7L2rbR+RmlZ293Zz5YoP1
         nefuNQK0THIa+EiJiiTDtXHBpDVA9CmOCJtuWVPMtuzLF5+q/D8auhFUhPHE/LUU/I
         6Xx/VOmt0+sNfinCXY5rtSzFEfrt85y8nY1OiTNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 073/114] Stop the ad-hoc games with -Wno-maybe-initialized
Date:   Mon, 18 May 2020 19:36:45 +0200
Message-Id: <20200518173516.080366587@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
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
 init/Kconfig         |   17 -----------------
 kernel/trace/Kconfig |    1 -
 3 files changed, 3 insertions(+), 22 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -661,10 +661,6 @@ else
 KBUILD_CFLAGS   += -O2
 endif
 
-ifdef CONFIG_CC_DISABLE_WARN_MAYBE_UNINITIALIZED
-KBUILD_CFLAGS   += -Wno-maybe-uninitialized
-endif
-
 # Tell gcc to never replace conditional load with a non-conditional one
 KBUILD_CFLAGS	+= $(call cc-option,--param=allow-store-data-races=0)
 
@@ -804,6 +800,9 @@ KBUILD_CFLAGS += $(call cc-disable-warni
 # disable stringop warnings in gcc 8+
 KBUILD_CFLAGS += $(call cc-disable-warning, stringop-truncation)
 
+# Enabled with W=2, disabled by default as noisy
+KBUILD_CFLAGS += $(call cc-disable-warning, maybe-uninitialized)
+
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
 
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -16,22 +16,6 @@ config DEFCONFIG_LIST
 	default "$ARCH_DEFCONFIG"
 	default "arch/$ARCH/defconfig"
 
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
@@ -1060,7 +1044,6 @@ config CC_OPTIMIZE_FOR_PERFORMANCE
 
 config CC_OPTIMIZE_FOR_SIZE
 	bool "Optimize for size"
-	imply CC_DISABLE_WARN_MAYBE_UNINITIALIZED  # avoid false positives
 	help
 	  Enabling this option will pass "-Os" instead of "-O2" to
 	  your compiler resulting in a smaller kernel.
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -345,7 +345,6 @@ config PROFILE_ANNOTATED_BRANCHES
 config PROFILE_ALL_BRANCHES
 	bool "Profile all if conditionals" if !FORTIFY_SOURCE
 	select TRACE_BRANCH_PROFILING
-	imply CC_DISABLE_WARN_MAYBE_UNINITIALIZED  # avoid false positives
 	help
 	  This tracer profiles all branch conditions. Every if ()
 	  taken in the kernel is recorded whether it hit or miss.


