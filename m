Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D59278888
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbgIYMyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:54:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728430AbgIYMyT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:54:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00D4A2072E;
        Fri, 25 Sep 2020 12:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038458;
        bh=JFrCt+vGTBVOxHL+wcCyG0sxMyL/8clo5DWfoflr+d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SaKnPBmHmwcodZv8nZLvEPryLWMyK+9V0I50E0uc0qNpBLfr/UmfyTT2v35P8sEKC
         PXjrOwKmO5a1VZqLIOTIMa7SEnowNiPta6rMHFO+HfHx/myZj7H8UdxGz7iZOl31Bp
         rDWgOsj+wSbnyF3da1KVeEWfT8t0H5zdhVYhecGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.19 26/37] Documentation/llvm: add documentation on building w/ Clang/LLVM
Date:   Fri, 25 Sep 2020 14:48:54 +0200
Message-Id: <20200925124724.908634664@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit fcf1b6a35c16ac500fa908a4022238e5d666eabf upstream.

added to kbuild documentation. Provides more official info on building
kernels with Clang and LLVM than our wiki.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
[nd: hunk against Documentation/kbuild/index.rst dropped due to not backporting
 commit cd238effefa2 ("docs: kbuild: convert docs to ReST and rename to *.rst")]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kbuild/llvm.rst |   80 ++++++++++++++++++++++++++++++++++++++++++
 MAINTAINERS                   |    1 
 2 files changed, 81 insertions(+)
 create mode 100644 Documentation/kbuild/llvm.rst

--- /dev/null
+++ b/Documentation/kbuild/llvm.rst
@@ -0,0 +1,80 @@
+==============================
+Building Linux with Clang/LLVM
+==============================
+
+This document covers how to build the Linux kernel with Clang and LLVM
+utilities.
+
+About
+-----
+
+The Linux kernel has always traditionally been compiled with GNU toolchains
+such as GCC and binutils. Ongoing work has allowed for `Clang
+<https://clang.llvm.org/>`_ and `LLVM <https://llvm.org/>`_ utilities to be
+used as viable substitutes. Distributions such as `Android
+<https://www.android.com/>`_, `ChromeOS
+<https://www.chromium.org/chromium-os>`_, and `OpenMandriva
+<https://www.openmandriva.org/>`_ use Clang built kernels.  `LLVM is a
+collection of toolchain components implemented in terms of C++ objects
+<https://www.aosabook.org/en/llvm.html>`_. Clang is a front-end to LLVM that
+supports C and the GNU C extensions required by the kernel, and is pronounced
+"klang," not "see-lang."
+
+Clang
+-----
+
+The compiler used can be swapped out via `CC=` command line argument to `make`.
+`CC=` should be set when selecting a config and during a build.
+
+	make CC=clang defconfig
+
+	make CC=clang
+
+Cross Compiling
+---------------
+
+A single Clang compiler binary will typically contain all supported backends,
+which can help simplify cross compiling.
+
+	ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make CC=clang
+
+`CROSS_COMPILE` is not used to prefix the Clang compiler binary, instead
+`CROSS_COMPILE` is used to set a command line flag: `--target <triple>`. For
+example:
+
+	clang --target aarch64-linux-gnu foo.c
+
+LLVM Utilities
+--------------
+
+LLVM has substitutes for GNU binutils utilities. These can be invoked as
+additional parameters to `make`.
+
+	make CC=clang AS=clang LD=ld.lld AR=llvm-ar NM=llvm-nm STRIP=llvm-strip \\
+	  OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump OBJSIZE=llvm-objsize \\
+	  READELF=llvm-readelf HOSTCC=clang HOSTCXX=clang++ HOSTAR=llvm-ar \\
+	  HOSTLD=ld.lld
+
+Getting Help
+------------
+
+- `Website <https://clangbuiltlinux.github.io/>`_
+- `Mailing List <https://groups.google.com/forum/#!forum/clang-built-linux>`_: <clang-built-linux@googlegroups.com>
+- `Issue Tracker <https://github.com/ClangBuiltLinux/linux/issues>`_
+- IRC: #clangbuiltlinux on chat.freenode.net
+- `Telegram <https://t.me/ClangBuiltLinux>`_: @ClangBuiltLinux
+- `Wiki <https://github.com/ClangBuiltLinux/linux/wiki>`_
+- `Beginner Bugs <https://github.com/ClangBuiltLinux/linux/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22>`_
+
+Getting LLVM
+-------------
+
+- http://releases.llvm.org/download.html
+- https://github.com/llvm/llvm-project
+- https://llvm.org/docs/GettingStarted.html
+- https://llvm.org/docs/CMake.html
+- https://apt.llvm.org/
+- https://www.archlinux.org/packages/extra/x86_64/llvm/
+- https://github.com/ClangBuiltLinux/tc-build
+- https://github.com/ClangBuiltLinux/linux/wiki/Building-Clang-from-source
+- https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3620,6 +3620,7 @@ B:	https://github.com/ClangBuiltLinux/li
 C:	irc://chat.freenode.net/clangbuiltlinux
 S:	Supported
 K:	\b(?i:clang|llvm)\b
+F:	Documentation/kbuild/llvm.rst
 
 CLEANCACHE API
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>


