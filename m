Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2853F6CCE7E
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 02:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjC2AIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 20:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjC2AIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 20:08:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E0E10F5
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 17:08:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3853618E5
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 00:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC729C433A0;
        Wed, 29 Mar 2023 00:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680048513;
        bh=urMRusiZ/H4YoKnSiVEuQOWabL7fOofFOVRAVUj9Qc0=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=OvPgynTlMhUUslguMmcyFV/rNCnfLmv2tkcSaX9dO946cV4bMCh4q614x5i++9MnH
         knB2YdfahTSdosFO3eswKXH5HrVJGkgZCDwq58EMifEls/mMQmaXprvT/cOjxh46SF
         4X/Gd4ZB52zNUhfIZnmjKeQ+u+prS+il2bApk2cpDvf3DLejiOWy657DyKMl+5mKQ5
         0y51RHZ6KzCoxCMfVZLxFClczLHWe+aT2Vh1kmjpmk1NAP4NV8DbRB2qKrfoAKyhXM
         HIdNG5oqgcxbjiaMsRBq9y+rmkW+M4GlueoKhhDf4R6Hmsu8UIbGgJDUkgWDYRWl53
         3t79oEPXNPEeA==
From:   Nathan Chancellor <nathan@kernel.org>
Date:   Tue, 28 Mar 2023 17:08:29 -0700
Subject: [PATCH 5.10 1/4] kbuild: check the minimum assembler version in
 Kconfig
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230328-riscv-zifencei-zicsr-5-10-v1-1-bccb3e16dc46@kernel.org>
References: <20230328-riscv-zifencei-zicsr-5-10-v1-0-bccb3e16dc46@kernel.org>
In-Reply-To: <20230328-riscv-zifencei-zicsr-5-10-v1-0-bccb3e16dc46@kernel.org>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     conor@kernel.org, stable@vger.kernel.org, llvm@lists.linux.dev,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7604; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Z3HJnwAkwMiLbQywhOjPGUGxt1eBMWgZmX+A2tREGsg=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCnKjXX9MabS/y1Olt7TEm/ZtoW3RSd72/OYlWtzcvekb
 OZPaF7SUcrCIMbBICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACbydzLDf9fSJaeiJerCXlcd
 CXftXcs97+DnPR/tlot051dUXajmbGL4p8qgosipe9J7FXddam74nYt5Wu4uxqcrbSpWTbJnl//
 GCwA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit ba64beb17493a4bfec563100c86a462a15926f24 upstream.

Documentation/process/changes.rst defines the minimum assembler version
(binutils version), but we have never checked it in the build time.

Kbuild never invokes 'as' directly because all assembly files in the
kernel tree are *.S, hence must be preprocessed. I do not expect
raw assembly source files (*.s) would be added to the kernel tree.

Therefore, we always use $(CC) as the assembler driver, and commit
aa824e0c962b ("kbuild: remove AS variable") removed 'AS'. However,
we are still interested in the version of the assembler acting behind.

As usual, the --version option prints the version string.

  $ as --version | head -n 1
  GNU assembler (GNU Binutils for Ubuntu) 2.35.1

But, we do not have $(AS). So, we can add the -Wa prefix so that
$(CC) passes --version down to the backing assembler.

  $ gcc -Wa,--version | head -n 1
  gcc: fatal error: no input files
  compilation terminated.

OK, we need to input something to satisfy gcc.

  $ gcc -Wa,--version -c -x assembler /dev/null -o /dev/null | head -n 1
  GNU assembler (GNU Binutils for Ubuntu) 2.35.1

The combination of Clang and GNU assembler works in the same way:

  $ clang -no-integrated-as -Wa,--version -c -x assembler /dev/null -o /dev/null | head -n 1
  GNU assembler (GNU Binutils for Ubuntu) 2.35.1

Clang with the integrated assembler fails like this:

  $ clang -integrated-as -Wa,--version -c -x assembler /dev/null -o /dev/null | head -n 1
  clang: error: unsupported argument '--version' to option 'Wa,'

For the last case, checking the error message is fragile. If the
proposal for -Wa,--version support [1] is accepted, this may not be
even an error in the future.

One easy way is to check if -integrated-as is present in the passed
arguments. We did not pass -integrated-as to CLANG_FLAGS before, but
we can make it explicit.

Nathan pointed out -integrated-as is the default for all of the
architectures/targets that the kernel cares about, but it goes
along with "explicit is better than implicit" policy. [2]

With all this in my mind, I implemented scripts/as-version.sh to
check the assembler version in Kconfig time.

  $ scripts/as-version.sh gcc
  GNU 23501
  $ scripts/as-version.sh clang -no-integrated-as
  GNU 23501
  $ scripts/as-version.sh clang -integrated-as
  LLVM 0

[1]: https://github.com/ClangBuiltLinux/linux/issues/1320
[2]: https://lore.kernel.org/linux-kbuild/20210307044253.v3h47ucq6ng25iay@archlinux-ax161/

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
[nathan: Backport to 5.10. Drop minimum version checking, as it is not
         required in 5.10]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 Makefile                |  4 ++-
 init/Kconfig            | 12 +++++++++
 scripts/Kconfig.include |  6 +++++
 scripts/as-version.sh   | 69 +++++++++++++++++++++++++++++++++++++++++++++++++
 scripts/dummy-tools/gcc |  6 +++++
 5 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 71caf5938361..44d9aff4f66a 100644
