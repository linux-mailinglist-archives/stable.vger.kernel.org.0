Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB3BA18B57A
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgCSNSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727731AbgCSNSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:18:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A19E52098B;
        Thu, 19 Mar 2020 13:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623934;
        bh=+pU4LulTU4mEYekBOst0ONklTIF3qN/8m0GK1PJ5h18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtQrYCAof7De8ao9pktjsSbj3zoaZPC4FoHKsSDhaTkZdTEUj4m0FxBb1/o1x6Inz
         JvYyDyOYIr3xDs24dcA7drSYu7MctR3IYlWVwdvMZgkngnax9zJ0sM+UtontbxuGr5
         TrA7sJKZTw3k72Tqxcd2rB/pk6HPhb97DQTeaY2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Soros <sorosj@gmail.com>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.14 76/99] batman-adv: Fix debugfs path for renamed hardif
Date:   Thu, 19 Mar 2020 14:03:54 +0100
Message-Id: <20200319124004.043668318@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/debugfs.c        |   22 +++++++++++++++++++++-
 net/batman-adv/debugfs.h        |    6 ++++++
 net/batman-adv/hard-interface.c |    3 +++
 3 files changed, 30 insertions(+), 1 deletion(-)

--- a/net/batman-adv/debugfs.c
+++ b/net/batman-adv/debugfs.c
@@ -18,6 +18,7 @@
 #include "debugfs.h"
 #include "main.h"
 
+#include <linux/dcache.h>
 #include <linux/debugfs.h>
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -338,7 +339,26 @@ out:
 }
 
 /**
- * batadv_debugfs_del_hardif - delete the base directory for a hard interface
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
+/**
+ * batadv_debugfs_del_hardif() - delete the base directory for a hard interface
  *  in debugfs.
  * @hard_iface: hard interface which is deleted.
  */
--- a/net/batman-adv/debugfs.h
+++ b/net/batman-adv/debugfs.h
@@ -31,6 +31,7 @@ void batadv_debugfs_destroy(void);
 int batadv_debugfs_add_meshif(struct net_device *dev);
 void batadv_debugfs_del_meshif(struct net_device *dev);
 int batadv_debugfs_add_hardif(struct batadv_hard_iface *hard_iface);
+void batadv_debugfs_rename_hardif(struct batadv_hard_iface *hard_iface);
 void batadv_debugfs_del_hardif(struct batadv_hard_iface *hard_iface);
 
 #else
@@ -59,6 +60,11 @@ int batadv_debugfs_add_hardif(struct bat
 }
 
 static inline
+void batadv_debugfs_rename_hardif(struct batadv_hard_iface *hard_iface)
+{
+}
+
+static inline
 void batadv_debugfs_del_hardif(struct batadv_hard_iface *hard_iface)
 {
 }
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -1017,6 +1017,9 @@ static int batadv_hard_if_event(struct n
 		if (batadv_is_wifi_hardif(hard_iface))
 			hard_iface->num_bcasts = BATADV_NUM_BCASTS_WIRELESS;
 		break;
+	case NETDEV_CHANGENAME:
+		batadv_debugfs_rename_hardif(hard_iface);
+		break;
 	default:
 		break;
 	}


