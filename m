Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93321406BC4
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhIJMeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233860AbhIJMds (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:33:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AB83611C8;
        Fri, 10 Sep 2021 12:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277157;
        bh=cdjEQ/kpWEpUpDdNkuO6BUlZv/6B0KdbAw4YAavMNFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RmlodpLZJDa3e/TgxN50rwHzKKgH86lLcg33CuIWEQS3LJcGN2b3YVVdwQmBhXxX4
         6g/UHqOf44b6cxot5VrkURS/Tdi6KO/MMUMs+tbhUCMincuLz51uaVW5Lb34uwowBw
         giW9T/ReD9mN6GzJpqdp1GlxY2vUk9d8KSfrSt2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Esben Haabendal <esben@geanix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 03/22] net: ll_temac: Remove left-over debug message
Date:   Fri, 10 Sep 2021 14:30:02 +0200
Message-Id: <20210910122916.049315669@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122915.942645251@linuxfoundation.org>
References: <20210910122915.942645251@linuxfoundation.org>
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
@@ -942,10 +942,8 @@ temac_start_xmit(struct sk_buff *skb, st
 	wmb();
 	lp->dma_out(lp, TX_TAILDESC_PTR, tail_p); /* DMA start */
 
-	if (temac_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
-		netdev_info(ndev, "%s -> netif_stop_queue\n", __func__);
+	if (temac_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
 		netif_stop_queue(ndev);
-	}
 
 	return NETDEV_TX_OK;
 }


