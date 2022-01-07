Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D8F48788B
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 14:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347682AbiAGNvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 08:51:10 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:35514 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347679AbiAGNvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 08:51:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3E7E2CE2AEF
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 13:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AC6C36AE5;
        Fri,  7 Jan 2022 13:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641563466;
        bh=ZYUsPMj3DlXVnL8dtSS7ILNdtgZ25IwPb0mL6HjRFu8=;
        h=Subject:To:Cc:From:Date:From;
        b=poykH3m6lhR5C1xXcWHqBcHD09k0VEXnY9eNHAC3YPP0A50/236WkvJf0m5bY8zZI
         sm4UHvrdR3WjKavOhH6e/uQMdFVLTHfkqzwO+9osv1QGcnUZZ/okMvi8aA+YCk9wAC
         nL7jA0luXwhZTcsDCg4VACM9GNoZuAwimm18A3ac=
Subject: FAILED: patch "[PATCH] sctp: hold endpoint before calling cb in" failed to apply to 5.10-stable tree
To:     lucien.xin@gmail.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Jan 2022 14:51:04 +0100
Message-ID: <164156346422147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f9d31c4cf4c11ff10317f038b9c6f7c3bda6cdd4 Mon Sep 17 00:00:00 2001
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 31 Dec 2021 18:37:37 -0500
Subject: [PATCH] sctp: hold endpoint before calling cb in
 sctp_transport_lookup_process

The same fix in commit 5ec7d18d1813 ("sctp: use call_rcu to free endpoint")
is also needed for dumping one asoc and sock after the lookup.

Fixes: 86fdb3448cc1 ("sctp: ensure ep is not destroyed before doing the dump")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index d314a180ab93..3ae61ce2eabd 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -112,8 +112,7 @@ struct sctp_transport *sctp_transport_get_next(struct net *net,
 			struct rhashtable_iter *iter);
 struct sctp_transport *sctp_transport_get_idx(struct net *net,
 			struct rhashtable_iter *iter, int pos);
-int sctp_transport_lookup_process(int (*cb)(struct sctp_transport *, void *),
-				  struct net *net,
+int sctp_transport_lookup_process(sctp_callback_t cb, struct net *net,
 				  const union sctp_addr *laddr,
 				  const union sctp_addr *paddr, void *p);
 int sctp_transport_traverse_process(sctp_callback_t cb, sctp_callback_t cb_done,
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index a7d623171501..034e2c74497d 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -245,48 +245,44 @@ static size_t inet_assoc_attr_size(struct sctp_association *asoc)
 		+ 64;
 }
 
-static int sctp_tsp_dump_one(struct sctp_transport *tsp, void *p)
+static int sctp_sock_dump_one(struct sctp_endpoint *ep, struct sctp_transport *tsp, void *p)
 {
 	struct sctp_association *assoc = tsp->asoc;
-	struct sock *sk = tsp->asoc->base.sk;
 	struct sctp_comm_param *commp = p;
-	struct sk_buff *in_skb = commp->skb;
+	struct sock *sk = ep->base.sk;
 	const struct inet_diag_req_v2 *req = commp->r;
-	const struct nlmsghdr *nlh = commp->nlh;
-	struct net *net = sock_net(in_skb->sk);
+	struct sk_buff *skb = commp->skb;
 	struct sk_buff *rep;
 	int err;
 
 	err = sock_diag_check_cookie(sk, req->id.idiag_cookie);
 	if (err)
-		goto out;
+		return err;
 
-	err = -ENOMEM;
 	rep = nlmsg_new(inet_assoc_attr_size(assoc), GFP_KERNEL);
 	if (!rep)
-		goto out;
+		return -ENOMEM;
 
 	lock_sock(sk);
-	if (sk != assoc->base.sk) {
-		release_sock(sk);
-		sk = assoc->base.sk;
-		lock_sock(sk);
+	if (ep != assoc->ep) {
+		err = -EAGAIN;
+		goto out;
 	}
-	err = inet_sctp_diag_fill(sk, assoc, rep, req,
-				  sk_user_ns(NETLINK_CB(in_skb).sk),
-				  NETLINK_CB(in_skb).portid,
-				  nlh->nlmsg_seq, 0, nlh,
-				  commp->net_admin);
-	release_sock(sk);
+
+	err = inet_sctp_diag_fill(sk, assoc, rep, req, sk_user_ns(NETLINK_CB(skb).sk),
+				  NETLINK_CB(skb).portid, commp->nlh->nlmsg_seq, 0,
+				  commp->nlh, commp->net_admin);
 	if (err < 0) {
 		WARN_ON(err == -EMSGSIZE);
-		kfree_skb(rep);
 		goto out;
 	}
+	release_sock(sk);
 
-	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
+	return nlmsg_unicast(sock_net(skb->sk)->diag_nlsk, rep, NETLINK_CB(skb).portid);
 
 out:
+	release_sock(sk);
+	kfree_skb(rep);
 	return err;
 }
 
@@ -429,15 +425,15 @@ static void sctp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 static int sctp_diag_dump_one(struct netlink_callback *cb,
 			      const struct inet_diag_req_v2 *req)
 {
-	struct sk_buff *in_skb = cb->skb;
-	struct net *net = sock_net(in_skb->sk);
+	struct sk_buff *skb = cb->skb;
+	struct net *net = sock_net(skb->sk);
 	const struct nlmsghdr *nlh = cb->nlh;
 	union sctp_addr laddr, paddr;
 	struct sctp_comm_param commp = {
-		.skb = in_skb,
+		.skb = skb,
 		.r = req,
 		.nlh = nlh,
-		.net_admin = netlink_net_capable(in_skb, CAP_NET_ADMIN),
+		.net_admin = netlink_net_capable(skb, CAP_NET_ADMIN),
 	};
 
 	if (req->sdiag_family == AF_INET) {
@@ -460,7 +456,7 @@ static int sctp_diag_dump_one(struct netlink_callback *cb,
 		paddr.v6.sin6_family = AF_INET6;
 	}
 
-	return sctp_transport_lookup_process(sctp_tsp_dump_one,
+	return sctp_transport_lookup_process(sctp_sock_dump_one,
 					     net, &laddr, &paddr, &commp);
 }
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ad5028a07b18..da08671a3f80 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5317,23 +5317,31 @@ int sctp_for_each_endpoint(int (*cb)(struct sctp_endpoint *, void *),
 }
 EXPORT_SYMBOL_GPL(sctp_for_each_endpoint);
 
-int sctp_transport_lookup_process(int (*cb)(struct sctp_transport *, void *),
-				  struct net *net,
+int sctp_transport_lookup_process(sctp_callback_t cb, struct net *net,
 				  const union sctp_addr *laddr,
 				  const union sctp_addr *paddr, void *p)
 {
 	struct sctp_transport *transport;
-	int err;
+	struct sctp_endpoint *ep;
+	int err = -ENOENT;
 
 	rcu_read_lock();
 	transport = sctp_addrs_lookup_transport(net, laddr, paddr);
+	if (!transport) {
+		rcu_read_unlock();
+		return err;
+	}
+	ep = transport->asoc->ep;
+	if (!sctp_endpoint_hold(ep)) { /* asoc can be peeled off */
+		sctp_transport_put(transport);
+		rcu_read_unlock();
+		return err;
+	}
 	rcu_read_unlock();
-	if (!transport)
-		return -ENOENT;
 
-	err = cb(transport, p);
+	err = cb(ep, transport, p);
+	sctp_endpoint_put(ep);
 	sctp_transport_put(transport);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(sctp_transport_lookup_process);

