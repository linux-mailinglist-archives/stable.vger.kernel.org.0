Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 385AE2EFC3
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731657AbfE3DSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731640AbfE3DSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:42 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75F142474D;
        Thu, 30 May 2019 03:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186321;
        bh=xntRxPlWYdQfPjD7QGj11AmNCrP8tvlr+4AU/4fmfpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYEc+WFeYJGvoqTVJkU8A7dDB1LtHuGr4IIbyRvukPdfuk60QyXA/qOoEWUj4Xq7p
         CzY8F92KqRvNXfKUkYXvLwE6HC6iOkED+j8kGDT1KLdAmeRW+6LIWQvuVqRG7pR+vf
         2TggcAj2u55oIZ47oxo5R9AURFgMWpB2oNLjpTb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+83f2d54ec6b7e417e13f@syzkaller.appspotmail.com,
        syzbot+050927a651272b145a5d@syzkaller.appspotmail.com,
        syzbot+979ffc89b87309b1b94b@syzkaller.appspotmail.com,
        syzbot+f9f3f388440283da2965@syzkaller.appspotmail.com,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.14 032/193] batman-adv: mcast: fix multicast tt/tvlv worker locking
Date:   Wed, 29 May 2019 20:04:46 -0700
Message-Id: <20190530030453.779235840@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

commit a3c7cd0cdf1107f891aff847ad481e34df727055 upstream.

Syzbot has reported some issues with the locking assumptions made for
the multicast tt/tvlv worker: It was able to trigger the WARN_ON() in
batadv_mcast_mla_tt_retract() and batadv_mcast_mla_tt_add().
While hard/not reproduceable for us so far it seems that the
delayed_work_pending() we use might not be quite safe from reordering.

Therefore this patch adds an explicit, new spinlock to protect the
update of the mla_list and flags in bat_priv and then removes the
WARN_ON(delayed_work_pending()).

Reported-by: syzbot+83f2d54ec6b7e417e13f@syzkaller.appspotmail.com
Reported-by: syzbot+050927a651272b145a5d@syzkaller.appspotmail.com
Reported-by: syzbot+979ffc89b87309b1b94b@syzkaller.appspotmail.com
Reported-by: syzbot+f9f3f388440283da2965@syzkaller.appspotmail.com
Fixes: cbebd363b2e9 ("batman-adv: Use own timer for multicast TT and TVLV updates")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/batman-adv/main.c      |    1 +
 net/batman-adv/multicast.c |   11 +++--------
 net/batman-adv/types.h     |    2 ++
 3 files changed, 6 insertions(+), 8 deletions(-)

--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -153,6 +153,7 @@ int batadv_mesh_init(struct net_device *
 	spin_lock_init(&bat_priv->tt.commit_lock);
 	spin_lock_init(&bat_priv->gw.list_lock);
 #ifdef CONFIG_BATMAN_ADV_MCAST
+	spin_lock_init(&bat_priv->mcast.mla_lock);
 	spin_lock_init(&bat_priv->mcast.want_lists_lock);
 #endif
 	spin_lock_init(&bat_priv->tvlv.container_list_lock);
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -269,8 +269,6 @@ static void batadv_mcast_mla_list_free(s
  * translation table except the ones listed in the given mcast_list.
  *
  * If mcast_list is NULL then all are retracted.
- *
- * Do not call outside of the mcast worker! (or cancel mcast worker first)
  */
 static void batadv_mcast_mla_tt_retract(struct batadv_priv *bat_priv,
 					struct hlist_head *mcast_list)
@@ -278,8 +276,6 @@ static void batadv_mcast_mla_tt_retract(
 	struct batadv_hw_addr *mcast_entry;
 	struct hlist_node *tmp;
 
-	WARN_ON(delayed_work_pending(&bat_priv->mcast.work));
-
 	hlist_for_each_entry_safe(mcast_entry, tmp, &bat_priv->mcast.mla_list,
 				  list) {
 		if (mcast_list &&
@@ -303,8 +299,6 @@ static void batadv_mcast_mla_tt_retract(
  *
  * Adds multicast listener announcements from the given mcast_list to the
  * translation table if they have not been added yet.
- *
- * Do not call outside of the mcast worker! (or cancel mcast worker first)
  */
 static void batadv_mcast_mla_tt_add(struct batadv_priv *bat_priv,
 				    struct hlist_head *mcast_list)
@@ -312,8 +306,6 @@ static void batadv_mcast_mla_tt_add(stru
 	struct batadv_hw_addr *mcast_entry;
 	struct hlist_node *tmp;
 
-	WARN_ON(delayed_work_pending(&bat_priv->mcast.work));
-
 	if (!mcast_list)
 		return;
 
@@ -600,7 +592,10 @@ static void batadv_mcast_mla_update(stru
 	priv_mcast = container_of(delayed_work, struct batadv_priv_mcast, work);
 	bat_priv = container_of(priv_mcast, struct batadv_priv, mcast);
 
+	spin_lock(&bat_priv->mcast.mla_lock);
 	__batadv_mcast_mla_update(bat_priv);
+	spin_unlock(&bat_priv->mcast.mla_lock);
+
 	batadv_mcast_start_timer(bat_priv);
 }
 
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -798,6 +798,7 @@ struct batadv_mcast_querier_state {
  * @flags: the flags we have last sent in our mcast tvlv
  * @enabled: whether the multicast tvlv is currently enabled
  * @bridged: whether the soft interface has a bridge on top
+ * @mla_lock: a lock protecting mla_list and mla_flags
  * @num_disabled: number of nodes that have no mcast tvlv
  * @num_want_all_unsnoopables: number of nodes wanting unsnoopable IP traffic
  * @num_want_all_ipv4: counter for items in want_all_ipv4_list
@@ -816,6 +817,7 @@ struct batadv_priv_mcast {
 	u8 flags;
 	bool enabled;
 	bool bridged;
+	spinlock_t mla_lock;
 	atomic_t num_disabled;
 	atomic_t num_want_all_unsnoopables;
 	atomic_t num_want_all_ipv4;


