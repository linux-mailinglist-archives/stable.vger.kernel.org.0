Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725212F06D7
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 12:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbhAJL5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 06:57:02 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:37941 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbhAJL5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 06:57:02 -0500
Date:   Sun, 10 Jan 2021 11:56:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610279780; bh=e3Fx1xMuOcodd9nkft6VXE99Jq/7Rxy9CCIA9/ZKpTI=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=jaBr7GOjsRY8ora1Ne+lK75KOkB1QTdD3G2VKgTQUzreZm6mRjkkoAiYSSSCarNsj
         Yg3hZgqmPn3TUctk956YIgMEUoaAnQ/NBpofBjSgSR0chTny6RcL/DT8rmCeJGdtCa
         Gej3Rbk+1ziZ3oIejDY807ocMKC+EeJwDpI9cJXxEBI8EVVb4UlezbUXxWP3QPexie
         MmgjVwyMbWKp7LvZysDmIBCIiKxWudE+NJc2WRi0jgrsbulghpynJBkj56AllUNbXT
         U2Sn3zUkR+YUUJJgyX6bY2y5/yMGcwOul/4J7E6ZljwLQZDvOX5FNfeDatpPrBs3kc
         157NhWME+OBUQ==
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
Subject: [PATCH v5 mips-next 2/9] MIPS: CPS: don't create redundant .text.cps-vec section
Message-ID: <20210110115546.30970-2-alobakin@pm.me>
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

A number of symbols from arch/mips/kernel/cps-vec.S is explicitly
placed into '.text.cps-vec' section.
There are no direct references to this section, so there's no need
to form it. '.balign 0x1000' directive will work anyway.

Moreover, this section was being placed in vmlinux differently
depending on CONFIG_LD_DEAD_CODE_DATA_ELIMINATION:
 - with this option enabled, '.text.cps-vec' was being caught
   by '.text.[0-9a-zA-Z_]*' from include/asm-generic/vmlinux.lds.h;
 - without this option, '.text.cps-vec' was being caught
   by discouraging '.text.*' from arch/mips/kernel/vmlinux.lds.S.

'.text.*' should not be used in vmlinux linker scripts at all as it
silently catches any orphan text sections.
So, remove both '.section .text.cps-vec' and '.text.*' from cps-vec.S
and vmlinux.lds.S respectively. As said, this does not affect related
functions alignment:

80116000 T mips_cps_core_entry
80116028 t not_nmi
80116200 T excep_tlbfill
80116280 T excep_xtlbfill
80116300 T excep_cache
80116380 T excep_genex
80116400 T excep_intex
80116480 T excep_ejtag
80116490 T mips_cps_core_init

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 arch/mips/kernel/cps-vec.S     | 1 -
 arch/mips/kernel/vmlinux.lds.S | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/mips/kernel/cps-vec.S b/arch/mips/kernel/cps-vec.S
index 4db7ff055c9f..975343240148 100644
--- a/arch/mips/kernel/cps-vec.S
+++ b/arch/mips/kernel/cps-vec.S
@@ -91,7 +91,6 @@
 =09.set=09pop
 =09.endm
=20
-.section .text.cps-vec
 .balign 0x1000
=20
 LEAF(mips_cps_core_entry)
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.=
S
index 83e27a181206..ae1d0b4bdd60 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -66,7 +66,6 @@ SECTIONS
 =09=09KPROBES_TEXT
 =09=09IRQENTRY_TEXT
 =09=09SOFTIRQENTRY_TEXT
-=09=09*(.text.*)
 =09=09*(.fixup)
 =09=09*(.gnu.warning)
 =09} :text =3D 0
--=20
2.30.0


