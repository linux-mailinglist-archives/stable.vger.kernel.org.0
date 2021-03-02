Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF64232AF2E
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhCCAPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:15:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1443527AbhCBMLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:11:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4338E64F5A;
        Tue,  2 Mar 2021 11:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686226;
        bh=ttBSAstuxahvrv6pryYeHwkR2zP2IIvHIkOm3LxkB/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWvWZ0zehZnFwlm1SuPprezHBsNpcwmzCOvBdSRtaniTLtfqhL+SoJcLfMuvjzOxZ
         UsEkA8Wxf2SWO5St91CBE7pS5yJ6pDKrEyT0SIvA99fo6YeoiwZa5L6yxukR1J+dsg
         Ja+VSuLSbpkDIHHZ0BL3yTamfHXIAZYWJFcRhPnKSVuKuN0ju80E93E7JooZew3H3F
         +gvoy4bXJFBq63wPG7N+LVks4UArhn7MVbJInzyE1lxSupNJS+waLyqfuFMWYanRbL
         PaHfVE+coev1yEL9FEacJOkQ6v7K91A1S8MkQckL3g/N0N2siqV5IMkn0lBCxj4x+R
         ecZKAb65FBs8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alain Volmat <alain.volmat@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 15/47] spi: stm32: make spurious and overrun interrupts visible
Date:   Tue,  2 Mar 2021 06:56:14 -0500
Message-Id: <20210302115646.62291-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
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
index 6017209c6d2f..4bcdad084801 100644
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

