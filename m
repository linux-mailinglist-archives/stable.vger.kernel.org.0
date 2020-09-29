Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D37027CD6B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgI2Mny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbgI2LJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:09:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE04A21D7F;
        Tue, 29 Sep 2020 11:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377769;
        bh=CRsjg3TOysFEb6PVC+Iq4aSMLT6JDEkSutZn15IF4Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6n50FkVq4xQAWyxweEez3ywVOkNZV/x8gNJhSLJaufTUsfihKPDoXf4WR7eQoaxi
         xXtGeHV2m14sdgbgQclGt/xrNnjngg0tx5IRNWohBf4+l7/j34lbXqRT+AKad6KMx/
         WZbFNiShjOjoChe3Kaufy+KP0BLQmLS1RiGNiEwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 066/121] serial: 8250: 8250_omap: Terminate DMA before pushing data on RX timeout
Date:   Tue, 29 Sep 2020 13:00:10 +0200
Message-Id: <20200929105933.439485483@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
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
index 7d4680ef5307d..d41be02abced2 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -773,7 +773,10 @@ static void __dma_rx_do_complete(struct uart_8250_port *p)
 	dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
 
 	count = dma->rx_size - state.residue;
-
+	if (count < dma->rx_size)
+		dmaengine_terminate_async(dma->rxchan);
+	if (!count)
+		goto unlock;
 	ret = tty_insert_flip_string(tty_port, dma->rx_buf, count);
 
 	p->port.icount.rx += ret;
@@ -811,7 +814,6 @@ static void omap_8250_rx_dma_flush(struct uart_8250_port *p)
 	spin_unlock_irqrestore(&priv->rx_dma_lock, flags);
 
 	__dma_rx_do_complete(p);
-	dmaengine_terminate_all(dma->rxchan);
 }
 
 static int omap_8250_rx_dma(struct uart_8250_port *p)
-- 
2.25.1



