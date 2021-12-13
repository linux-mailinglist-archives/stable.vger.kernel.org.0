Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB6E4726C6
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbhLMJyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:54:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38504 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237923AbhLMJwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:52:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3937AB80E19;
        Mon, 13 Dec 2021 09:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817CFC00446;
        Mon, 13 Dec 2021 09:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389136;
        bh=bho0cu3DLMeVTfoxIFWtYHdpNXVTZVf5jDMnpw44mus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Klx586oeAxybYUqFfHY78EVMva8N2YCEePZvbMUZg6nfMXPe+WkEcZwm5rRdY9U0x
         4DFBNHWSKZ44TO1MWG6Xi6dyLzuhtlvDtJimST/CCyhjrajcYRiHrdkh1JVH2R0VZD
         b4Nhry/0uPvaRn4MSBp7R8jsEr5VPfADXy4yDxNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 130/132] doc: gcc-plugins: update gcc-plugins.rst
Date:   Mon, 13 Dec 2021 10:31:11 +0100
Message-Id: <20211213092943.552620715@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 9b6164342e981d751e69f5a165dd596ffcdfd6fe upstream.

This document was written a long time ago. Update it.

[1] Drop the version information

The range of the supported GCC versions are always changing. The
current minimal GCC version is 4.9, and commit 1e860048c53e
("gcc-plugins: simplify GCC plugin-dev capability test") removed the
old code accordingly.

We do not need to mention specific version ranges like "all gcc versions
from 4.5 to 6.0" since we forget to update the documentation when we
raise the minimal compiler version.

[2] Drop the C compiler statements

Since commit 77342a02ff6e ("gcc-plugins: drop support for GCC <= 4.7")
the GCC plugin infrastructure only supports g++.

[3] Drop supported architectures

As of v5.11-rc4, the infrastructure supports more architectures;
arm, arm64, mips, powerpc, riscv, s390, um, and x86. (just grep
"select HAVE_GCC_PLUGINS") Again, we miss to update this document when a
new architecture is supported. Let's just say "only some architectures".

[4] Update the apt-get example

We are now discussing to bump the minimal version to GCC 5. The GCC 4.9
support will be removed sooner or later. Change the package example to
gcc-10-plugin-dev while we are here.

[5] Update the build target

Since commit ce2fd53a10c7 ("kbuild: descend into scripts/gcc-plugins/
via scripts/Makefile"), "make gcc-plugins" is not supported.
"make scripts" builds all the enabled plugins, including some other
tools.

[6] Update the steps for adding a new plugin

At first, all CONFIG options for GCC plugins were located in arch/Kconfig.
After commit 45332b1bdfdc ("gcc-plugins: split out Kconfig entries to
scripts/gcc-plugins/Kconfig"), scripts/gcc-plugins/Kconfig became the
central place to collect plugin CONFIG options. In my understanding,
this requirement no longer exists because commit 9f671e58159a ("security:
Create "kernel hardening" config area") moved some of plugin CONFIG
options to another file. Find an appropriate place to add the new CONFIG.

The sub-directory support was never used by anyone, and removed by
commit c17d6179ad5a ("gcc-plugins: remove unused GCC_PLUGIN_SUBDIR").

Remove the useless $(src)/ prefix.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kbuild/gcc-plugins.rst |   43 +++++++++++++++++------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

--- a/Documentation/kbuild/gcc-plugins.rst
+++ b/Documentation/kbuild/gcc-plugins.rst
@@ -11,16 +11,13 @@ compiler [1]_. They are useful for runti
 We can analyse, change and add further code during compilation via
 callbacks [2]_, GIMPLE [3]_, IPA [4]_ and RTL passes [5]_.
 
-The GCC plugin infrastructure of the kernel supports all gcc versions from
-4.5 to 6.0, building out-of-tree modules, cross-compilation and building in a
-separate directory.
-Plugin source files have to be compilable by both a C and a C++ compiler as well
-because gcc versions 4.5 and 4.6 are compiled by a C compiler,
-gcc-4.7 can be compiled by a C or a C++ compiler,
-and versions 4.8+ can only be compiled by a C++ compiler.
-
-Currently the GCC plugin infrastructure supports only the x86, arm, arm64 and
-powerpc architectures.
+The GCC plugin infrastructure of the kernel supports building out-of-tree
+modules, cross-compilation and building in a separate directory.
+Plugin source files have to be compilable by a C++ compiler.
+
+Currently the GCC plugin infrastructure supports only some architectures.
+Grep "select HAVE_GCC_PLUGINS" to find out which architectures support
+GCC plugins.
 
 This infrastructure was ported from grsecurity [6]_ and PaX [7]_.
 
@@ -59,8 +56,7 @@ $(src)/scripts/gcc-plugins/gcc-generate-
 $(src)/scripts/gcc-plugins/gcc-generate-rtl-pass.h**
 
 	These headers automatically generate the registration structures for
-	GIMPLE, SIMPLE_IPA, IPA and RTL passes. They support all gcc versions
-	from 4.5 to 6.0.
+	GIMPLE, SIMPLE_IPA, IPA and RTL passes.
 	They should be preferred to creating the structures by hand.
 
 
@@ -68,21 +64,25 @@ Usage
 =====
 
 You must install the gcc plugin headers for your gcc version,
-e.g., on Ubuntu for gcc-4.9::
+e.g., on Ubuntu for gcc-10::
 
-	apt-get install gcc-4.9-plugin-dev
+	apt-get install gcc-10-plugin-dev
 
 Or on Fedora::
 
 	dnf install gcc-plugin-devel
 
-Enable a GCC plugin based feature in the kernel config::
+Enable the GCC plugin infrastructure and some plugin(s) you want to use
+in the kernel config::
 
-	CONFIG_GCC_PLUGIN_CYC_COMPLEXITY = y
+	CONFIG_GCC_PLUGINS=y
+	CONFIG_GCC_PLUGIN_CYC_COMPLEXITY=y
+	CONFIG_GCC_PLUGIN_LATENT_ENTROPY=y
+	...
 
-To compile only the plugin(s)::
+To compile the minimum tool set including the plugin(s)::
 
-	make gcc-plugins
+	make scripts
 
 or just run the kernel make and compile the whole kernel with
 the cyclomatic complexity GCC plugin.
@@ -91,7 +91,8 @@ the cyclomatic complexity GCC plugin.
 4. How to add a new GCC plugin
 ==============================
 
-The GCC plugins are in $(src)/scripts/gcc-plugins/. You can use a file or a directory
-here. It must be added to $(src)/scripts/gcc-plugins/Makefile,
-$(src)/scripts/Makefile.gcc-plugins and $(src)/arch/Kconfig.
+The GCC plugins are in scripts/gcc-plugins/. You need to put plugin source files
+right under scripts/gcc-plugins/. Creating subdirectories is not supported.
+It must be added to scripts/gcc-plugins/Makefile, scripts/Makefile.gcc-plugins
+and a relevant Kconfig file.
 See the cyc_complexity_plugin.c (CONFIG_GCC_PLUGIN_CYC_COMPLEXITY) GCC plugin.


