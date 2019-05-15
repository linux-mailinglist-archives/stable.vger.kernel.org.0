Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFC41EFEB
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732758AbfEOLak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732752AbfEOLaj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:30:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EDE920843;
        Wed, 15 May 2019 11:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919839;
        bh=X8flbAO2akxSEzZQ8zHamo1pcx8klqpvg+NacVqQhnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMEZAO+UIRwKqg+BiZZnXQXWOjtppPJoIuPCGqsCl8pVgXmIgE5R13wyObxEbGQua
         NMuOc6EJBro2El++8krvlQurm64hKfhqlR1MZZB0do6cGZh18vSmYefOvZOdkRhqso
         BPgRw2k0Csj5E/QOGx961QRgc9WRJV3gbxm4GoS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 112/137] net: macb: Change interrupt and napi enable order in open
Date:   Wed, 15 May 2019 12:56:33 +0200
Message-Id: <20190515090701.711180496@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

[ Upstream commit 0504453139ef5a593c9587e1e851febee859c7d8 ]

Current order in open:
-> Enable interrupts (macb_init_hw)
-> Enable NAPI
-> Start PHY

Sequence of RX handling:
-> RX interrupt occurs
-> Interrupt is cleared and interrupt bits disabled in handler
-> NAPI is scheduled
-> In NAPI, RX budget is processed and RX interrupts are re-enabled

With the above, on QEMU or fixed link setups (where PHY state doesn't
matter), there's a chance macb RX interrupt occurs before NAPI is
enabled. This will result in NAPI being scheduled before it is enabled.
Fix this macb open by changing the order.

Fixes: ae1f2a56d273 ("net: macb: Added support for many RX queues")
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2414,12 +2414,12 @@ static int macb_open(struct net_device *
 		return err;
 	}
 
-	bp->macbgem_ops.mog_init_rings(bp);
-	macb_init_hw(bp);
-
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
 		napi_enable(&queue->napi);
 
+	bp->macbgem_ops.mog_init_rings(bp);
+	macb_init_hw(bp);
+
 	/* schedule a link state check */
 	phy_start(dev->phydev);
 


