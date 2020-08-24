Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7765F250575
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgHXRQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:16:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbgHXQg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:36:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25AC922CF7;
        Mon, 24 Aug 2020 16:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286996;
        bh=WhrAFwOzk/Rx5uChKtXnYnxfBGZcnnRc64UJOZ28RDM=;
        h=From:To:Cc:Subject:Date:From;
        b=ZfZUntRf4rOkJ1EKFCGx4fq/Fo8+CaQ9UdZZbjkrACyjWCEBNv36S8FRD0tV1twOV
         cpEs2Uvz5+9jaCVnBzsOhfXcizJh1lc21KF3+7n1z+o90poSNW/xEi5Zk2TWZG8z0T
         B7niwUTNESJeZMEb3rgCkAywE3usPTRNHs2pcd1k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tobias Schramm <t.schramm@manjaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 01/54] spi: stm32: clear only asserted irq flags on interrupt
Date:   Mon, 24 Aug 2020 12:35:40 -0400
Message-Id: <20200824163634.606093-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Schramm <t.schramm@manjaro.org>

[ Upstream commit ae1ba50f1e706dfd7ce402ac52c1f1f10becad68 ]

Previously the stm32h7 interrupt thread cleared all non-masked interrupts.
If an interrupt was to occur during the handling of another interrupt its
flag would be unset, resulting in a lost interrupt.
This patches fixes the issue by clearing only the currently set interrupt
flags.

Signed-off-by: Tobias Schramm <t.schramm@manjaro.org>
Link: https://lore.kernel.org/r/20200804195136.1485392-1-t.schramm@manjaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 44ac6eb3298d4..ef3be03574e80 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -964,7 +964,7 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 		if (!spi->cur_usedma && (spi->rx_buf && (spi->rx_len > 0)))
 			stm32h7_spi_read_rxfifo(spi, false);
 
-	writel_relaxed(mask, spi->base + STM32H7_SPI_IFCR);
+	writel_relaxed(sr & mask, spi->base + STM32H7_SPI_IFCR);
 
 	spin_unlock_irqrestore(&spi->lock, flags);
 
-- 
2.25.1

