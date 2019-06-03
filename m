Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2AA732C6F
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfFCJLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbfFCJLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:11:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DABF27E4B;
        Mon,  3 Jun 2019 09:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553082;
        bh=rrKoH+wLsNhDcMmgiH75B0ng71payu+f34ZXIwuEHJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LlyaM5bMR2bObpFlTHIxqJqOEgpdyY5iOmGa2xjLi1rymuOCNKEUxIpB5dUnb6G3K
         NTCcAy9vCiI56LYnWrH0XYrRQnMywxjFIs+lvYUJi9Qpq0AsdfMPqqk7iWElB3pBLn
         eV01GX8/IDhgi16nn0wX1X/JHabbnzNJapRYp+HA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 14/36] net: mvpp2: fix bad MVPP2_TXQ_SCHED_TOKEN_CNTR_REG queue value
Date:   Mon,  3 Jun 2019 11:09:02 +0200
Message-Id: <20190603090521.907589478@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
References: <20190603090520.998342694@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

[ Upstream commit 21808437214637952b61beaba6034d97880fbeb3 ]

MVPP2_TXQ_SCHED_TOKEN_CNTR_REG() expects the logical queue id but
the current code is passing the global tx queue offset, so it ends
up writing to unknown registers (between 0x8280 and 0x82fc, which
seemed to be unused by the hardware). This fixes the issue by using
the logical queue id instead.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1412,7 +1412,7 @@ static inline void mvpp2_xlg_max_rx_size
 /* Set defaults to the MVPP2 port */
 static void mvpp2_defaults_set(struct mvpp2_port *port)
 {
-	int tx_port_num, val, queue, ptxq, lrxq;
+	int tx_port_num, val, queue, lrxq;
 
 	if (port->priv->hw_version == MVPP21) {
 		/* Update TX FIFO MIN Threshold */
@@ -1433,11 +1433,9 @@ static void mvpp2_defaults_set(struct mv
 	mvpp2_write(port->priv, MVPP2_TXP_SCHED_FIXED_PRIO_REG, 0);
 
 	/* Close bandwidth for all queues */
-	for (queue = 0; queue < MVPP2_MAX_TXQ; queue++) {
-		ptxq = mvpp2_txq_phys(port->id, queue);
+	for (queue = 0; queue < MVPP2_MAX_TXQ; queue++)
 		mvpp2_write(port->priv,
-			    MVPP2_TXQ_SCHED_TOKEN_CNTR_REG(ptxq), 0);
-	}
+			    MVPP2_TXQ_SCHED_TOKEN_CNTR_REG(queue), 0);
 
 	/* Set refill period to 1 usec, refill tokens
 	 * and bucket size to maximum
@@ -2293,7 +2291,7 @@ static void mvpp2_txq_deinit(struct mvpp
 	txq->descs_dma         = 0;
 
 	/* Set minimum bandwidth for disabled TXQs */
-	mvpp2_write(port->priv, MVPP2_TXQ_SCHED_TOKEN_CNTR_REG(txq->id), 0);
+	mvpp2_write(port->priv, MVPP2_TXQ_SCHED_TOKEN_CNTR_REG(txq->log_id), 0);
 
 	/* Set Tx descriptors queue starting address and size */
 	thread = mvpp2_cpu_to_thread(port->priv, get_cpu());


