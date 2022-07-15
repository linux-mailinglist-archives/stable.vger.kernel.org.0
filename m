Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AC5576537
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 18:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbiGOQ1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 12:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiGOQ1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 12:27:25 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB2C5E314
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 09:27:24 -0700 (PDT)
Received: from localhost.localdomain (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPSA id 0C8B340755C7;
        Fri, 15 Jul 2022 16:27:23 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH 5.10 2/7] net: make free_netdev() more lenient with unregistering devices
Date:   Fri, 15 Jul 2022 19:26:27 +0300
Message-Id: <20220715162632.332718-3-pchelkin@ispras.ru>
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

commit c269a24ce057abfc31130960e96ab197ef6ab196 upstream.

There are two flavors of handling netdev registration:
 - ones called without holding rtnl_lock: register_netdev() and
   unregister_netdev(); and
 - those called with rtnl_lock held: register_netdevice() and
   unregister_netdevice().

While the semantics of the former are pretty clear, the same can't
be said about the latter. The netdev_todo mechanism is utilized to
perform some of the device unregistering tasks and it hooks into
rtnl_unlock() so the locked variants can't actually finish the work.
In general free_netdev() does not mix well with locked calls. Most
drivers operating under rtnl_lock set dev->needs_free_netdev to true
and expect core to make the free_netdev() call some time later.

The part where this becomes most problematic is error paths. There is
no way to unwind the state cleanly after a call to register_netdevice(),
since unreg can't be performed fully without dropping locks.

Make free_netdev() more lenient, and defer the freeing if device
is being unregistered. This allows error paths to simply call
free_netdev() both after register_netdevice() failed, and after
a call to unregister_netdevice() but before dropping rtnl_lock.

Simplify the error paths which are currently doing gymnastics
around free_netdev() handling.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 net/8021q/vlan.c     |  4 +---
 net/core/dev.c       | 11 +++++++++++
 net/core/rtnetlink.c | 23 ++++++-----------------
 3 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 15bbfaf943fd..8b644113715e 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -284,9 +284,7 @@ static int register_vlan_device(struct net_device *real_dev, u16 vlan_id)
 	return 0;
 
 out_free_newdev:
-	if (new_dev->reg_state == NETREG_UNINITIALIZED ||
-	    new_dev->reg_state == NETREG_UNREGISTERED)
-		free_netdev(new_dev);
+	free_netdev(new_dev);
 	return err;
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 8fa739259041..adde93cbca9f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10631,6 +10631,17 @@ void free_netdev(struct net_device *dev)
 	struct napi_struct *p, *n;
 
 	might_sleep();
+
+	/* When called immediately after register_netdevice() failed the unwind
+	 * handling may still be dismantling the device. Handle that case by
+	 * deferring the free.
+	 */
+	if (dev->reg_state == NETREG_UNREGISTERING) {
+		ASSERT_RTNL();
+		dev->needs_free_netdev = true;
+		return;
+	}
+
 	netif_free_tx_queues(dev);
 	netif_free_rx_queues(dev);
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 79f514afb17d..3d6ab194d0f5 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3439,26 +3439,15 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	dev->ifindex = ifm->ifi_index;
 
-	if (ops->newlink) {
+	if (ops->newlink)
 		err = ops->newlink(link_net ? : net, dev, tb, data, extack);
-		/* Drivers should set dev->needs_free_netdev
-		 * and unregister it on failure after registration
-		 * so that device could be finally freed in rtnl_unlock.
-		 */
-		if (err < 0) {
-			/* If device is not registered at all, free it now */
-			if (dev->reg_state == NETREG_UNINITIALIZED ||
-			    dev->reg_state == NETREG_UNREGISTERED)
-				free_netdev(dev);
-			goto out;
-		}
-	} else {
+	else
 		err = register_netdevice(dev);
-		if (err < 0) {
-			free_netdev(dev);
-			goto out;
-		}
+	if (err < 0) {
+		free_netdev(dev);
+		goto out;
 	}
+
 	err = rtnl_configure_link(dev, ifm);
 	if (err < 0)
 		goto out_unregister;
-- 
2.25.1

