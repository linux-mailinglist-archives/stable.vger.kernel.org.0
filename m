Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480132F06DD
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 12:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbhAJL5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 06:57:10 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:50432 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbhAJL5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 06:57:10 -0500
Date:   Sun, 10 Jan 2021 11:56:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610279787; bh=z4p3GtI1grxbS9iYRUU8FxMU4I/9YCWsZkDii++EkHY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=kXksgyJ2ZKnkOB56k/OUlWAYbFEoy4qCZSRRM1QCOSsoJRz/wN/f5197IAyqeLjXc
         vLyb84amAp9xJQbLkjaOW6bO9+xBinyP0z7mdCuFnsLUEDxyTSVAdNDf3YSeTy/j+T
         R+e3aG2BGgb4V0StoGGkcZXJgaUDxNuwvKRutZHUijsPJL4zcnWsWvOK7IgDNBitZ/
         n0u1DjFtuYJIWqtYXZaANOVkHeDQb5+penkn9WIRCa3Y0/GEh0UJVvzxyUE2dmbfU7
         ffc0bS5IU+Z4Jq80t84BDCiUCJXyZ/2KRO6A/NHDYRqQS0WVM9NARCVyAy1zwzPazn
         qsE28JKCwcStA==
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
Subject: [PATCH v5 mips-next 3/9] MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
Message-ID: <20210110115546.30970-3-alobakin@pm.me>
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

Discard GNU attributes (MIPS FP type, GNU Hash etc.) at link time
as kernel doesn't use it at all.
Solves a dozen of the following ld warnings (one per every file):

mips-alpine-linux-musl-ld: warning: orphan section `.gnu.attributes'
from `arch/mips/kernel/head.o' being placed in section
`.gnu.attributes'
mips-alpine-linux-musl-ld: warning: orphan section `.gnu.attributes'
from `init/main.o' being placed in section `.gnu.attributes'

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
---
 arch/mips/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.=
S
index ae1d0b4bdd60..09669a8fddec 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -220,6 +220,7 @@ SECTIONS
 =09=09/* ABI crap starts here */
 =09=09*(.MIPS.abiflags)
 =09=09*(.MIPS.options)
+=09=09*(.gnu.attributes)
 =09=09*(.options)
 =09=09*(.pdr)
 =09=09*(.reginfo)
--=20
2.30.0


