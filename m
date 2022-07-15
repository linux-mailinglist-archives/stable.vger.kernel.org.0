Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D601E57653B
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 18:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbiGOQ1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 12:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiGOQ1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 12:27:34 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E90A564CA
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 09:27:33 -0700 (PDT)
Received: from localhost.localdomain (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPSA id CAEF540755E8;
        Fri, 15 Jul 2022 16:27:31 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH 5.10 6/7] net: move rollback_registered_many()
Date:   Fri, 15 Jul 2022 19:26:31 +0300
Message-Id: <20220715162632.332718-7-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220715162632.332718-1-pchelkin@ispras.ru>
References: <20220715162632.332718-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

commit bcfe2f1a3818d9dca945b6aca4ae741cb1f75329 upstream.

Move rollback_registered_many() and add a temporary
forward declaration to make merging the code into
unregister_netdevice_many() easier to review.

No functional changes.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 net/core/dev.c | 188 +++++++++++++++++++++++++------------------------
 1 file changed, 95 insertions(+), 93 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 9a147142c477..1fb99ae8cc22 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9459,99 +9459,6 @@ static void net_set_todo(struct net_device *dev)
 	dev_net(dev)->dev_unreg_count++;
 }
 
-static void rollback_registered_many(struct list_head *head)
-{
-	struct net_device *dev, *tmp;
-	LIST_HEAD(close_head);
-
-	BUG_ON(dev_boot_phase);
-	ASSERT_RTNL();
-
-	list_for_each_entry_safe(dev, tmp, head, unreg_list) {
-		/* Some devices call without registering
-		 * for initialization unwind. Remove those
-		 * devices and proceed with the remaining.
-		 */
-		if (dev->reg_state == NETREG_UNINITIALIZED) {
-			pr_debug("unregister_netdevice: device %s/%p never was registered\n",
-				 dev->name, dev);
-
-			WARN_ON(1);
-			list_del(&dev->unreg_list);
-			continue;
-		}
-		dev->dismantle = true;
-		BUG_ON(dev->reg_state != NETREG_REGISTERED);
-	}
-
-	/* If device is running, close it first. */
-	list_for_each_entry(dev, head, unreg_list)
-		list_add_tail(&dev->close_list, &close_head);
-	dev_close_many(&close_head, true);
-
-	list_for_each_entry(dev, head, unreg_list) {
-		/* And unlink it from device chain. */
-		unlist_netdevice(dev);
-
-		dev->reg_state = NETREG_UNREGISTERING;
-	}
-	flush_all_backlogs();
-
-	synchronize_net();
-
-	list_for_each_entry(dev, head, unreg_list) {
-		struct sk_buff *skb = NULL;
-
-		/* Shutdown queueing discipline. */
-		dev_shutdown(dev);
-
-		dev_xdp_uninstall(dev);
-
-		/* Notify protocols, that we are about to destroy
-		 * this device. They should clean all the things.
-		 */
-		call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
-
-		if (!dev->rtnl_link_ops ||
-		    dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
-			skb = rtmsg_ifinfo_build_skb(RTM_DELLINK, dev, ~0U, 0,
-						     GFP_KERNEL, NULL, 0);
-
-		/*
-		 *	Flush the unicast and multicast chains
-		 */
-		dev_uc_flush(dev);
-		dev_mc_flush(dev);
-
-		netdev_name_node_alt_flush(dev);
-		netdev_name_node_free(dev->name_node);
-
-		if (dev->netdev_ops->ndo_uninit)
-			dev->netdev_ops->ndo_uninit(dev);
-
-		if (skb)
-			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL);
-
-		/* Notifier chain MUST detach us all upper devices. */
-		WARN_ON(netdev_has_any_upper_dev(dev));
-		WARN_ON(netdev_has_any_lower_dev(dev));
-
-		/* Remove entries from kobject tree */
-		netdev_unregister_kobject(dev);
-#ifdef CONFIG_XPS
-		/* Remove XPS queueing entries */
-		netif_reset_xps_queues_gt(dev, 0);
-#endif
-	}
-
-	synchronize_net();
-
-	list_for_each_entry(dev, head, unreg_list) {
-		dev_put(dev);
-		net_set_todo(dev);
-	}
-}
-
 static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
 	struct net_device *upper, netdev_features_t features)
 {
@@ -10703,6 +10610,8 @@ void synchronize_net(void)
 }
 EXPORT_SYMBOL(synchronize_net);
 
