Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08B62F06E3
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 12:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbhAJL5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 06:57:20 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:41412 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbhAJL5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 06:57:20 -0500
Date:   Sun, 10 Jan 2021 11:56:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610279798; bh=+ae0nqbyeS3RjrUU35uQTOED4nYRvyGMZstGTOsR/XI=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=C2tPyl58XE2zQ0KPOSMylWBWbk0UKeDtNEOseTTtSJLWstFv8cTRa0XqoNaYmusB3
         maeMzBWCdVdVsiUork2JsMn2ZMcsA7efIbmqnhb03RW69cIZyYgmkZCpQsnbzPJaVm
         PRXCMI6pg8ODZalPOq0c4P7qcga3n2/DQ1r9W4fy3wckCj2eZEqjUtprOFDrwl2/Z9
         G/OyXLkoD5mKAEhPeyHVmgyH3xLpKX4dlzYmj/yOPD76YEwRLjJsHIIwbBd4daD9Vn
         YBXACF6CdymNRuD3/ZHPHb/e5GlHQpZEse6i5L0stZyrse8JeqUfGIPP/1bnpbidnH
         nY+860napd82A==
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
Subject: [PATCH v5 mips-next 5/9] MIPS: vmlinux.lds.S: explicitly catch .rel.dyn symbols
Message-ID: <20210110115546.30970-5-alobakin@pm.me>
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

According to linker warnings, both GCC and LLVM generate '.rel.dyn'
symbols:

mips-alpine-linux-musl-ld: warning: orphan section `.rel.dyn'
from `init/main.o' being placed in section `.rel.dyn'

Link-time assertion shows that this section is sometimes empty,
sometimes not, depending on machine bitness and the compiler [0]:

  LD      .tmp_vmlinux.kallsyms1
mips64-linux-gnu-ld: Unexpected run-time relocations (.rel) detected!

Just use the ARM64 approach and declare it in vmlinux.lds.S closer
to __init_end.

[0] https://lore.kernel.org/linux-mips/20210109111259.GA4213@alpha.franken.=
de

Reported-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 arch/mips/kernel/vmlinux.lds.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.=
S
index 10d8f0dcb76b..70bba1ff08da 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -137,6 +137,11 @@ SECTIONS
 =09PERCPU_SECTION(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
 #endif
=20
+=09.rel.dyn : ALIGN(8) {
+=09=09*(.rel)
+=09=09*(.rel*)
+=09}
+
 #ifdef CONFIG_MIPS_ELF_APPENDED_DTB
 =09.appended_dtb : AT(ADDR(.appended_dtb) - LOAD_OFFSET) {
 =09=09*(.appended_dtb)
--=20
2.30.0


