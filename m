Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034E5441688
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbhKAJ01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232647AbhKAJYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:24:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4340610E5;
        Mon,  1 Nov 2021 09:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758478;
        bh=St0LobpWJov0hVt+W4TVWNARJ5CMi+3hwNzHhwPGzY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNdkHCpyOR2yd6tqrQzlu/xhziV1p80pvQSPZrmxs3B4meQOp5XQwStmnXHbjEojR
         kx5RhkwmIu/HEJiLnC06TMLfE0VvM7gK7/ZyMQp78k+XPGCspUim3JUFNPx6ekOGu9
         IALrJ9/dujCvs0qjztFWu927f4ktDu/1Nd2EK3i4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Nicolas Pitre <nico@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Stefan Agner <stefan@agner.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.19 07/35] ARM: 8819/1: Remove -p from LDFLAGS
Date:   Mon,  1 Nov 2021 10:17:19 +0100
Message-Id: <20211101082453.278295835@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082451.430720900@linuxfoundation.org>
References: <20211101082451.430720900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 091bb549f7722723b284f63ac665e2aedcf9dec9 upstream.

This option is not supported by lld:

    ld.lld: error: unknown argument: -p

This has been a no-op in binutils since 2004 (see commit dea514f51da1 in
that tree). Given that the lowest officially supported of binutils for
the kernel is 2.20, which was released in 2009, nobody needs this flag
around so just remove it. Commit 1a381d4a0a9a ("arm64: remove no-op -p
linker flag") did the same for arm64.

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Makefile                 |    2 +-
 arch/arm/boot/bootp/Makefile      |    2 +-
 arch/arm/boot/compressed/Makefile |    2 --
 3 files changed, 2 insertions(+), 4 deletions(-)

--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -10,7 +10,7 @@
 #
 # Copyright (C) 1995-2001 by Russell King
 
-LDFLAGS_vmlinux	:=-p --no-undefined -X --pic-veneer
+LDFLAGS_vmlinux	:= --no-undefined -X --pic-veneer
 ifeq ($(CONFIG_CPU_ENDIAN_BE8),y)
 LDFLAGS_vmlinux	+= --be8
 KBUILD_LDFLAGS_MODULE	+= --be8
--- a/arch/arm/boot/bootp/Makefile
+++ b/arch/arm/boot/bootp/Makefile
@@ -8,7 +8,7 @@
 
 GCOV_PROFILE	:= n
 
-LDFLAGS_bootp	:=-p --no-undefined -X \
+LDFLAGS_bootp	:= --no-undefined -X \
 		 --defsym initrd_phys=$(INITRD_PHYS) \
 		 --defsym params_phys=$(PARAMS_PHYS) -T
 AFLAGS_initrd.o :=-DINITRD=\"$(INITRD)\"
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -133,8 +133,6 @@ endif
 ifeq ($(CONFIG_CPU_ENDIAN_BE8),y)
 LDFLAGS_vmlinux += --be8
 endif
-# ?
-LDFLAGS_vmlinux += -p
 # Report unresolved symbol references
 LDFLAGS_vmlinux += --no-undefined
 # Delete all temporary local symbols


