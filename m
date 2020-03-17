Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2304F1891F8
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgCQX1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:27:51 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53532 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgCQX1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:27:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v2YRAOfX+yfsHIAdEnT2CamkCmdMNRK1h4fFnmPDGio=;
        b=L4WlHGJ+rwIaFf5HwQS7gMBgT135kh+36ZUEh1dgT4GaMZXoOev0hwKDzqPqbDPc56apZk
        jcPDpB8/llFLHw8KIE9QAdKPAekO+NIm/9Q1tnhVqu3slJHfgAnYepMkJ3o5o+BeU1IlzH
        pQzbXewoZnNYJn5BLc+pCVEOERkIYG4=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 09/48] batman-adv: Drop reference to netdevice on last reference
Date:   Wed, 18 Mar 2020 00:26:55 +0100
Message-Id: <20200317232734.6127-10-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 140ed8e87ca8f4875c2b146cdb2cdbf0c9ac6080 upstream.

The references to the network device should be dropped inside the release
function for batadv_hard_iface similar to what is done with the batman-adv
internal datastructures.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <a@unstable.cc>
---
 net/batman-adv/hard-interface.c | 13 ++++++++-----
 net/batman-adv/hard-interface.h |  6 +++---
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index ecaa68ae62f5..cc3be5489f5c 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -45,13 +45,16 @@
 #include "sysfs.h"
 #include "translation-table.h"
 
-void batadv_hardif_free_rcu(struct rcu_head *rcu)
+/**
+ * batadv_hardif_release - release hard interface from lists and queue for
+ *  free after rcu grace period
+ * @hard_iface: the hard interface to free
+ */
+void batadv_hardif_release(struct batadv_hard_iface *hard_iface)
 {
-	struct batadv_hard_iface *hard_iface;
-
-	hard_iface = container_of(rcu, struct batadv_hard_iface, rcu);
 	dev_put(hard_iface->net_dev);
-	kfree(hard_iface);
+
+	kfree_rcu(hard_iface, rcu);
 }
 
 struct batadv_hard_iface *
diff --git a/net/batman-adv/hard-interface.h b/net/batman-adv/hard-interface.h
index 7b12ea8ea29d..4d74c0415911 100644
--- a/net/batman-adv/hard-interface.h
+++ b/net/batman-adv/hard-interface.h
@@ -61,18 +61,18 @@ void batadv_hardif_disable_interface(struct batadv_hard_iface *hard_iface,
 void batadv_hardif_remove_interfaces(void);
 int batadv_hardif_min_mtu(struct net_device *soft_iface);
 void batadv_update_min_mtu(struct net_device *soft_iface);
-void batadv_hardif_free_rcu(struct rcu_head *rcu);
+void batadv_hardif_release(struct batadv_hard_iface *hard_iface);
 
 /**
  * batadv_hardif_free_ref - decrement the hard interface refcounter and
- *  possibly free it
+ *  possibly release it
  * @hard_iface: the hard interface to free
  */
 static inline void
 batadv_hardif_free_ref(struct batadv_hard_iface *hard_iface)
 {
 	if (atomic_dec_and_test(&hard_iface->refcount))
-		call_rcu(&hard_iface->rcu, batadv_hardif_free_rcu);
+		batadv_hardif_release(hard_iface);
 }
 
 static inline struct batadv_hard_iface *
-- 
2.20.1

