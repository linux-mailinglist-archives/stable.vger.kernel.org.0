Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C82499BFB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573847AbiAXV6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573899AbiAXVqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:46:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1ECAC08B4D0;
        Mon, 24 Jan 2022 12:32:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51CFE61512;
        Mon, 24 Jan 2022 20:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3691CC340E5;
        Mon, 24 Jan 2022 20:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056351;
        bh=8hJ9WSv+1YCuUgqJuulbIBv8+KsKLIxorvnJhi8rvSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zYKidgnZjQa15XMCJFCPOcnJC1cS+HSMGyI9PziKXthgqn7pP3yQLNYz6FDre7evO
         zEbZzSJKRsB6zPf955Ihmpi93nKoNc265LVs9R2XsK6U/ntLSkl1svFenD0l8zjmJz
         X/KrEo0MlIQjO+DABN9BtBek4otAvKkTuzTihuRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Nick Terrell <terrelln@fb.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 455/846] MIPS: compressed: Fix build with ZSTD compression
Date:   Mon, 24 Jan 2022 19:39:32 +0100
Message-Id: <20220124184116.671697604@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit c5c7440fe7f74645940d5c9e2c49cd7efb706a4f ]

Fix the following build issues:

mips64el-linux-ld: arch/mips/boot/compressed/decompress.o: in function `FSE_buildDTable_internal':
 decompress.c:(.text.FSE_buildDTable_internal+0x2cc): undefined reference to `__clzdi2'
   mips64el-linux-ld: arch/mips/boot/compressed/decompress.o: in function `BIT_initDStream':
   decompress.c:(.text.BIT_initDStream+0x7c): undefined reference to `__clzdi2'
   mips64el-linux-ld: decompress.c:(.text.BIT_initDStream+0x158): undefined reference to `__clzdi2'
   mips64el-linux-ld: arch/mips/boot/compressed/decompress.o: in function `ZSTD_buildFSETable_body_default.constprop.0':
 decompress.c:(.text.ZSTD_buildFSETable_body_default.constprop.0+0x2a8): undefined reference to `__clzdi2'
   mips64el-linux-ld: arch/mips/boot/compressed/decompress.o: in function `FSE_readNCount_body_default':
 decompress.c:(.text.FSE_readNCount_body_default+0x130): undefined reference to `__ctzdi2'
 mips64el-linux-ld: decompress.c:(.text.FSE_readNCount_body_default+0x1a4): undefined reference to `__ctzdi2'
 mips64el-linux-ld: decompress.c:(.text.FSE_readNCount_body_default+0x2e4): undefined reference to `__clzdi2'
   mips64el-linux-ld: arch/mips/boot/compressed/decompress.o: in function `HUF_readStats_body_default':
 decompress.c:(.text.HUF_readStats_body_default+0x184): undefined reference to `__clzdi2'
 mips64el-linux-ld: decompress.c:(.text.HUF_readStats_body_default+0x1b4): undefined reference to `__clzdi2'
   mips64el-linux-ld: arch/mips/boot/compressed/decompress.o: in function `ZSTD_DCtx_getParameter':
 decompress.c:(.text.ZSTD_DCtx_getParameter+0x60): undefined reference to `__clzdi2'

Fixes: a510b616131f ("MIPS: Add support for ZSTD-compressed kernels")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Nick Terrell <terrelln@fb.com>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/compressed/Makefile  | 2 +-
 arch/mips/boot/compressed/clz_ctz.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)
 create mode 100644 arch/mips/boot/compressed/clz_ctz.c

diff --git a/arch/mips/boot/compressed/Makefile b/arch/mips/boot/compressed/Makefile
index f53510d2f6296..705b9e7f8035a 100644
--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -56,7 +56,7 @@ $(obj)/uart-ath79.c: $(srctree)/arch/mips/ath79/early_printk.c
 
 vmlinuzobjs-$(CONFIG_KERNEL_XZ) += $(obj)/ashldi3.o
 
-vmlinuzobjs-$(CONFIG_KERNEL_ZSTD) += $(obj)/bswapdi.o $(obj)/ashldi3.o
+vmlinuzobjs-$(CONFIG_KERNEL_ZSTD) += $(obj)/bswapdi.o $(obj)/ashldi3.o $(obj)/clz_ctz.o
 
 extra-y += ashldi3.c
 $(obj)/ashldi3.c: $(obj)/%.c: $(srctree)/lib/%.c FORCE
diff --git a/arch/mips/boot/compressed/clz_ctz.c b/arch/mips/boot/compressed/clz_ctz.c
new file mode 100644
index 0000000000000..b4a1b6eb2f8ad
--- /dev/null
+++ b/arch/mips/boot/compressed/clz_ctz.c
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "../../../../lib/clz_ctz.c"
-- 
2.34.1



