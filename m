Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B603D75E3
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbhG0NTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:19:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236641AbhG0NTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:19:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 886FA61A7F;
        Tue, 27 Jul 2021 13:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391953;
        bh=EYzzl8gg1iWuIJJmqTaoMdjVzD7xtB1AJagLb8jwHic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1KutB1WjBvLSOQkW0m6TlS5DgI7uhSdumqjhRZfnr26mTU/Jc3Csms12tnF74qKb
         qvdKF/4wrBpXUygH0avxdFAakTN0/ZaTMlEbwy071rLeaqvNoOpZTr6kOgvq985/mO
         eWrHQw9Hh1t5GkVuBDk/p5YPMcxoSM6I8Aw/RaAPC0cZV+201gRardAvpxo4AgURV2
         Iwyjt/dHGJu/y8GSod/79Fs5VCZBQwwc4X0cDjjm8BDb4xO0QOt7Vf54sYx4RVkYBY
         ZJ9pv/JvsE+iH9qzIV+RzUZx7G8eK1mYHxMf6NQMQ7y8/jJWKBVRBa9E+QteIKxath
         s28V48qq9DQGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alain Volmat <alain.volmat@foss.st.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 03/21] spi: stm32h7: fix full duplex irq handler handling
Date:   Tue, 27 Jul 2021 09:18:50 -0400
Message-Id: <20210727131908.834086-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131908.834086-1-sashal@kernel.org>
References: <20210727131908.834086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 8ffcffbb8157..65b37c8dc49f 100644
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

