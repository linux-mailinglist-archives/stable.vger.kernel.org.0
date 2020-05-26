Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1BF1E2C1E
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404146AbgEZTMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404136AbgEZTMR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:12:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E58E320888;
        Tue, 26 May 2020 19:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520336;
        bh=++VqZKrYqAQ5Dck8ZaiFp4nu/4KSfacu9BrCWRmdi6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVTXCvV9esPjk9cvfKAJdhMHpTHfgOoK47pSE3DQFz8s61BUQV7NAxieC1xi6PvB+
         GV2L8iV8wl38o5aZ/Vr3CobMT/gtisce0fpG/o6bJdxf5bgUn6fu9t5fuT7J5AqrLQ
         fx+q9XjOJk0BVJLMWePlXGww9C388t8lc8TIAU4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 040/126] selftests: fix kvm relocatable native/cross builds and installs
Date:   Tue, 26 May 2020 20:52:57 +0200
Message-Id: <20200526183941.314354114@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit 66d69e081b526b6a6031f0d3ca8ddff71e5707a5 ]

kvm test Makefile doesn't fully support cross-builds and installs.
UNAME_M = $(shell uname -m) variable is used to define the target
programs and libraries to be built from arch specific sources in
sub-directories.

For cross-builds to work, UNAME_M has to map to ARCH and arch specific
directories and targets in this Makefile.

UNAME_M variable to used to run the compiles pointing to the right arch
directories and build the right targets for these supported architectures.

TEST_GEN_PROGS and LIBKVM are set using UNAME_M variable.
LINUX_TOOL_ARCH_INCLUDE is set using ARCH variable.

x86_64 targets are named to include x86_64 as a suffix and directories
for includes are in x86_64 sub-directory. s390x and aarch64 follow the
same convention. "uname -m" doesn't result in the correct mapping for
s390x and aarch64. Fix it to set UNAME_M correctly for s390x and aarch64
cross-builds.

In addition, Makefile doesn't create arch sub-directories in the case of
relocatable builds and test programs under s390x and x86_64 directories
fail to build. This is a problem for native and cross-builds. Fix it to
create all necessary directories keying off of TEST_GEN_PROGS.

The following use-cases work with this change:

Native x86_64:
make O=/tmp/kselftest -C tools/testing/selftests TARGETS=kvm install \
 INSTALL_PATH=$HOME/x86_64

arm64 cross-build:
make O=$HOME/arm64_build/ ARCH=arm64 HOSTCC=gcc \
	CROSS_COMPILE=aarch64-linux-gnu- defconfig

make O=$HOME/arm64_build/ ARCH=arm64 HOSTCC=gcc \
	CROSS_COMPILE=aarch64-linux-gnu- all

make kselftest-install TARGETS=kvm O=$HOME/arm64_build ARCH=arm64 \
	HOSTCC=gcc CROSS_COMPILE=aarch64-linux-gnu-

s390x cross-build:
make O=$HOME/s390x_build/ ARCH=s390 HOSTCC=gcc \
	CROSS_COMPILE=s390x-linux-gnu- defconfig

make O=$HOME/s390x_build/ ARCH=s390 HOSTCC=gcc \
	CROSS_COMPILE=s390x-linux-gnu- all

make kselftest-install TARGETS=kvm O=$HOME/s390x_build/ ARCH=s390 \
	HOSTCC=gcc CROSS_COMPILE=s390x-linux-gnu- all

No regressions in the following use-cases:
make -C tools/testing/selftests TARGETS=kvm
make kselftest-all TARGETS=kvm

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/Makefile | 29 +++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index d91c53b726e6..75dec268787f 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -5,8 +5,34 @@ all:
 
 top_srcdir = ../../../..
 KSFT_KHDR_INSTALL := 1
+
+# For cross-builds to work, UNAME_M has to map to ARCH and arch specific
+# directories and targets in this Makefile. "uname -m" doesn't map to
+# arch specific sub-directory names.
+#
+# UNAME_M variable to used to run the compiles pointing to the right arch
+# directories and build the right targets for these supported architectures.
+#
+# TEST_GEN_PROGS and LIBKVM are set using UNAME_M variable.
+# LINUX_TOOL_ARCH_INCLUDE is set using ARCH variable.
+#
+# x86_64 targets are named to include x86_64 as a suffix and directories
+# for includes are in x86_64 sub-directory. s390x and aarch64 follow the
+# same convention. "uname -m" doesn't result in the correct mapping for
+# s390x and aarch64.
+#
+# No change necessary for x86_64
 UNAME_M := $(shell uname -m)
 
+# Set UNAME_M for arm64 compile/install to work
+ifeq ($(ARCH),arm64)
+	UNAME_M := aarch64
+endif
+# Set UNAME_M s390x compile/install to work
+ifeq ($(ARCH),s390)
+	UNAME_M := s390x
+endif
+
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c
 LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c
 LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
@@ -47,7 +73,7 @@ LIBKVM += $(LIBKVM_$(UNAME_M))
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
-LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
+LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
@@ -78,6 +104,7 @@ $(LIBKVM_OBJ): $(OUTPUT)/%.o: %.c
 $(OUTPUT)/libkvm.a: $(LIBKVM_OBJ)
 	$(AR) crs $@ $^
 
+x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
 all: $(STATIC_LIBS)
 $(TEST_GEN_PROGS): $(STATIC_LIBS)
 
-- 
2.25.1



