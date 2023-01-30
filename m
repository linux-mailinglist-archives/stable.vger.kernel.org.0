Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411416810EE
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237127AbjA3OIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237130AbjA3OIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:08:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C7938028
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:08:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8A26B81151
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FB0C433EF;
        Mon, 30 Jan 2023 14:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087706;
        bh=RF+eZ5QPDwfrxVrFaV5K/BFJwCf2699qjYjEo4z5ggk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEQtM+mqoZGTZ+bi+T6qEVsWIBB7LRgaPzn+W8SLLjfIiN/1uZRxWDuncrHyXfiNr
         dkumvGb7E3Uenikzvr8nH+9i857OmphcUG0R/wpuWdC6JpSWZcqExlUKOmkSBBC7LU
         nkHoukESicZAoKSTFlWWDFMIR7srCy0K74e7MrXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 296/313] tsnep: Fix TX queue stop/wake for multiple queues
Date:   Mon, 30 Jan 2023 14:52:11 +0100
Message-Id: <20230130134350.527364792@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerhard Engleder <gerhard@engleder-embedded.com>

[ Upstream commit 3d53aaef4332245044b2f3688ac0ea10436c719c ]

netif_stop_queue() and netif_wake_queue() act on TX queue 0. This is ok
as long as only a single TX queue is supported. But support for multiple
TX queues was introduced with 762031375d5c and I missed to adapt stop
and wake of TX queues.

Use netif_stop_subqueue() and netif_tx_wake_queue() to act on specific
TX queue.

Fixes: 762031375d5c ("tsnep: Support multiple TX/RX queue pairs")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Link: https://lore.kernel.org/r/20230124191440.56887-1-gerhard@engleder-embedded.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 13d5ff4e0e02..6bf3cc11d212 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -419,7 +419,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 		/* ring full, shall not happen because queue is stopped if full
 		 * below
 		 */
-		netif_stop_queue(tx->adapter->netdev);
+		netif_stop_subqueue(tx->adapter->netdev, tx->queue_index);
 
 		spin_unlock_irqrestore(&tx->lock, flags);
 
@@ -462,7 +462,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 
 	if (tsnep_tx_desc_available(tx) < (MAX_SKB_FRAGS + 1)) {
 		/* ring can get full with next frame */
-		netif_stop_queue(tx->adapter->netdev);
+		netif_stop_subqueue(tx->adapter->netdev, tx->queue_index);
 	}
 
 	spin_unlock_irqrestore(&tx->lock, flags);
@@ -472,11 +472,14 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 
 static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 {
+	struct tsnep_tx_entry *entry;
+	struct netdev_queue *nq;
 	unsigned long flags;
 	int budget = 128;
-	struct tsnep_tx_entry *entry;
-	int count;
 	int length;
+	int count;
+
+	nq = netdev_get_tx_queue(tx->adapter->netdev, tx->queue_index);
 
 	spin_lock_irqsave(&tx->lock, flags);
 
@@ -533,8 +536,8 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 	} while (likely(budget));
 
 	if ((tsnep_tx_desc_available(tx) >= ((MAX_SKB_FRAGS + 1) * 2)) &&
-	    netif_queue_stopped(tx->adapter->netdev)) {
-		netif_wake_queue(tx->adapter->netdev);
+	    netif_tx_queue_stopped(nq)) {
+		netif_tx_wake_queue(nq);
 	}
 
 	spin_unlock_irqrestore(&tx->lock, flags);
-- 
2.39.0



