Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6578E1F27F0
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731766AbgFHXZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731769AbgFHXZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:25:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 424ED20872;
        Mon,  8 Jun 2020 23:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658712;
        bh=ihRGke3F8C3EzU5YHRa+sfbGeIHPfno11X1+nn+coJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hAf7lJS2ptma0Jn7gHKHqWVkULVjwubcx9Czt0eWNIC0XqIobams3Q9jKqH6WjPhh
         LLxEgYK8k/qz7Dn69YHxC6k5LKb8So6NQ67UlP2cZFHO72mIQOaCSpDv1kJc6cHll2
         7fdzS3V3bui5RW/WuFlloglgAbyllxgack0RgGGQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/72] spi: dw: Zero DMA Tx and Rx configurations on stack
Date:   Mon,  8 Jun 2020 19:23:57 -0400
Message-Id: <20200608232500.3369581-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232500.3369581-1-sashal@kernel.org>
References: <20200608232500.3369581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3cb97e223d277f84171cc4ccecab31e08b2ee7b5 ]

Some DMA controller drivers do not tolerate non-zero values in
the DMA configuration structures. Zero them to avoid issues with
such DMA controller drivers. Even despite above this is a good
practice per se.

Fixes: 7063c0d942a1 ("spi/dw_spi: add DMA support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Feng Tang <feng.tang@intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Link: https://lore.kernel.org/r/20200506153025.21441-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-mid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index 837cb8d0bac6..4f41d44e8b4c 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -155,6 +155,7 @@ static struct dma_async_tx_descriptor *dw_spi_dma_prepare_tx(struct dw_spi *dws,
 	if (!xfer->tx_buf)
 		return NULL;
 
+	memset(&txconf, 0, sizeof(txconf));
 	txconf.direction = DMA_MEM_TO_DEV;
 	txconf.dst_addr = dws->dma_addr;
 	txconf.dst_maxburst = 16;
@@ -201,6 +202,7 @@ static struct dma_async_tx_descriptor *dw_spi_dma_prepare_rx(struct dw_spi *dws,
 	if (!xfer->rx_buf)
 		return NULL;
 
+	memset(&rxconf, 0, sizeof(rxconf));
 	rxconf.direction = DMA_DEV_TO_MEM;
 	rxconf.src_addr = dws->dma_addr;
 	rxconf.src_maxburst = 16;
-- 
2.25.1

