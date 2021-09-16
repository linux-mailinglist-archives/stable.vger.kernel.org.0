Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAABF40E855
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354267AbhIPRoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354979AbhIPRky (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03A7263255;
        Thu, 16 Sep 2021 16:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811124;
        bh=2FUurahQuMNoqoxElWAAqPLgyzavMl4Nm2d4EpBcabs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STTITEWYrYY8K69FIyWT2zw8Q/vuGajEuZSy9GaUWBS+b4F1AdMf6XtrSbuRM1o64
         mlLDF0GXuGNhPmZOdU7Jyj2o1k/tM1RCtQh0+/chcZBDh/Xyv6RgzHUyuXmx7UqNhv
         iduku/MM+oXaXXVdc7pyYY1jprFXRtapf5vqDAKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Meelis Roos <mroos@linux.ee>, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.14 392/432] parisc: Fix compile failure when building 64-bit kernel natively
Date:   Thu, 16 Sep 2021 18:02:21 +0200
Message-Id: <20210916155824.096923936@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 5f6e0fe01b6b33894cf6f61b359ab5a6d2b7674e upstream.

Commit 23243c1ace9f ("arch: use cross_compiling to check whether it is
a cross build or not") broke 64-bit parisc builds on 32-bit parisc
systems.

Helge mentioned:
  - 64-bit parisc userspace is not supported yet [1]
  - hppa gcc does not support "-m64" flag [2]

That means, parisc developers working on a 32-bit parisc machine need
to use hppa64-linux-gnu-gcc (cross compiler) for building the 64-bit
parisc kernel.

After the offending commit, gcc is used in such a case because
both $(SRCARCH) and $(SUBARCH) are 'parisc', hence cross_compiling is
unset.

A correct way is to introduce ARCH=parisc64 because building the 64-bit
parisc kernel on a 32-bit parisc system is not exactly a native build,
but rather a semi-cross build.

[1]: https://lore.kernel.org/linux-parisc/5dfd81eb-c8ca-b7f5-e80e-8632767c022d@gmx.de/#t
[2]: https://lore.kernel.org/linux-parisc/89515325-fc21-31da-d238-6f7a9abbf9a0@gmx.de/

Fixes: 23243c1ace9f ("arch: use cross_compiling to check whether it is a cross build or not")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reported-by: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
Cc: <stable@vger.kernel.org> # v5.13+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile                |    5 +++++
 arch/parisc/Makefile    |    6 +++---
 scripts/subarch.include |    2 +-
 3 files changed, 9 insertions(+), 4 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -404,6 +404,11 @@ ifeq ($(ARCH),sparc64)
        SRCARCH := sparc
 endif
 
+# Additional ARCH settings for parisc
+ifeq ($(ARCH),parisc64)
+       SRCARCH := parisc
+endif
+
 export cross_compiling :=
 ifneq ($(SRCARCH),$(SUBARCH))
 cross_compiling := 1
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -25,18 +25,18 @@ CHECKFLAGS	+= -D__hppa__=1
 ifdef CONFIG_64BIT
 UTS_MACHINE	:= parisc64
 CHECKFLAGS	+= -D__LP64__=1
-CC_ARCHES	= hppa64
 LD_BFD		:= elf64-hppa-linux
 else # 32-bit
-CC_ARCHES	= hppa hppa2.0 hppa1.1
 LD_BFD		:= elf32-hppa-linux
 endif
 
 # select defconfig based on actual architecture
-ifeq ($(shell uname -m),parisc64)
+ifeq ($(ARCH),parisc64)
 	KBUILD_DEFCONFIG := generic-64bit_defconfig
+	CC_ARCHES := hppa64
 else
 	KBUILD_DEFCONFIG := generic-32bit_defconfig
+	CC_ARCHES := hppa hppa2.0 hppa1.1
 endif
 
 export LD_BFD
--- a/scripts/subarch.include
+++ b/scripts/subarch.include
@@ -7,7 +7,7 @@
 SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
 				  -e s/sun4u/sparc64/ \
 				  -e s/arm.*/arm/ -e s/sa110/arm/ \
-				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
+				  -e s/s390x/s390/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
 				  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ \
 				  -e s/riscv.*/riscv/)


