Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99097198F7F
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730892AbgCaJD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730655AbgCaJD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:03:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DF7A20787;
        Tue, 31 Mar 2020 09:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645436;
        bh=53iqeY/2ZUDVwxvV3ybd+GcjsI/fnlbrKFLdNi/ocoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UueZNbPiXrsqdqUvTcrUkHRtb5vTje5czTNfErHTTLqeaK9UCoYLURXee3UGGEo6c
         kak5i8mwavWzMj/J/5JbzoC4i/j+NDeJQ7L+rNG1kumj4E3i1dN5H9dBguzoWwF9Pn
         5mo+IvEUE8IKF0BR7wfBA5SU4WR2cYIQFq5rOZ78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 053/170] hsr: use rcu_read_lock() in hsr_get_node_{list/status}()
Date:   Tue, 31 Mar 2020 10:57:47 +0200
Message-Id: <20200331085430.058683605@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 173756b86803655d70af7732079b3aa935e6ab68 ]

hsr_get_node_{list/status}() are not under rtnl_lock() because
they are callback functions of generic netlink.
But they use __dev_get_by_index() without rtnl_lock().
So, it would use unsafe data.
In order to fix it, rcu_read_lock() and dev_get_by_index_rcu()
are used instead of __dev_get_by_index().

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_framereg.c |    9 ++-------
 net/hsr/hsr_netlink.c  |   39 +++++++++++++++++++++------------------
 2 files changed, 23 insertions(+), 25 deletions(-)

--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -482,12 +482,9 @@ int hsr_get_node_data(struct hsr_priv *h
 	struct hsr_port *port;
 	unsigned long tdiff;
 
-	rcu_read_lock();
 	node = find_node_by_addr_A(&hsr->node_db, addr);
-	if (!node) {
-		rcu_read_unlock();
-		return -ENOENT;	/* No such entry */
-	}
+	if (!node)
+		return -ENOENT;
 
 	ether_addr_copy(addr_b, node->macaddress_B);
 
@@ -522,7 +519,5 @@ int hsr_get_node_data(struct hsr_priv *h
 		*addr_b_ifindex = -1;
 	}
 
-	rcu_read_unlock();
-
 	return 0;
 }
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -251,15 +251,16 @@ static int hsr_get_node_status(struct sk
 	if (!na)
 		goto invalid;
 
-	hsr_dev = __dev_get_by_index(genl_info_net(info),
-				     nla_get_u32(info->attrs[HSR_A_IFINDEX]));
+	rcu_read_lock();
+	hsr_dev = dev_get_by_index_rcu(genl_info_net(info),
+				       nla_get_u32(info->attrs[HSR_A_IFINDEX]));
 	if (!hsr_dev)
-		goto invalid;
+		goto rcu_unlock;
 	if (!is_hsr_master(hsr_dev))
-		goto invalid;
+		goto rcu_unlock;
 
 	/* Send reply */
-	skb_out = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	skb_out = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb_out) {
 		res = -ENOMEM;
 		goto fail;
@@ -313,12 +314,10 @@ static int hsr_get_node_status(struct sk
 	res = nla_put_u16(skb_out, HSR_A_IF1_SEQ, hsr_node_if1_seq);
 	if (res < 0)
 		goto nla_put_failure;
-	rcu_read_lock();
 	port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_A);
 	if (port)
 		res = nla_put_u32(skb_out, HSR_A_IF1_IFINDEX,
 				  port->dev->ifindex);
-	rcu_read_unlock();
 	if (res < 0)
 		goto nla_put_failure;
 
@@ -328,20 +327,22 @@ static int hsr_get_node_status(struct sk
 	res = nla_put_u16(skb_out, HSR_A_IF2_SEQ, hsr_node_if2_seq);
 	if (res < 0)
 		goto nla_put_failure;
-	rcu_read_lock();
 	port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_B);
 	if (port)
 		res = nla_put_u32(skb_out, HSR_A_IF2_IFINDEX,
 				  port->dev->ifindex);
-	rcu_read_unlock();
 	if (res < 0)
 		goto nla_put_failure;
 
+	rcu_read_unlock();
+
 	genlmsg_end(skb_out, msg_head);
 	genlmsg_unicast(genl_info_net(info), skb_out, info->snd_portid);
 
 	return 0;
 
+rcu_unlock:
+	rcu_read_unlock();
 invalid:
 	netlink_ack(skb_in, nlmsg_hdr(skb_in), -EINVAL, NULL);
 	return 0;
@@ -351,6 +352,7 @@ nla_put_failure:
 	/* Fall through */
 
 fail:
+	rcu_read_unlock();
 	return res;
 }
 
@@ -377,15 +379,16 @@ static int hsr_get_node_list(struct sk_b
 	if (!na)
 		goto invalid;
 
-	hsr_dev = __dev_get_by_index(genl_info_net(info),
-				     nla_get_u32(info->attrs[HSR_A_IFINDEX]));
+	rcu_read_lock();
+	hsr_dev = dev_get_by_index_rcu(genl_info_net(info),
+				       nla_get_u32(info->attrs[HSR_A_IFINDEX]));
 	if (!hsr_dev)
-		goto invalid;
+		goto rcu_unlock;
 	if (!is_hsr_master(hsr_dev))
-		goto invalid;
+		goto rcu_unlock;
 
 	/* Send reply */
-	skb_out = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	skb_out = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb_out) {
 		res = -ENOMEM;
 		goto fail;
@@ -405,14 +408,11 @@ static int hsr_get_node_list(struct sk_b
 
 	hsr = netdev_priv(hsr_dev);
 
-	rcu_read_lock();
 	pos = hsr_get_next_node(hsr, NULL, addr);
 	while (pos) {
 		res = nla_put(skb_out, HSR_A_NODE_ADDR, ETH_ALEN, addr);
-		if (res < 0) {
-			rcu_read_unlock();
+		if (res < 0)
 			goto nla_put_failure;
-		}
 		pos = hsr_get_next_node(hsr, pos, addr);
 	}
 	rcu_read_unlock();
@@ -422,6 +422,8 @@ static int hsr_get_node_list(struct sk_b
 
 	return 0;
 
+rcu_unlock:
+	rcu_read_unlock();
 invalid:
 	netlink_ack(skb_in, nlmsg_hdr(skb_in), -EINVAL, NULL);
 	return 0;
@@ -431,6 +433,7 @@ nla_put_failure:
 	/* Fall through */
 
 fail:
+	rcu_read_unlock();
 	return res;
 }
 


