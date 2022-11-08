Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D19621349
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbiKHNsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbiKHNsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:48:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BCABC9C
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:48:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1B2461567
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B444C433C1;
        Tue,  8 Nov 2022 13:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915324;
        bh=do7kudJUKvNGpL2gTZfxRyNWQBJq1n57jFBhGmKH0Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMjZnMPxkqNBHdCpDTkgvlTe6c0pGB0XL5ePtibyo4Ng0mmKCVFDEudrd/1X0JLzD
         Bd5Ym7ItwhdG8cdMwSvgX01STuPvplafWq0t5SAif3Nc3sL2dovsZNs3vMEv+n94A9
         pGftL2oG7uuwkapJAhHWGOQvYPEW0UY+NDoerirM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/74] net: fec: fix improper use of NETDEV_TX_BUSY
Date:   Tue,  8 Nov 2022 14:38:39 +0100
Message-Id: <20221108133334.138327344@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 06a4df5863f73af193a4ff7abf7cb04058584f06 ]

The ndo_start_xmit() method must not free skb when returning
NETDEV_TX_BUSY, since caller is going to requeue freed skb.

Fix it by returning NETDEV_TX_OK in case of dma_map_single() fails.

Fixes: 79f339125ea3 ("net: fec: Add software TSO support")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a31f891d51fb..e1b8c58c4d6b 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -626,7 +626,7 @@ fec_enet_txq_put_data_tso(struct fec_enet_priv_tx_q *txq, struct sk_buff *skb,
 		dev_kfree_skb_any(skb);
 		if (net_ratelimit())
 			netdev_err(ndev, "Tx DMA memory map failed\n");
-		return NETDEV_TX_BUSY;
+		return NETDEV_TX_OK;
 	}
 
 	bdp->cbd_datlen = cpu_to_fec16(size);
@@ -688,7 +688,7 @@ fec_enet_txq_put_hdr_tso(struct fec_enet_priv_tx_q *txq,
 			dev_kfree_skb_any(skb);
 			if (net_ratelimit())
 				netdev_err(ndev, "Tx DMA memory map failed\n");
-			return NETDEV_TX_BUSY;
+			return NETDEV_TX_OK;
 		}
 	}
 
-- 
2.35.1



