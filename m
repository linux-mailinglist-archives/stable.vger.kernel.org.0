Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C8B2F06D3
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 12:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbhAJL44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 06:56:56 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:43907 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbhAJL4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 06:56:55 -0500
Date:   Sun, 10 Jan 2021 11:56:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610279773; bh=MxtmeMzoZosf2A+5OO/KqkqqfNrpxRLfY3mE8BM76lQ=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=JZj3U2JaMwR6aIb+WJNixdldVJL+Sv39Cg7zlScN1lcrDdhgLwr1j1U2izIIllaGq
         myziSQIz+n/t3F5fE6BhvLoGmdhdklFvf5QllTupqf//cw1D2EQcktUtFaKc5tsVe8
         zr4KO+0q0Ao9RTUUqJ3YPsNu6klprCJxSsxyTIXPInaXkeuXpSH+21g4GOSEH17170
         M2H3ax30J9U4jtk2/+bfVHbS8uA1Hl1M80fkLdmMv6fXgdnB/k1l9eml8EI8fwNZvM
         J+Gi5qzKU6R2CwysDgqu4EmsC7Qrb89FW7D+YElgvAqR6F4N9jky+JQ+Z5450u0xjR
         Movfwmvgv1y+A==
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
Subject: [PATCH v5 mips-next 1/9] MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section
Message-ID: <20210110115546.30970-1-alobakin@pm.me>
In-Reply-To: <20210110115245.30762-1-alobakin@pm.me>
References: <20210110115245.30762-1-alobakin@pm.me>
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

MIPS uses its own declaration of rwdata, and thus it should be kept
in sync with the asm-generic one. Currently PAGE_ALIGNED_DATA() is
missing from the linker script, which emits the following ld
warnings:

mips-alpine-linux-musl-ld: warning: orphan section
`.data..page_aligned' from `arch/mips/kernel/vdso.o' being placed
in section `.data..page_aligned'
mips-alpine-linux-musl-ld: warning: orphan section
`.data..page_aligned' from `arch/mips/vdso/vdso-image.o' being placed
in section `.data..page_aligned'

Add the necessary declaration, so the mentioned structures will be
placed in vmlinux as intended:

ffffffff80630580 D __end_once
ffffffff80630580 D __start___dyndbg
ffffffff80630580 D __start_once
ffffffff80630580 D __stop___dyndbg
ffffffff80634000 d mips_vdso_data
ffffffff80638000 d vdso_data
ffffffff80638580 D _gp
ffffffff8063c000 T __init_begin
ffffffff8063c000 D _edata
ffffffff8063c000 T _sinittext

->

ffffffff805a4000 D __end_init_task
ffffffff805a4000 D __nosave_begin
ffffffff805a4000 D __nosave_end
ffffffff805a4000 d mips_vdso_data
ffffffff805a8000 d vdso_data
ffffffff805ac000 D mmlist_lock
ffffffff805ac080 D tasklist_lock

Fixes: ebb5e78cc634 ("MIPS: Initial implementation of a VDSO")
Cc: stable@vger.kernel.org # 4.4+
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
---
 arch/mips/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.=
S
index 5e97e9d02f98..83e27a181206 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -90,6 +90,7 @@ SECTIONS
=20
 =09=09INIT_TASK_DATA(THREAD_SIZE)
 =09=09NOSAVE_DATA
+=09=09PAGE_ALIGNED_DATA(PAGE_SIZE)
 =09=09CACHELINE_ALIGNED_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
 =09=09READ_MOSTLY_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
 =09=09DATA_DATA
--=20
2.30.0


