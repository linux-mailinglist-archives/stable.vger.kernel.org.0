Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BB6411FE2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349777AbhITRqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353006AbhITRnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:43:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFBB161B72;
        Mon, 20 Sep 2021 17:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157746;
        bh=GVDe6dytpR8MZgWC71Q+k/v2IWhxvAb5Tj1GIdvifOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xo8dXNKe6zSASi5faISY/y2QrjScBUsXCzqvDLB9dibMkOkRC5gaI1uMkq60bXkjm
         bEvqAOat91QKuHc98yd4IGt3dBysDvgdsKQXqWpr1uNhrKDuLZgf7Q0MNq4G5fstG2
         CuiASYIFwsrZ8VdV0SsfHfusRU78EHvG7X6XaC3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
Subject: [PATCH 4.19 105/293] netns: protect netns ID lookups with RCU
Date:   Mon, 20 Sep 2021 18:41:07 +0200
Message-Id: <20210920163936.858871708@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

commit 2dce224f469f060b9998a5a869151ef83c08ce77 upstream.

__peernet2id() can be protected by RCU as it only calls idr_for_each(),
which is RCU-safe, and never modifies the nsid table.

rtnl_net_dumpid() can also do lockless lookups. It does two nested
idr_for_each() calls on nsid tables (one direct call and one indirect
call because of rtnl_net_dumpid_one() calling __peernet2id()). The
netnsid tables are never updated. Therefore it is safe to not take the
nsid_lock and run within an RCU-critical section instead.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>

---
 net/core/net_namespace.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -192,9 +192,9 @@ static int net_eq_idr(int id, void *net,
 	return 0;
 }
 
-/* Should be called with nsid_lock held. If a new id is assigned, the bool alloc
- * is set to true, thus the caller knows that the new id must be notified via
- * rtnl.
+/* Must be called from RCU-critical section or with nsid_lock held. If
+ * a new id is assigned, the bool alloc is set to true, thus the
+ * caller knows that the new id must be notified via rtnl.
  */
 static int __peernet2id_alloc(struct net *net, struct net *peer, bool *alloc)
 {
@@ -218,7 +218,7 @@ static int __peernet2id_alloc(struct net
 	return NETNSA_NSID_NOT_ASSIGNED;
 }
 
-/* should be called with nsid_lock held */
+/* Must be called from RCU-critical section or with nsid_lock held */
 static int __peernet2id(struct net *net, struct net *peer)
 {
 	bool no = false;
@@ -261,9 +261,10 @@ int peernet2id(struct net *net, struct n
 {
 	int id;
 
-	spin_lock_bh(&net->nsid_lock);
+	rcu_read_lock();
 	id = __peernet2id(net, peer);
-	spin_unlock_bh(&net->nsid_lock);
+	rcu_read_unlock();
+
 	return id;
 }
 EXPORT_SYMBOL(peernet2id);
@@ -837,6 +838,7 @@ struct rtnl_net_dump_cb {
 	int s_idx;
 };
 
+/* Runs in RCU-critical section. */
 static int rtnl_net_dumpid_one(int id, void *peer, void *data)
 {
 	struct rtnl_net_dump_cb *net_cb = (struct rtnl_net_dump_cb *)data;
@@ -867,9 +869,9 @@ static int rtnl_net_dumpid(struct sk_buf
 		.s_idx = cb->args[0],
 	};
 
-	spin_lock_bh(&net->nsid_lock);
+	rcu_read_lock();
 	idr_for_each(&net->netns_ids, rtnl_net_dumpid_one, &net_cb);
-	spin_unlock_bh(&net->nsid_lock);
+	rcu_read_unlock();
 
 	cb->args[0] = net_cb.idx;
 	return skb->len;


