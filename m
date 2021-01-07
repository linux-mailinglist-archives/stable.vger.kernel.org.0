Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D602ECF36
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 12:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbhAGLyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 06:54:51 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:12636 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbhAGLyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 06:54:50 -0500
Date:   Thu, 07 Jan 2021 11:54:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610020448; bh=1iHiRQzHqAO/hOdIJm7931oVSjvi8g99iSxotTA/NNE=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=h9iDE6kYHoQBexkMbRaeK54YzGi6+A5II9aLhoDuUgm9dAgTgIfDEJGYmr1UC2yIZ
         JREQr544tOE1P32+AuHWzTO5MRYqHkYBz1c9dE0WDWNm608M5Awd90cTG3Cnb/IxGo
         gYlMIVh2tb3kQMwghxTHGFtxhzqXHh7/vuRXYCTaet0z8uvPzSkJTJBJPTQIuD8DTF
         e7nnotl5SZ+TKjpCirUVXeE7esPQt874qFPiteLNySMNysyOtATkdySQ4yXZFH4spw
         CCXyRY/GZIKfSymZrdNz9h0ndUR9p+LZSS9HbBeCmgJ32pPsEUSj8DS50Pm7Odo4vL
         7EkzefXyUDKtg==
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
Subject: [PATCH v3 mips-next 4/7] MIPS: vmlinux.lds.S: catch bad .rel.dyn at link time
Message-ID: <20210107115329.281266-4-alobakin@pm.me>
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

Catch any symbols placed in .rel.dyn and check for these sections
to be zero-sized at link time.
Eliminates following ld warning:

mips-alpine-linux-musl-ld: warning: orphan section `.rel.dyn'
from `init/main.o' being placed in section `.rel.dyn'

Adopted from x86/kernel/vmlinux.lds.S.

Suggested-by: Fangrui Song <maskray@google.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 arch/mips/kernel/vmlinux.lds.S | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.=
S
index 0f4e46ea4458..0f736d60d43e 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -226,4 +226,15 @@ SECTIONS
 =09=09*(.pdr)
 =09=09*(.reginfo)
 =09}
+
+=09/*
+=09 * Sections that should stay zero sized, which is safer to
+=09 * explicitly check instead of blindly discarding.
+=09 */
+
+=09.rel.dyn : {
+=09=09*(.rel.*)
+=09=09*(.rel_*)
+=09}
+=09ASSERT(SIZEOF(.rel.dyn) =3D=3D 0, "Unexpected run-time relocations (.re=
l) detected!")
 }
--=20
2.30.0


