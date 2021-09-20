Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29073411A85
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244144AbhITQuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:50:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243455AbhITQsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:48:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E2BE611ED;
        Mon, 20 Sep 2021 16:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156432;
        bh=K5KXSD+jjQeXzcQALgpzdggOZ4F9iGSoMqVje5/6ttU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsW7kRa9DGRxX4hbFgEev4DClEJJR4a1PjWjwAQ1CaUEp+18r/0j68jOl5/p/i2hG
         OEQJLExxSg6H+cHvIKKMrDZGQFOH6Nkc9FbNIsz9Tv+Z+Z+6hyk/EeLPva55McSPZj
         mEm6j/P6U0twpDFUxYavh50KghoDivDSpy4JvUCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Esben Haabendal <esben@geanix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 024/133] net: ll_temac: Remove left-over debug message
Date:   Mon, 20 Sep 2021 18:41:42 +0200
Message-Id: <20210920163913.403413583@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>

commit ce03b94ba682a67e8233c9ee3066071656ded58f upstream.

Fixes: f63963411942 ("net: ll_temac: Avoid ndo_start_xmit returning NETDEV_TX_BUSY")
Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -735,10 +735,8 @@ temac_start_xmit(struct sk_buff *skb, st
 	/* Kick off the transfer */
 	lp->dma_out(lp, TX_TAILDESC_PTR, tail_p); /* DMA start */
 
-	if (temac_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
-		netdev_info(ndev, "%s -> netif_stop_queue\n", __func__);
+	if (temac_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
 		netif_stop_queue(ndev);
-	}
 
 	return NETDEV_TX_OK;
 }


