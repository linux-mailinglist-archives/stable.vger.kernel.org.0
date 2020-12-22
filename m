Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9010A2DEF37
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgLSNA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:00:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728310AbgLSM7u (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:59:50 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 28/49] bonding: fix feature flag setting at init time
Date:   Sat, 19 Dec 2020 13:58:32 +0100
Message-Id: <20201219125346.056624222@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>

[ Upstream commit 007ab5345545aba2f9cbe4c096cc35d2fd3275ac ]

Don't try to adjust XFRM support flags if the bond device isn't yet
registered. Bad things can currently happen when netdev_change_features()
is called without having wanted_features fully filled in yet. This code
runs both on post-module-load mode changes, as well as at module init
time, and when run at module init time, it is before register_netdevice()
has been called and filled in wanted_features. The empty wanted_features
led to features also getting emptied out, which was definitely not the
intended behavior, so prevent that from happening.

Originally, I'd hoped to stop adjusting wanted_features at all in the
bonding driver, as it's documented as being something only the network
core should touch, but we actually do need to do this to properly update
both the features and wanted_features fields when changing the bond type,
or we get to a situation where ethtool sees:

    esp-hw-offload: off [requested on]

I do think we should be using netdev_update_features instead of
netdev_change_features here though, so we only send notifiers when the
features actually changed.

Fixes: a3b658cfb664 ("bonding: allow xfrm offload setup post-module-load")
Reported-by: Ivan Vecera <ivecera@redhat.com>
Suggested-by: Ivan Vecera <ivecera@redhat.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
Link: https://lore.kernel.org/r/20201205172229.576587-1-jarod@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_options.c |   22 +++++++++++++++-------
 include/net/bonding.h              |    2 --
 2 files changed, 15 insertions(+), 9 deletions(-)

--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -745,6 +745,19 @@ const struct bond_option *bond_opt_get(u
 	return &bond_opts[option];
 }
 
+static void bond_set_xfrm_features(struct net_device *bond_dev, u64 mode)
+{
+	if (!IS_ENABLED(CONFIG_XFRM_OFFLOAD))
+		return;
+
+	if (mode == BOND_MODE_ACTIVEBACKUP)
+		bond_dev->wanted_features |= BOND_XFRM_FEATURES;
+	else
+		bond_dev->wanted_features &= ~BOND_XFRM_FEATURES;
+
+	netdev_update_features(bond_dev);
+}
+
 static int bond_option_mode_set(struct bonding *bond,
 				const struct bond_opt_value *newval)
 {
@@ -767,13 +780,8 @@ static int bond_option_mode_set(struct b
 	if (newval->value == BOND_MODE_ALB)
 		bond->params.tlb_dynamic_lb = 1;
 
-#ifdef CONFIG_XFRM_OFFLOAD
-	if (newval->value == BOND_MODE_ACTIVEBACKUP)
-		bond->dev->wanted_features |= BOND_XFRM_FEATURES;
-	else
-		bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
-	netdev_change_features(bond->dev);
-#endif /* CONFIG_XFRM_OFFLOAD */
+	if (bond->dev->reg_state == NETREG_REGISTERED)
+		bond_set_xfrm_features(bond->dev, newval->value);
 
 	/* don't cache arp_validate between modes */
 	bond->params.arp_validate = BOND_ARP_VALIDATE_NONE;
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -86,10 +86,8 @@
 #define bond_for_each_slave_rcu(bond, pos, iter) \
 	netdev_for_each_lower_private_rcu((bond)->dev, pos, iter)
 
-#ifdef CONFIG_XFRM_OFFLOAD
 #define BOND_XFRM_FEATURES (NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM | \
 			    NETIF_F_GSO_ESP)
-#endif /* CONFIG_XFRM_OFFLOAD */
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 extern atomic_t netpoll_block_tx;


