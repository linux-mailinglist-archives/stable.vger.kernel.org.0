Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3128260418C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbiJSKpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbiJSKoa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:44:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDEF1578BD;
        Wed, 19 Oct 2022 03:20:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C018B823B0;
        Wed, 19 Oct 2022 08:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75ED2C433C1;
        Wed, 19 Oct 2022 08:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169546;
        bh=dVDJSEzRrPtFqIsoE3zXwmOWCE8M6Zw0BQZP6LOW0Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKqM23aaQh5eGBkp3tyKgTLhQQtBauVikuDueIY3SJdsxmi/vXwM1VynbO/bBGgQu
         xtXMUUCmxbG6ok1UlwVArRAR7gos7OlEF7+cfhDAfGVSA97lDa6EfNaU5T2vgkshMO
         25MOW0xomKMxwbFX12AEo/abSYFJbV5DjXGM6c/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 318/862] cw1200: fix incorrect check to determine if no element is found in list
Date:   Wed, 19 Oct 2022 10:26:45 +0200
Message-Id: <20221019083304.064274432@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

[ Upstream commit 86df5de5c632d3bd940f59bbb14ae912aa9cc363 ]

The bug is here: "} else if (item) {".

The list iterator value will *always* be set and non-NULL by
list_for_each_entry(), so it is incorrect to assume that the iterator
value will be NULL if the list is empty or no element is found in list.

Use a new value 'iter' as the list iterator, while use the old value
'item' as a dedicated pointer to point to the found element, which
1. can fix this bug, due to now 'item' is NULL only if it's not found.
2. do not need to change all the uses of 'item' after the loop.
3. can also limit the scope of the list iterator 'iter' *only inside*
   the traversal loop by simply declaring 'iter' inside the loop in the
   future, as usage of the iterator outside of the list_for_each_entry
   is considered harmful. https://lkml.org/lkml/2022/2/17/1032

Fixes: a910e4a94f692 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220413091723.17596-1-xiam0nd.tong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/queue.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/queue.c b/drivers/net/wireless/st/cw1200/queue.c
index e06da4b3b0d4..805a3c1bf8fe 100644
--- a/drivers/net/wireless/st/cw1200/queue.c
+++ b/drivers/net/wireless/st/cw1200/queue.c
@@ -91,23 +91,25 @@ static void __cw1200_queue_gc(struct cw1200_queue *queue,
 			      bool unlock)
 {
 	struct cw1200_queue_stats *stats = queue->stats;
-	struct cw1200_queue_item *item = NULL, *tmp;
+	struct cw1200_queue_item *item = NULL, *iter, *tmp;
 	bool wakeup_stats = false;
 
-	list_for_each_entry_safe(item, tmp, &queue->queue, head) {
-		if (time_is_after_jiffies(item->queue_timestamp + queue->ttl))
+	list_for_each_entry_safe(iter, tmp, &queue->queue, head) {
+		if (time_is_after_jiffies(iter->queue_timestamp + queue->ttl)) {
+			item = iter;
 			break;
+		}
 		--queue->num_queued;
-		--queue->link_map_cache[item->txpriv.link_id];
+		--queue->link_map_cache[iter->txpriv.link_id];
 		spin_lock_bh(&stats->lock);
 		--stats->num_queued;
-		if (!--stats->link_map_cache[item->txpriv.link_id])
+		if (!--stats->link_map_cache[iter->txpriv.link_id])
 			wakeup_stats = true;
 		spin_unlock_bh(&stats->lock);
 		cw1200_debug_tx_ttl(stats->priv);
-		cw1200_queue_register_post_gc(head, item);
-		item->skb = NULL;
-		list_move_tail(&item->head, &queue->free_pool);
+		cw1200_queue_register_post_gc(head, iter);
+		iter->skb = NULL;
+		list_move_tail(&iter->head, &queue->free_pool);
 	}
 
 	if (wakeup_stats)
-- 
2.35.1



