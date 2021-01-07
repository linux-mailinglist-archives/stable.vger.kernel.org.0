Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429982ED098
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 14:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbhAGNVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 08:21:34 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:64020 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728390AbhAGNVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 08:21:33 -0500
Date:   Thu, 07 Jan 2021 13:20:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610025651; bh=9oCj7QKLJWJNGcOnNqI17iIRyczWE6M4kFx9CTLO44o=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=lrLPAOvww0VvEA4BtSTnnUTYtcgzLetcZIBJZI7GJT8o5QacEQyCtZ4AUc6x8k323
         jMAKgxOIP62fj4sou0ajm07YYRlfNW0D36sPcxS8N4l1i7zGK+xA6tw6GEFLKtE7l9
         zIHmFSEar2TLaHvwmFRtMohUoQFC/j/68PHBVMswYWSIYJ57JpBFWtvGroeUBqL7Qz
         9cgckGv6AZjZhxZtQDK7zA0609rtDrXdPmaEq9N8Z6p3pqxbksf3Gycm61TBb4aXPZ
         guCuLJi8d9Bwh4bS4ApL0AQHSlG8QNR6l8FhH/rJhXAo40NCnfGEkHEUg89uyhEu8c
         jyYk0VWsux/5g==
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
Subject: [PATCH v4 mips-next 5/7] MIPS: vmlinux.lds.S: explicitly declare .got table
Message-ID: <20210107132010.463129-2-alobakin@pm.me>
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


