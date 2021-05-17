Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33873835CC
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbhEQPZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244681AbhEQPVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:21:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BB8C61C8B;
        Mon, 17 May 2021 14:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262083;
        bh=DxU9+nY6tUwW5jIzX0NGUV+BeSAfbINP9dmdrOB1P94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttSHEJbvov0Zy4fd7vTnOKft+4Oep5RHv3UpYyaWROH0UfT7o2Lt4Vo4FLU3oufCz
         6zarWE8L3liAfTXusioWDm3CSLIS5inFUKAkA4uzPpfC+qIol5LSp8wk2A6+c7bhaf
         IW1oryBfNhNSJs/0N2ngmEg7itbOv4uDg1J0lK04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 213/329] can: mcp251xfd: mcp251xfd_probe(): add missing can_rx_offload_del() in error path
Date:   Mon, 17 May 2021 16:02:04 +0200
Message-Id: <20210517140309.338787062@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index ee39e79927ef..486dbd3357aa 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2947,10 +2947,12 @@ static int mcp251xfd_probe(struct spi_device *spi)
 
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



