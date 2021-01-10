Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1052F06EF
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 12:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbhAJL5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 06:57:52 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:17066 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbhAJL5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 06:57:52 -0500
Date:   Sun, 10 Jan 2021 11:56:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610279810; bh=x8cRNNoQDUio05HqY97IXykwYEnNtBTKUh4spQvRTkU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Vn6/a5xZo9524H3sJXKD1skGlwNWJBKpxsaQlelflZWpiRO6mvcpRXbkqWhE1penm
         ndkAzPHQ6OJZnJMzz1W6177XAau2X1iZiwugVn1rACTV1Typ9lpvgpFAZQ9moC2R5d
         SoyJ4LnYL/PbTdyrTiw92NsZf8ayY1ZA44dtUgQN9XX6hp+EbnFKmC9kgotXWQ3U3P
         nxwov3RXk0ZzC8oYRrLAsmhVLmFA+7dPmPQeJCIvf4+jcbtukzYFduFdFK5CX7B6M0
         xPyUxcRog1HRkHy3MIgZgnMDgH79NpMZVKdPNMBecY7x9TT6tCZeKTYerByMaaXvu4
         7D83kWhj3y2eg==
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Pei Huang <huangpei@loongson.cn>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Fangrui Song <maskray@google.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Corey Minyard <cminyard@mvista.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Sami Tolvanen <samitolvanen@google.com>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v5 mips-next 7/9] vmlinux.lds.h: catch compound literals into data and BSS
Message-ID: <20210110115546.30970-7-alobakin@pm.me>
In-Reply-To: <20210110115546.30970-1-alobakin@pm.me>
References: <20210110115245.30762-1-alobakin@pm.me> <20210110115546.30970-1-alobakin@pm.me>
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

When building kernel with LD_DEAD_CODE_DATA_ELIMINATION, LLVM stack
generates separate sections for compound literals, just like in case
with enabled LTO [0]:

ld.lld: warning: drivers/built-in.a(mtd/nand/spi/gigadevice.o):
(.data..compoundliteral.14) is being placed in
'.data..compoundliteral.14'
ld.lld: warning: drivers/built-in.a(mtd/nand/spi/gigadevice.o):
(.data..compoundliteral.15) is being placed in
'.data..compoundliteral.15'
ld.lld: warning: drivers/built-in.a(mtd/nand/spi/gigadevice.o):
(.data..compoundliteral.16) is being placed in
'.data..compoundliteral.16'
ld.lld: warning: drivers/built-in.a(mtd/nand/spi/gigadevice.o):
(.data..compoundliteral.17) is being placed in
'.data..compoundliteral.17'

[...]

Handle this by adding the related sections to generic definitions
as suggested by Sami [0].

[0] https://lore.kernel.org/lkml/20201211184633.3213045-3-samitolvanen@goog=
le.com

Suggested-by: Sami Tolvanen <samitolvanen@google.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
---
 include/asm-generic/vmlinux.lds.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinu=
x.lds.h
index b2b3d81b1535..5f2f5b1db84f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -95,10 +95,10 @@
  */
 #ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
 #define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
-#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..LPBX*
+#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..L* .data..compoundliter=
al*
 #define SDATA_MAIN .sdata .sdata.[0-9a-zA-Z_]*
-#define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]*
-#define BSS_MAIN .bss .bss.[0-9a-zA-Z_]*
+#define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]* .rodata..L*
+#define BSS_MAIN .bss .bss.[0-9a-zA-Z_]* .bss..compoundliteral*
 #define SBSS_MAIN .sbss .sbss.[0-9a-zA-Z_]*
 #else
 #define TEXT_MAIN .text
--=20
2.30.0


