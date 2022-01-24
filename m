Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4354499BC7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1458049AbiAXVzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354658AbiAXVqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:46:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D6DC00365E;
        Mon, 24 Jan 2022 12:32:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A05EB812A4;
        Mon, 24 Jan 2022 20:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CD3C340E5;
        Mon, 24 Jan 2022 20:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056348;
        bh=MVdRqYa1p9ZJ0mIo1ZiaJWdNN13LKLT2GhdK1wfH3g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ql97tln4FsYfckKDQCr0S7FShIhdCMxO3IKtBKvVnokqZ9bffiLy6jHfDXFuvsfkk
         q3PjFuCoo6Am4UYrODzWL54lDKgLasF3r+QxmQgmrkiGKizcE3ZmSxVznEQcCjU+Z+
         QyzZMqAP/Lf2BXAvF5Om5pNFJdjtlNaltl+S0Gfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 454/846] MIPS: boot/compressed/: add __ashldi3 to target for ZSTD compression
Date:   Mon, 24 Jan 2022 19:39:31 +0100
Message-Id: <20220124184116.641582776@linuxfoundation.org>
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

[ Upstream commit fbf3bce458214bb971d3d571515b3b129eac290b ]

Just like before with __bswapdi2(), for MIPS pre-boot when
CONFIG_KERNEL_ZSTD=y the decompressor function will use __ashldi3(), so
the object file should be added to the target object file.

Fixes these build errors:

mipsel-linux-ld: arch/mips/boot/compressed/decompress.o: in function `FSE_buildDTable_internal':
decompress.c:(.text.FSE_buildDTable_internal+0x48): undefined reference to `__ashldi3'
mipsel-linux-ld: arch/mips/boot/compressed/decompress.o: in function `FSE_decompress_wksp_body_default':
decompress.c:(.text.FSE_decompress_wksp_body_default+0xa8): undefined reference to `__ashldi3'
mipsel-linux-ld: arch/mips/boot/compressed/decompress.o: in function `ZSTD_getFrameHeader_advanced':
decompress.c:(.text.ZSTD_getFrameHeader_advanced+0x134): undefined reference to `__ashldi3'

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/compressed/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/boot/compressed/Makefile b/arch/mips/boot/compressed/Makefile
index 9112bdb86be45..f53510d2f6296 100644
--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -56,7 +56,7 @@ $(obj)/uart-ath79.c: $(srctree)/arch/mips/ath79/early_printk.c
 
 vmlinuzobjs-$(CONFIG_KERNEL_XZ) += $(obj)/ashldi3.o
 
-vmlinuzobjs-$(CONFIG_KERNEL_ZSTD) += $(obj)/bswapdi.o
+vmlinuzobjs-$(CONFIG_KERNEL_ZSTD) += $(obj)/bswapdi.o $(obj)/ashldi3.o
 
 extra-y += ashldi3.c
 $(obj)/ashldi3.c: $(obj)/%.c: $(srctree)/lib/%.c FORCE
-- 
2.34.1



