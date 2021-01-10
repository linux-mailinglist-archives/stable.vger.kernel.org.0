Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725942F06EA
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 12:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbhAJL5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 06:57:44 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:30735 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbhAJL5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 06:57:43 -0500
Date:   Sun, 10 Jan 2021 11:56:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610279820; bh=uBfGM5EGQNjpg0d/r+6RHo1eXsl0e/48xvwxFVSmmH4=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=P+8SKV7ni23HcrUcB47hl2iy85MY84jROQWpUkBFOwkQmVk0721gLt8uraxdCn/uE
         D797LDQHehlcKF/0AWssQ+89Kly7aoog1hMRIKs1ExJpTYDKXyx5d4dGFcXPhsoJE/
         p4RyBZqSowzG5yYT3gfT70Ur38y7MUm3DvJlXM26qsBV+/x+uBrLWcg7+9FuS2+zlF
         MmtEL7Anl8euGs9nb4y2Q06vEmxu65EWAQc4imgMDVMFT51T5QNtL+5qKVog0Wquxy
         Nd9dVUAe/zBVifVS0L7EQv7/oC4h9uDbVkQkBqunwSmgnhxPhDC1tgPpiGstDO2bL8
         2YZPrhxbVSX5Q==
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
        clang-built-linux@googlegroups.com
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v5 mips-next 8/9] vmlinux.lds.h: catch UBSAN's "unnamed data" into data
Message-ID: <20210110115546.30970-8-alobakin@pm.me>
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

When building kernel with both LD_DEAD_CODE_DATA_ELIMINATION and
UBSAN, LLVM stack generates lots of "unnamed data" sections:

ld.lld: warning: net/built-in.a(netfilter/utils.o): (.data.$__unnamed_2)
is being placed in '.data.$__unnamed_2'
ld.lld: warning: net/built-in.a(netfilter/utils.o): (.data.$__unnamed_3)
is being placed in '.data.$__unnamed_3'
ld.lld: warning: net/built-in.a(netfilter/utils.o): (.data.$__unnamed_4)
is being placed in '.data.$__unnamed_4'
ld.lld: warning: net/built-in.a(netfilter/utils.o): (.data.$__unnamed_5)
is being placed in '.data.$__unnamed_5'

[...]

Also handle this by adding the related sections to generic definitions.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/asm-generic/vmlinux.lds.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinu=
x.lds.h
index 5f2f5b1db84f..cc659e77fcb0 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -95,7 +95,7 @@
  */
 #ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
 #define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
-#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..L* .data..compoundliter=
al*
+#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..L* .data..compoundliter=
al* .data.$__unnamed_*
 #define SDATA_MAIN .sdata .sdata.[0-9a-zA-Z_]*
 #define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]* .rodata..L*
 #define BSS_MAIN .bss .bss.[0-9a-zA-Z_]* .bss..compoundliteral*
--=20
2.30.0


