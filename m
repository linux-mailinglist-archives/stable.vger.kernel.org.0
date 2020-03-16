Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0F921875A8
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732822AbgCPWbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:20 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49142 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732770AbgCPWbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JPXqLThNDob97Kp0tOoh7taJ7I8ozSZd0ou3CaoQGlQ=;
        b=e6IuUUz4fnUyw1VjEIL6RP03eNFIJlgT8JoWXpUVGHagWc2vITFJdkNY9jPJlvdgJfR3Ez
        pqpH7MajdvjYp/mjVDLI9axXE52nA9VLDzhganfmD1QgqqWUC7UAcZRDQ97fRIYty46gDE
        frEQXnynA5OB0uGtvh9dXncdtgtiK5Q=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 11/24] batman-adv: Fix lock for ogm cnt access in batadv_iv_ogm_calc_tq
Date:   Mon, 16 Mar 2020 23:30:52 +0100
Message-Id: <20200316223105.6333-12-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223105.6333-1-sven@narfation.org>
References: <20200316223105.6333-1-sven@narfation.org>
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
---
 net/batman-adv/bat_iv_ogm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 6aecab38a694..477ec5023488 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1227,7 +1227,7 @@ static bool batadv_iv_ogm_calc_tq(struct batadv_orig_node *orig_node,
 	orig_node->last_seen = jiffies;
 
 	/* find packet count of corresponding one hop neighbor */
-	spin_lock_bh(&orig_node->bat_iv.ogm_cnt_lock);
+	spin_lock_bh(&orig_neigh_node->bat_iv.ogm_cnt_lock);
 	if_num = if_incoming->if_num;
 	orig_eq_count = orig_neigh_node->bat_iv.bcast_own_sum[if_num];
 	neigh_ifinfo = batadv_neigh_ifinfo_new(neigh_node, if_outgoing);
@@ -1237,7 +1237,7 @@ static bool batadv_iv_ogm_calc_tq(struct batadv_orig_node *orig_node,
 	} else {
 		neigh_rq_count = 0;
 	}
-	spin_unlock_bh(&orig_node->bat_iv.ogm_cnt_lock);
+	spin_unlock_bh(&orig_neigh_node->bat_iv.ogm_cnt_lock);
 
 	/* pay attention to not get a value bigger than 100 % */
 	if (orig_eq_count > neigh_rq_count)
-- 
2.20.1

