Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF7712209F
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfLQA4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:56:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35052 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726907AbfLQAvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0003Ky-Al; Tue, 17 Dec 2019 00:51:32 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0005WF-JG; Tue, 17 Dec 2019 00:51:31 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+0cc629f19ccb8534935b@syzkaller.appspotmail.com,
        "Simon Wunderlich" <sw@simonwunderlich.de>,
        "Sven Eckelmann" <sven@narfation.org>
Date:   Tue, 17 Dec 2019 00:46:35 +0000
Message-ID: <lsq.1576543535.565401289@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 061/136] batman-adv: Avoid free/alloc race when
 handling OGM buffer
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 40e220b4218bb3d278e5e8cc04ccdfd1c7ff8307 upstream.

Each slave interface of an B.A.T.M.A.N. IV virtual interface has an OGM
packet buffer which is initialized using data from netdevice notifier and
other rtnetlink related hooks. It is sent regularly via various slave
interfaces of the batadv virtual interface and in this process also
modified (realloced) to integrate additional state information via TVLV
containers.

It must be avoided that the worker item is executed without a common lock
with the netdevice notifier/rtnetlink helpers. Otherwise it can either
happen that half modified/freed data is sent out or functions modifying the
OGM buffer try to access already freed memory regions.

Reported-by: syzbot+0cc629f19ccb8534935b@syzkaller.appspotmail.com
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[bwh: Backported to 3.16:
 - Don't add status check in batadv_iv_ogm_schedule()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -26,6 +26,8 @@
 #include "bat_algo.h"
 #include "network-coding.h"
 
+#include <linux/lockdep.h>
+#include <linux/mutex.h>
 
 /**
  * batadv_dup_status - duplicate status
@@ -308,14 +310,18 @@ static int batadv_iv_ogm_iface_enable(st
 	unsigned char *ogm_buff;
 	uint32_t random_seqno;
 
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
+
 	/* randomize initial seqno to avoid collision */
 	get_random_bytes(&random_seqno, sizeof(random_seqno));
 	atomic_set(&hard_iface->bat_iv.ogm_seqno, random_seqno);
 
 	hard_iface->bat_iv.ogm_buff_len = BATADV_OGM_HLEN;
 	ogm_buff = kmalloc(hard_iface->bat_iv.ogm_buff_len, GFP_ATOMIC);
-	if (!ogm_buff)
+	if (!ogm_buff) {
+		mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
 		return -ENOMEM;
+	}
 
 	hard_iface->bat_iv.ogm_buff = ogm_buff;
 
@@ -327,36 +333,60 @@ static int batadv_iv_ogm_iface_enable(st
 	batadv_ogm_packet->reserved = 0;
 	batadv_ogm_packet->tq = BATADV_TQ_MAX_VALUE;
 
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
+
 	return 0;
 }
 
 static void batadv_iv_ogm_iface_disable(struct batadv_hard_iface *hard_iface)
 {
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
+
 	kfree(hard_iface->bat_iv.ogm_buff);
 	hard_iface->bat_iv.ogm_buff = NULL;
+
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
 }
 
 static void batadv_iv_ogm_iface_update_mac(struct batadv_hard_iface *hard_iface)
 {
 	struct batadv_ogm_packet *batadv_ogm_packet;
-	unsigned char *ogm_buff = hard_iface->bat_iv.ogm_buff;
+	void *ogm_buff;
 
-	batadv_ogm_packet = (struct batadv_ogm_packet *)ogm_buff;
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
+
+	ogm_buff = hard_iface->bat_iv.ogm_buff;
+	if (!ogm_buff)
+		goto unlock;
+
+	batadv_ogm_packet = ogm_buff;
 	ether_addr_copy(batadv_ogm_packet->orig,
 			hard_iface->net_dev->dev_addr);
 	ether_addr_copy(batadv_ogm_packet->prev_sender,
 			hard_iface->net_dev->dev_addr);
+
+unlock:
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
 }
 
 static void
 batadv_iv_ogm_primary_iface_set(struct batadv_hard_iface *hard_iface)
 {
 	struct batadv_ogm_packet *batadv_ogm_packet;
-	unsigned char *ogm_buff = hard_iface->bat_iv.ogm_buff;
+	void *ogm_buff;
 
-	batadv_ogm_packet = (struct batadv_ogm_packet *)ogm_buff;
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
+
+	ogm_buff = hard_iface->bat_iv.ogm_buff;
+	if (!ogm_buff)
+		goto unlock;
+
+	batadv_ogm_packet = ogm_buff;
 	batadv_ogm_packet->flags = BATADV_PRIMARIES_FIRST_HOP;
 	batadv_ogm_packet->ttl = BATADV_TTL;
+
+unlock:
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
 }
 
 /* when do we schedule our own ogm to be sent */
@@ -891,7 +921,11 @@ batadv_iv_ogm_slide_own_bcast_window(str
 	}
 }
 
-static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
+/**
+ * batadv_iv_ogm_schedule_buff() - schedule submission of hardif ogm buffer
+ * @hard_iface: interface whose ogm buffer should be transmitted
+ */
+static void batadv_iv_ogm_schedule_buff(struct batadv_hard_iface *hard_iface)
 {
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 	unsigned char **ogm_buff = &hard_iface->bat_iv.ogm_buff;
@@ -902,6 +936,8 @@ static void batadv_iv_ogm_schedule(struc
 	uint16_t tvlv_len = 0;
 	unsigned long send_time;
 
+	lockdep_assert_held(&hard_iface->bat_iv.ogm_buff_mutex);
+
 	primary_if = batadv_primary_if_get_selected(bat_priv);
 
 	if (hard_iface == primary_if) {
@@ -1560,6 +1596,13 @@ out:
 	kfree_skb(skb_priv);
 }
 
+static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
+{
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
+	batadv_iv_ogm_schedule_buff(hard_iface);
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
+}
+
 /**
  * batadv_iv_ogm_process - process an incoming batman iv OGM
  * @skb: the skb containing the OGM
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -31,6 +31,7 @@
 
 #include <linux/if_arp.h>
 #include <linux/if_ether.h>
+#include <linux/mutex.h>
 
 void batadv_hardif_free_rcu(struct rcu_head *rcu)
 {
@@ -591,6 +592,7 @@ batadv_hardif_add_interface(struct net_d
 	INIT_WORK(&hard_iface->cleanup_work,
 		  batadv_hardif_remove_interface_finish);
 
+	mutex_init(&hard_iface->bat_iv.ogm_buff_mutex);
 	hard_iface->num_bcasts = BATADV_NUM_BCASTS_DEFAULT;
 	if (batadv_is_wifi_netdev(net_dev))
 		hard_iface->num_bcasts = BATADV_NUM_BCASTS_WIRELESS;
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -68,6 +68,9 @@ struct batadv_hard_iface_bat_iv {
 	unsigned char *ogm_buff;
 	int ogm_buff_len;
 	atomic_t ogm_seqno;
+
+	/** @ogm_buff_mutex: lock protecting ogm_buff and ogm_buff_len */
+	struct mutex ogm_buff_mutex;
 };
 
 /**

