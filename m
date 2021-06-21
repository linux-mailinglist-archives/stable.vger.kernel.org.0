Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8C13AEF57
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhFUQhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231488AbhFUQfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60CD1613EB;
        Mon, 21 Jun 2021 16:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292891;
        bh=T635PmZqw00LVOjHU601srM16cHxEV08q50yxS3l3uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yN42L+zKCeAqcUCWCFqc6z4w107mtOpbi8IzChU4yZD4B0FLuoH+0xq58WycAevzz
         X68jziSJlOlUDOI8yd/8BtTmdwNjh0UG7+t9Q9e8mpuD0dFV03nxd2oleOBGX1sQDj
         TRsP/t0JJoNY1XzRf2rC5gkzNERqjAF/Cz9F5rvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>, Stefan Roese <sr@denx.de>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 005/178] dmaengine: ALTERA_MSGDMA depends on HAS_IOMEM
Date:   Mon, 21 Jun 2021 18:13:39 +0200
Message-Id: <20210621154921.592179062@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 253697b93c2a1c237d34d3ae326e394aeb0ca7b3 ]

When CONFIG_HAS_IOMEM is not set/enabled, certain iomap() family
functions [including ioremap(), devm_ioremap(), etc.] are not
available.
Drivers that use these functions should depend on HAS_IOMEM so that
they do not cause build errors.

Repairs this build error:
s390-linux-ld: drivers/dma/altera-msgdma.o: in function `request_and_map':
altera-msgdma.c:(.text+0x14b0): undefined reference to `devm_ioremap'

Fixes: a85c6f1b2921 ("dmaengine: Add driver for Altera / Intel mSGDMA IP core")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Stefan Roese <sr@denx.de>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Reviewed-by: Stefan Roese <sr@denx.de>
Phone: (+49)-8142-66989-51 Fax: (+49)-8142-66989-80 Email: sr@denx.de
Link: https://lore.kernel.org/r/20210522021313.16405-2-rdunlap@infradead.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 0c2827fd8c19..03b1b0334947 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -59,6 +59,7 @@ config DMA_OF
 #devices
 config ALTERA_MSGDMA
 	tristate "Altera / Intel mSGDMA Engine"
+	depends on HAS_IOMEM
 	select DMA_ENGINE
 	help
 	  Enable support for Altera / Intel mSGDMA controller.
-- 
2.30.2



