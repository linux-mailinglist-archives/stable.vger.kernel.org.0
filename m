Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 432C51875AF
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732829AbgCPWb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:27 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49362 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732766AbgCPWb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=riIfuxqABLjU35vyURUA4IJAmGfSNNgME/7PcrX6oMo=;
        b=wUVF7Je6XxUhUZgiwsRl3ahrlfqfr0Htt4u3EApneLZUzMOn9fScqH2IzNVc3cbcmuHBnU
        C9cIsWmN+ZUHv5aGKEEhjh0TqAaJPE6nUD+jaRprsVSXynZZISjk3dgBc2OZmq7Dc1xA2F
        4zMarPP9zYMKzKblS8gsqkSnBNGVITc=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 17/24] batman-adv: Fix debugfs path for renamed softif
Date:   Mon, 16 Mar 2020 23:30:58 +0100
Message-Id: <20200316223105.6333-18-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223105.6333-1-sven@narfation.org>
References: <20200316223105.6333-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6da7be7d24b2921f8215473ba7552796dff05fe1 upstream.

batman-adv is creating special debugfs directories in the init
net_namespace for each created soft-interface (batadv net_device). But it
is possible to rename a net_device to a completely different name then the
original one.

It can therefore happen that a user registers a new batadv net_device with
the name "bat0". batman-adv is then also adding a new directory under
$debugfs/batman-adv/ with the name "wlan0".

The user then decides to rename this device to "bat1" and registers a
different batadv device with the name "bat0". batman-adv will then try to
create a directory with the name "bat0" under $debugfs/batman-adv/ again.
But there already exists one with this name under this path and thus this
fails. batman-adv will detect a problem and rollback the registering of
this device.

batman-adv must therefore take care of renaming the debugfs directories for
soft-interfaces whenever it detects such a net_device rename.

Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/debugfs.c        | 20 +++++++++++++++++++
 net/batman-adv/debugfs.h        |  5 +++++
 net/batman-adv/hard-interface.c | 34 +++++++++++++++++++++++++++------
 3 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/net/batman-adv/debugfs.c b/net/batman-adv/debugfs.c
index df58e21c3841..e0ab277db503 100644
--- a/net/batman-adv/debugfs.c
+++ b/net/batman-adv/debugfs.c
@@ -423,6 +423,26 @@ int batadv_debugfs_add_meshif(struct net_device *dev)
 	return -ENOMEM;
 }
 
+/**
+ * batadv_debugfs_rename_meshif() - Fix debugfs path for renamed softif
+ * @dev: net_device which was renamed
+ */
+void batadv_debugfs_rename_meshif(struct net_device *dev)
+{
+	struct batadv_priv *bat_priv = netdev_priv(dev);
+	const char *name = dev->name;
+	struct dentry *dir;
+	struct dentry *d;
+
+	dir = bat_priv->debug_dir;
+	if (!dir)
+		return;
+
+	d = debugfs_rename(dir->d_parent, dir, dir->d_parent, name);
+	if (!d)
+		pr_err("Can't rename debugfs dir to %s\n", name);
+}
+
 void batadv_debugfs_del_meshif(struct net_device *dev)
 {
 	struct batadv_priv *bat_priv = netdev_priv(dev);
diff --git a/net/batman-adv/debugfs.h b/net/batman-adv/debugfs.h
index 3d9b684b862d..59a0d6d70ecd 100644
--- a/net/batman-adv/debugfs.h
+++ b/net/batman-adv/debugfs.h
@@ -29,6 +29,7 @@ struct net_device;
 void batadv_debugfs_init(void);
 void batadv_debugfs_destroy(void);
 int batadv_debugfs_add_meshif(struct net_device *dev);
+void batadv_debugfs_rename_meshif(struct net_device *dev);
 void batadv_debugfs_del_meshif(struct net_device *dev);
 int batadv_debugfs_add_hardif(struct batadv_hard_iface *hard_iface);
 void batadv_debugfs_rename_hardif(struct batadv_hard_iface *hard_iface);
@@ -49,6 +50,10 @@ static inline int batadv_debugfs_add_meshif(struct net_device *dev)
 	return 0;
 }
 
+static inline void batadv_debugfs_rename_meshif(struct net_device *dev)
+{
+}
+
 static inline void batadv_debugfs_del_meshif(struct net_device *dev)
 {
 }
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index da66fca54bc0..34331ed6de73 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -755,6 +755,32 @@ void batadv_hardif_remove_interfaces(void)
 	rtnl_unlock();
 }
 
+/**
+ * batadv_hard_if_event_softif() - Handle events for soft interfaces
+ * @event: NETDEV_* event to handle
+ * @net_dev: net_device which generated an event
+ *
+ * Return: NOTIFY_* result
+ */
+static int batadv_hard_if_event_softif(unsigned long event,
+				       struct net_device *net_dev)
+{
+	struct batadv_priv *bat_priv;
+
+	switch (event) {
+	case NETDEV_REGISTER:
+		batadv_sysfs_add_meshif(net_dev);
+		bat_priv = netdev_priv(net_dev);
+		batadv_softif_create_vlan(bat_priv, BATADV_NO_FLAGS);
+		break;
+	case NETDEV_CHANGENAME:
+		batadv_debugfs_rename_meshif(net_dev);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
 static int batadv_hard_if_event(struct notifier_block *this,
 				unsigned long event, void *ptr)
 {
@@ -763,12 +789,8 @@ static int batadv_hard_if_event(struct notifier_block *this,
 	struct batadv_hard_iface *primary_if = NULL;
 	struct batadv_priv *bat_priv;
 
-	if (batadv_softif_is_valid(net_dev) && event == NETDEV_REGISTER) {
-		batadv_sysfs_add_meshif(net_dev);
-		bat_priv = netdev_priv(net_dev);
-		batadv_softif_create_vlan(bat_priv, BATADV_NO_FLAGS);
-		return NOTIFY_DONE;
-	}
+	if (batadv_softif_is_valid(net_dev))
+		return batadv_hard_if_event_softif(event, net_dev);
 
 	hard_iface = batadv_hardif_get_by_netdev(net_dev);
 	if (!hard_iface && (event == NETDEV_REGISTER ||
-- 
2.20.1

