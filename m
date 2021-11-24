Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4597B45BABA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243605AbhKXMOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:14:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242276AbhKXMLm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:11:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3079C610CA;
        Wed, 24 Nov 2021 12:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755592;
        bh=tkP7SDcw/RUv5RTKfkZoJ0tUTp8lXtF1+XfDr9S8muo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDb1A65fzKVZEGothdYEJlsPHuur1dHQsUJImCSKwdQhqQi1xgyOkqyXywp9SB5j2
         Kx2C2gz3peN+8Nw7L4v7ftzjglCaHBNlumv4l4QRCM2F1/vjvXpmABR3PGx3q+6f+P
         3ER0lXEh2yymk5vMQC4HHbFfGPMxabPKzZXdjehY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 151/162] batman-adv: Prevent duplicated softif_vlan entry
Date:   Wed, 24 Nov 2021 12:57:34 +0100
Message-Id: <20211124115703.158037786@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

commit 94cb82f594ed86be303398d6dfc7640a6f1d45d4 upstream.

The function batadv_softif_vlan_get is responsible for adding new
softif_vlan to the softif_vlan_list. It first checks whether the entry
already is in the list or not. If it is, then the creation of a new entry
is aborted.

But the lock for the list is only held when the list is really modified.
This could lead to duplicated entries because another context could create
an entry with the same key between the check and the list manipulation.

The check and the manipulation of the list must therefore be in the same
locked code section.

Fixes: 5d2c05b21337 ("batman-adv: add per VLAN interface attribute framework")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[ bp: 4.4 backport: switch back to atomic_t based reference counting. ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/soft-interface.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -539,15 +539,20 @@ int batadv_softif_create_vlan(struct bat
 	struct batadv_softif_vlan *vlan;
 	int err;
 
+	spin_lock_bh(&bat_priv->softif_vlan_list_lock);
+
 	vlan = batadv_softif_vlan_get(bat_priv, vid);
 	if (vlan) {
 		batadv_softif_vlan_free_ref(vlan);
+		spin_unlock_bh(&bat_priv->softif_vlan_list_lock);
 		return -EEXIST;
 	}
 
 	vlan = kzalloc(sizeof(*vlan), GFP_ATOMIC);
-	if (!vlan)
+	if (!vlan) {
+		spin_unlock_bh(&bat_priv->softif_vlan_list_lock);
 		return -ENOMEM;
+	}
 
 	vlan->bat_priv = bat_priv;
 	vlan->vid = vid;
@@ -555,16 +560,19 @@ int batadv_softif_create_vlan(struct bat
 
 	atomic_set(&vlan->ap_isolation, 0);
 
+	hlist_add_head_rcu(&vlan->list, &bat_priv->softif_vlan_list);
+	spin_unlock_bh(&bat_priv->softif_vlan_list_lock);
+
+	/* batadv_sysfs_add_vlan cannot be in the spinlock section due to the
+	 * sleeping behavior of the sysfs functions and the fs_reclaim lock
+	 */
 	err = batadv_sysfs_add_vlan(bat_priv->soft_iface, vlan);
 	if (err) {
-		kfree(vlan);
+		/* ref for the list */
+		batadv_softif_vlan_free_ref(vlan);
 		return err;
 	}
 
-	spin_lock_bh(&bat_priv->softif_vlan_list_lock);
-	hlist_add_head_rcu(&vlan->list, &bat_priv->softif_vlan_list);
-	spin_unlock_bh(&bat_priv->softif_vlan_list_lock);
-
 	/* add a new TT local entry. This one will be marked with the NOPURGE
 	 * flag
 	 */


