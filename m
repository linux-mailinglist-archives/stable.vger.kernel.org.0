Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5821F2651
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730803AbgFHXhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:37:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732241AbgFHX2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:28:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 846982089D;
        Mon,  8 Jun 2020 23:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658920;
        bh=Ec9E1Z1Kggiu9aSgVolMP5zrSre0Y3RZiZbp6pW4Gz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/ia1UA8nibxF6/m26MtEGkXNeVugPk79K0Thgh9drICPU9FybzNnKXqL+hNt9C67
         0DmmNujX04x0WfbRE1TBXxwNZIZaANPGsqm9M8jVhOTQ2KE8vNd3iYesOS3Red9urY
         7xkCzppnkk26TpFCqyNyCglQsvEwQKgfRH6Bjwj0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Georgy Vlasov <Georgy.Vlasov@baikalelectronics.ru>,
        Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Rob Herring <robh+dt@kernel.org>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 35/37] spi: dw: Return any value retrieved from the dma_transfer callback
Date:   Mon,  8 Jun 2020 19:27:47 -0400
Message-Id: <20200608232750.3370747-35-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232750.3370747-1-sashal@kernel.org>
References: <20200608232750.3370747-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit f0410bbf7d0fb80149e3b17d11d31f5b5197873e ]

DW APB SSI DMA-part of the driver may need to perform the requested
SPI-transfer synchronously. In that case the dma_transfer() callback
will return 0 as a marker of the SPI transfer being finished so the
SPI core doesn't need to wait and may proceed with the SPI message
trasnfers pumping procedure. This will be needed to fix the problem
when DMA transactions are finished, but there is still data left in
the SPI Tx/Rx FIFOs being sent/received. But for now make dma_transfer
to return 1 as the normal dw_spi_transfer_one() method.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Georgy Vlasov <Georgy.Vlasov@baikalelectronics.ru>
Cc: Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>
Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: devicetree@vger.kernel.org
Link: https://lore.kernel.org/r/20200529131205.31838-3-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-mid.c | 2 +-
 drivers/spi/spi-dw.c     | 7 ++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index bd116f117b02..14902efae621 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -274,7 +274,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, struct spi_transfer *xfer)
 		dma_async_issue_pending(dws->txchan);
 	}
 
-	return 0;
+	return 1;
 }
 
 static void mid_spi_dma_stop(struct dw_spi *dws)
diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 4edd38d03b93..3667f8860aaf 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -382,11 +382,8 @@ static int dw_spi_transfer_one(struct spi_master *master,
 
 	spi_enable_chip(dws, 1);
 
-	if (dws->dma_mapped) {
-		ret = dws->dma_ops->dma_transfer(dws, transfer);
-		if (ret < 0)
-			return ret;
-	}
+	if (dws->dma_mapped)
+		return dws->dma_ops->dma_transfer(dws, transfer);
 
 	if (chip->poll_mode)
 		return poll_transfer(dws);
-- 
2.25.1

