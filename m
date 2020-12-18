Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1892DDC5C
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 01:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732048AbgLRAZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 19:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731130AbgLRAZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 19:25:22 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05E7C0617A7
        for <stable@vger.kernel.org>; Thu, 17 Dec 2020 16:24:41 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id z1so457559ybg.22
        for <stable@vger.kernel.org>; Thu, 17 Dec 2020 16:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc:content-transfer-encoding;
        bh=ERR2VE2oCwVj0NVrLHMHrJrZvp//bs46UVD4KXEsUV4=;
        b=kGo+noPT2sAcMd9H4DHcFIPyvTbkVbBAZXLSRZGw92t40O6jtpQ1pVyIsyVdt/EG1O
         kB2HpGKjev7+TPuMeWx9py1VLcPFBxqGVDMMHkrcVA8O9VHU2Xb+HjmoClG2L+KlBDb3
         mQpC281cO1ZSrRuj4nL0zI3rEChn24EiDyuwL0WZ3ia9eaMMUEhC96Z0hjYY5FiqhNiy
         s73i34Blc94eiBPAPtC4hiG4HAvhuO0rmRwZNV5G6df847xe/pOxBbTEnLoZK9BRrFUH
         zAPODaE3aZi/5c+v+R+Dv/mM1tIUbV1vpQBh4BzAhFTRdHFUFjFd2BLcgZzkvvkBF6GL
         40Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=ERR2VE2oCwVj0NVrLHMHrJrZvp//bs46UVD4KXEsUV4=;
        b=a0qWuYsb0jRtvekyQtxjZRIt6L3PzkZEv9BORyM9x8yWemwjm4/akgd30WD98vyMR7
         STQbbHSgHtybGfiqokXtYzTjWkFxRSm/A/509p/YhnVb7uqnfatksKUnD0r4UPQWnpse
         l5OHNRWVBMYSnvgHwClmUOlc4apkuQWGzY/s6j27tv8rWLUl8vmz5hIRYhuutn9+Z++m
         6idgxUmRhdF207kn1LwTw4e5103iG2sq7U5mQbrBjRE9by28L9z8Aw9O+nFShXcrkzCu
         TxQRZlE0N5Ru+GkZd0DEaZLhZ9FIcT3VakYq4+Gqzj8tI3Tg/6iVG8F7F5yaBrTqOE7N
         5DSg==
X-Gm-Message-State: AOAM532MYNPuTKg9V+VggPtKj3XxxFCV/7okawM5CMNszQglg4hJWL+w
        93QeXeEpERqxYSnwE+Cztzsxcy4PGdlHXG/l7lw=
X-Google-Smtp-Source: ABdhPJzNZDCIVC2LbClgGga7MLXdQa4n65MGucsJKpJdIgtXg0yTfsIN04/oazZ0QmUaUU1Szu/76HoHRO+UYrqIimo=
Sender: "ndesaulniers via sendgmr" 
        <ndesaulniers@ndesaulniers1.mtv.corp.google.com>
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:f693:9fff:fef4:4d25])
 (user=ndesaulniers job=sendgmr) by 2002:a5b:b0b:: with SMTP id
 z11mr2665128ybp.164.1608251080932; Thu, 17 Dec 2020 16:24:40 -0800 (PST)
Date:   Thu, 17 Dec 2020 16:24:32 -0800
In-Reply-To: <CAKwvOd=LZHzR11kuhT2EjFnUdFwu5hQmxiwqeLB2sKC0hWFY=g@mail.gmail.com>
Message-Id: <20201218002432.788499-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <CAKwvOd=LZHzR11kuhT2EjFnUdFwu5hQmxiwqeLB2sKC0hWFY=g@mail.gmail.com>
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
Subject: [PATCH v2] arm64: link with -z norelro for LLD or aarch64-elf
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     kernel-team <kernel-team@android.com>,
        Peter Smith <Peter.Smith@arm.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        "=?UTF-8?q?F=C4=81ng-ru=C3=AC=20S=C3=B2ng?=" <maskray@google.com>,
        Quentin Perret <qperret@google.com>,
        Alan Modra <amodra@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With GNU binutils 2.35+, linking with BFD produces warnings for vmlinux:
