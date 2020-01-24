Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5884A147F67
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387881AbgAXLB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:01:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:35136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731007AbgAXLB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:01:58 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D14D42071A;
        Fri, 24 Jan 2020 11:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863717;
        bh=yLfTmaglozY6K/Ku3rRLkRVjGDv7qOHZTsNAHGo/CyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvfqPJMB5NUTRGnTFWj1VlI/LGsE7oMiMlRIZ2l+Owepjzxw2IZ4H7mQMkh8wKyIU
         ii9xu3CEGhFn0pBn5xqtp8VgdzTtv8Vsh1GBtfTBPu/i2cTnejdcpE4DEXlIjWO0EZ
         +IjHtofQmFgOOKggUNbYING4TGDacARzngLejZX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tuong Lien Tong <tuong.t.lien@dektech.com.au>,
        Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 056/639] tipc: eliminate message disordering during binding table update
Date:   Fri, 24 Jan 2020 10:23:46 +0100
Message-Id: <20200124093054.421375980@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>

[ Upstream commit 988f3f1603d4650409db5334355cbf7b13ef50c3 ]

We have seen the following race scenario:
1) named_distribute() builds a "bulk" message, containing a PUBLISH
   item for a certain publication. This is based on the contents of
   the binding tables's 'cluster_scope' list.
2) tipc_named_withdraw() removes the same publication from the list,
   bulds a WITHDRAW message and distributes it to all cluster nodes.
3) tipc_named_node_up(), which was calling named_distribute(), sends
   out the bulk message built under 1)
4) The WITHDRAW message arrives at the just detected node, finds
   no corresponding publication, and is dropped.
5) The PUBLISH item arrives at the same node, is added to its binding
   table, and remains there forever.

This arrival disordering was earlier taken care of by the backlog queue,
originally added for a different purpose, which was removed in the
commit referred to below, but we now need a different solution.
In this commit, we replace the rcu lock protecting the 'cluster_scope'
list with a regular RW lock which comprises even the sending of the
bulk message. This both guarantees both the list integrity and the
message sending order. We will later add a commit which cleans up
this code further.

Note that this commit needs recently added commit d3092b2efca1 ("tipc:
fix unsafe rcu locking when accessing publication list") to apply
cleanly.

Fixes: 37922ea4a310 ("tipc: permit overlapping service ranges in name table")
Reported-by: Tuong Lien Tong <tuong.t.lien@dektech.com.au>
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/name_distr.c | 18 ++++++++++--------
 net/tipc/name_table.c |  1 +
 net/tipc/name_table.h |  1 +
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index e0a3dd424d8c2..836e629e8f4ab 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -94,8 +94,9 @@ struct sk_buff *tipc_named_publish(struct net *net, struct publication *publ)
 		list_add_tail_rcu(&publ->binding_node, &nt->node_scope);
 		return NULL;
 	}
-	list_add_tail_rcu(&publ->binding_node, &nt->cluster_scope);
-
+	write_lock_bh(&nt->cluster_scope_lock);
+	list_add_tail(&publ->binding_node, &nt->cluster_scope);
+	write_unlock_bh(&nt->cluster_scope_lock);
 	skb = named_prepare_buf(net, PUBLICATION, ITEM_SIZE, 0);
 	if (!skb) {
 		pr_warn("Publication distribution failure\n");
@@ -112,11 +113,13 @@ struct sk_buff *tipc_named_publish(struct net *net, struct publication *publ)
  */
 struct sk_buff *tipc_named_withdraw(struct net *net, struct publication *publ)
 {
+	struct name_table *nt = tipc_name_table(net);
 	struct sk_buff *buf;
 	struct distr_item *item;
 
-	list_del_rcu(&publ->binding_node);
-
+	write_lock_bh(&nt->cluster_scope_lock);
+	list_del(&publ->binding_node);
+	write_unlock_bh(&nt->cluster_scope_lock);
 	if (publ->scope == TIPC_NODE_SCOPE)
 		return NULL;
 
@@ -147,7 +150,7 @@ static void named_distribute(struct net *net, struct sk_buff_head *list,
 			ITEM_SIZE) * ITEM_SIZE;
 	u32 msg_rem = msg_dsz;
 
-	list_for_each_entry_rcu(publ, pls, binding_node) {
+	list_for_each_entry(publ, pls, binding_node) {
 		/* Prepare next buffer: */
 		if (!skb) {
 			skb = named_prepare_buf(net, PUBLICATION, msg_rem,
@@ -189,11 +192,10 @@ void tipc_named_node_up(struct net *net, u32 dnode)
 
 	__skb_queue_head_init(&head);
 
-	rcu_read_lock();
+	read_lock_bh(&nt->cluster_scope_lock);
 	named_distribute(net, &head, dnode, &nt->cluster_scope);
-	rcu_read_unlock();
-
 	tipc_node_xmit(net, &head, dnode, 0);
+	read_unlock_bh(&nt->cluster_scope_lock);
 }
 
 /**
diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index d72985ca1d555..89993afe0fbd3 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -744,6 +744,7 @@ int tipc_nametbl_init(struct net *net)
 
 	INIT_LIST_HEAD(&nt->node_scope);
 	INIT_LIST_HEAD(&nt->cluster_scope);
+	rwlock_init(&nt->cluster_scope_lock);
 	tn->nametbl = nt;
 	spin_lock_init(&tn->nametbl_lock);
 	return 0;
diff --git a/net/tipc/name_table.h b/net/tipc/name_table.h
index 892bd750b85fa..f79066334cc8f 100644
--- a/net/tipc/name_table.h
+++ b/net/tipc/name_table.h
@@ -100,6 +100,7 @@ struct name_table {
 	struct hlist_head services[TIPC_NAMETBL_SIZE];
 	struct list_head node_scope;
 	struct list_head cluster_scope;
+	rwlock_t cluster_scope_lock;
 	u32 local_publ_count;
 };
 
-- 
2.20.1



