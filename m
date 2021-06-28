Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869A53B6189
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbhF1OgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235007AbhF1Oek (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:34:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E43361C84;
        Mon, 28 Jun 2021 14:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890615;
        bh=SbtBNEAPeD/UKetEODgR02icvIt73lWymM9zAAuBFjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZyOoYxG8tOhX/eNrofBcAa9kjps6u0vUFozR/cVR+v4PKXmGftUJO1W5542RRF6py
         hD/7+RAY/rF+BppL3wBNBXK1DHRgoZoueHx1a4IaSiD97wvUwUgwBZBB6lAwWAWY/i
         GMJOZHcRDYjZt0osugWZB7dpfsj5FVWX8NKr74Y++ZaAXCYXzE/7ohVGLcNUdv4Cz1
         Z8JMrLZ1LiNCfQOXAndF7nMaZX18aezETwc1B2NTM8G/3NsO6ncSx64lP8AbJYDiEK
         n+eWVH/qu19s3P/mlP96lOMXOeyP/YR9b8FyowCpJP16qprcIyrXa1aScdtzSABKbA
         Ku5o5m35KAusw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Quentin Perret <qperret@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Alan Modra <amodra@gmail.com>,
        =?UTF-8?q?F=C4=81ng-ru=C3=AC=20S=C3=B2ng?= <maskray@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 09/71] arm64: link with -z norelro for LLD or aarch64-elf
Date:   Mon, 28 Jun 2021 10:29:02 -0400
Message-Id: <20210628143004.32596-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 arch/arm64/Makefile | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index cd8f3cdabfd0..d227cf87c48f 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -10,7 +10,7 @@
 #
 # Copyright (C) 1995-2001 by Russell King
 
-LDFLAGS_vmlinux	:=--no-undefined -X -z norelro
+LDFLAGS_vmlinux	:=--no-undefined -X
 CPPFLAGS_vmlinux.lds = -DTEXT_OFFSET=$(TEXT_OFFSET)
 GZFLAGS		:=-9
 
@@ -82,17 +82,21 @@ CHECKFLAGS	+= -D__AARCH64EB__
 AS		+= -EB
 # Prefer the baremetal ELF build target, but not all toolchains include
 # it so fall back to the standard linux version if needed.
-KBUILD_LDFLAGS	+= -EB $(call ld-option, -maarch64elfb, -maarch64linuxb)
+KBUILD_LDFLAGS	+= -EB $(call ld-option, -maarch64elfb, -maarch64linuxb -z norelro)
 UTS_MACHINE	:= aarch64_be
 else
 KBUILD_CPPFLAGS	+= -mlittle-endian
 CHECKFLAGS	+= -D__AARCH64EL__
 AS		+= -EL
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
 
 ifeq ($(CONFIG_ARM64_MODULE_PLTS),y)
-- 
2.30.2

