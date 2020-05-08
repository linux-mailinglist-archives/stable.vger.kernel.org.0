Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41181CAC91
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730229AbgEHMyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730223AbgEHMyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:54:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BE132495C;
        Fri,  8 May 2020 12:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942475;
        bh=w+CRxr9kY4K+9b8jpYJdkDCWoR7oDk9596EFqhXzsvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdyYxYH1xmw6kYanqV22Ih59AYBDJbkdnLgsALj3UT8mIB7hBNGlg25PgpuoOIRMA
         TTCPSHtGu//z4dTJWiyIz9VloGSvaQ6VuU6wJ3MUAZN/m7xGP8V0zVVNkqetOMsuLt
         u581T73NIKIJFCY6paQvMCi2e0Fx3d0/yEEvOZLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandipan Das <sandipan@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 10/49] selftests: vm: Do not override definition of ARCH
Date:   Fri,  8 May 2020 14:35:27 +0200
Message-Id: <20200508123044.428448691@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
References: <20200508123042.775047422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandipan Das <sandipan@linux.ibm.com>

[ Upstream commit 24c3f063c57b2a8ae21b259bcfa7690e2eb56dd9 ]

Independent builds of the vm selftests is currently broken because
commit 7549b3364201 ("selftests: vm: Build/Run 64bit tests only on
64bit arch") overrides the value of ARCH with the machine name from
uname. This does not always match the architecture names used for
tasks like header installation.

E.g. for building tests on powerpc64, we need ARCH=powerpc
and not ARCH=ppc64 or ARCH=ppc64le. Otherwise, the build
fails as shown below.

  $ uname -m
  ppc64le

  $ make -C tools/testing/selftests/vm
  make: Entering directory '/home/sandipan/linux/tools/testing/selftests/vm'
  make --no-builtin-rules ARCH=ppc64le -C ../../../.. headers_install
  make[1]: Entering directory '/home/sandipan/linux'
  Makefile:653: arch/ppc64le/Makefile: No such file or directory
  make[1]: *** No rule to make target 'arch/ppc64le/Makefile'.  Stop.
  make[1]: Leaving directory '/home/sandipan/linux'
  ../lib.mk:50: recipe for target 'khdr' failed
  make: *** [khdr] Error 2
  make: Leaving directory '/home/sandipan/linux/tools/testing/selftests/vm'

Fixes: 7549b3364201 ("selftests: vm: Build/Run 64bit tests only on 64bit arch")
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 7f9a8a8c31da9..3f2e2f0ccbc9a 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for vm selftests
 uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/')
+MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/')
 
 CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
 LDLIBS = -lrt
@@ -19,7 +19,7 @@ TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
 
-ifneq (,$(filter $(ARCH),arm64 ia64 mips64 parisc64 ppc64 riscv64 s390x sh64 sparc64 x86_64))
+ifneq (,$(filter $(MACHINE),arm64 ia64 mips64 parisc64 ppc64 riscv64 s390x sh64 sparc64 x86_64))
 TEST_GEN_FILES += va_128TBswitch
 TEST_GEN_FILES += virtual_address_range
 endif
-- 
2.20.1



