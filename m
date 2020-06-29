Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D450920DB42
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731896AbgF2UEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:04:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732985AbgF2Tab (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BCC925269;
        Mon, 29 Jun 2020 15:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444979;
        bh=OvWWwk41cNAWQcZ61SqYRjzD8VCGnnJDsEo9RiDUSbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJOOvJudU/4IA9UD2ZyrlzmlT1fqNDCe5gZQw7DslGSSP1fiKE9thkc5ZOx6tKTJe
         Jdieqg4ecQmIU/VBoEYaMDYLiClL+R1BH7sIvAeC1U6p1zTk0mwNooQC0LfC2WaqtO
         HcYXvEPRipuSmPuludYpG5Sz7wtZ2MLvIfFYIc0U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/131] cxgb4: move handling L2T ARP failures to caller
Date:   Mon, 29 Jun 2020 11:34:09 -0400
Message-Id: <20200629153502.2494656-79-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 11d8cd5c9f3b46f397f889cefdb66795518aaebd ]

Move code handling L2T ARP failures to the only caller.

Fixes following sparse warning:
skbuff.h:2091:29: warning: context imbalance in
'handle_failed_resolution' - unexpected unlock

Fixes: 749cb5fe48bb ("cxgb4: Replace arpq_head/arpq_tail with SKB double link-list code")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/l2t.c | 52 +++++++++++-------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/l2t.c b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
index 986277744611c..08f4780e7fe7a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/l2t.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
@@ -507,41 +507,20 @@ u64 cxgb4_select_ntuple(struct net_device *dev,
 }
 EXPORT_SYMBOL(cxgb4_select_ntuple);
 
-/*
- * Called when address resolution fails for an L2T entry to handle packets
- * on the arpq head.  If a packet specifies a failure handler it is invoked,
- * otherwise the packet is sent to the device.
- */
-static void handle_failed_resolution(struct adapter *adap, struct l2t_entry *e)
-{
-	struct sk_buff *skb;
-
-	while ((skb = __skb_dequeue(&e->arpq)) != NULL) {
-		const struct l2t_skb_cb *cb = L2T_SKB_CB(skb);
-
-		spin_unlock(&e->lock);
-		if (cb->arp_err_handler)
-			cb->arp_err_handler(cb->handle, skb);
-		else
-			t4_ofld_send(adap, skb);
-		spin_lock(&e->lock);
-	}
-}
-
 /*
  * Called when the host's neighbor layer makes a change to some entry that is
  * loaded into the HW L2 table.
  */
 void t4_l2t_update(struct adapter *adap, struct neighbour *neigh)
 {
-	struct l2t_entry *e;
-	struct sk_buff_head *arpq = NULL;
-	struct l2t_data *d = adap->l2t;
 	unsigned int addr_len = neigh->tbl->key_len;
 	u32 *addr = (u32 *) neigh->primary_key;
-	int ifidx = neigh->dev->ifindex;
-	int hash = addr_hash(d, addr, addr_len, ifidx);
+	int hash, ifidx = neigh->dev->ifindex;
+	struct sk_buff_head *arpq = NULL;
+	struct l2t_data *d = adap->l2t;
+	struct l2t_entry *e;
 
+	hash = addr_hash(d, addr, addr_len, ifidx);
 	read_lock_bh(&d->lock);
 	for (e = d->l2tab[hash].first; e; e = e->next)
 		if (!addreq(e, addr) && e->ifindex == ifidx) {
@@ -574,8 +553,25 @@ void t4_l2t_update(struct adapter *adap, struct neighbour *neigh)
 			write_l2e(adap, e, 0);
 	}
 
-	if (arpq)
-		handle_failed_resolution(adap, e);
+	if (arpq) {
+		struct sk_buff *skb;
+
+		/* Called when address resolution fails for an L2T
+		 * entry to handle packets on the arpq head. If a
+		 * packet specifies a failure handler it is invoked,
+		 * otherwise the packet is sent to the device.
+		 */
+		while ((skb = __skb_dequeue(&e->arpq)) != NULL) {
+			const struct l2t_skb_cb *cb = L2T_SKB_CB(skb);
+
+			spin_unlock(&e->lock);
+			if (cb->arp_err_handler)
+				cb->arp_err_handler(cb->handle, skb);
+			else
+				t4_ofld_send(adap, skb);
+			spin_lock(&e->lock);
+		}
+	}
 	spin_unlock_bh(&e->lock);
 }
 
-- 
2.25.1

