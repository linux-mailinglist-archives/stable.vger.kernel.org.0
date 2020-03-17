Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D3D1891F1
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgCQX1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:27:45 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53448 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgCQX1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:27:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pZ1SO8YzsnOCcD6Tb3Dpx2626rgNUD1lbLgi0zVV+2o=;
        b=vdCSZANy2aKxSBvIH+IaZESCVIE021kOOTYRrNXUiIaqkm6+iZVsLYw02i99i/YrxrJDnG
        kcpSzihI1gJ6D0vmZSb+3vKfSxOuuCC0ts3DSu/GeqS5O/l0HU+2AHjUFo0N2csTP/DYJP
        FTKh7WBJFWokvXtvRXh8l0y7efgzucA=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 02/48] batman-adv: Only put gw_node list reference when removed
Date:   Wed, 18 Mar 2020 00:26:48 +0100
Message-Id: <20200317232734.6127-3-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c18bdd018e8912ca73ad6c12120b7283b5038875 upstream.

The batadv_gw_node reference counter in batadv_gw_node_update can only be
reduced when the list entry was actually removed. Otherwise the reference
counter may reach zero when batadv_gw_node_update is called from two
different contexts for the same gw_node but only one context is actually
removing the entry from the list.

The release function for this gw_node is not called inside the list_lock
spinlock protected region because the function batadv_gw_node_update still
holds a gw_node reference for the object pointer on the stack. Thus the
actual release function (when required) will be called only at the end of
the function.

Fixes: bd3524c14bd0 ("batman-adv: remove obsolete deleted attribute for gateway node")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <a@unstable.cc>
---
 net/batman-adv/gateway_client.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index 6abfba1e227f..055baa396260 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -527,11 +527,12 @@ void batadv_gw_node_update(struct batadv_priv *bat_priv,
 		 * gets dereferenced.
 		 */
 		spin_lock_bh(&bat_priv->gw.list_lock);
-		hlist_del_init_rcu(&gw_node->list);
+		if (!hlist_unhashed(&gw_node->list)) {
+			hlist_del_init_rcu(&gw_node->list);
+			batadv_gw_node_free_ref(gw_node);
+		}
 		spin_unlock_bh(&bat_priv->gw.list_lock);
 
-		batadv_gw_node_free_ref(gw_node);
-
 		curr_gw = batadv_gw_get_selected_gw_node(bat_priv);
 		if (gw_node == curr_gw)
 			batadv_gw_reselect(bat_priv);
-- 
2.20.1

