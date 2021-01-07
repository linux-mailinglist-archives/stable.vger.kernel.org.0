Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47112ECFE1
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 13:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbhAGMeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 07:34:31 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:31388 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728090AbhAGMeb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 07:34:31 -0500
X-Greylist: delayed 2405 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jan 2021 07:34:29 EST
Date:   Thu, 07 Jan 2021 12:33:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610022823; bh=cGGCdvWu4PwKRz1S12Mzu82QSX0n1m3RhliddwWOBIo=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=g46HgMEoNVFPYStTMl2U0tiPPlynTb67J8pWxwlfvVy6Em26mrnGfYXJ/NHnzF9C0
         2l0iJxG1l6L2MQmeYZiPk5ENNdy7OPJYqqUNgs8l5ON/RdkT7ZICusXDnJal0o/X3i
         Tj4cO9W6AOsYzEJ0gxL2+BDdGBbhOUiaYSHhiaYiMvQthW9Prgz9YMLvzYTSsqwFzf
         Y1JjpqrCobMYSRQ+oCsp1mj+LhXd0yY23z00kpxeH166K/JShx6Ws84LoZP/ZUU6Ty
         4BRvaE0wALd41ERV9FeUwIZ0F7w7LKZEhl03kCs89rDDh8rRI5ktvz8h0G0KHnV8m6
         XoOQIqhKZCu+Q==
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
Subject: [PATCH v4 mips-next 0/7] MIPS: vmlinux.lds.S sections fixes & cleanup
Message-ID: <20210107123331.354075-1-alobakin@pm.me>
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
 - properly stops .eh_frame section generation.

Compile and runtime tested on MIPS32R2 CPS board with no issues
using two different toolkits:
 - Binutils 2.35.1, GCC 10.2.0;
 - LLVM stack 11.0.0.

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

Alexander Lobakin (7):
  MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section
  MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
  MIPS: properly stop .eh_frame generation
  MIPS: vmlinux.lds.S: catch bad .rel.dyn at link time
  MIPS: vmlinux.lds.S: explicitly declare .got table
  vmlinux.lds.h: catch compound literals into data and BSS
  MIPS: select ARCH_WANT_LD_ORPHAN_WARN

 arch/mips/Kconfig                 |  1 +
 arch/mips/include/asm/asm.h       | 18 ++++++++++++++++++
 arch/mips/kernel/vmlinux.lds.S    | 15 ++++++++++++++-
 include/asm-generic/vmlinux.lds.h |  6 +++---
 4 files changed, 36 insertions(+), 4 deletions(-)

--=20
2.30.0


