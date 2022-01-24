Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68D4499440
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388882AbiAXUkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385569AbiAXUdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:33:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2F9C07E2AC;
        Mon, 24 Jan 2022 11:46:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 685C86131E;
        Mon, 24 Jan 2022 19:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49974C340E5;
        Mon, 24 Jan 2022 19:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053617;
        bh=H1hFsvuFf55B6JVRQj672EgOQJOv6pp5Kk5rrycgc9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZ2if9Uhajqg6wITfg7Nj0uDMIXSIDsxMdAB9Zsbtn9iStWpgXM07/WAOpIYPCNM/
         +m/hFHEJSoMizZLXFYp8CEMXDlLnt88Yy/1bR0+65twGC2lsY1vmCPLVSBy83UQ6ap
         OjR5jxCKYBK5TwyK7hRsXbLx3HaIK7b1w23febtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/563] tty: serial: atmel: Call dma_async_issue_pending()
Date:   Mon, 24 Jan 2022 19:37:50 +0100
Message-Id: <20220124184028.030130227@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 396fe8c51f93b..602065bfc9bb8 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1009,6 +1009,8 @@ static void atmel_tx_dma(struct uart_port *port)
 				atmel_port->cookie_tx);
 			return;
 		}
+
+		dma_async_issue_pending(chan);
 	}
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
@@ -1275,6 +1277,8 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
 		goto chan_err;
 	}
 
+	dma_async_issue_pending(atmel_port->chan_rx);
+
 	return 0;
 
 chan_err:
-- 
2.34.1



