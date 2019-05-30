Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61DDA2F41F
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbfE3EfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729370AbfE3DNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:14 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA568244B0;
        Thu, 30 May 2019 03:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185993;
        bh=TowusqZkdbphibd65Bc4guMeYN9nvPInafHrQJQPyqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPT7KKrQLRCz7xWnGkNRO5PlCNbcdt1NNo2HTrElZuPMnDlOfljKcBmQe0K9nzclU
         /XIxHQXqmtyZokrBfU+WhO4BTO9MBlBmb/cOYEyuhCgnfncTXpOM2j/j9KemVpSbj1
         Pn7Od1U6Fwy2+jYeYKI/IktLhKNJ3Wffvt1moJ8w=
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
Subject: [PATCH 5.0 037/346] batman-adv: mcast: fix multicast tt/tvlv worker locking
Date:   Wed, 29 May 2019 20:01:50 -0700
Message-Id: <20190530030542.717727452@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
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
 net/batman-adv/types.h     |    5 +++++
 3 files changed, 9 insertions(+), 8 deletions(-)

--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -161,6 +161,7 @@ int batadv_mesh_init(struct net_device *
 	spin_lock_init(&bat_priv->tt.commit_lock);
 	spin_lock_init(&bat_priv->gw.list_lock);
 #ifdef CONFIG_BATMAN_ADV_MCAST
+	spin_lock_init(&bat_priv->mcast.mla_lock);
 	spin_lock_init(&bat_priv->mcast.want_lists_lock);
 #endif
 	spin_lock_init(&bat_priv->tvlv.container_list_lock);
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -325,8 +325,6 @@ static void batadv_mcast_mla_list_free(s
  * translation table except the ones listed in the given mcast_list.
  *
  * If mcast_list is NULL then all are retracted.
- *
- * Do not call outside of the mcast worker! (or cancel mcast worker first)
  */
 static void batadv_mcast_mla_tt_retract(struct batadv_priv *bat_priv,
 					struct hlist_head *mcast_list)
@@ -334,8 +332,6 @@ static void batadv_mcast_mla_tt_retract(
 	struct batadv_hw_addr *mcast_entry;
 	struct hlist_node *tmp;
 
-	WARN_ON(delayed_work_pending(&bat_priv->mcast.work));
-
 	hlist_for_each_entry_safe(mcast_entry, tmp, &bat_priv->mcast.mla_list,
 				  list) {
 		if (mcast_list &&
@@ -359,8 +355,6 @@ static void batadv_mcast_mla_tt_retract(
  *
  * Adds multicast listener announcements from the given mcast_list to the
  * translation table if they have not been added yet.
- *
- * Do not call outside of the mcast worker! (or cancel mcast worker first)
  */
 static void batadv_mcast_mla_tt_add(struct batadv_priv *bat_priv,
 				    struct hlist_head *mcast_list)
@@ -368,8 +362,6 @@ static void batadv_mcast_mla_tt_add(stru
 	struct batadv_hw_addr *mcast_entry;
 	struct hlist_node *tmp;
 
-	WARN_ON(delayed_work_pending(&bat_priv->mcast.work));
-
 	if (!mcast_list)
 		return;
 
@@ -658,7 +650,10 @@ static void batadv_mcast_mla_update(stru
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
@@ -1224,6 +1224,11 @@ struct batadv_priv_mcast {
 	unsigned char bridged:1;
 
 	/**
+	 * @mla_lock: a lock protecting mla_list and mla_flags
+	 */
+	spinlock_t mla_lock;
+
+	/**
 	 * @num_want_all_unsnoopables: number of nodes wanting unsnoopable IP
 	 *  traffic
 	 */


