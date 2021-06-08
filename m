Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F6B3A01F7
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbhFHS6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236419AbhFHS4T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:56:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 088766161E;
        Tue,  8 Jun 2021 18:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177724;
        bh=9xJJhDQNyfp0aWz5jPAS8nOngbPYQVpdSHWmLb4rIrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTknFLkbfLRDPoI0bpVu7TkoeMqINbtaEaZK2YM9ih/OL8UgKddtjAndmAFUAeZAS
         4MM9+sIn3L6HlE3jF6sQUAA2rbVc13TYgtmkefo48pAKLq7273ABYbz8xgCE/DJje1
         ZlAi4btPXQvziqG6s9NvTql6ex3Pt/nvsAPWvXhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/137] cxgb4: fix regression with HASH tc prio value update
Date:   Tue,  8 Jun 2021 20:26:23 +0200
Message-Id: <20210608175943.869784734@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit a27fb314cba8cb84cd6456a4699c3330a83c326d ]

commit db43b30cd89c ("cxgb4: add ethtool n-tuple filter deletion")
has moved searching for next highest priority HASH filter rule to
cxgb4_flow_rule_destroy(), which searches the rhashtable before the
the rule is removed from it and hence always finds at least 1 entry.
Fix by removing the rule from rhashtable first before calling
cxgb4_flow_rule_destroy() and hence avoid fetching stale info.

Fixes: db43b30cd89c ("cxgb4: add ethtool n-tuple filter deletion")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 1b88bd1c2dbe..dd9be229819a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -997,20 +997,16 @@ int cxgb4_tc_flower_destroy(struct net_device *dev,
 	if (!ch_flower)
 		return -ENOENT;
 
+	rhashtable_remove_fast(&adap->flower_tbl, &ch_flower->node,
+			       adap->flower_ht_params);
+
 	ret = cxgb4_flow_rule_destroy(dev, ch_flower->fs.tc_prio,
 				      &ch_flower->fs, ch_flower->filter_id);
 	if (ret)
-		goto err;
+		netdev_err(dev, "Flow rule destroy failed for tid: %u, ret: %d",
+			   ch_flower->filter_id, ret);
 
-	ret = rhashtable_remove_fast(&adap->flower_tbl, &ch_flower->node,
-				     adap->flower_ht_params);
-	if (ret) {
-		netdev_err(dev, "Flow remove from rhashtable failed");
-		goto err;
-	}
 	kfree_rcu(ch_flower, rcu);
-
-err:
 	return ret;
 }
 
-- 
2.30.2



