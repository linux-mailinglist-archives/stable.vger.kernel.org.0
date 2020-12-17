Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82D22DCA14
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 01:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgLQAlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 19:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgLQAlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 19:41:47 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78BCC06179C
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 16:41:06 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id m203so9951446ybf.1
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 16:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc:content-transfer-encoding;
        bh=nQgcH8JHZsnhKqD6NfgVnumKz059kSgcZknDGcmmB+s=;
        b=EPE7cvqG1CwG1U3Og2cZeOASwzVU7A+l3tQlQ2Q1Qj+umQaGHp3C5Fzz5bGK0Crd04
         /n0YTZKkbnJr55TZON2xRNoUuFq97eIpqlag40vlkNDS9th2edu7BRoJnTUF+LPOl8rU
         5QaH44QM+D7Kwn3CKIxtIUPM9XYOv/kqIUwu885gR114fRktV2zSCPew4FsWlE4Rnrqj
         Sef/7Zkk91vRjq1xBxnjAM/t8D+kC9wSde//oqYHh2BBIY2f/0vJh1lY1ypqnmuM7/Hi
         +/2Bf97sUoUrVjttz+wvnStPfEKtpMxMUPz5lBve+Tqg6wmZ2Ta5IY6wJaVGLQbdGFHN
         YyZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=nQgcH8JHZsnhKqD6NfgVnumKz059kSgcZknDGcmmB+s=;
        b=AaxZffDGQP3wrHlEQjjNumFR/IwG7nUx23ME0ilDpadP4PzKx9fCNs+szEMyLaYhyB
         +CchnkCE8JsX05aGTVH4jJtOB+AXPLh0/EZf6TWuErt45ltXIfRpcPHADRlT//CrGQ1R
         9VK4Mf0a8cF4TstFXqHREnsi6dpFo7MhuNF/vy4b1NQsh5WouTO7uid5kx7A/xNeztYs
         wPLilS5r+15+dP5PUPPoIGeUp6hL2sYCGnzxXkG9Qm+f7OYFfsW/kNbRSx/c41o5iiBK
         jXmDn4/xJaIK288XMqyC3RfK/2ZmzadrACIhzYiZ4iq1X4LJVNh33ClMRNisRDa7O6ej
         aK0g==
X-Gm-Message-State: AOAM531dNdbT4e8HS5mIthTCeqW1Nl35s1F8hDhpsA6oA91dHMBRYkWb
        LZK50imjY39XbmSjiK5VZS4uVFDag/cjyM97tN8=
X-Google-Smtp-Source: ABdhPJzDCsUbB7yanWIFRkse1AcPCUp2lzaL4KZ94TktWtsEANgAnit5Tri5D+L2KDcRYZoHWgMFew1sqgzoawDx0kU=
Sender: "ndesaulniers via sendgmr" 
        <ndesaulniers@ndesaulniers1.mtv.corp.google.com>
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:f693:9fff:fef4:4d25])
 (user=ndesaulniers job=sendgmr) by 2002:a25:ed7:: with SMTP id
 206mr50304845ybo.136.1608165666117; Wed, 16 Dec 2020 16:41:06 -0800 (PST)
Date:   Wed, 16 Dec 2020 16:40:51 -0800
In-Reply-To: <CAKwvOdkP8vHidFPWczC24XwNHhQaXovQiQ43Yb6Csp_+kPR9XQ@mail.gmail.com>
Message-Id: <20201217004051.1247544-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <CAKwvOdkP8vHidFPWczC24XwNHhQaXovQiQ43Yb6Csp_+kPR9XQ@mail.gmail.com>
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
Subject: [PATCH] arm64: link with -z norelro for LLD or aarch64-elf
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

With newer GNU binutils, linking with BFD produces warnings for vmlinux:
aarch64-linux-gnu-ld: warning: -z norelro ignored

BFD can produce this warning when the target emulation mode does not
support RELRO relocation types, and -z relro or -z norelro is passed.

Alan Modra clarifies:
  The default linker emulation for an aarch64-linux ld.bfd is
  -maarch64linux, the default for an aarch64-elf linker is
  -maarch64elf.  They are not equivalent.  If you choose -maarch64elf
  you get an emulation that doesn't support -z relro.

The ARCH=3Darm64 kernel prefers -maarch64elf, but may fall back to
-maarch64linux based on the toolchain configuration.

LLD will always create RELRO relocation types regardless of target
emulation.

To avoid the above warning when linking with BFD, pass -z norelro only
when linking with LLD or with -maarch64linux.

Cc: Alan Modra <amodra@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: F=C4=81ng-ru=C3=AC S=C3=B2ng <maskray@google.com>
Fixes: 3b92fa7485eb ("arm64: link with -z norelro regardless of CONFIG_RELO=
CATABLE")
Reported-by: kernelci.org bot <bot@kernelci.org>
Reported-by: Quentin Perret <qperret@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
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

