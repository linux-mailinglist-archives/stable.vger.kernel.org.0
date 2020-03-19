Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 799DE18B796
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgCSNed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:34:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728457AbgCSNMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:12:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E2E7208D6;
        Thu, 19 Mar 2020 13:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623567;
        bh=tIV3m+VXCyZx1W2UV5zbTOf+QDk0frEHYVCGbgJ7AZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMLNcj8mYTBL40a9QA0H+1E4WwXWKinIWWZ2xhBU5R5dmsTTxapUQLUQtWbbV2h8W
         XrCw6RG8rmzsSkyKRyzrI4YlB/tVGUbyx8uClSBouBIruiMcCyEQHAuPWSU1fTcR9o
         Z3oIwmcamA4LhuFo5oUKvQPFngwUz+dZFwlxKFhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Linus=20L=FCssing?= <linus.luessing@c0d3.blue>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 71/90] batman-adv: Fix duplicated OGMs on NETDEV_UP
Date:   Thu, 19 Mar 2020 14:00:33 +0100
Message-Id: <20200319123950.322968502@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123928.635114118@linuxfoundation.org>
References: <20200319123928.635114118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c     |    4 ++--
 net/batman-adv/hard-interface.c |    3 +++
 net/batman-adv/types.h          |    2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -2477,7 +2477,7 @@ batadv_iv_ogm_neigh_is_sob(struct batadv
 	return ret;
 }
 
-static void batadv_iv_iface_activate(struct batadv_hard_iface *hard_iface)
+static void batadv_iv_iface_enabled(struct batadv_hard_iface *hard_iface)
 {
 	/* begin scheduling originator messages on that interface */
 	batadv_iv_ogm_schedule(hard_iface);
@@ -2817,8 +2817,8 @@ unlock:
 static struct batadv_algo_ops batadv_batman_iv __read_mostly = {
 	.name = "BATMAN_IV",
 	.iface = {
-		.activate = batadv_iv_iface_activate,
 		.enable = batadv_iv_ogm_iface_enable,
+		.enabled = batadv_iv_iface_enabled,
 		.disable = batadv_iv_ogm_iface_disable,
 		.update_mac = batadv_iv_ogm_iface_update_mac,
 		.primary_set = batadv_iv_ogm_primary_iface_set,
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -596,6 +596,9 @@ int batadv_hardif_enable_interface(struc
 
 	batadv_hardif_recalc_extra_skbroom(soft_iface);
 
+	if (bat_priv->algo_ops->iface.enabled)
+		bat_priv->algo_ops->iface.enabled(hard_iface);
+
 out:
 	return 0;
 
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


