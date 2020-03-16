Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207141875B3
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732825AbgCPWba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:30 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49394 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732832AbgCPWba (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5CIbhvSgF1fTid9vhi8UGuCMyRpgO0HjMHweJwG7snA=;
        b=QDoPHvDy3PytA69rE+KBBh4kzIeVicJLAiKMZv0f6NAe3nP9DPea2aPL62aIrJji8M2pv1
        2WPrh7d8GuMdpzpt/WOIymM5MvQU4/YZSau5cnT7rSUEUNobfBhS0O9heyUZTYDRiOE/Nt
        F8u6X3ac4YSz+dunVcAAAYKxitwG5Rw=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 22/24] batman-adv: Avoid free/alloc race when handling OGM2 buffer
Date:   Mon, 16 Mar 2020 23:31:03 +0100
Message-Id: <20200316223105.6333-23-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223105.6333-1-sven@narfation.org>
References: <20200316223105.6333-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a8d23cbbf6c9f515ed678204ad2962be7c336344 upstream.

A B.A.T.M.A.N. V virtual interface has an OGM2 packet buffer which is
initialized using data from the netdevice notifier and other rtnetlink
related hooks. It is sent regularly via various slave interfaces of the
batadv virtual interface and in this process also modified (realloced) to
integrate additional state information via TVLV containers.

It must be avoided that the worker item is executed without a common lock
with the netdevice notifier/rtnetlink helpers. Otherwise it can either
happen that half modified data is sent out or the functions modifying the
OGM2 buffer try to access already freed memory regions.

Fixes: 0da0035942d4 ("batman-adv: OGMv2 - add basic infrastructure")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_v_ogm.c | 42 ++++++++++++++++++++++++++++++--------
 net/batman-adv/types.h     |  3 +++
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index f435435b447e..b0cae59bd327 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -28,6 +28,8 @@
 #include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
+#include <linux/lockdep.h>
+#include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/random.h>
 #include <linux/rculist.h>
@@ -127,22 +129,19 @@ static void batadv_v_ogm_send_to_if(struct sk_buff *skb,
 }
 
 /**
- * batadv_v_ogm_send - periodic worker broadcasting the own OGM
- * @work: work queue item
+ * batadv_v_ogm_send_softif() - periodic worker broadcasting the own OGM
+ *  @bat_priv: the bat priv with all the soft interface information
  */
-static void batadv_v_ogm_send(struct work_struct *work)
+static void batadv_v_ogm_send_softif(struct batadv_priv *bat_priv)
 {
 	struct batadv_hard_iface *hard_iface;
-	struct batadv_priv_bat_v *bat_v;
-	struct batadv_priv *bat_priv;
 	struct batadv_ogm2_packet *ogm_packet;
 	struct sk_buff *skb, *skb_tmp;
 	unsigned char *ogm_buff, *pkt_buff;
 	int ogm_buff_len;
 	u16 tvlv_len = 0;
 
-	bat_v = container_of(work, struct batadv_priv_bat_v, ogm_wq.work);
-	bat_priv = container_of(bat_v, struct batadv_priv, bat_v);
+	lockdep_assert_held(&bat_priv->bat_v.ogm_buff_mutex);
 
 	if (atomic_read(&bat_priv->mesh_state) == BATADV_MESH_DEACTIVATING)
 		goto out;
@@ -209,6 +208,23 @@ static void batadv_v_ogm_send(struct work_struct *work)
 	return;
 }
 
+/**
+ * batadv_v_ogm_send() - periodic worker broadcasting the own OGM
+ * @work: work queue item
+ */
+static void batadv_v_ogm_send(struct work_struct *work)
+{
+	struct batadv_priv_bat_v *bat_v;
+	struct batadv_priv *bat_priv;
+
+	bat_v = container_of(work, struct batadv_priv_bat_v, ogm_wq.work);
+	bat_priv = container_of(bat_v, struct batadv_priv, bat_v);
+
+	mutex_lock(&bat_priv->bat_v.ogm_buff_mutex);
+	batadv_v_ogm_send_softif(bat_priv);
+	mutex_unlock(&bat_priv->bat_v.ogm_buff_mutex);
+}
+
 /**
  * batadv_v_ogm_iface_enable - prepare an interface for B.A.T.M.A.N. V
  * @hard_iface: the interface to prepare
@@ -235,11 +251,15 @@ void batadv_v_ogm_primary_iface_set(struct batadv_hard_iface *primary_iface)
 	struct batadv_priv *bat_priv = netdev_priv(primary_iface->soft_iface);
 	struct batadv_ogm2_packet *ogm_packet;
 
+	mutex_lock(&bat_priv->bat_v.ogm_buff_mutex);
 	if (!bat_priv->bat_v.ogm_buff)
-		return;
+		goto unlock;
 
 	ogm_packet = (struct batadv_ogm2_packet *)bat_priv->bat_v.ogm_buff;
 	ether_addr_copy(ogm_packet->orig, primary_iface->net_dev->dev_addr);
+
+unlock:
+	mutex_unlock(&bat_priv->bat_v.ogm_buff_mutex);
 }
 
 /**
@@ -827,6 +847,8 @@ int batadv_v_ogm_init(struct batadv_priv *bat_priv)
 	atomic_set(&bat_priv->bat_v.ogm_seqno, random_seqno);
 	INIT_DELAYED_WORK(&bat_priv->bat_v.ogm_wq, batadv_v_ogm_send);
 
+	mutex_init(&bat_priv->bat_v.ogm_buff_mutex);
+
 	return 0;
 }
 
@@ -838,7 +860,11 @@ void batadv_v_ogm_free(struct batadv_priv *bat_priv)
 {
 	cancel_delayed_work_sync(&bat_priv->bat_v.ogm_wq);
 
+	mutex_lock(&bat_priv->bat_v.ogm_buff_mutex);
+
 	kfree(bat_priv->bat_v.ogm_buff);
 	bat_priv->bat_v.ogm_buff = NULL;
 	bat_priv->bat_v.ogm_buff_len = 0;
+
+	mutex_unlock(&bat_priv->bat_v.ogm_buff_mutex);
 }
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 02eaa90569d9..bade61f56aa5 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -27,6 +27,7 @@
 #include <linux/compiler.h>
 #include <linux/if_ether.h>
 #include <linux/kref.h>
+#include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/netlink.h>
 #include <linux/sched.h> /* for linux/wait.h */
@@ -966,12 +967,14 @@ struct batadv_softif_vlan {
  * @ogm_buff: buffer holding the OGM packet
  * @ogm_buff_len: length of the OGM packet buffer
  * @ogm_seqno: OGM sequence number - used to identify each OGM
+ * @ogm_buff_mutex: lock protecting ogm_buff and ogm_buff_len
  * @ogm_wq: workqueue used to schedule OGM transmissions
  */
 struct batadv_priv_bat_v {
 	unsigned char *ogm_buff;
 	int ogm_buff_len;
 	atomic_t ogm_seqno;
+	struct mutex ogm_buff_mutex;
 	struct delayed_work ogm_wq;
 };
 
-- 
2.20.1

