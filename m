Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BDF498BDD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346565AbiAXTRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:17:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44216 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348182AbiAXTPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:15:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1DED60917;
        Mon, 24 Jan 2022 19:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB3CC340E5;
        Mon, 24 Jan 2022 19:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051699;
        bh=iGX1mZJhwUEK5jqknqNU7KydGA/VgXiua29cyCulylc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=veKbQTb1tHPnnymKJK6OAzB67i0EO0Fxa7+E0cYkobkE7FhDrSf8NxBkU13qG8bM/
         QRa9eg1orF+U5hPIXX+fTKWVRR4FXGIDEI4ZwZdyeUR+1DHAoCMgakNvj8bmafe/6D
         7r3ZbPQ2erqoXVKTHCqWVSnZTB4hTE/bB5yca8iQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/239] tty: serial: atmel: Call dma_async_issue_pending()
Date:   Mon, 24 Jan 2022 19:41:36 +0100
Message-Id: <20220124183944.981674331@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit 4f4b9b5895614eb2e2b5f4cab7858f44bd113e1b ]

The driver wrongly assummed that tx_submit() will start the transfer,
which is not the case, now that the at_xdmac driver is fixed. tx_submit
is supposed to push the current transaction descriptor to a pending queue,
waiting for issue_pending to be called. issue_pending must start the
transfer, not tx_submit.

Fixes: 34df42f59a60 ("serial: at91: add rx dma support")
Fixes: 08f738be88bb ("serial: at91: add tx dma support")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20211125090028.786832-4-tudor.ambarus@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/atmel_serial.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index f6287d76b2984..3ba9ed36d6362 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -923,6 +923,8 @@ static void atmel_tx_dma(struct uart_port *port)
 				atmel_port->cookie_tx);
 			return;
 		}
+
+		dma_async_issue_pending(chan);
 	}
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
@@ -1187,6 +1189,8 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
 		goto chan_err;
 	}
 
+	dma_async_issue_pending(atmel_port->chan_rx);
+
 	return 0;
 
 chan_err:
-- 
2.34.1



