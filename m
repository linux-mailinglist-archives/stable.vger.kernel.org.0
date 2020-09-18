Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBE626EC2C
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgIRCKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbgIRCKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:10:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 235BE238E6;
        Fri, 18 Sep 2020 02:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395029;
        bh=aQq/XrNxqAThGtox7or18hiKFV/n0MaMqrF9FiZdhyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3XRR5ygipiwwRM6NcAl7exd9n9mQj2u/wVLK8bVfPKuSBFCni6w9pUgk12/K01Ne
         QTE/Z4AkwiXALz3KeaqpQqdgj4D9tfqd3TatXVW2LNmhNXThG8VPzkVQmbfpU3oGXz
         yurCmy2PSzLScCeuFmcztzkTvpaIIgP/TqcVtiRg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 122/206] serial: 8250: 8250_omap: Terminate DMA before pushing data on RX timeout
Date:   Thu, 17 Sep 2020 22:06:38 -0400
Message-Id: <20200918020802.2065198-122-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

