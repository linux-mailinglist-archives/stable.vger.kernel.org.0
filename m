Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40A54988AB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244961AbiAXStv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245391AbiAXStB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:49:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC75C06175A;
        Mon, 24 Jan 2022 10:49:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8E36B81221;
        Mon, 24 Jan 2022 18:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD59C340E5;
        Mon, 24 Jan 2022 18:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050138;
        bh=E9a2z6EE0+tnBwnlD62xWh25c50ZEbJkBrNw5rjdFOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=czX4fdPahi0UdTPeErm3eP3+FC0llFP5Loz0NE5wMlZqVKF3whMRzgl5DkONfnqfz
         pKygdJ5R+w63m1U5D/gcWLPMHr3t1EtBB5fExIryk9//gLbBtVpiJi3DFXhMDV7d2f
         ESZwqjETJdRGe3ecE+EIwg9M2HR8XM6lykEcDKAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 023/114] tty: serial: atmel: Check return code of dmaengine_submit()
Date:   Mon, 24 Jan 2022 19:41:58 +0100
Message-Id: <20220124183927.841121990@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit 1e67bd2b8cb90b66e89562598e9c2046246832d3 ]

The tx_submit() method of struct dma_async_tx_descriptor is entitled
to do sanity checks and return errors if encountered. It's not the
case for the DMA controller drivers that this client is using
(at_h/xdmac), because they currently don't do sanity checks and always
return a positive cookie at tx_submit() method. In case the controller
drivers will implement sanity checks and return errors, print a message
so that the client will be informed that something went wrong at
tx_submit() level.

Fixes: 08f738be88bb ("serial: at91: add tx dma support")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Acked-by: Richard Genoud <richard.genoud@gmail.com>
Link: https://lore.kernel.org/r/20211125090028.786832-3-tudor.ambarus@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/atmel_serial.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 3bd19de7df71b..be15061a14479 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -928,6 +928,11 @@ static void atmel_tx_dma(struct uart_port *port)
 		desc->callback = atmel_complete_tx_dma;
 		desc->callback_param = atmel_port;
 		atmel_port->cookie_tx = dmaengine_submit(desc);
+		if (dma_submit_error(atmel_port->cookie_tx)) {
+			dev_err(port->dev, "dma_submit_error %d\n",
+				atmel_port->cookie_tx);
+			return;
+		}
 	}
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
@@ -1186,6 +1191,11 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
 	desc->callback_param = port;
 	atmel_port->desc_rx = desc;
 	atmel_port->cookie_rx = dmaengine_submit(desc);
+	if (dma_submit_error(atmel_port->cookie_rx)) {
+		dev_err(port->dev, "dma_submit_error %d\n",
+			atmel_port->cookie_rx);
+		goto chan_err;
+	}
 
 	return 0;
 
-- 
2.34.1



