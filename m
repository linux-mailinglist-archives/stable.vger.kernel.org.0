Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC32450E9B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240914AbhKOSQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:16:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240686AbhKOSLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:11:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A62A76329A;
        Mon, 15 Nov 2021 17:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998468;
        bh=Yr5MWcSH8vL+VOxhzPRgyUoe+naXLj3rYSzfBsNCDMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TYM2Pdi1u4qJRnrUiCTOLMXq8R8Jc9EYWPX0lsVsUgJu2wjSzM/MSM62fDaJpqHmU
         uxTaxsV46ocuG29tVZCcioiOAKatPovgrYezYZgTSs3h1qw4ZWh/UnOGBTq18PFysq
         xJ10wcRagKZPEV6OY/5XmswDWVaF0/eIC458o4pM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 520/575] can: mcp251xfd: mcp251xfd_chip_start(): fix error handling for mcp251xfd_chip_rx_int_enable()
Date:   Mon, 15 Nov 2021 18:04:05 +0100
Message-Id: <20211115165401.657661613@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 69c55f6e7669d46bb40e41f6e2b218428178368a ]

This patch fixes the error handling for mcp251xfd_chip_rx_int_enable().
Instead just returning the error, properly shut down the chip.

Link: https://lore.kernel.org/all/20211106201526.44292-2-mkl@pengutronix.de
Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 68ff931993c25..4e13f6dfb91a2 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1041,7 +1041,7 @@ static int mcp251xfd_chip_start(struct mcp251xfd_priv *priv)
 
 	err = mcp251xfd_chip_rx_int_enable(priv);
 	if (err)
-		return err;
+		goto out_chip_stop;
 
 	err = mcp251xfd_chip_ecc_init(priv);
 	if (err)
-- 
2.33.0



