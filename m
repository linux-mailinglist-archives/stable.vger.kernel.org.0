Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DA268114F
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237234AbjA3OMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237233AbjA3OMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:12:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4213B3D2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:11:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F7C9B811C7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87B9C433D2;
        Mon, 30 Jan 2023 14:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087915;
        bh=NNSsII8hg20NUiFeZ89sqGkTPzbH5X4Zke8SJq+kARY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1tvKhqeFKfEmJGFJuFNxzh5jzWJr8AMF5EDZ6+5S4FCEtnoR5TOB9cpZDy8Mnezu
         f8SDg6VdG/2my49Ms8C5uN0DUB8XYkdYlAP6VJ/sAzXq/B8qxquVGef2VSbnomhB7y
         r3R84lfUGAT0+Atn/4+L9G4VrF+ENN3K09nkHjsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Guillaume Nault <gnault@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Tom Parkin <tparkin@katalix.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/204] l2tp: convert l2tp_tunnel_list to idr
Date:   Mon, 30 Jan 2023 14:50:18 +0100
Message-Id: <20230130134318.634505636@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit c4d48a58f32c5972174a1d01c33b296fe378cce0 ]

l2tp uses l2tp_tunnel_list to track all registered tunnels and
to allocate tunnel ID's. IDR can do the same job.

More importantly, with IDR we can hold the ID before a successful
registration so that we don't need to worry about late error
handling, it is not easy to rollback socket changes.

