Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5FB03CE190
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349315AbhGSP0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348088AbhGSPYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D022B61420;
        Mon, 19 Jul 2021 16:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710493;
        bh=ynxWwos6ThPE3LdqM4qwi1zF9hkoNni01RHbrBSvwtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNi5LHxW831pWnOjYGIfubFw77u7Uv1Xph19x0FPxgJIw4j+pXc2G+xSxrEzArrEe
         zF8i7yrDCSrlTg3WW0BdR3pWTw5ot/OIpJh1hzdjc6TcY8PvrXVCH+dBLzf4CCPVjZ
         UxFW7HtApKgXfgT8rmUe5P2COKFRpWs3SewslBuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 239/243] mips: always link byteswap helpers into decompressor
Date:   Mon, 19 Jul 2021 16:54:28 +0200
Message-Id: <20210719144948.637353837@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit cddc40f5617e53f97ef019d5b29c1bd6cbb031ec ]

My series to clean up the unaligned access implementation
across architectures caused some mips randconfig builds to
fail with:

   mips64-linux-ld: arch/mips/boot/compressed/decompress.o: in function `decompress_kernel':
   decompress.c:(.text.decompress_kernel+0x54): undefined reference to `__bswapsi2'

It turns out that this problem has already been fixed for the XZ
decompressor but now it also shows up in (at least) LZO and LZ4.  From my
analysis I concluded that the compiler could always have emitted those
calls, but the different implementation allowed it to make otherwise
better decisions about not inlining the byteswap, which results in the
link error when the out-of-line code is missing.

While it could be addressed by adding it to the two decompressor
implementations that are known to be affected, but as this only adds
112 bytes to the kernel, the safer choice is to always add them.

Fixes: c50ec6787536 ("MIPS: zboot: Fix the build with XZ compression on older GCC versions")
Fixes: 0652035a5794 ("asm-generic: unaligned: remove byteshift helpers")
Link: https://lore.kernel.org/linux-mm/202106301304.gz2wVY9w-lkp@intel.com/
Link: https://lore.kernel.org/linux-mm/202106260659.TyMe8mjr-lkp@intel.com/
Link: https://lore.kernel.org/linux-mm/202106172016.onWT6Tza-lkp@intel.com/
Link: https://lore.kernel.org/linux-mm/202105231743.JJcALnhS-lkp@intel.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/compressed/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/boot/compressed/Makefile b/arch/mips/boot/compressed/Makefile
index 337ab1d18cc1..eae0fad30f27 100644
--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -39,7 +39,7 @@ KCOV_INSTRUMENT		:= n
 UBSAN_SANITIZE := n
 
 # decompressor objects (linked with vmlinuz)
-vmlinuzobjs-y := $(obj)/head.o $(obj)/decompress.o $(obj)/string.o
+vmlinuzobjs-y := $(obj)/head.o $(obj)/decompress.o $(obj)/string.o $(obj)/bswapsi.o
 
 ifdef CONFIG_DEBUG_ZBOOT
 vmlinuzobjs-$(CONFIG_DEBUG_ZBOOT)		   += $(obj)/dbg.o
@@ -53,7 +53,7 @@ extra-y += uart-ath79.c
 $(obj)/uart-ath79.c: $(srctree)/arch/mips/ath79/early_printk.c
 	$(call cmd,shipped)
 
-vmlinuzobjs-$(CONFIG_KERNEL_XZ) += $(obj)/ashldi3.o $(obj)/bswapsi.o
+vmlinuzobjs-$(CONFIG_KERNEL_XZ) += $(obj)/ashldi3.o
 
 extra-y += ashldi3.c
 $(obj)/ashldi3.c: $(obj)/%.c: $(srctree)/lib/%.c FORCE
-- 
2.30.2



