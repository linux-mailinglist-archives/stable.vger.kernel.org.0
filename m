Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B035D18B5F2
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbgCSNWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730263AbgCSNWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:22:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC383214D8;
        Thu, 19 Mar 2020 13:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624161;
        bh=apxNGTTawxO88AhaRt5S23Z7rTLns5Lk95jgyvF3/SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDHO1qh/tATPTNXbA1JwlRnbM2AXiZKOJw1rjpVVEGgCvIWIMyCsKhiZIhm2iAKo8
         8mjXTpreQjPQdZfBmkiXdBsenOeyQQpD+ME+/5Fn31YfUAK9qCoF9tti6jhcOEtk5I
         vcRbxXiwjRlV333mbqUhrfaqNnaniKbal5Usa1CY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Esben Haabendal <esben@geanix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/60] net: ll_temac: Fix race condition causing TX hang
Date:   Thu, 19 Mar 2020 14:04:06 +0100
Message-Id: <20200319123928.418978918@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 84823ff80f7403752b59e00bb198724100dc611c ]

It is possible that the interrupt handler fires and frees up space in
the TX ring in between checking for sufficient TX ring space and
stopping the TX queue in temac_start_xmit. If this happens, the
queue wake from the interrupt handler will occur before the queue is
stopped, causing a lost wakeup and the adapter's transmit hanging.

To avoid this, after stopping the queue, check again whether there is
sufficient space in the TX ring. If so, wake up the queue again.

This is a port of the similar fix in axienet driver,
commit 7de44285c1f6 ("net: axienet: Fix race condition causing TX hang").

Fixes: 23ecc4bde21f ("net: ll_temac: fix checksum offload logic")
Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 21c1b4322ea78..fd578568b3bff 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -788,6 +788,9 @@ static void temac_start_xmit_done(struct net_device *ndev)
 		stat = be32_to_cpu(cur_p->app0);
 	}
 
+	/* Matches barrier in temac_start_xmit */
+	smp_mb();
+
 	netif_wake_queue(ndev);
 }
 
@@ -830,9 +833,19 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 
 	if (temac_check_tx_bd_space(lp, num_frag + 1)) {
-		if (!netif_queue_stopped(ndev))
-			netif_stop_queue(ndev);
-		return NETDEV_TX_BUSY;
+		if (netif_queue_stopped(ndev))
+			return NETDEV_TX_BUSY;
+
+		netif_stop_queue(ndev);
+
+		/* Matches barrier in temac_start_xmit_done */
+		smp_mb();
+
+		/* Space might have just been freed - check again */
+		if (temac_check_tx_bd_space(lp, num_frag))
+			return NETDEV_TX_BUSY;
+
+		netif_wake_queue(ndev);
 	}
 
 	cur_p->app0 = 0;
-- 
2.20.1



