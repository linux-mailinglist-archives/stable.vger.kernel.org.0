Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E3E383052
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239367AbhEQO0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239472AbhEQOYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:24:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1EA86145F;
        Mon, 17 May 2021 14:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260765;
        bh=YU7iGQimgJ3VKI8wwRhRPYmvBuXUT0P50iE+cSKr+Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUMCK1dgrpfmjCW0YBFEjHpAJ1IVMmTtb3EX9bM35345G9gTCJcuol0uk/lxXrhGk
         pj0/cnahg8euzX14FiwkVPT2lOu/kYkRuzwYhNGdiueXiURYRCLmAoUvuEgDa+Cl0r
         qu3DJbpbHGOnTz7xqRqY7uou3ASXzTCkz6vMW2EA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 231/363] can: mcp251xfd: mcp251xfd_probe(): add missing can_rx_offload_del() in error path
Date:   Mon, 17 May 2021 16:01:37 +0200
Message-Id: <20210517140310.387940309@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 4376ea42db8bfcac2bc3a30bba93917244a8c2d4 ]

This patch adds the missing can_rx_offload_del(), that must be called
if mcp251xfd_register() fails.

Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Link: https://lore.kernel.org/r/20210504091838.1109047-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 15b04db6ed9c..4a742aa5c417 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2957,10 +2957,12 @@ static int mcp251xfd_probe(struct spi_device *spi)
 
 	err = mcp251xfd_register(priv);
 	if (err)
-		goto out_free_candev;
+		goto out_can_rx_offload_del;
 
 	return 0;
 
+ out_can_rx_offload_del:
+	can_rx_offload_del(&priv->offload);
  out_free_candev:
 	spi->max_speed_hz = priv->spi_max_speed_hz_orig;
 
-- 
2.30.2