+static void rollback_registered_many(struct list_head *head);
+
 /**
  *	unregister_netdevice_queue - remove device from the kernel
  *	@dev: device
@@ -10748,6 +10657,99 @@ void unregister_netdevice_many(struct list_head *head)
 }
 EXPORT_SYMBOL(unregister_netdevice_many);
 
+static void rollback_registered_many(struct list_head *head)
+{
+	struct net_device *dev, *tmp;
+	LIST_HEAD(close_head);
+
+	BUG_ON(dev_boot_phase);
+	ASSERT_RTNL();
+
+	list_for_each_entry_safe(dev, tmp, head, unreg_list) {
+		/* Some devices call without registering
+		 * for initialization unwind. Remove those
+		 * devices and proceed with the remaining.
+		 */
+		if (dev->reg_state == NETREG_UNINITIALIZED) {
+			pr_debug("unregister_netdevice: device %s/%p never was registered\n",
+				 dev->name, dev);
+
+			WARN_ON(1);
+			list_del(&dev->unreg_list);
+			continue;
+		}
+		dev->dismantle = true;
+		BUG_ON(dev->reg_state != NETREG_REGISTERED);
+	}
+
+	/* If device is running, close it first. */
+	list_for_each_entry(dev, head, unreg_list)
+		list_add_tail(&dev->close_list, &close_head);
+	dev_close_many(&close_head, true);
+
+	list_for_each_entry(dev, head, unreg_list) {
+		/* And unlink it from device chain. */
+		unlist_netdevice(dev);
+
+		dev->reg_state = NETREG_UNREGISTERING;
+	}
+	flush_all_backlogs();
+
+	synchronize_net();
+
+	list_for_each_entry(dev, head, unreg_list) {
+		struct sk_buff *skb = NULL;
+
+		/* Shutdown queueing discipline. */
+		dev_shutdown(dev);
+
+		dev_xdp_uninstall(dev);
+
+		/* Notify protocols, that we are about to destroy
+		 * this device. They should clean all the things.
+		 */
+		call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
+
+		if (!dev->rtnl_link_ops ||
+		    dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
+			skb = rtmsg_ifinfo_build_skb(RTM_DELLINK, dev, ~0U, 0,
+						     GFP_KERNEL, NULL, 0);
+
+		/*
+		 *	Flush the unicast and multicast chains
+		 */
+		dev_uc_flush(dev);
+		dev_mc_flush(dev);
+
+		netdev_name_node_alt_flush(dev);
+		netdev_name_node_free(dev->name_node);
+
+		if (dev->netdev_ops->ndo_uninit)
+			dev->netdev_ops->ndo_uninit(dev);
+
+		if (skb)
+			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL);
+
+		/* Notifier chain MUST detach us all upper devices. */
+		WARN_ON(netdev_has_any_upper_dev(dev));
+		WARN_ON(netdev_has_any_lower_dev(dev));
+
+		/* Remove entries from kobject tree */
+		netdev_unregister_kobject(dev);
+#ifdef CONFIG_XPS
+		/* Remove XPS queueing entries */
+		netif_reset_xps_queues_gt(dev, 0);
+#endif
+	}
+
+	synchronize_net();
+
+	list_for_each_entry(dev, head, unreg_list) {
+		dev_put(dev);
+		net_set_todo(dev);
+	}
+}
+
 /**
  *	unregister_netdev - remove device from the kernel
  *	@dev: device
-- 
2.25.1

