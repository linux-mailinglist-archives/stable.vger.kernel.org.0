Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D01AD73FD7
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbfGXTZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbfGXTZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:25:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E181218F0;
        Wed, 24 Jul 2019 19:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996322;
        bh=AHGkYwUFFFPf7Dj2D4wc3lGnKJts8mpM6fWbta8L218=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q7Vaq/Uq7hklLG8Fr7a2UhADJI5lJonDVwiPPqxFx6wv8Z2m2HEdvSaoFl+5kmccA
         SQfIeNeYQv/Ozsb3w8tZNAC7tEyzdOPn8SpSKvWt/76QMEWHmZJSVtnVyPoITdx/B0
         J23xDwXUnmwJisgvtPh+tt1Taode/ygtl8ZRMhrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 056/413] batman-adv: Fix duplicated OGMs on NETDEV_UP
Date:   Wed, 24 Jul 2019 21:15:47 +0200
Message-Id: <20190724191739.379821121@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9e6b5648bbc4cd48fab62cecbb81e9cc3c6e7e88 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c     | 4 ++--
 net/batman-adv/hard-interface.c | 3 +++
 net/batman-adv/types.h          | 3 +++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index bd4138ddf7e0..240ed70912d6 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -2337,7 +2337,7 @@ batadv_iv_ogm_neigh_is_sob(struct batadv_neigh_node *neigh1,
 	return ret;
 }
 
-static void batadv_iv_iface_activate(struct batadv_hard_iface *hard_iface)
+static void batadv_iv_iface_enabled(struct batadv_hard_iface *hard_iface)
 {
 	/* begin scheduling originator messages on that interface */
 	batadv_iv_ogm_schedule(hard_iface);
@@ -2683,8 +2683,8 @@ static void batadv_iv_gw_dump(struct sk_buff *msg, struct netlink_callback *cb,
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
index 79d1731b8306..3719cfd026f0 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -795,6 +795,9 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
 
 	batadv_hardif_recalc_extra_skbroom(soft_iface);
 
+	if (bat_priv->algo_ops->iface.enabled)
+		bat_priv->algo_ops->iface.enabled(hard_iface);
+
 out:
 	return 0;
 
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 74b644738a36..e0b25104cbfa 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -2129,6 +2129,9 @@ struct batadv_algo_iface_ops {
 	/** @enable: init routing info when hard-interface is enabled */
 	int (*enable)(struct batadv_hard_iface *hard_iface);
 
+	/** @enabled: notification when hard-interface was enabled (optional) */
+	void (*enabled)(struct batadv_hard_iface *hard_iface);
+
 	/** @disable: de-init routing info when hard-interface is disabled */
 	void (*disable)(struct batadv_hard_iface *hard_iface);
 
-- 
2.20.1



