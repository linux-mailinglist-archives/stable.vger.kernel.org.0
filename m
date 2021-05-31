Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E52F395F14
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhEaOHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:07:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232561AbhEaOFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:05:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A2D661960;
        Mon, 31 May 2021 13:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468320;
        bh=ROmstazyoaFNN3theMl0eig7ltzXRdcQMLKvT3gtATw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISkvwxMLAKdhf5XGIDJiXFV9c/0NyVS4cy5l7ca3QrZN89uBYOQd/rjK9LVF88gTs
         WEMAn5fFasLiNyXSgf0fV6gmpTtlcT2zEnpODUYsv3kLq2WsgQsIwDnWQ6h4YCesaw
         UN8SsVwFirvHH0cGNoSI2EzqImJF/5eyKsNiazAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/252] net: fec: fix the potential memory leak in fec_enet_init()
Date:   Mon, 31 May 2021 15:14:25 +0200
Message-Id: <20210531130704.811954649@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

[ Upstream commit 619fee9eb13b5d29e4267cb394645608088c28a8 ]

If the memory allocated for cbd_base is failed, it should
free the memory allocated for the queues, otherwise it causes
memory leak.

And if the memory allocated for the queues is failed, it can
return error directly.

Fixes: 59d0f7465644 ("net: fec: init multi queue date structure")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 55c28fbc5f9e..960def41cc55 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3277,7 +3277,9 @@ static int fec_enet_init(struct net_device *ndev)
 		return ret;
 	}
 
-	fec_enet_alloc_queue(ndev);
+	ret = fec_enet_alloc_queue(ndev);
+	if (ret)
+		return ret;
 
 	bd_size = (fep->total_tx_ring_size + fep->total_rx_ring_size) * dsize;
 
@@ -3285,7 +3287,8 @@ static int fec_enet_init(struct net_device *ndev)
 	cbd_base = dmam_alloc_coherent(&fep->pdev->dev, bd_size, &bd_dma,
 				       GFP_KERNEL);
 	if (!cbd_base) {
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto free_queue_mem;
 	}
 
 	/* Get the Ethernet address */
@@ -3363,6 +3366,10 @@ static int fec_enet_init(struct net_device *ndev)
 		fec_enet_update_ethtool_stats(ndev);
 
 	return 0;
+
+free_queue_mem:
+	fec_enet_free_queue(ndev);
+	return ret;
 }
 
 #ifdef CONFIG_OF
-- 
2.30.2



