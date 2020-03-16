Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F11F718759B
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732808AbgCPWbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:04 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49068 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732743AbgCPWbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mvsSEQu6KHuA0Wf9yv80R8eoq40EdcXcHo5uW7o/eSM=;
        b=r4Qo098+z7Lnhofu+JgQtq0Tb15M+kHAcNMfhTrMaXdLwp268MF3dchYea/vu672m6sVzX
        FJlPR0XYZ0B7wN6ZZ56Dqf9k8lsEIJa9Y/qmCV7rq+1+bYmlZz9e66ebiY7JripTF1n/h4
        AVuiYF7QktQ8KYzUfqZAsPCjZGn6cdQ=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        syzbot+0cc629f19ccb8534935b@syzkaller.appspotmail.com,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.14 14/15] batman-adv: Avoid free/alloc race when handling OGM buffer
Date:   Mon, 16 Mar 2020 23:30:31 +0100
Message-Id: <20200316223032.6236-15-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223032.6236-1-sven@narfation.org>
References: <20200316223032.6236-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 net/batman-adv/bat_iv_ogm.c     | 60 ++++++++++++++++++++++++++++-----
 net/batman-adv/hard-interface.c |  2 ++
 net/batman-adv/types.h          |  2 ++
 3 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 0ed33a9a41b7..30e774354d4e 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -34,6 +34,7 @@
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
+#include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/netlink.h>
 #include <linux/pkt_sched.h>
@@ -370,14 +371,18 @@ static int batadv_iv_ogm_iface_enable(struct batadv_hard_iface *hard_iface)
 	unsigned char *ogm_buff;
 	u32 random_seqno;
 
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
 
@@ -389,35 +394,59 @@ static int batadv_iv_ogm_iface_enable(struct batadv_hard_iface *hard_iface)
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
 	batadv_ogm_packet->ttl = BATADV_TTL;
+
+unlock:
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
 }
 
 /* when do we schedule our own ogm to be sent */
@@ -915,7 +944,11 @@ batadv_iv_ogm_slide_own_bcast_window(struct batadv_hard_iface *hard_iface)
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
@@ -926,9 +959,7 @@ static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
 	u16 tvlv_len = 0;
 	unsigned long send_time;
 
-	if ((hard_iface->if_status == BATADV_IF_NOT_IN_USE) ||
-	    (hard_iface->if_status == BATADV_IF_TO_BE_REMOVED))
-		return;
+	lockdep_assert_held(&hard_iface->bat_iv.ogm_buff_mutex);
 
 	/* the interface gets activated here to avoid race conditions between
 	 * the moment of activating the interface in
@@ -996,6 +1027,17 @@ static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
 		batadv_hardif_put(primary_if);
 }
 
+static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
+{
+	if (hard_iface->if_status == BATADV_IF_NOT_IN_USE ||
+	    hard_iface->if_status == BATADV_IF_TO_BE_REMOVED)
+		return;
+
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
+	batadv_iv_ogm_schedule_buff(hard_iface);
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
+}
+
 /**
  * batadv_iv_ogm_orig_update - use OGM to update corresponding data in an
  *  originator
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 63760967712e..9fdfa9984f02 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -28,6 +28,7 @@
 #include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
@@ -901,6 +902,7 @@ batadv_hardif_add_interface(struct net_device *net_dev)
 	INIT_LIST_HEAD(&hard_iface->list);
 	INIT_HLIST_HEAD(&hard_iface->neigh_list);
 
+	mutex_init(&hard_iface->bat_iv.ogm_buff_mutex);
 	spin_lock_init(&hard_iface->neigh_list_lock);
 	kref_init(&hard_iface->refcount);
 
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 21642fbe95c3..540a9c5c2270 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -82,11 +82,13 @@ enum batadv_dhcp_recipient {
  * @ogm_buff: buffer holding the OGM packet
  * @ogm_buff_len: length of the OGM packet buffer
  * @ogm_seqno: OGM sequence number - used to identify each OGM
+ * @ogm_buff_mutex: lock protecting ogm_buff and ogm_buff_len
  */
 struct batadv_hard_iface_bat_iv {
 	unsigned char *ogm_buff;
 	int ogm_buff_len;
 	atomic_t ogm_seqno;
+	struct mutex ogm_buff_mutex;
 };
 
 /**
-- 
2.20.1

