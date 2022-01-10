Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0EE48924D
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239585AbiAJHlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240771AbiAJHiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:38:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABC0C028B9E;
        Sun,  9 Jan 2022 23:32:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF091B811FE;
        Mon, 10 Jan 2022 07:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CD6C36AED;
        Mon, 10 Jan 2022 07:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799948;
        bh=BYFkaeZVeRf3DcpiRNxRe4CMYuNGnpx0GLf8LTcbRvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PkZfh8yLyATs3AtanSYAJnTaFpGaJxws+O1x3dMlCF19ob/j7aBOYQkW+GK9lyegY
         x4gJDVeqXWWadJf0gkdE2B1Z7fRLbECb7u6VaJpe5+r9vzou+VGKRAyHTX90mXF/p+
         AtY3SsST6To6Fc+bsjlAQcjBdmPRHcD8ot2SwXuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 26/72] sctp: hold endpoint before calling cb in sctp_transport_lookup_process
Date:   Mon, 10 Jan 2022 08:23:03 +0100
Message-Id: <20220110071822.454728244@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit f9d31c4cf4c11ff10317f038b9c6f7c3bda6cdd4 upstream.

The same fix in commit 5ec7d18d1813 ("sctp: use call_rcu to free endpoint")
is also needed for dumping one asoc and sock after the lookup.

Fixes: 86fdb3448cc1 ("sctp: ensure ep is not destroyed before doing the dump")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sctp/sctp.h |    3 +--
 net/sctp/diag.c         |   48 ++++++++++++++++++++++--------------------------
 net/sctp/socket.c       |   22 +++++++++++++++-------
 3 files changed, 38 insertions(+), 35 deletions(-)

--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -112,8 +112,7 @@ struct sctp_transport *sctp_transport_ge
 			struct rhashtable_iter *iter);
 struct sctp_transport *sctp_transport_get_idx(struct net *net,
 			struct rhashtable_iter *iter, int pos);
-int sctp_transport_lookup_process(int (*cb)(struct sctp_transport *, void *),
-				  struct net *net,
+int sctp_transport_lookup_process(sctp_callback_t cb, struct net *net,
 				  const union sctp_addr *laddr,
 				  const union sctp_addr *paddr, void *p);
 int sctp_transport_traverse_process(sctp_callback_t cb, sctp_callback_t cb_done,
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -245,48 +245,44 @@ static size_t inet_assoc_attr_size(struc
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
-	}
-	err = inet_sctp_diag_fill(sk, assoc, rep, req,
-				  sk_user_ns(NETLINK_CB(in_skb).sk),
-				  NETLINK_CB(in_skb).portid,
-				  nlh->nlmsg_seq, 0, nlh,
-				  commp->net_admin);
-	release_sock(sk);
+	if (ep != assoc->ep) {
+		err = -EAGAIN;
+		goto out;
+	}
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
 
@@ -429,15 +425,15 @@ static void sctp_diag_get_info(struct so
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
@@ -460,7 +456,7 @@ static int sctp_diag_dump_one(struct net
 		paddr.v6.sin6_family = AF_INET6;
 	}
 
-	return sctp_transport_lookup_process(sctp_tsp_dump_one,
+	return sctp_transport_lookup_process(sctp_sock_dump_one,
 					     net, &laddr, &paddr, &commp);
 }
 
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5317,23 +5317,31 @@ int sctp_for_each_endpoint(int (*cb)(str
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


