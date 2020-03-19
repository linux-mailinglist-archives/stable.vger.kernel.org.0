Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69D918B460
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbgCSNJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:09:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728275AbgCSNJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:09:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 122732145D;
        Thu, 19 Mar 2020 13:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623351;
        bh=JkTM20Kk2R0YWQ3TX/NJ6Uv6Q9HIqDn2yyxbsoFnRzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZ9ZcsgXupHDs8LjHCmMHd7cvSy+r4na2U4RzEzzS9dXKNlhHV7cpIhz2fV2lTk87
         MAFScz0bIaQxe4mibrXleSuAuNe8r6rcmiVb15rsSsU+wbjiqkZQEMfNSGqw4fPDKV
         6Av0T9lfrKGdzu56V7nf/ZSD1vIzc27AmQj1neOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 74/93] batman-adv: Fix debugfs path for renamed softif
Date:   Thu, 19 Mar 2020 14:00:18 +0100
Message-Id: <20200319123948.301736883@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

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
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/debugfs.c        |   20 ++++++++++++++++++++
 net/batman-adv/debugfs.h        |    5 +++++
 net/batman-adv/hard-interface.c |   34 ++++++++++++++++++++++++++++------
 3 files changed, 53 insertions(+), 6 deletions(-)

--- a/net/batman-adv/debugfs.c
+++ b/net/batman-adv/debugfs.c
@@ -581,6 +581,26 @@ out:
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
--- a/net/batman-adv/debugfs.h
+++ b/net/batman-adv/debugfs.h
@@ -31,6 +31,7 @@ struct net_device;
 void batadv_debugfs_init(void);
 void batadv_debugfs_destroy(void);
 int batadv_debugfs_add_meshif(struct net_device *dev);
+void batadv_debugfs_rename_meshif(struct net_device *dev);
 void batadv_debugfs_del_meshif(struct net_device *dev);
 int batadv_debugfs_add_hardif(struct batadv_hard_iface *hard_iface);
 void batadv_debugfs_rename_hardif(struct batadv_hard_iface *hard_iface);
@@ -51,6 +52,10 @@ static inline int batadv_debugfs_add_mes
 	return 0;
 }
 
+static inline void batadv_debugfs_rename_meshif(struct net_device *dev)
+{
+}
+
 static inline void batadv_debugfs_del_meshif(struct net_device *dev)
 {
 }
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -725,6 +725,32 @@ void batadv_hardif_remove_interfaces(voi
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
@@ -733,12 +759,8 @@ static int batadv_hard_if_event(struct n
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
 	if (!hard_iface && event == NETDEV_REGISTER)


