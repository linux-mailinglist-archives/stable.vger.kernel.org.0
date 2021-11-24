Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571C645C4B7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354505AbhKXNuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:50:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:41982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349776AbhKXNtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:49:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 601226334E;
        Wed, 24 Nov 2021 13:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758984;
        bh=zBhW86EEASlQcxMCzjwewFN754UMqiBKCuTk/UUBTKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOsl0FRazWv69NPeRClHwqdEgjXzc3s9gm8E+IXt6AmUqmOmT20JQAtE9vafgnVVF
         5ePHKSWZE3mR+xkHvXEYxoog8zfjPKAiX9YJBe9n/ApxBSJ1fdkTC7ho7dvKzmec5W
         XKybsbMo0q1AUwiM+LernpArbTPagCVYR1vVBBHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/279] MIPS: boot/compressed/: add __bswapdi2() to target for ZSTD decompression
Date:   Wed, 24 Nov 2021 12:56:22 +0100
Message-Id: <20211124115722.061558787@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit e2f4b3be1d3c73176db734565b160250cc1300dd ]

For MIPS pre-boot, when CONFIG_KERNEL_ZSTD=y, the decompressor
function uses __bswapdi2(), so this object file should be added to
the target object file.

Fixes these build errors:

mips-linux-ld: arch/mips/boot/compressed/decompress.o: in function `xxh64':
decompress.c:(.text+0x8be0): undefined reference to `__bswapdi2'
mips-linux-ld: decompress.c:(.text+0x8c78): undefined reference to `__bswapdi2'
mips-linux-ld: decompress.c:(.text+0x8d04): undefined reference to `__bswapdi2'
mips-linux-ld: arch/mips/boot/compressed/decompress.o:decompress.c:(.text+0xa010): more undefined references to `__bswapdi2' follow

Fixes: 0652035a5794 ("asm-generic: unaligned: remove byteshift helpers")
Fixes: cddc40f5617e ("mips: always link byteswap helpers into decompressor")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/compressed/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/mips/boot/compressed/Makefile b/arch/mips/boot/compressed/Makefile
index 3548b3b452699..9112bdb86be45 100644
--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -56,6 +56,8 @@ $(obj)/uart-ath79.c: $(srctree)/arch/mips/ath79/early_printk.c
 
 vmlinuzobjs-$(CONFIG_KERNEL_XZ) += $(obj)/ashldi3.o
 
+vmlinuzobjs-$(CONFIG_KERNEL_ZSTD) += $(obj)/bswapdi.o
+
 extra-y += ashldi3.c
 $(obj)/ashldi3.c: $(obj)/%.c: $(srctree)/lib/%.c FORCE
 	$(call if_changed,shipped)
@@ -64,6 +66,10 @@ extra-y += bswapsi.c
 $(obj)/bswapsi.c: $(obj)/%.c: $(srctree)/arch/mips/lib/%.c FORCE
 	$(call if_changed,shipped)
 
+extra-y += bswapdi.c
+$(obj)/bswapdi.c: $(obj)/%.c: $(srctree)/arch/mips/lib/%.c FORCE
+	$(call if_changed,shipped)
+
 targets := $(notdir $(vmlinuzobjs-y))
 
 targets += vmlinux.bin
-- 
2.33.0



