Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54EA41875AD
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732827AbgCPWb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:26 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49346 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732825AbgCPWb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6AdtKtViBFzNcTLE+7Cc6BBPjJYNDXIIUPw7eGgHxNg=;
        b=XdSvlozB+fvehvffNQEh0PSLmf7KWKgP5TCWe8sQaqCTOPZSrBBGJ+tj4uklVyt+T6KPkY
        FxhGOdSXaW6NzcTwFKJSfiJSPIMQdUpJ8hqJz7VkAyARfYRfncaS7CTY2IpoGaKghy/DAF
        DGSIki5JqYrKc7kbXj5m6CGTPrXyqsw=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>, John Soros <sorosj@gmail.com>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 16/24] batman-adv: Fix debugfs path for renamed hardif
Date:   Mon, 16 Mar 2020 23:30:57 +0100
Message-Id: <20200316223105.6333-17-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223105.6333-1-sven@narfation.org>
References: <20200316223105.6333-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 36dc621ceca1be3ec885aeade5fdafbbcc452a6d upstream.

batman-adv is creating special debugfs directories in the init
net_namespace for each valid hard-interface (net_device). But it is
possible to rename a net_device to a completely different name then the
original one.

It can therefore happen that a user registers a new net_device which gets
the name "wlan0" assigned by default. batman-adv is also adding a new
directory under $debugfs/batman-adv/ with the name "wlan0".

The user then decides to rename this device to "wl_pri" and registers a
different device. The kernel may now decide to use the name "wlan0" again
for this new device. batman-adv will detect it as a valid net_device and
tries to create a directory with the name "wlan0" under
$debugfs/batman-adv/. But there already exists one with this name under
this path and thus this fails. batman-adv will detect a problem and
rollback the registering of this device.

batman-adv must therefore take care of renaming the debugfs directories
for hard-interfaces whenever it detects such a net_device rename.

Fixes: 5bc7c1eb44f2 ("batman-adv: add debugfs structure for information per interface")
Reported-by: John Soros <sorosj@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/debugfs.c        | 20 ++++++++++++++++++++
 net/batman-adv/debugfs.h        |  6 ++++++
 net/batman-adv/hard-interface.c |  3 +++
 3 files changed, 29 insertions(+)

diff --git a/net/batman-adv/debugfs.c b/net/batman-adv/debugfs.c
index b4ffba7dd583..df58e21c3841 100644
--- a/net/batman-adv/debugfs.c
+++ b/net/batman-adv/debugfs.c
@@ -18,6 +18,7 @@
 #include "debugfs.h"
 #include "main.h"
 
+#include <linux/dcache.h>
 #include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/errno.h>
@@ -339,6 +340,25 @@ int batadv_debugfs_add_hardif(struct batadv_hard_iface *hard_iface)
 	return -ENOMEM;
 }
 
+/**
+ * batadv_debugfs_rename_hardif() - Fix debugfs path for renamed hardif
+ * @hard_iface: hard interface which was renamed
+ */
+void batadv_debugfs_rename_hardif(struct batadv_hard_iface *hard_iface)
+{
+	const char *name = hard_iface->net_dev->name;
+	struct dentry *dir;
+	struct dentry *d;
+
+	dir = hard_iface->debug_dir;
+	if (!dir)
+		return;
+
+	d = debugfs_rename(dir->d_parent, dir, dir->d_parent, name);
+	if (!d)
+		pr_err("Can't rename debugfs dir to %s\n", name);
+}
+
 /**
  * batadv_debugfs_del_hardif - delete the base directory for a hard interface
  *  in debugfs.
diff --git a/net/batman-adv/debugfs.h b/net/batman-adv/debugfs.h
index e49121ee55f6..3d9b684b862d 100644
--- a/net/batman-adv/debugfs.h
+++ b/net/batman-adv/debugfs.h
@@ -31,6 +31,7 @@ void batadv_debugfs_destroy(void);
 int batadv_debugfs_add_meshif(struct net_device *dev);
 void batadv_debugfs_del_meshif(struct net_device *dev);
 int batadv_debugfs_add_hardif(struct batadv_hard_iface *hard_iface);
+void batadv_debugfs_rename_hardif(struct batadv_hard_iface *hard_iface);
 void batadv_debugfs_del_hardif(struct batadv_hard_iface *hard_iface);
 
 #else
@@ -58,6 +59,11 @@ int batadv_debugfs_add_hardif(struct batadv_hard_iface *hard_iface)
 	return 0;
 }
 
+static inline
+void batadv_debugfs_rename_hardif(struct batadv_hard_iface *hard_iface)
+{
+}
+
 static inline
 void batadv_debugfs_del_hardif(struct batadv_hard_iface *hard_iface)
 {
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index cda2b1af0d4f..da66fca54bc0 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -812,6 +812,9 @@ static int batadv_hard_if_event(struct notifier_block *this,
 		if (hard_iface == primary_if)
 			batadv_primary_if_update_addr(bat_priv, NULL);
 		break;
+	case NETDEV_CHANGENAME:
+		batadv_debugfs_rename_hardif(hard_iface);
+		break;
 	default:
 		break;
 	}
-- 
2.20.1

