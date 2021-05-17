Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A802B3836F2
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245179AbhEQPiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243734AbhEQPf6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:35:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F7E561CEA;
        Mon, 17 May 2021 14:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262394;
        bh=MwOCbBcfvlb0ciXm2Mc6pB0nprG2EIV1HA5/KJiix2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjoMjzz4Nghy2rjfcmyJoKPPR7sLgiTNMat3+JXXLQDv4K3azNSIQ21UdRAS4mUKE
         Vbm193/scZlSZUZ4k/3Y+UGLFUPKz910xtSQcUX21qJ2JdqOs/6sAe1c7hen/vWEzH
         3HGD2lRXBtxJCYw+Xuxw223s5o1pk+hCFC2xoe/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/289] can: mcp251xfd: mcp251xfd_probe(): add missing can_rx_offload_del() in error path
Date:   Mon, 17 May 2021 16:01:43 +0200
Message-Id: <20210517140311.110782258@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
index 096d818c167e..68ff931993c2 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2870,10 +2870,12 @@ static int mcp251xfd_probe(struct spi_device *spi)
 
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