--- a/Makefile
+++ b/Makefile
@@ -580,7 +580,9 @@ endif
 ifneq ($(GCC_TOOLCHAIN),)
 CLANG_FLAGS	+= --gcc-toolchain=$(GCC_TOOLCHAIN)
 endif
-ifneq ($(LLVM_IAS),1)
+ifeq ($(LLVM_IAS),1)
+CLANG_FLAGS	+= -integrated-as
+else
 CLANG_FLAGS	+= -no-integrated-as
 endif
 CLANG_FLAGS	+= -Werror=unknown-warning-option
diff --git a/init/Kconfig b/init/Kconfig
index eba883d6d9ed..9807c66b24bb 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -47,6 +47,18 @@ config CLANG_VERSION
 	int
 	default $(shell,$(srctree)/scripts/clang-version.sh $(CC))
 
+config AS_IS_GNU
+	def_bool $(success,test "$(as-name)" = GNU)
+
+config AS_IS_LLVM
+	def_bool $(success,test "$(as-name)" = LLVM)
+
+config AS_VERSION
+	int
+	# Use clang version if this is the integrated assembler
+	default CLANG_VERSION if AS_IS_LLVM
+	default $(as-version)
+
 config LLD_VERSION
 	int
 	default $(shell,$(srctree)/scripts/lld-version.sh $(LD))
diff --git a/scripts/Kconfig.include b/scripts/Kconfig.include
index a5fe72c504ff..6d37cb780452 100644
--- a/scripts/Kconfig.include
+++ b/scripts/Kconfig.include
@@ -42,6 +42,12 @@ $(error-if,$(failure,command -v $(LD)),linker '$(LD)' not found)
 # Fail if the linker is gold as it's not capable of linking the kernel proper
 $(error-if,$(success, $(LD) -v | grep -q gold), gold linker '$(LD)' not supported)
 
+# Get the assembler name, version, and error out if it is not supported.
+as-info := $(shell,$(srctree)/scripts/as-version.sh $(CC) $(CLANG_FLAGS))
+$(error-if,$(success,test -z "$(as-info)"),Sorry$(comma) this assembler is not supported.)
+as-name := $(shell,set -- $(as-info) && echo $1)
+as-version := $(shell,set -- $(as-info) && echo $2)
+
 # machine bit flags
 #  $(m32-flag): -m32 if the compiler supports it, or an empty string otherwise.
 #  $(m64-flag): -m64 if the compiler supports it, or an empty string otherwise.
diff --git a/scripts/as-version.sh b/scripts/as-version.sh
new file mode 100755
index 000000000000..851dcb8a0e68
--- /dev/null
+++ b/scripts/as-version.sh
@@ -0,0 +1,69 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Print the assembler name and its version in a 5 or 6-digit form.
+# Also, perform the minimum version check.
+# (If it is the integrated assembler, return 0 as the version, and
+# skip the version check.)
+
+set -e
+
+# Convert the version string x.y.z to a canonical 5 or 6-digit form.
+get_canonical_version()
+{
+	IFS=.
+	set -- $1
+
+	# If the 2nd or 3rd field is missing, fill it with a zero.
+	#
+	# The 4th field, if present, is ignored.
+	# This occurs in development snapshots as in 2.35.1.20201116
+	echo $((10000 * $1 + 100 * ${2:-0} + ${3:-0}))
+}
+
+# Clang fails to handle -Wa,--version unless -no-integrated-as is given.
+# We check -(f)integrated-as, expecting it is explicitly passed in for the
+# integrated assembler case.
+check_integrated_as()
+{
+	while [ $# -gt 0 ]; do
+		if [ "$1" = -integrated-as -o "$1" = -fintegrated-as ]; then
+			# For the intergrated assembler, we do not check the
+			# version here. It is the same as the clang version, and
+			# it has been already checked by scripts/cc-version.sh.
+			echo LLVM 0
+			exit 0
+		fi
+		shift
+	done
+}
+
+check_integrated_as "$@"
+
+orig_args="$@"
+
+# Get the first line of the --version output.
+IFS='
+'
+set -- $(LC_ALL=C "$@" -Wa,--version -c -x assembler /dev/null -o /dev/null 2>/dev/null)
+
+# Split the line on spaces.
+IFS=' '
+set -- $1
+
+if [ "$1" = GNU -a "$2" = assembler ]; then
+	shift $(($# - 1))
+	version=$1
+	name=GNU
+else
+	echo "$orig_args: unknown assembler invoked" >&2
+	exit 1
+fi
+
+# Some distributions append a package release number, as in 2.34-4.fc32
+# Trim the hyphen and any characters that follow.
+version=${version%-*}
+
+cversion=$(get_canonical_version $version)
+
+echo $name $cversion
diff --git a/scripts/dummy-tools/gcc b/scripts/dummy-tools/gcc
index 346757a87dbc..485427f40dba 100755
--- a/scripts/dummy-tools/gcc
+++ b/scripts/dummy-tools/gcc
@@ -67,6 +67,12 @@ if arg_contain -E "$@"; then
 	fi
 fi
 
+# To set CONFIG_AS_IS_GNU
+if arg_contain -Wa,--version "$@"; then
+	echo "GNU assembler (scripts/dummy-tools) 2.50"
+	exit 0
+fi
+
 if arg_contain -S "$@"; then
 	# For scripts/gcc-x86-*-has-stack-protector.sh
 	if arg_contain -fstack-protector "$@"; then

-- 
2.40.0

