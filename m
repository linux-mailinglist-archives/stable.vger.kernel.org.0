Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C53B187596
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732804AbgCPWbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:00 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:48960 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732798AbgCPWbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i+Ssq+bIH8RM+8X62iRGzMoDMXHsUSZyepQM+kpr9vk=;
        b=Rl93c2JyfRJqUuRhQirBEp959VUR8AEyVVXXPIXtAPEPzlU6tpwE+iO8vU4njDczMDWCG8
        /w1eqfZm5PMB3sWO3zXx5FGQKNo32FJEq4+IUu90K3qJZQeD7opOm8c3HeewNHER/d6f9W
        4OOdya+NyKr/PpqDlHy5mdanjQzQnUU=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>, John Soros <sorosj@gmail.com>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.14 10/15] batman-adv: Fix debugfs path for renamed hardif
Date:   Mon, 16 Mar 2020 23:30:27 +0100
Message-Id: <20200316223032.6236-11-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223032.6236-1-sven@narfation.org>
References: <20200316223032.6236-1-sven@narfation.org>
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
 net/batman-adv/debugfs.c        | 22 +++++++++++++++++++++-
 net/batman-adv/debugfs.h        |  6 ++++++
 net/batman-adv/hard-interface.c |  3 +++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/debugfs.c b/net/batman-adv/debugfs.c
index e32ad47c6efd..7ee828cd9778 100644
--- a/net/batman-adv/debugfs.c
+++ b/net/batman-adv/debugfs.c
@@ -18,6 +18,7 @@
 #include "debugfs.h"
 #include "main.h"
 
+#include <linux/dcache.h>
 #include <linux/debugfs.h>
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -338,7 +339,26 @@ int batadv_debugfs_add_hardif(struct batadv_hard_iface *hard_iface)
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
diff --git a/net/batman-adv/debugfs.h b/net/batman-adv/debugfs.h
index 9c5d4a65b98c..295e11146818 100644
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
index 4b67731677af..e72e95208339 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -1017,6 +1017,9 @@ static int batadv_hard_if_event(struct notifier_block *this,
 		if (batadv_is_wifi_hardif(hard_iface))
 			hard_iface->num_bcasts = BATADV_NUM_BCASTS_WIRELESS;
 		break;
+	case NETDEV_CHANGENAME:
+		batadv_debugfs_rename_hardif(hard_iface);
+		break;
 	default:
 		break;
 	}
-- 
2.20.1

