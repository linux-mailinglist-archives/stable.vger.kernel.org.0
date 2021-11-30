Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242C24637A9
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhK3Oza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:55:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47362 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242757AbhK3Oxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:53:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE439B81A25;
        Tue, 30 Nov 2021 14:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD5CC5832A;
        Tue, 30 Nov 2021 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283810;
        bh=TxDUDD+NY1vlTmpxRejy48pXmN0PgBZt689ynrVMYc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfxPvqkXCL1S/5RfcTVy7YEGKpJvJ5IOdRVjNxjwqhaAjdo2/DweEXnAgkOWtavrf
         0NotKw5Pj/zvzGwAZQN1RfOPunXZimaeKVesjIj1vwqtvmMh0VCQC5bdoyfdp4RV+Z
         ED2ueklgNKpQGylDVMKSNb6KKJSQ6DbiyK0O4UEJvmSpGwBdbcpY8LAkVB7I8dcBlH
         jnGMzi6weFzMZcY26jSBmuQmqrNcacjf5FzcYSFLAVAplYmeDc5ZUJ+WdUQmbu2jrn
         h0PxJgg0yjlX3KqPcaXxhlQFKd8MujMmRs3Dujof02V0fc0kHZNCBtlVhG2h1VvGOX
         ejkL5LHS+P2NQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, arnd@arndb.de,
        masahiroy@kernel.org, suxingxing@loongson.cn, alobakin@pm.me,
        zhaoxiao@uniontech.com, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 62/68] MIPS: boot/compressed/: add __ashldi3 to target for ZSTD compression
Date:   Tue, 30 Nov 2021 09:46:58 -0500
Message-Id: <20211130144707.944580-62-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
2.33.0