This is a preparation for the following fix.

Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Guillaume Nault <gnault@redhat.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Tom Parkin <tparkin@katalix.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0b2c59720e65 ("l2tp: close all race conditions in l2tp_tunnel_register()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c | 85 ++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 43 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index d22dbd92b709..68d8b2aa6f6d 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -104,9 +104,9 @@ static struct workqueue_struct *l2tp_wq;
 /* per-net private data for this module */
 static unsigned int l2tp_net_id;
 struct l2tp_net {
-	struct list_head l2tp_tunnel_list;
-	/* Lock for write access to l2tp_tunnel_list */
-	spinlock_t l2tp_tunnel_list_lock;
+	/* Lock for write access to l2tp_tunnel_idr */
+	spinlock_t l2tp_tunnel_idr_lock;
+	struct idr l2tp_tunnel_idr;
 	struct hlist_head l2tp_session_hlist[L2TP_HASH_SIZE_2];
 	/* Lock for write access to l2tp_session_hlist */
 	spinlock_t l2tp_session_hlist_lock;
@@ -208,13 +208,10 @@ struct l2tp_tunnel *l2tp_tunnel_get(const struct net *net, u32 tunnel_id)
 	struct l2tp_tunnel *tunnel;
 
 	rcu_read_lock_bh();
-	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
-		if (tunnel->tunnel_id == tunnel_id &&
-		    refcount_inc_not_zero(&tunnel->ref_count)) {
-			rcu_read_unlock_bh();
-
-			return tunnel;
-		}
+	tunnel = idr_find(&pn->l2tp_tunnel_idr, tunnel_id);
+	if (tunnel && refcount_inc_not_zero(&tunnel->ref_count)) {
+		rcu_read_unlock_bh();
+		return tunnel;
 	}
 	rcu_read_unlock_bh();
 
@@ -224,13 +221,14 @@ EXPORT_SYMBOL_GPL(l2tp_tunnel_get);
 
 struct l2tp_tunnel *l2tp_tunnel_get_nth(const struct net *net, int nth)
 {
-	const struct l2tp_net *pn = l2tp_pernet(net);
+	struct l2tp_net *pn = l2tp_pernet(net);
+	unsigned long tunnel_id, tmp;
 	struct l2tp_tunnel *tunnel;
 	int count = 0;
 
 	rcu_read_lock_bh();
-	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
-		if (++count > nth &&
+	idr_for_each_entry_ul(&pn->l2tp_tunnel_idr, tunnel, tmp, tunnel_id) {
+		if (tunnel && ++count > nth &&
 		    refcount_inc_not_zero(&tunnel->ref_count)) {
 			rcu_read_unlock_bh();
 			return tunnel;
@@ -1229,6 +1227,15 @@ static void l2tp_udp_encap_destroy(struct sock *sk)
 		l2tp_tunnel_delete(tunnel);
 }
 
+static void l2tp_tunnel_remove(struct net *net, struct l2tp_tunnel *tunnel)
+{
+	struct l2tp_net *pn = l2tp_pernet(net);
+
+	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
+	idr_remove(&pn->l2tp_tunnel_idr, tunnel->tunnel_id);
+	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
+}
+
 /* Workqueue tunnel deletion function */
 static void l2tp_tunnel_del_work(struct work_struct *work)
 {
@@ -1236,7 +1243,6 @@ static void l2tp_tunnel_del_work(struct work_struct *work)
 						  del_work);
 	struct sock *sk = tunnel->sock;
 	struct socket *sock = sk->sk_socket;
-	struct l2tp_net *pn;
 
 	l2tp_tunnel_closeall(tunnel);
 
@@ -1250,12 +1256,7 @@ static void l2tp_tunnel_del_work(struct work_struct *work)
 		}
 	}
 
-	/* Remove the tunnel struct from the tunnel list */
-	pn = l2tp_pernet(tunnel->l2tp_net);
-	spin_lock_bh(&pn->l2tp_tunnel_list_lock);
-	list_del_rcu(&tunnel->list);
-	spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
-
+	l2tp_tunnel_remove(tunnel->l2tp_net, tunnel);
 	/* drop initial ref */
 	l2tp_tunnel_dec_refcount(tunnel);
 
@@ -1457,12 +1458,19 @@ static int l2tp_validate_socket(const struct sock *sk, const struct net *net,
 int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 			 struct l2tp_tunnel_cfg *cfg)
 {
-	struct l2tp_tunnel *tunnel_walk;
-	struct l2tp_net *pn;
+	struct l2tp_net *pn = l2tp_pernet(net);
+	u32 tunnel_id = tunnel->tunnel_id;
 	struct socket *sock;
 	struct sock *sk;
 	int ret;
 
+	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
+	ret = idr_alloc_u32(&pn->l2tp_tunnel_idr, NULL, &tunnel_id, tunnel_id,
+			    GFP_ATOMIC);
+	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
+	if (ret)
+		return ret == -ENOSPC ? -EEXIST : ret;
+
 	if (tunnel->fd < 0) {
 		ret = l2tp_tunnel_sock_create(net, tunnel->tunnel_id,
 					      tunnel->peer_tunnel_id, cfg,
@@ -1483,23 +1491,13 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	rcu_assign_sk_user_data(sk, tunnel);
 	write_unlock_bh(&sk->sk_callback_lock);
 
-	tunnel->l2tp_net = net;
-	pn = l2tp_pernet(net);
-
 	sock_hold(sk);
 	tunnel->sock = sk;
+	tunnel->l2tp_net = net;
 
-	spin_lock_bh(&pn->l2tp_tunnel_list_lock);
-	list_for_each_entry(tunnel_walk, &pn->l2tp_tunnel_list, list) {
-		if (tunnel_walk->tunnel_id == tunnel->tunnel_id) {
-			spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
-			sock_put(sk);
-			ret = -EEXIST;
-			goto err_sock;
-		}
-	}
-	list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
-	spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
+	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
+	idr_replace(&pn->l2tp_tunnel_idr, tunnel, tunnel->tunnel_id);
+	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
 
 	if (tunnel->encap == L2TP_ENCAPTYPE_UDP) {
 		struct udp_tunnel_sock_cfg udp_cfg = {
@@ -1525,9 +1523,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 	return 0;
 
-err_sock:
-	write_lock_bh(&sk->sk_callback_lock);
-	rcu_assign_sk_user_data(sk, NULL);
 err_inval_sock:
 	write_unlock_bh(&sk->sk_callback_lock);
 
@@ -1536,6 +1531,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	else
 		sockfd_put(sock);
 err:
+	l2tp_tunnel_remove(net, tunnel);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(l2tp_tunnel_register);
@@ -1649,8 +1645,8 @@ static __net_init int l2tp_init_net(struct net *net)
 	struct l2tp_net *pn = net_generic(net, l2tp_net_id);
 	int hash;
 
-	INIT_LIST_HEAD(&pn->l2tp_tunnel_list);
-	spin_lock_init(&pn->l2tp_tunnel_list_lock);
+	idr_init(&pn->l2tp_tunnel_idr);
+	spin_lock_init(&pn->l2tp_tunnel_idr_lock);
 
 	for (hash = 0; hash < L2TP_HASH_SIZE_2; hash++)
 		INIT_HLIST_HEAD(&pn->l2tp_session_hlist[hash]);
@@ -1664,11 +1660,13 @@ static __net_exit void l2tp_exit_net(struct net *net)
 {
 	struct l2tp_net *pn = l2tp_pernet(net);
 	struct l2tp_tunnel *tunnel = NULL;
+	unsigned long tunnel_id, tmp;
 	int hash;
 
 	rcu_read_lock_bh();
-	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
-		l2tp_tunnel_delete(tunnel);
+	idr_for_each_entry_ul(&pn->l2tp_tunnel_idr, tunnel, tmp, tunnel_id) {
+		if (tunnel)
+			l2tp_tunnel_delete(tunnel);
 	}
 	rcu_read_unlock_bh();
 
@@ -1678,6 +1676,7 @@ static __net_exit void l2tp_exit_net(struct net *net)
 
 	for (hash = 0; hash < L2TP_HASH_SIZE_2; hash++)
 		WARN_ON_ONCE(!hlist_empty(&pn->l2tp_session_hlist[hash]));
+	idr_destroy(&pn->l2tp_tunnel_idr);
 }
 
 static struct pernet_operations l2tp_net_ops = {
-- 
2.39.0



