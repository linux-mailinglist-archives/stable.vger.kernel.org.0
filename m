Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821E22ECFF0
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 13:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbhAGMfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 07:35:55 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:17678 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbhAGMfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 07:35:53 -0500
Date:   Thu, 07 Jan 2021 12:35:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610022909; bh=eO/PHJsxC/BU0o916BcRj7k2ZJn51umK9YSTysF7W78=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=kciYVe03J5dOgcjBjgbL9dsEjwXLN50MloldQqPfktixp4SpXMEiQi130FWwV/OYi
         mVpGtod8b2IFKlLCKi0UDe2HLSeSpbGEMb6vBxfC0FqULBmXCnBkkqzEGTep3bu73g
         bH3yZxK7+dIHrRCss90VaaUcDhykUqDvALa7Q9ey0pA5CwVLvHxAqI53vk4yH9DHAv
         pLhqJbygw/gnK17FBYRjZGWrEWXvlm0bgYRESsNT+BprTpTwq539KdUJQFsfxWJy5b
         Awc9dOon0SdbDRlySpNKa2JRvhVizUsyHqatGx5XcYXGm5dX8m196NisGw9xsly99O
         dOyb420EDYYwg==
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Pei Huang <huangpei@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Corey Minyard <cminyard@mvista.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v4 mips-next 3/7] MIPS: properly stop .eh_frame generation
Message-ID: <20210107123428.354231-3-alobakin@pm.me>
In-Reply-To: <20210107123428.354231-1-alobakin@pm.me>
References: <20210107123331.354075-1-alobakin@pm.me> <20210107123428.354231-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 866b6a89c6d1 ("MIPS: Add DWARF unwinding to assembly") added
-fno-asynchronous-unwind-tables to KBUILD_CFLAGS to prevent compiler
from emitting .eh_frame symbols.
However, as MIPS heavily uses CFI, that's not enough. Use the
approach taken for x86 (as it also uses CFI) and explicitly put CFI
symbols into the .debug_frame section (except for VDSO).
This allows us to drop .eh_frame from DISCARDS as it's no longer
being generated.

Fixes: 866b6a89c6d1 ("MIPS: Add DWARF unwinding to assembly")
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 arch/mips/include/asm/asm.h    | 18 ++++++++++++++++++
 arch/mips/kernel/vmlinux.lds.S |  1 -
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/asm.h b/arch/mips/include/asm/asm.h
index 3682d1a0bb80..908f6d6ae24b 100644
--- a/arch/mips/include/asm/asm.h
+++ b/arch/mips/include/asm/asm.h
@@ -20,10 +20,27 @@
 #include <asm/sgidefs.h>
 #include <asm/asm-eva.h>
=20
+#ifndef __VDSO__
+/*
+ * Emit CFI data in .debug_frame sections, not .eh_frame sections.
+ * We don't do DWARF unwinding at runtime, so only the offline DWARF
+ * information is useful to anyone. Note we should change this if we
+ * ever decide to enable DWARF unwinding at runtime.
+ */
+#define CFI_SECTIONS=09.cfi_sections .debug_frame
+#else
+ /*
+  * For the vDSO, emit both runtime unwind information and debug
+  * symbols for the .dbg file.
+  */
+#define CFI_SECTIONS
+#endif
+
 /*
  * LEAF - declare leaf routine
  */
 #define LEAF(symbol)=09=09=09=09=09\
+=09=09CFI_SECTIONS;=09=09=09=09\
 =09=09.globl=09symbol;=09=09=09=09\
 =09=09.align=092;=09=09=09=09\
 =09=09.type=09symbol, @function;=09=09\
@@ -36,6 +53,7 @@ symbol:=09=09.frame=09sp, 0, ra;=09=09=09\
  * NESTED - declare nested routine entry point
  */
 #define NESTED(symbol, framesize, rpc)=09=09=09\
+=09=09CFI_SECTIONS;=09=09=09=09\
 =09=09.globl=09symbol;=09=09=09=09\
 =09=09.align=092;=09=09=09=09\
 =09=09.type=09symbol, @function;=09=09\
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.=
S
index 16468957cba2..0f4e46ea4458 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -225,6 +225,5 @@ SECTIONS
 =09=09*(.options)
 =09=09*(.pdr)
 =09=09*(.reginfo)
-=09=09*(.eh_frame)
 =09}
 }
--=20
2.30.0


