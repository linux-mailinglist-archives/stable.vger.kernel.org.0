Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F20313288
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 13:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhBHMjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 07:39:23 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:15053 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbhBHMiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 07:38:51 -0500
Date:   Mon, 08 Feb 2021 12:37:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612787866; bh=koAMeATYJYWKmkFiz3wj+nM7gDgJYPD0x5UJ1gcespo=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=a6WMNoFmMqa0DSoaxn/SdvYQwTY+MQyEcCVxUJ00mURZdp8lg2LUC7OPODuhmmXGw
         loPJv2L0iKeN7nZQCcXqQ233p7LPNLyZkahtEbf53ALNVmJ4ajiqq1J0KAvgCFTIMN
         OHbUQy3DQBDTFP6GphtqZFnfex1HhaqFTA5zxrQGangF6SFSn2mIx7K4mv19BeVxzV
         dSoqb3RvhIn7q/zY1kwVD0/bx1oSLP1zEjt8t35Kbu7YWLTxjxP+mk47YunuCq60wK
         lDb3wsEzvPpfydmHELCTmQUqHWZiVNTv9GwGP84tH71hIvHY/+w6lRC3B/w4cmmdxT
         3lDpVmzqX8X7w==
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Alexander Lobakin <alobakin@pm.me>,
        Youling Tang <tangyouling@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Xingxing Su <suxingxing@loongson.cn>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH mips-fixes] MIPS: compressed: fix build with enabled UBSAN
Message-ID: <20210208123645.101354-1-alobakin@pm.me>
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

Commit 1e35918ad9d1 ("MIPS: Enable Undefined Behavior Sanitizer
UBSAN") added a possibility to build the entire kernel with UBSAN
instrumentation for MIPS, with the exception for VDSO.
However, self-extracting head wasn't been added to exceptions, so
this occurs:

mips-alpine-linux-musl-ld: arch/mips/boot/compressed/decompress.o:
in function `FSE_buildDTable_wksp':
decompress.c:(.text.FSE_buildDTable_wksp+0x278): undefined reference
to `__ubsan_handle_shift_out_of_bounds'
mips-alpine-linux-musl-ld: decompress.c:(.text.FSE_buildDTable_wksp+0x2a8):
undefined reference to `__ubsan_handle_shift_out_of_bounds'
mips-alpine-linux-musl-ld: decompress.c:(.text.FSE_buildDTable_wksp+0x2c4):
undefined reference to `__ubsan_handle_shift_out_of_bounds'
mips-alpine-linux-musl-ld: arch/mips/boot/compressed/decompress.o:
decompress.c:(.text.FSE_buildDTable_raw+0x9c): more undefined references
to `__ubsan_handle_shift_out_of_bounds' follow

Add UBSAN_SANITIZE :=3D n to mips/boot/compressed/Makefile to exclude
it from instrumentation scope and fix this issue.

Fixes: 1e35918ad9d1 ("MIPS: Enable Undefined Behavior Sanitizer UBSAN")
Cc: stable@vger.kernel.org # 5.0+
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 arch/mips/boot/compressed/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/boot/compressed/Makefile b/arch/mips/boot/compressed=
/Makefile
index 47cd9dc7454a..f93f72bcba97 100644
--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -37,6 +37,7 @@ KBUILD_AFLAGS :=3D $(KBUILD_AFLAGS) -D__ASSEMBLY__ \
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
 KCOV_INSTRUMENT=09=09:=3D n
 GCOV_PROFILE :=3D n
+UBSAN_SANITIZE :=3D n
=20
 # decompressor objects (linked with vmlinuz)
 vmlinuzobjs-y :=3D $(obj)/head.o $(obj)/decompress.o $(obj)/string.o
--=20
2.30.0


