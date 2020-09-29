Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D6E27CB82
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732637AbgI2M2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729390AbgI2Lc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:32:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 468BF23B27;
        Tue, 29 Sep 2020 11:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378742;
        bh=aQq/XrNxqAThGtox7or18hiKFV/n0MaMqrF9FiZdhyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhHjNx9m8dGKvCgoRmRgSartO4+YWefoiNYKtwdGBhBUiVJ6TqLuf5+mH5D9t90qJ
         OBKI/NZfUO2m5sFmFWW5cLcamMMov8jFu3kT2JkA5F8Owmb1ZeF1JwLS4XhO6JSmpM
         qNSXHKZov2L1u4lPnI+2GJ0YaX9MhX/9osusNVRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 123/245] serial: 8250: 8250_omap: Terminate DMA before pushing data on RX timeout
Date:   Tue, 29 Sep 2020 12:59:34 +0200
Message-Id: <20200929105952.974223855@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 7cf4df30a98175033e9849f7f16c46e96ba47f41 ]

Terminate and flush DMA internal buffers, before pushing RX data to
higher layer. Otherwise, this will lead to data corruption, as driver
would end up pushing stale buffer data to higher layer while actual data
is still stuck inside DMA hardware and has yet not arrived at the
memory.
While at that, replace deprecated dmaengine_terminate_all() with
dmaengine_terminate_async().

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20200319110344.21348-2-vigneshr@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index a7e555e413a69..cbd006fb7fbb9 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -781,7 +781,10 @@ static void __dma_rx_do_complete(struct uart_8250_port *p)
 	dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
 
 	count = dma->rx_size - state.residue;
-
+	if (count < dma->rx_size)
+		dmaengine_terminate_async(dma->rxchan);
+	if (!count)
+		goto unlock;
 	ret = tty_insert_flip_string(tty_port, dma->rx_buf, count);
 
 	p->port.icount.rx += ret;
@@ -843,7 +846,6 @@ static void omap_8250_rx_dma_flush(struct uart_8250_port *p)
 	spin_unlock_irqrestore(&priv->rx_dma_lock, flags);
 
 	__dma_rx_do_complete(p);
-	dmaengine_terminate_all(dma->rxchan);
 }
 
 static int omap_8250_rx_dma(struct uart_8250_port *p)
-- 
2.25.1



