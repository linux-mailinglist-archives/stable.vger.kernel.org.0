Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970B9A9174
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390105AbfIDSPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:32952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390990AbfIDSPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:15:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E560B206BA;
        Wed,  4 Sep 2019 18:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620934;
        bh=GVhog9IIZmIBP587bxenKiB18fEW1PN/f7l5RLrKjIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BaLi7Aq8B0QfOaS41vV7GigNX4QA/qm/goYF/dX8q7v0M2HLlggdHm4P0wIPVBCdE
         8wYnLrYi0TNS0atduzhY1/D2jCPrn3eAAGH+Tqs53ka/ryP92cHcgV+ln/OBflGOd5
         gsozUun8HymYBXC0BU9SmXmbu13gGN9yD9CpMl7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c6167ec3de7def23d1e8@syzkaller.appspotmail.com,
        Arvid Brodin <arvid.brodin@alten.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 143/143] hsr: implement dellink to clean up resources
Date:   Wed,  4 Sep 2019 19:54:46 +0200
Message-Id: <20190904175320.090038891@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668 upstream.

hsr_link_ops implements ->newlink() but not ->dellink(),
which leads that resources not released after removing the device,
particularly the entries in self_node_db and node_db.

So add ->dellink() implementation to replace the priv_destructor.
This also makes the code slightly easier to understand.

Reported-by: syzbot+c6167ec3de7def23d1e8@syzkaller.appspotmail.com
Cc: Arvid Brodin <arvid.brodin@alten.se>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/hsr/hsr_device.c   |   13 +++++--------
 net/hsr/hsr_device.h   |    1 +
 net/hsr/hsr_framereg.c |   11 ++++++++++-
 net/hsr/hsr_framereg.h |    3 ++-
 net/hsr/hsr_netlink.c  |    7 +++++++
 5 files changed, 25 insertions(+), 10 deletions(-)

--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -344,10 +344,7 @@ static void hsr_announce(struct timer_li
 	rcu_read_unlock();
 }
 
-/* According to comments in the declaration of struct net_device, this function
- * is "Called from unregister, can be used to call free_netdev". Ok then...
- */
-static void hsr_dev_destroy(struct net_device *hsr_dev)
+void hsr_dev_destroy(struct net_device *hsr_dev)
 {
 	struct hsr_priv *hsr;
 	struct hsr_port *port;
@@ -356,15 +353,16 @@ static void hsr_dev_destroy(struct net_d
 
 	hsr_debugfs_term(hsr);
 
-	rtnl_lock();
 	hsr_for_each_port(hsr, port)
 		hsr_del_port(port);
-	rtnl_unlock();
 
 	del_timer_sync(&hsr->prune_timer);
 	del_timer_sync(&hsr->announce_timer);
 
 	synchronize_rcu();
+
+	hsr_del_self_node(&hsr->self_node_db);
+	hsr_del_nodes(&hsr->node_db);
 }
 
 static const struct net_device_ops hsr_device_ops = {
@@ -391,7 +389,6 @@ void hsr_dev_setup(struct net_device *de
 	dev->priv_flags |= IFF_NO_QUEUE;
 
 	dev->needs_free_netdev = true;
-	dev->priv_destructor = hsr_dev_destroy;
 
 	dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA |
 			   NETIF_F_GSO_MASK | NETIF_F_HW_CSUM |
@@ -495,7 +492,7 @@ fail:
 	hsr_for_each_port(hsr, port)
 		hsr_del_port(port);
 err_add_port:
-	hsr_del_node(&hsr->self_node_db);
+	hsr_del_self_node(&hsr->self_node_db);
 
 	return res;
 }
--- a/net/hsr/hsr_device.h
+++ b/net/hsr/hsr_device.h
@@ -14,6 +14,7 @@
 void hsr_dev_setup(struct net_device *dev);
 int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 		     unsigned char multicast_spec, u8 protocol_version);
+void hsr_dev_destroy(struct net_device *hsr_dev);
 void hsr_check_carrier_and_operstate(struct hsr_priv *hsr);
 bool is_hsr_master(struct net_device *dev);
 int hsr_get_max_mtu(struct hsr_priv *hsr);
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -104,7 +104,7 @@ int hsr_create_self_node(struct list_hea
 	return 0;
 }
 
-void hsr_del_node(struct list_head *self_node_db)
+void hsr_del_self_node(struct list_head *self_node_db)
 {
 	struct hsr_node *node;
 
@@ -117,6 +117,15 @@ void hsr_del_node(struct list_head *self
 	}
 }
 
+void hsr_del_nodes(struct list_head *node_db)
+{
+	struct hsr_node *node;
+	struct hsr_node *tmp;
+
+	list_for_each_entry_safe(node, tmp, node_db, mac_list)
+		kfree(node);
+}
+
 /* Allocate an hsr_node and add it to node_db. 'addr' is the node's address_A;
  * seq_out is used to initialize filtering of outgoing duplicate frames
  * originating from the newly added node.
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -12,7 +12,8 @@
 
 struct hsr_node;
 
-void hsr_del_node(struct list_head *self_node_db);
+void hsr_del_self_node(struct list_head *self_node_db);
+void hsr_del_nodes(struct list_head *node_db);
 struct hsr_node *hsr_add_node(struct list_head *node_db, unsigned char addr[],
 			      u16 seq_out);
 struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -69,6 +69,12 @@ static int hsr_newlink(struct net *src_n
 	return hsr_dev_finalize(dev, link, multicast_spec, hsr_version);
 }
 
+static void hsr_dellink(struct net_device *hsr_dev, struct list_head *head)
+{
+	hsr_dev_destroy(hsr_dev);
+	unregister_netdevice_queue(hsr_dev, head);
+}
+
 static int hsr_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct hsr_priv *hsr;
@@ -113,6 +119,7 @@ static struct rtnl_link_ops hsr_link_ops
 	.priv_size	= sizeof(struct hsr_priv),
 	.setup		= hsr_dev_setup,
 	.newlink	= hsr_newlink,
+	.dellink	= hsr_dellink,
 	.fill_info	= hsr_fill_info,
 };
 


