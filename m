Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32C82ED09B
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 14:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbhAGNVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 08:21:47 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:16120 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbhAGNVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 08:21:47 -0500
Date:   Thu, 07 Jan 2021 13:20:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610025664; bh=tAhGyp2geX19Adc0pmsweHYMg6GqMIq+Zk7djwr/y7M=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=fMAChsxhN37qCfBmEwpgDN7pHIELWE4oEMllD4cxn+PyA8L+hPw26OwD3+JVccWui
         06aq+eRq8a4InUotyP1RyI0X20Y6x90l5cn3bCTogmA5RDs9ZRyJdfaPxfk1LoPDkG
         4YlRElx0ohdWxN2Aw8xwxLRmlS2gLO2df0Mb+VfVYurfgdocVZpjzFRjCfH3jP/EUr
         X3x1gBCSI/k767qtRhMWqgWuhl/it4x0GswYdykTHF457MqkBtrr0wVXAUCUn8x1oe
         WX9CaY4VsDc6h3fnJ6Mglf5ZWRqX9GktvLw3A1N27oJdSfauGXUtacdsSp3qDgbI0t
         ZwudvWYogKkCw==
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
Subject: [PATCH v4 mips-next 6/7] vmlinux.lds.h: catch compound literals into data and BSS
Message-ID: <20210107132010.463129-3-alobakin@pm.me>
In-Reply-To: <20210107132010.463129-1-alobakin@pm.me>
References: <20210107123331.354075-1-alobakin@pm.me> <20210107132010.463129-1-alobakin@pm.me>
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

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
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


