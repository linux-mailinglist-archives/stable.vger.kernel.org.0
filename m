Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8F018B559
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbgCSNRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729684AbgCSNRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:17:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 482F220787;
        Thu, 19 Mar 2020 13:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623861;
        bh=yWBP8NC1T6Y41kW+SfUswRPelU3dwmrCB55ljXektVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybAMsgObQ1WasKfYJ1vml/6w6FRxNK886OW/0b0T+7HZ68fE0P+8rOrbL9spCtp/F
         pDpMsDaP/ErNU/ol4o50TUP8a+FFE2c/pygtCdZkTM4BCAzH3a2FLMXNTW+ftpjO/w
         tRDsNg2+VnHdB4LlACpv7Y+cULVEGOyVkaIPY7gA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.14 79/99] batman-adv: Avoid free/alloc race when handling OGM2 buffer
Date:   Thu, 19 Mar 2020 14:03:57 +0100
Message-Id: <20200319124004.677685811@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_v_ogm.c |   42 ++++++++++++++++++++++++++++++++++--------
 net/batman-adv/types.h     |    3 +++
 2 files changed, 37 insertions(+), 8 deletions(-)

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
@@ -127,14 +129,12 @@ static void batadv_v_ogm_send_to_if(stru
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
 	unsigned char *ogm_buff;
@@ -142,8 +142,7 @@ static void batadv_v_ogm_send(struct wor
 	u16 tvlv_len = 0;
 	int ret;
 
-	bat_v = container_of(work, struct batadv_priv_bat_v, ogm_wq.work);
-	bat_priv = container_of(bat_v, struct batadv_priv, bat_v);
+	lockdep_assert_held(&bat_priv->bat_v.ogm_buff_mutex);
 
 	if (atomic_read(&bat_priv->mesh_state) == BATADV_MESH_DEACTIVATING)
 		goto out;
@@ -235,6 +234,23 @@ out:
 }
 
 /**
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
+/**
  * batadv_v_ogm_iface_enable - prepare an interface for B.A.T.M.A.N. V
  * @hard_iface: the interface to prepare
  *
@@ -260,11 +276,15 @@ void batadv_v_ogm_primary_iface_set(stru
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
@@ -886,6 +906,8 @@ int batadv_v_ogm_init(struct batadv_priv
 	atomic_set(&bat_priv->bat_v.ogm_seqno, random_seqno);
 	INIT_DELAYED_WORK(&bat_priv->bat_v.ogm_wq, batadv_v_ogm_send);
 
+	mutex_init(&bat_priv->bat_v.ogm_buff_mutex);
+
 	return 0;
 }
 
@@ -897,7 +919,11 @@ void batadv_v_ogm_free(struct batadv_pri
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
@@ -989,12 +990,14 @@ struct batadv_softif_vlan {
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
 


