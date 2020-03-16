Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A345F1875B2
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732766AbgCPWba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:30 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49428 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732825AbgCPWba (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V2y6ZYgPhOa/FD/tcYiWbPYp572N5gYc984pCX1UDSo=;
        b=L2WLtEHrXU0tTgPtCNXcw7HU07sA/lqvsnCO2KtQc6NOVjVS5BOfY/MMivBHpNIFbyY/eh
        FfOhjGHbEcJG2hkFP0044awRFUzmpxKMhhk68yd/2qSJ0A0wSijJMY5mXwl2L5P8g9DBSK
        RUk3j075uBsKm/vZaehCGEe10aRFZ5U=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 21/24] batman-adv: Fix duplicated OGMs on NETDEV_UP
Date:   Mon, 16 Mar 2020 23:31:02 +0100
Message-Id: <20200316223105.6333-22-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223105.6333-1-sven@narfation.org>
References: <20200316223105.6333-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9e6b5648bbc4cd48fab62cecbb81e9cc3c6e7e88 upstream.

The state of slave interfaces are handled differently depending on whether
the interface is up or not. All active interfaces (IFF_UP) will transmit
OGMs. But for B.A.T.M.A.N. IV, also non-active interfaces are scheduling
(low TTL) OGMs on active interfaces. The code which setups and schedules
the OGMs must therefore already be called when the interfaces gets added as
slave interface and the transmit function must then check whether it has to
send out the OGM or not on the specific slave interface.

But the commit f0d97253fb5f ("batman-adv: remove ogm_emit and ogm_schedule
API calls") moved the setup code from the enable function to the activate
function. The latter is called either when the added slave was already up
when batadv_hardif_enable_interface processed the new interface or when a
NETDEV_UP event was received for this slave interfac. As result, each
NETDEV_UP would schedule a new OGM worker for the interface and thus OGMs
would be send a lot more than expected.

Fixes: f0d97253fb5f ("batman-adv: remove ogm_emit and ogm_schedule API calls")
Reported-by: Linus Lüssing <linus.luessing@c0d3.blue>
Tested-by: Linus Lüssing <linus.luessing@c0d3.blue>
Acked-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_iv_ogm.c     | 4 ++--
 net/batman-adv/hard-interface.c | 3 +++
 net/batman-adv/types.h          | 2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index f3de43ccdf93..6f0160c73322 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -2477,7 +2477,7 @@ batadv_iv_ogm_neigh_is_sob(struct batadv_neigh_node *neigh1,
 	return ret;
 }
 
-static void batadv_iv_iface_activate(struct batadv_hard_iface *hard_iface)
+static void batadv_iv_iface_enabled(struct batadv_hard_iface *hard_iface)
 {
 	/* begin scheduling originator messages on that interface */
 	batadv_iv_ogm_schedule(hard_iface);
@@ -2817,8 +2817,8 @@ static void batadv_iv_gw_dump(struct sk_buff *msg, struct netlink_callback *cb,
 static struct batadv_algo_ops batadv_batman_iv __read_mostly = {
 	.name = "BATMAN_IV",
 	.iface = {
-		.activate = batadv_iv_iface_activate,
 		.enable = batadv_iv_ogm_iface_enable,
+		.enabled = batadv_iv_iface_enabled,
 		.disable = batadv_iv_ogm_iface_disable,
 		.update_mac = batadv_iv_ogm_iface_update_mac,
 		.primary_set = batadv_iv_ogm_primary_iface_set,
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 34331ed6de73..5346c6595a09 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -596,6 +596,9 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
 
 	batadv_hardif_recalc_extra_skbroom(soft_iface);
 
+	if (bat_priv->algo_ops->iface.enabled)
+		bat_priv->algo_ops->iface.enabled(hard_iface);
+
 out:
 	return 0;
 
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 1caff709e94e..02eaa90569d9 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1399,6 +1399,7 @@ struct batadv_forw_packet {
  * @activate: start routing mechanisms when hard-interface is brought up
  *  (optional)
  * @enable: init routing info when hard-interface is enabled
+ * @enabled: notification when hard-interface was enabled (optional)
  * @disable: de-init routing info when hard-interface is disabled
  * @update_mac: (re-)init mac addresses of the protocol information
  *  belonging to this hard-interface
@@ -1407,6 +1408,7 @@ struct batadv_forw_packet {
 struct batadv_algo_iface_ops {
 	void (*activate)(struct batadv_hard_iface *hard_iface);
 	int (*enable)(struct batadv_hard_iface *hard_iface);
+	void (*enabled)(struct batadv_hard_iface *hard_iface);
 	void (*disable)(struct batadv_hard_iface *hard_iface);
 	void (*update_mac)(struct batadv_hard_iface *hard_iface);
 	void (*primary_set)(struct batadv_hard_iface *hard_iface);
-- 
2.20.1

