Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7DF200E61
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391534AbgFSPHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391523AbgFSPHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:07:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4548621835;
        Fri, 19 Jun 2020 15:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579224;
        bh=Ry7ffsonlHv7a5vi0afMmIH01N+u6fWs+CVFyp4Y7tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=14UOJBFBXzyfdWAyPQQ/4omCx0CJDYaIUkRMciZvAlSkCGpUu3C3B3xedhDGcqTEq
         NNDV1D6QV6v0vtIS35ktp9zDB8yd4cJaldJt724PygROhkfRT0wo5ibVSkRNdKQ4zl
         NSvf3z3iCTRM8EAIha0kIrkqO5JVjBPjoBujP/3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Georgy Vlasov <Georgy.Vlasov@baikalelectronics.ru>,
        Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Arnd Bergmann <arnd@arndb.de>, Feng Tang <feng.tang@intel.com>,
        Rob Herring <robh+dt@kernel.org>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/261] spi: dw: Fix Rx-only DMA transfers
Date:   Fri, 19 Jun 2020 16:31:04 +0200
Message-Id: <20200619141652.470882659@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 46164fde6b7890e7a3982d54549947c8394c0192 ]

Tx-only DMA transfers are working perfectly fine since in this case
the code just ignores the Rx FIFO overflow interrupts. But it turns
out the SPI Rx-only transfers are broken since nothing pushing any
data to the shift registers, so the Rx FIFO is left empty and the
SPI core subsystems just returns a timeout error. Since DW DMAC
driver doesn't support something like cyclic write operations of
a single byte to a device register, the only way to support the
Rx-only SPI transfers is to fake it by using a dummy Tx-buffer.
This is what we intend to fix in this commit by setting the
SPI_CONTROLLER_MUST_TX flag for DMA-capable platform.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Georgy Vlasov <Georgy.Vlasov@baikalelectronics.ru>
Cc: Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>
Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: devicetree@vger.kernel.org
Link: https://lore.kernel.org/r/20200529131205.31838-9-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 82c5c027ec4c..07d1c170c657 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -529,6 +529,7 @@ int dw_spi_add_host(struct device *dev, struct dw_spi *dws)
 			dws->dma_inited = 0;
 		} else {
 			master->can_dma = dws->dma_ops->can_dma;
+			master->flags |= SPI_CONTROLLER_MUST_TX;
 		}
 	}
 
-- 
2.25.1



