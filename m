Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED05C18920C
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgCQX2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:11 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53676 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgCQX2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FTOabC+rJR7j1uJd5HxWpykPFnXydgznWx/hYwgEPrk=;
        b=kDnWMwdGJH5IyUIBMnBcRQemPuBrR2bMpXSFgOVcqQqQP5312Xl7KpSqFnqqvvLZK7VvEB
        wmyutRPnDQYuN8e0L+iOZaNWIC+7H+6XCkjeRuh9rqaWdKsFEqa6veLewOoaKvyBjHXqTY
        UptTHD/ronRXu4FfjAOAF3pXPu5YDws=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 29/48] batman-adv: Fix lock for ogm cnt access in batadv_iv_ogm_calc_tq
Date:   Wed, 18 Mar 2020 00:27:15 +0100
Message-Id: <20200317232734.6127-30-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 5ba7dcfe77037b67016263ea597a8b431692ecab upstream.

The originator node object orig_neigh_node is used to when accessing the
bcast_own(_sum) and real_packet_count information. The access to them has
to be protected with the spinlock in orig_neigh_node.

But the function uses the lock in orig_node instead. This is incorrect
because they could be two different originator node objects.

Fixes: 0ede9f41b217 ("batman-adv: protect bit operations to count OGMs with spinlock")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/bat_iv_ogm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 749b9157fe11..910889dd5356 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1180,7 +1180,7 @@ static int batadv_iv_ogm_calc_tq(struct batadv_orig_node *orig_node,
 	orig_node->last_seen = jiffies;
 
 	/* find packet count of corresponding one hop neighbor */
-	spin_lock_bh(&orig_node->bat_iv.ogm_cnt_lock);
+	spin_lock_bh(&orig_neigh_node->bat_iv.ogm_cnt_lock);
 	if_num = if_incoming->if_num;
 	orig_eq_count = orig_neigh_node->bat_iv.bcast_own_sum[if_num];
 	neigh_ifinfo = batadv_neigh_ifinfo_new(neigh_node, if_outgoing);
@@ -1190,7 +1190,7 @@ static int batadv_iv_ogm_calc_tq(struct batadv_orig_node *orig_node,
 	} else {
 		neigh_rq_count = 0;
 	}
-	spin_unlock_bh(&orig_node->bat_iv.ogm_cnt_lock);
+	spin_unlock_bh(&orig_neigh_node->bat_iv.ogm_cnt_lock);
 
 	/* pay attention to not get a value bigger than 100 % */
 	if (orig_eq_count > neigh_rq_count)
-- 
2.20.1

