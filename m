Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4335045BE1F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244833AbhKXMos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:44:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344851AbhKXMnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:43:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9946361409;
        Wed, 24 Nov 2021 12:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756743;
        bh=E75xeQtI4oHGuXT23o4iJrM5A/1CZ+eA7kXnn4MJp4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcc1qkORtCdt+gsgnMmLSWaRqLt0boXlTyZB6PjJMqb35n7FORZfUlUs/qOe1g9Pb
         FfkqYKGqd1V6eH8skFVh0FELud3KYMytDAWZxew/yEPe7MqW6Bz4XebUq9uqt6JcUz
         3uUP6SUv0Vc3HPU9/oaU3PcCSTSK3I/zaQ5CYRMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antonio Terceiro <antonio.terceiro@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Klaus Kudielka <klaus.kudielka@gmail.com>,
        Matthias Klose <doko@debian.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.14 190/251] ARM: 9156/1: drop cc-option fallbacks for architecture selection
Date:   Wed, 24 Nov 2021 12:57:12 +0100
Message-Id: <20211124115716.881602398@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 418ace9992a7647c446ed3186df40cf165b67298 upstream.

Naresh and Antonio ran into a build failure with latest Debian
armhf compilers, with lots of output like

 tmp/ccY3nOAs.s:2215: Error: selected processor does not support `cpsid i' in ARM mode

As it turns out, $(cc-option) fails early here when the FPU is not
selected before CPU architecture is selected, as the compiler
option check runs before enabling -msoft-float, which causes
a problem when testing a target architecture level without an FPU:

cc1: error: '-mfloat-abi=hard': selected architecture lacks an FPU

Passing e.g. -march=armv6k+fp in place of -march=armv6k would avoid this
issue, but the fallback logic is already broken because all supported
compilers (gcc-5 and higher) are much more recent than these options,
and building with -march=armv5t as a fallback no longer works.

The best way forward that I see is to just remove all the checks, which
also has the nice side-effect of slightly improving the startup time for
'make'.

The -mtune=marvell-f option was apparently never supported by any mainline
compiler, and the custom Codesourcery gcc build that did support is
now too old to build kernels, so just use -mtune=xscale unconditionally
for those.

This should be safe to apply on all stable kernels, and will be required
in order to keep building them with gcc-11 and higher.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=996419

Reported-by: Antonio Terceiro <antonio.terceiro@linaro.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Tested-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Tested-by: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: Matthias Klose <doko@debian.org>
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Makefile |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -66,15 +66,15 @@ KBUILD_CFLAGS	+= $(call cc-option,-fno-i
 # Note that GCC does not numerically define an architecture version
 # macro, but instead defines a whole series of macros which makes
 # testing for a specific architecture or later rather impossible.
-arch-$(CONFIG_CPU_32v7M)	=-D__LINUX_ARM_ARCH__=7 -march=armv7-m -Wa,-march=armv7-m
-arch-$(CONFIG_CPU_32v7)		=-D__LINUX_ARM_ARCH__=7 $(call cc-option,-march=armv7-a,-march=armv5t -Wa$(comma)-march=armv7-a)
-arch-$(CONFIG_CPU_32v6)		=-D__LINUX_ARM_ARCH__=6 $(call cc-option,-march=armv6,-march=armv5t -Wa$(comma)-march=armv6)
+arch-$(CONFIG_CPU_32v7M)	=-D__LINUX_ARM_ARCH__=7 -march=armv7-m
+arch-$(CONFIG_CPU_32v7)		=-D__LINUX_ARM_ARCH__=7 -march=armv7-a
+arch-$(CONFIG_CPU_32v6)		=-D__LINUX_ARM_ARCH__=6 -march=armv6
 # Only override the compiler option if ARMv6. The ARMv6K extensions are
 # always available in ARMv7
 ifeq ($(CONFIG_CPU_32v6),y)
-arch-$(CONFIG_CPU_32v6K)	=-D__LINUX_ARM_ARCH__=6 $(call cc-option,-march=armv6k,-march=armv5t -Wa$(comma)-march=armv6k)
+arch-$(CONFIG_CPU_32v6K)	=-D__LINUX_ARM_ARCH__=6 -march=armv6k
 endif
-arch-$(CONFIG_CPU_32v5)		=-D__LINUX_ARM_ARCH__=5 $(call cc-option,-march=armv5te,-march=armv4t)
+arch-$(CONFIG_CPU_32v5)		=-D__LINUX_ARM_ARCH__=5 -march=armv5te
 arch-$(CONFIG_CPU_32v4T)	=-D__LINUX_ARM_ARCH__=4 -march=armv4t
 arch-$(CONFIG_CPU_32v4)		=-D__LINUX_ARM_ARCH__=4 -march=armv4
 arch-$(CONFIG_CPU_32v3)		=-D__LINUX_ARM_ARCH__=3 -march=armv3
@@ -88,7 +88,7 @@ tune-$(CONFIG_CPU_ARM720T)	=-mtune=arm7t
 tune-$(CONFIG_CPU_ARM740T)	=-mtune=arm7tdmi
 tune-$(CONFIG_CPU_ARM9TDMI)	=-mtune=arm9tdmi
 tune-$(CONFIG_CPU_ARM940T)	=-mtune=arm9tdmi
-tune-$(CONFIG_CPU_ARM946E)	=$(call cc-option,-mtune=arm9e,-mtune=arm9tdmi)
+tune-$(CONFIG_CPU_ARM946E)	=-mtune=arm9e
 tune-$(CONFIG_CPU_ARM920T)	=-mtune=arm9tdmi
 tune-$(CONFIG_CPU_ARM922T)	=-mtune=arm9tdmi
 tune-$(CONFIG_CPU_ARM925T)	=-mtune=arm9tdmi
@@ -96,11 +96,11 @@ tune-$(CONFIG_CPU_ARM926T)	=-mtune=arm9t
 tune-$(CONFIG_CPU_FA526)	=-mtune=arm9tdmi
 tune-$(CONFIG_CPU_SA110)	=-mtune=strongarm110
 tune-$(CONFIG_CPU_SA1100)	=-mtune=strongarm1100
-tune-$(CONFIG_CPU_XSCALE)	=$(call cc-option,-mtune=xscale,-mtune=strongarm110) -Wa,-mcpu=xscale
-tune-$(CONFIG_CPU_XSC3)		=$(call cc-option,-mtune=xscale,-mtune=strongarm110) -Wa,-mcpu=xscale
-tune-$(CONFIG_CPU_FEROCEON)	=$(call cc-option,-mtune=marvell-f,-mtune=xscale)
-tune-$(CONFIG_CPU_V6)		=$(call cc-option,-mtune=arm1136j-s,-mtune=strongarm)
-tune-$(CONFIG_CPU_V6K)		=$(call cc-option,-mtune=arm1136j-s,-mtune=strongarm)
+tune-$(CONFIG_CPU_XSCALE)	=-mtune=xscale
+tune-$(CONFIG_CPU_XSC3)		=-mtune=xscale
+tune-$(CONFIG_CPU_FEROCEON)	=-mtune=xscale
+tune-$(CONFIG_CPU_V6)		=-mtune=arm1136j-s
+tune-$(CONFIG_CPU_V6K)		=-mtune=arm1136j-s
 
 # Evaluate tune cc-option calls now
 tune-y := $(tune-y)


