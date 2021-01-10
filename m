Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363A42F06BF
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 12:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbhAJLyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 06:54:45 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:17908 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbhAJLyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 06:54:45 -0500
Date:   Sun, 10 Jan 2021 11:53:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610279636; bh=e+CceW4cTSMaSiEXVZcdatIqUeP8AJi4B5rdzKiTWXc=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=FBoH46m0JJOf+Mn9CgCEuL4rdSIL1n0YXYcAAVT69BLb+xDN7BH68mxBzUtgiOKXB
         OQYCCc7upTbzvRT4dBDL+Fa8nHH3kYn7rLN/xsyVFkxCTbPc75vWpN9NR9hd9nELkS
         V/rb0ZpHTYU1UUaqoXuC5diaIqiJHKxamOtdnWuNRWzV4bpI/8ttijqyRtJkDzl/xQ
         1/srqKG6F0uvhzx7GsDS5/Xxq9Eqh82KAOlzKZkkx72DjPtCCRrG8jjFFFAgy6w7Oe
         BqFjT2VnsDtF6tWS88RcW+9j3Pq9Jlc5bLXnoyfNulvbq99PrEGA+qgw1M0W7S1ayl
         k3YYy74DVPnjw==
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
Subject: [PATCH v5 mips-next 0/9] MIPS: vmlinux.lds.S sections fixes & cleanup
Message-ID: <20210110115245.30762-1-alobakin@pm.me>
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

This series hunts the problems discovered after manual enabling of
ARCH_WANT_LD_ORPHAN_WARN. Notably:
 - adds the missing PAGE_ALIGNED_DATA() section affecting VDSO
   placement (marked for stable);
 - stops blind catching of orphan text sections with .text.*
   directive;
 - properly stops .eh_frame section generation.

Compile and runtime tested on MIPS32R2 CPS board with no issues
using two different toolkits:
 - Binutils 2.35.1, GCC 10.2.1 (with Alpine patches);
 - LLVM stack: 11.0.0 and from latest Git snapshot.

Since v4 [3]:
 - new: drop redundant .text.cps-vec creation and blind inclusion
   of orphan text sections via .text.* directive in vmlinux.lds.S;
 - don't assert SIZEOF(.rel.dyn) as it's reported that it may be not
   empty on certain machines and compilers (Thomas);
 - align GOT table like it's done for ARM64;
 - new: catch UBSAN's "unnamed data" sections in generic definitions
   when building with LD_DEAD_CODE_DATA_ELIMINATION;
 - collect Reviewed-bys (Kees, Nathan).

Since v3 [2]:
 - fix the third patch as GNU stack emits .rel.dyn into VDSO for
   some reason if .cfi_sections is specified.

Since v2 [1]:
 - stop discarding .eh_frame and just prevent it from generating
   (Kees);
 - drop redundant sections assertions (Fangrui);
 - place GOT table in .text instead of asserting as it's not empty
   when building with LLVM (Nathan);
 - catch compound literals in generic definitions when building with
   LD_DEAD_CODE_DATA_ELIMINATION (Kees);
 - collect two Reviewed-bys (Kees).

Since v1 [0]:
 - catch .got entries too as LLD may produce it (Nathan);
 - check for unwanted sections to be zero-sized instead of
   discarding (Fangrui).

[0] https://lore.kernel.org/linux-mips/20210104121729.46981-1-alobakin@pm.m=
e
[1] https://lore.kernel.org/linux-mips/20210106200713.31840-1-alobakin@pm.m=
e
[2] https://lore.kernel.org/linux-mips/20210107115120.281008-1-alobakin@pm.=
me
[3] https://lore.kernel.org/linux-mips/20210107123331.354075-1-alobakin@pm.=
me

Alexander Lobakin (9):
  MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section
  MIPS: CPS: don't create redundant .text.cps-vec section
  MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
  MIPS: properly stop .eh_frame generation
  MIPS: vmlinux.lds.S: explicitly catch .rel.dyn symbols
  MIPS: vmlinux.lds.S: explicitly declare .got table
  vmlinux.lds.h: catch compound literals into data and BSS
  vmlinux.lds.h: catch UBSAN's "unnamed data" into data
  MIPS: select ARCH_WANT_LD_ORPHAN_WARN

 arch/mips/Kconfig                 |  1 +
 arch/mips/include/asm/asm.h       | 18 ++++++++++++++++++
 arch/mips/kernel/cps-vec.S        |  1 -
 arch/mips/kernel/vmlinux.lds.S    | 11 +++++++++--
 include/asm-generic/vmlinux.lds.h |  6 +++---
 5 files changed, 31 insertions(+), 6 deletions(-)

--=20
2.30.0


