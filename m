Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6801840A0DE
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349719AbhIMWme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244688AbhIMWkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:40:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDCBE61261;
        Mon, 13 Sep 2021 22:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572563;
        bh=gP/FR+RTc1p6XswCaxsB4txWoB8XWZyhR7RIfruoL6E=;
        h=From:To:Cc:Subject:Date:From;
        b=BbnGFEkhklw/u/ewiCdsm3MaxbkIr5wTE9U36O1ggdaxfsnBhSG0xfkAN3o4/4UJH
         xZ1rAWdnuzoYhV33kQteAARpwuyEYIk9G0uxlwh4Mq8JhFuLH6swKOaRKtN1xDmJuQ
         MRWG/Y4Hx0FrNng9eyBW6HiY6wwjOvyeqVWZTeKZEFl6DjyPS+Rn4tNpkXNXhB/Sid
         eoZcN9HiYhzv2ANUNxnGagc2d4IHcYyZeDjE+T20nu6EkeNH9Xkm4XVYUWip3FRpn+
         FRc+7NSFApgaWZaJPWvNCkjO3TAEvCiCqFZ3D+RXq0exfPHL38AODK1yp8LOjgMdYG
         60wQl4dJaZM6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/8] dmaengine: ioat: depends on !UML
Date:   Mon, 13 Sep 2021 18:35:54 -0400
Message-Id: <20210913223601.436675-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit bbac7a92a46f0876e588722ebe552ddfe6fd790f ]

Now that UML has PCI support, this driver must depend also on
!UML since it pokes at X86_64 architecture internals that don't
exist on ARCH=um.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20210809112409.a3a0974874d2.I2ffe3d11ed37f735da2f39884a74c953b258b995@changeid
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index e6cd1a32025a..f450f3d8f63a 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -239,7 +239,7 @@ config INTEL_IDMA64
 
 config INTEL_IOATDMA
 	tristate "Intel I/OAT DMA support"
-	depends on PCI && X86_64
+	depends on PCI && X86_64 && !UML
 	select DMA_ENGINE
 	select DMA_ENGINE_RAID
 	select DCA
-- 
2.30.2

