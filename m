Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A81F2ECF40
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 12:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbhAGLzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 06:55:25 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:52829 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbhAGLzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 06:55:22 -0500
Date:   Thu, 07 Jan 2021 11:54:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610020456; bh=9oCj7QKLJWJNGcOnNqI17iIRyczWE6M4kFx9CTLO44o=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=PX7IdcsmptB95flrpg7vbA9aXY9Z4x0rBaPZAqWBLPxiyKVct33PYc+tD+iFojHb5
         /WQ4rauUjUGQrB3wCWthec91WMP36cR/ZvDcSR9I5pSObxgE+10VkNJc8R53cP7xJ3
         Z/5yOorsBQGDFzv5/WRP23wfcYHdX1ZW4R5imCcHYifo9kvN2mZyucsp7W4ENoOgsX
         EsQ9+rXIirHMLfO/Znuy0UK0+OzPyRZg++nPcXI+1dZg4KNT1oCL2f7lMYlhqFbIwx
         a2EqXM2d79aeE4dwJGr27V5f37DCMYsoHHMnz+b6stL0v3IW+FvWdWxsFM8GIheh1g
         2lJ4rFqEVgF1Q==
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
Subject: [PATCH v3 mips-next 5/7] MIPS: vmlinux.lds.S: explicitly declare .got table
Message-ID: <20210107115329.281266-5-alobakin@pm.me>
In-Reply-To: <20210107115329.281266-1-alobakin@pm.me>
References: <20210107115120.281008-1-alobakin@pm.me> <20210107115329.281266-1-alobakin@pm.me>
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

LLVM stack generates GOT table when building the kernel:

ld.lld: warning: <internal>:(.got) is being placed in '.got'

According to the debug assertions, it's not zero-sized and thus
can't be handled the same way as .rel.dyn (like it's done for x86).
Use the ARM/ARM64 path here and place it at the end of .text section.

Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 arch/mips/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.=
S
index 0f736d60d43e..4709959f6985 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -69,6 +69,7 @@ SECTIONS
 =09=09*(.text.*)
 =09=09*(.fixup)
 =09=09*(.gnu.warning)
+=09=09*(.got)
 =09} :text =3D 0
 =09_etext =3D .;=09/* End of text section */
=20
--=20
2.30.0


