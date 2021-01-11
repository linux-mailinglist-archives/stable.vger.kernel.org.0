Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15162F1433
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbhAKNVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:21:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:37532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733244AbhAKNTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:19:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60C2022A83;
        Mon, 11 Jan 2021 13:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371112;
        bh=xZJ4AxdMJDxWjNqQHP2cu0DDr9uFvEAqpMKQt77EwSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFFyjMZs8fkwBw3Ey/Sc7gnhbWcDQibnmORjqfgrxaG+/gfH1OHYtJQQnwVhdDATx
         ewC0yyRXbhCYWel6EepIbUihc/iAufO8C5q2a57xWRAICRhp/kkdFVA3DDPvnmoQzO
         /DVQ1AeYD6tohXBB5Ek/0Fi4kiwcuXehfsoGkw4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "kernelci.org bot" <bot@kernelci.org>,
        Quentin Perret <qperret@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Alan Modra <amodra@gmail.com>,
        =?UTF-8?q?F=C4=81ng-ru=C3=AC=20S=C3=B2ng?= <maskray@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.10 129/145] arm64: link with -z norelro for LLD or aarch64-elf
Date:   Mon, 11 Jan 2021 14:02:33 +0100
Message-Id: <20210111130054.714929856@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 311bea3cb9ee20ef150ca76fc60a592bf6b159f5 upstream.

With GNU binutils 2.35+, linking with BFD produces warnings for vmlinux:
aarch64-linux-gnu-ld: warning: -z norelro ignored

BFD can produce this warning when the target emulation mode does not
support RELRO program headers, and -z relro or -z norelro is passed.

Alan Modra clarifies:
  The default linker emulation for an aarch64-linux ld.bfd is
  -maarch64linux, the default for an aarch64-elf linker is
  -maarch64elf.  They are not equivalent.  If you choose -maarch64elf
  you get an emulation that doesn't support -z relro.

The ARCH=arm64 kernel prefers -maarch64elf, but may fall back to
-maarch64linux based on the toolchain configuration.

LLD will always create RELRO program header regardless of target
emulation.

To avoid the above warning when linking with BFD, pass -z norelro only
when linking with LLD or with -maarch64linux.

Fixes: 3b92fa7485eb ("arm64: link with -z norelro regardless of CONFIG_RELOCATABLE")
Fixes: 3bbd3db86470 ("arm64: relocatable: fix inconsistencies in linker script and options")
Cc: <stable@vger.kernel.org> # 5.0.x-
Reported-by: kernelci.org bot <bot@kernelci.org>
Reported-by: Quentin Perret <qperret@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Alan Modra <amodra@gmail.com>
Cc: Fāng-ruì Sòng <maskray@google.com>
Link: https://lore.kernel.org/r/20201218002432.788499-1-ndesaulniers@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/Makefile |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -10,7 +10,7 @@
 #
 # Copyright (C) 1995-2001 by Russell King
 
-LDFLAGS_vmlinux	:=--no-undefined -X -z norelro
+LDFLAGS_vmlinux	:=--no-undefined -X
 
 ifeq ($(CONFIG_RELOCATABLE), y)
 # Pass --no-apply-dynamic-relocs to restore pre-binutils-2.27 behaviour
@@ -110,16 +110,20 @@ KBUILD_CPPFLAGS	+= -mbig-endian
 CHECKFLAGS	+= -D__AARCH64EB__
 # Prefer the baremetal ELF build target, but not all toolchains include
 # it so fall back to the standard linux version if needed.
-KBUILD_LDFLAGS	+= -EB $(call ld-option, -maarch64elfb, -maarch64linuxb)
+KBUILD_LDFLAGS	+= -EB $(call ld-option, -maarch64elfb, -maarch64linuxb -z norelro)
 UTS_MACHINE	:= aarch64_be
 else
 KBUILD_CPPFLAGS	+= -mlittle-endian
 CHECKFLAGS	+= -D__AARCH64EL__
 # Same as above, prefer ELF but fall back to linux target if needed.
-KBUILD_LDFLAGS	+= -EL $(call ld-option, -maarch64elf, -maarch64linux)
+KBUILD_LDFLAGS	+= -EL $(call ld-option, -maarch64elf, -maarch64linux -z norelro)
 UTS_MACHINE	:= aarch64
 endif
 
+ifeq ($(CONFIG_LD_IS_LLD), y)
+KBUILD_LDFLAGS	+= -z norelro
+endif
+
 CHECKFLAGS	+= -D__aarch64__
 
 ifeq ($(CONFIG_DYNAMIC_FTRACE_WITH_REGS),y)


