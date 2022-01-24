Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D49A498F07
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357402AbiAXTt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:49:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50538 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351483AbiAXT1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:27:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B967B81233;
        Mon, 24 Jan 2022 19:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8FCC340E7;
        Mon, 24 Jan 2022 19:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052429;
        bh=5dfdM11Vu6Ql+YgfcST9a+l5HW3BDYKh79+zoWWMh4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZ1cPx3hIB0yidB/wuqUA7i/JB83qx1CyypujD+rY8z6I5vrjxCJ/TOPbsG92UgZ8
         l0AnfepAiJJmDiMNG1fhJcf3f3dGfu2Jr0lewBa4pm+oI/Z2x0pwGsAgOx+qKHTTIW
         lj7xixKgydn4sAP3JVo+FxSJO3Gn6LdoI0E1cJQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/320] tty: serial: atmel: Call dma_async_issue_pending()
Date:   Mon, 24 Jan 2022 19:40:38 +0100
Message-Id: <20220124183955.577865981@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index da076493b336a..3b2c25bd2e06b 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1007,6 +1007,8 @@ static void atmel_tx_dma(struct uart_port *port)
 				atmel_port->cookie_tx);
 			return;
 		}
+
+		dma_async_issue_pending(chan);
 	}
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
@@ -1273,6 +1275,8 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
 		goto chan_err;
 	}
 
+	dma_async_issue_pending(atmel_port->chan_rx);
+
 	return 0;
 
 chan_err:
-- 
2.34.1



