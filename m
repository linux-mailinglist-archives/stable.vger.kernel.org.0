Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA192F06EC
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 12:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbhAJL5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 06:57:48 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:41644 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbhAJL5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 06:57:44 -0500
Date:   Sun, 10 Jan 2021 11:56:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610279803; bh=RlF1lh7iHyBsNtm+h3Fc1S3Q2TDvtrRsAKToRMl4zRY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=YhwP9l3YFs/Snyz4zF4eru6TnU1fWkw+3mw05LcJzw+A3v/4q+HzkCZmy+g1nV7lm
         7HvbK69qKcd/5KCyoCYYbIt1rGvG52946+v7bWKtgW3nuO35q91Nqzmrb5SavkVYl9
         uxvveKgPQvxNkNuxjbo9cODYeRG3vPkqqf+jqScRAM4XRf2y0Aaac0PZgebeBHC57r
         ywACjMxtw2/JlIfjWxqyizqN/xg6706DNTKmLkOfUwBnMlhun7Ex78fp63/yETFmWv
         QjfKlkH3bcokvSVNsc41/JjLdqPMSlB8f+SpiSxxlfhYJe3BQ0JvGSy6uo/5Ez0stH
         WsW13QZyflgYg==
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
Subject: [PATCH v5 mips-next 6/9] MIPS: vmlinux.lds.S: explicitly declare .got table
Message-ID: <20210110115546.30970-6-alobakin@pm.me>
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

LLVM stack generates GOT table when building the kernel:

ld.lld: warning: <internal>:(.got) is being placed in '.got'

According to the debug assertions, it's not zero-sized and thus can't
be handled the way it's done for x86.
Also use the ARM64 path here and place it at the end of .text section.

Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
---
 arch/mips/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.=
S
index 70bba1ff08da..c1c345be04ff 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -68,6 +68,8 @@ SECTIONS
 =09=09SOFTIRQENTRY_TEXT
 =09=09*(.fixup)
 =09=09*(.gnu.warning)
+=09=09. =3D ALIGN(16);
+=09=09*(.got)=09/* Global offset table */
 =09} :text =3D 0
 =09_etext =3D .;=09/* End of text section */
=20
--=20
2.30.0


