Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05C232AFFF
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbhCCAaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:30:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350766AbhCBMub (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:50:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E9C164F86;
        Tue,  2 Mar 2021 11:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686283;
        bh=JxBOvQlb1mV3WHzKwhlOFEdlY0k8MJZTgRuw+0Gkp5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqf370pCtxv/9RNoR5hlUuVNvQ5FKwfEZ6AO/RAnkKgilZ2CTtaf6ijKp7EadryFI
         RIQIJTWovgBxYfWDITQu3wC0t5+DisXN35n1duOuXERvJrMfkaz7PyLf2R6ZT1zjB1
         Ya2nj+eQzryYbsHFby8K3hPnchkaq57jeOzk7o7iNCDFc8aXMwibYVtwM92W6us3nO
         BE62qlUPu2l0j9pX/QwvZxcWM9jslWe0XXbc3WJcw6k8gzbGX65/oRmTAVKJ42LMdk
         wynrv6UWU7vqvdgMaIXTJlze0V+Q8/lT9bFLstmIDgeuf++XSiZ8DzndeEzUg3swSt
         lVoHc36bDoQHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alain Volmat <alain.volmat@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 10/33] spi: stm32: make spurious and overrun interrupts visible
Date:   Tue,  2 Mar 2021 06:57:26 -0500
Message-Id: <20210302115749.62653-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115749.62653-1-sashal@kernel.org>
References: <20210302115749.62653-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 77ddf23b65d6..c7546683fc80 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -924,8 +924,8 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 		mask |= STM32H7_SPI_SR_RXP;
 
 	if (!(sr & mask)) {
-		dev_dbg(spi->dev, "spurious IT (sr=0x%08x, ier=0x%08x)\n",
-			sr, ier);
+		dev_warn(spi->dev, "spurious IT (sr=0x%08x, ier=0x%08x)\n",
+			 sr, ier);
 		spin_unlock_irqrestore(&spi->lock, flags);
 		return IRQ_NONE;
 	}
@@ -952,15 +952,8 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
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

