Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01A13E259E
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244081AbhHFIVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243538AbhHFIUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:20:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDC2161211;
        Fri,  6 Aug 2021 08:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238006;
        bh=FiM9Ouxl3/T/dWjCq1Yq1eASepxBbDOq7itEEDXVa9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mf3l0uB9tBf+9/JhK+SCXpI1i1x/M86LFCnNFaE98GMVQXJAi9g/54b8tIr3/I+wZ
         7Lt7DUdDw8p3aasH8kbT3FmFSiLbwHkOSlgYXMmCpUY5tmpv2Q2h4cnq1CaXHnh6Vg
         IDoAEB53akJWObtNzwJDPfdgXcQuWwgQIbE8CxEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Alain Volmat <alain.volmat@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 16/35] spi: stm32h7: fix full duplex irq handler handling
Date:   Fri,  6 Aug 2021 10:16:59 +0200
Message-Id: <20210806081114.252079907@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit e4a5c19888a5f8a9390860ca493e643be58c8791 ]

In case of Full-Duplex mode, DXP flag is set when RXP and TXP flags are
set. But to avoid 2 different handlings, just add TXP and RXP flag in
the mask instead of DXP, and then keep the initial handling of TXP and
RXP events.
Also rephrase comment about EOTIE which is one of the interrupt enable
bits. It is not triggered by any event.

Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Reviewed-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/1625042723-661-3-git-send-email-alain.volmat@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index a92a28933edb..05618a618939 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -884,15 +884,18 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 	ier = readl_relaxed(spi->base + STM32H7_SPI_IER);
 
 	mask = ier;
-	/* EOTIE is triggered on EOT, SUSP and TXC events. */
+	/*
+	 * EOTIE enables irq from EOT, SUSP and TXC events. We need to set
+	 * SUSP to acknowledge it later. TXC is automatically cleared
+	 */
+
 	mask |= STM32H7_SPI_SR_SUSP;
 	/*
-	 * When TXTF is set, DXPIE and TXPIE are cleared. So in case of
-	 * Full-Duplex, need to poll RXP event to know if there are remaining
-	 * data, before disabling SPI.
+	 * DXPIE is set in Full-Duplex, one IT will be raised if TXP and RXP
+	 * are set. So in case of Full-Duplex, need to poll TXP and RXP event.
 	 */
-	if (spi->rx_buf && !spi->cur_usedma)
-		mask |= STM32H7_SPI_SR_RXP;
+	if ((spi->cur_comm == SPI_FULL_DUPLEX) && !spi->cur_usedma)
+		mask |= STM32H7_SPI_SR_TXP | STM32H7_SPI_SR_RXP;
 
 	if (!(sr & mask)) {
 		dev_warn(spi->dev, "spurious IT (sr=0x%08x, ier=0x%08x)\n",
-- 
2.30.2



