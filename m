Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FA0582C9D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240509AbiG0QsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240513AbiG0Qrv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:47:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E053B60689;
        Wed, 27 Jul 2022 09:32:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3E6E61A69;
        Wed, 27 Jul 2022 16:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC2CC433D6;
        Wed, 27 Jul 2022 16:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939530;
        bh=x62oYt0nv8/6MhmQFrVc/A5UY17q4Wq4XlS+Piv5KXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9Yl734/8bJlHDmXkaTcY2URJ6PvLcFb7FLeMpQoNvYVAltdtanSle5w4rAhutmPN
         jWlZP1Ka9tRDyogBxkOZ33guh4RwbMWIcWaBJfGSkMYMzGdF9Eu9yrWYWqjnLR7WLR
         +VS2rjupn+JD6JNbwhbTo+gOdcO2lKRlHQ9s0Nx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.10 014/105] net: move rollback_registered_many()
Date:   Wed, 27 Jul 2022 18:10:00 +0200
Message-Id: <20220727161012.635565992@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

From: Jakub Kicinski <kuba@kernel.org>

commit bcfe2f1a3818d9dca945b6aca4ae741cb1f75329 upstream.

Move rollback_registered_many() and add a temporary
forward declaration to make merging the code into
unregister_netdevice_many() easier to review.

No functional changes.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |  188 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 95 insertions(+), 93 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9508,99 +9508,6 @@ static void net_set_todo(struct net_devi
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
@@ -10726,6 +10633,8 @@ void synchronize_net(void)
 }
 EXPORT_SYMBOL(synchronize_net);
 
+static void rollback_registered_many(struct list_head *head);
+
 /**
  *	unregister_netdevice_queue - remove device from the kernel
  *	@dev: device
@@ -10771,6 +10680,99 @@ void unregister_netdevice_many(struct li
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