aarch64-linux-gnu-ld: warning: -z norelro ignored

BFD can produce this warning when the target emulation mode does not
support RELRO program headers, and -z relro or -z norelro is passed.

Alan Modra clarifies:
  The default linker emulation for an aarch64-linux ld.bfd is
  -maarch64linux, the default for an aarch64-elf linker is
  -maarch64elf.  They are not equivalent.  If you choose -maarch64elf
  you get an emulation that doesn't support -z relro.

The ARCH=3Darm64 kernel prefers -maarch64elf, but may fall back to
-maarch64linux based on the toolchain configuration.

LLD will always create RELRO program header regardless of target
emulation.

To avoid the above warning when linking with BFD, pass -z norelro only
when linking with LLD or with -maarch64linux.

Cc: Alan Modra <amodra@gmail.com>
Cc: F=C4=81ng-ru=C3=AC S=C3=B2ng <maskray@google.com>
Fixes: 3b92fa7485eb ("arm64: link with -z norelro regardless of CONFIG_RELO=
CATABLE")
Reported-by: kernelci.org bot <bot@kernelci.org>
Reported-by: Quentin Perret <qperret@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Changes V1 -> V2:
* s/relocation types/program headers/
* s/newer GNU binutils/GNU binutils 2.35+/
* Pick up Ard's Ack.

Note: maintainers may want to pick up the following tag:

Fixes: 3bbd3db86470 ("arm64: relocatable: fix inconsistencies in linker scr=
ipt and options")

or drop the existing fixes tag (this patch is more so in response to
change to BFD to warn than fix a kernel regression, IMO, but I don't
care). Either way, it would be good to fix this for the newly minted
v5.10.y.

I'll probably be offline for the next two weeks for the holidays, so no
promises on quick replies. Happy holidays+new year!


 arch/arm64/Makefile | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 6be9b3750250..90309208bb28 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -10,7 +10,7 @@
 #
 # Copyright (C) 1995-2001 by Russell King
=20
-LDFLAGS_vmlinux	:=3D--no-undefined -X -z norelro
+LDFLAGS_vmlinux	:=3D--no-undefined -X
=20
 ifeq ($(CONFIG_RELOCATABLE), y)
 # Pass --no-apply-dynamic-relocs to restore pre-binutils-2.27 behaviour
@@ -115,16 +115,20 @@ KBUILD_CPPFLAGS	+=3D -mbig-endian
 CHECKFLAGS	+=3D -D__AARCH64EB__
 # Prefer the baremetal ELF build target, but not all toolchains include
 # it so fall back to the standard linux version if needed.
-KBUILD_LDFLAGS	+=3D -EB $(call ld-option, -maarch64elfb, -maarch64linuxb)
+KBUILD_LDFLAGS	+=3D -EB $(call ld-option, -maarch64elfb, -maarch64linuxb -=
z norelro)
 UTS_MACHINE	:=3D aarch64_be
 else
 KBUILD_CPPFLAGS	+=3D -mlittle-endian
 CHECKFLAGS	+=3D -D__AARCH64EL__
 # Same as above, prefer ELF but fall back to linux target if needed.
-KBUILD_LDFLAGS	+=3D -EL $(call ld-option, -maarch64elf, -maarch64linux)
+KBUILD_LDFLAGS	+=3D -EL $(call ld-option, -maarch64elf, -maarch64linux -z =
norelro)
 UTS_MACHINE	:=3D aarch64
 endif
=20
+ifeq ($(CONFIG_LD_IS_LLD), y)
+KBUILD_LDFLAGS	+=3D -z norelro
+endif
+
 CHECKFLAGS	+=3D -D__aarch64__
=20
 ifeq ($(CONFIG_DYNAMIC_FTRACE_WITH_REGS),y)
--=20
2.29.2.684.gfbc64c5ab5-goog

