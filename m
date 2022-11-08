Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8936213B7
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbiKHNxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbiKHNwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:52:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68416238F
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:52:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EFF5DCE1B90
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A88C433D7;
        Tue,  8 Nov 2022 13:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915570;
        bh=YbJDCzntyljszkdocSNKenAEZCzvY3ittJ80/ueHqoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7GxXEZ7AtZ0LXmTStvexjo3/u/jgs8PsZLxdrNHm+8SPSwED3pdsgEQsgLfWzub9
         8W66wOSbE+jbUz5MBnumC0D0wMh0DxVMFBPcNwrnc92gWWP+uYoBY5YVl6PEd2Nugp
         8Gto9J10bILIhVq6YSybSTVWfbHgUm96B2U9DsZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/118] net: fec: fix improper use of NETDEV_TX_BUSY
Date:   Tue,  8 Nov 2022 14:38:26 +0100
Message-Id: <20221108133341.885111845@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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
index e183caf38176..686bb873125c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -623,7 +623,7 @@ fec_enet_txq_put_data_tso(struct fec_enet_priv_tx_q *txq, struct sk_buff *skb,
 		dev_kfree_skb_any(skb);
 		if (net_ratelimit())
 			netdev_err(ndev, "Tx DMA memory map failed\n");
-		return NETDEV_TX_BUSY;
+		return NETDEV_TX_OK;
 	}
 
 	bdp->cbd_datlen = cpu_to_fec16(size);
@@ -685,7 +685,7 @@ fec_enet_txq_put_hdr_tso(struct fec_enet_priv_tx_q *txq,
 			dev_kfree_skb_any(skb);
 			if (net_ratelimit())
 				netdev_err(ndev, "Tx DMA memory map failed\n");
-			return NETDEV_TX_BUSY;
+			return NETDEV_TX_OK;
 		}
 	}
 
-- 
2.35.1



