Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF641891FE
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgCQX16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:27:58 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53676 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgCQX16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:27:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YoKyaLl5AU7UP6GRp8q/T1afIkS2BfWx0QY8gz38i5g=;
        b=XFmjYVlE6W49VokSRLgq7J9gj4lOFoGgUM27VK5F9Nw2Uy8iosPeO8Z+T6Xki9uoosIHJ8
        6h/6J79WixQ8ID+r832PhvyOT+Pd9xJVKpjHqPlOnLEk96P4J8nXD62s9d/OyxcDOS2eZV
        hiu3dteC5yedLyYwaqxXhHvSRh2vf0c=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <a@unstable.cc>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 15/48] batman-adv: Clean up untagged vlan when destroying via rtnl-link
Date:   Wed, 18 Mar 2020 00:27:01 +0100
Message-Id: <20200317232734.6127-16-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 420cb1b764f9169c5d2601b4af90e4a1702345ee upstream.

The untagged vlan object is only destroyed when the interface is removed
via the legacy sysfs interface. But it also has to be destroyed when the
standard rtnl-link interface is used.

Fixes: 5d2c05b21337 ("batman-adv: add per VLAN interface attribute framework")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/batman-adv/soft-interface.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 4812123e0a2c..ff693887ea82 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -1000,7 +1000,9 @@ void batadv_softif_destroy_sysfs(struct net_device *soft_iface)
 static void batadv_softif_destroy_netlink(struct net_device *soft_iface,
 					  struct list_head *head)
 {
+	struct batadv_priv *bat_priv = netdev_priv(soft_iface);
 	struct batadv_hard_iface *hard_iface;
+	struct batadv_softif_vlan *vlan;
 
 	list_for_each_entry(hard_iface, &batadv_hardif_list, list) {
 		if (hard_iface->soft_iface == soft_iface)
@@ -1008,6 +1010,13 @@ static void batadv_softif_destroy_netlink(struct net_device *soft_iface,
 							BATADV_IF_CLEANUP_KEEP);
 	}
 
+	/* destroy the "untagged" VLAN */
+	vlan = batadv_softif_vlan_get(bat_priv, BATADV_NO_FLAGS);
+	if (vlan) {
+		batadv_softif_destroy_vlan(bat_priv, vlan);
+		batadv_softif_vlan_free_ref(vlan);
+	}
+
 	batadv_sysfs_del_meshif(soft_iface);
 	unregister_netdevice_queue(soft_iface, head);
 }
-- 
2.20.1

