Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A142133B924
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhCOOFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230192AbhCOOBK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 152BE61477;
        Mon, 15 Mar 2021 14:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816835;
        bh=GTeUtwzfq/978IFxOmeHTwhMilYuUVY1oe7gQEu1PeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1tZju5bfeeMaAcNV/Zt1bhx9wi4OtuRNTKZKYSVWlpuah/TgfxjUtQdBJOxSM/++
         a16P3dNC48rvZhCV4TO5uESf+nH3Ep0h7L+pCIJGFgv5wb4UOwIKzydHCYtasQ6WB7
         0ER3wQthCXvx1/JLYOaQuPLtUEWhjC/PMpbp7ZdY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Volmat <alain.volmat@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/290] spi: stm32: make spurious and overrun interrupts visible
Date:   Mon, 15 Mar 2021 14:53:54 +0100
Message-Id: <20210315135546.680216630@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit c64e7efe46b7de21937ef4b3594d9b1fc74f07df ]

We do not expect to receive spurious interrupts so rise a warning
if it happens.

RX overrun is an error condition that signals a corrupted RX
stream both in dma and in irq modes. Report the error and
abort the transfer in either cases.

Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Link: https://lore.kernel.org/r/1612551572-495-9-git-send-email-alain.volmat@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 6eeb39669a86..53c4311cc6ab 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -928,8 +928,8 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 		mask |= STM32H7_SPI_SR_RXP;
 
 	if (!(sr & mask)) {
-		dev_dbg(spi->dev, "spurious IT (sr=0x%08x, ier=0x%08x)\n",
-			sr, ier);
+		dev_warn(spi->dev, "spurious IT (sr=0x%08x, ier=0x%08x)\n",
+			 sr, ier);
 		spin_unlock_irqrestore(&spi->lock, flags);
 		return IRQ_NONE;
 	}
@@ -956,15 +956,8 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 	}
 
 	if (sr & STM32H7_SPI_SR_OVR) {
-		dev_warn(spi->dev, "Overrun: received value discarded\n");
-		if (!spi->cur_usedma && (spi->rx_buf && (spi->rx_len > 0)))
-			stm32h7_spi_read_rxfifo(spi, false);
-		/*
-		 * If overrun is detected while using DMA, it means that
-		 * something went wrong, so stop the current transfer
-		 */
-		if (spi->cur_usedma)
-			end = true;
+		dev_err(spi->dev, "Overrun: RX data lost\n");
+		end = true;
 	}
 
 	if (sr & STM32H7_SPI_SR_EOT) {
-- 
2.30.1



