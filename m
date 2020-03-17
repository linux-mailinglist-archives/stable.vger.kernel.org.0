Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57FE2189220
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbgCQX2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:30 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53930 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgCQX2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o52CJ0L17dMS1RFhQbwaI4qpWpOy2i1j6AuoJkPhdnM=;
        b=cy30zeLxgNVmPQ9OryRi2M59v0nghA/zjT0IxBVYCkeAHhgxto1/jMSWRr/5SQr9crulXu
        PmtjjbMEQUNFaPYc+VLyHoVuHaw0QIr+bzGc7xFK5pL8nFh4xMhXpSM5TrBHDP/XyQE7Dp
        JikjeI95Eonptz3s9rfKHbQH5jZLeu8=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        syzbot+0cc629f19ccb8534935b@syzkaller.appspotmail.com,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 47/48] batman-adv: Avoid free/alloc race when handling OGM buffer
Date:   Wed, 18 Mar 2020 00:27:33 +0100
Message-Id: <20200317232734.6127-48-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
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
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/bat_iv_ogm.c     | 57 +++++++++++++++++++++++++++++----
 net/batman-adv/hard-interface.c |  2 ++
 net/batman-adv/types.h          |  2 ++
 3 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index f1c8b1311dee..eb2f2ed9a956 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -316,14 +316,18 @@ static int batadv_iv_ogm_iface_enable(struct batadv_hard_iface *hard_iface)
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
 
@@ -335,36 +339,60 @@ static int batadv_iv_ogm_iface_enable(struct batadv_hard_iface *hard_iface)
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
@@ -899,7 +927,11 @@ batadv_iv_ogm_slide_own_bcast_window(struct batadv_hard_iface *hard_iface)
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
@@ -910,6 +942,8 @@ static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
 	u16 tvlv_len = 0;
 	unsigned long send_time;
 
+	lockdep_assert_held(&hard_iface->bat_iv.ogm_buff_mutex);
+
 	primary_if = batadv_primary_if_get_selected(bat_priv);
 
 	if (hard_iface == primary_if) {
@@ -961,6 +995,17 @@ out:
 		batadv_hardif_free_ref(primary_if);
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
index 70f7bb42cd2a..c59bbc327763 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -26,6 +26,7 @@
 #include <linux/if.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
@@ -671,6 +672,7 @@ batadv_hardif_add_interface(struct net_device *net_dev)
 		goto free_sysfs;
 
 	INIT_LIST_HEAD(&hard_iface->list);
+	mutex_init(&hard_iface->bat_iv.ogm_buff_mutex);
 	INIT_WORK(&hard_iface->cleanup_work,
 		  batadv_hardif_remove_interface_finish);
 
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 6dcee1991c54..8fce1241ad6d 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -77,11 +77,13 @@ enum batadv_dhcp_recipient {
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

