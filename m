Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7E458307D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242265AbiG0Riw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242602AbiG0RiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:38:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161638722B;
        Wed, 27 Jul 2022 09:50:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB37F61709;
        Wed, 27 Jul 2022 16:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2034C433D7;
        Wed, 27 Jul 2022 16:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940620;
        bh=7FXiz8Wqs8s3IpD8TXzH/H16cPz+n1lRHTcYIBx3ioU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExZQGXi9yVHqTuLPDOyNNF9mZyAIs9283yafi99xP01AChm1iwCKXaue2k0C+8Owv
         j5HjtaAqfflOrLYVwGVRvXxLlLHGIbQWPhtwEnd77lmfSGDehgS31bZCL3YeflWRrp
         HUoqci5nCzv/TiFGtApJJ8tQ4p+90dlyKzfX2o7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 088/158] net: lan966x: Fix usage of lan966x->mac_lock when used by FDB
Date:   Wed, 27 Jul 2022 18:12:32 +0200
Message-Id: <20220727161025.007895912@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 675c807ae26b267233b97cd5006979a6bb8d54d4 ]

When the SW bridge was trying to add/remove entries to/from HW, the
access to HW was not protected by any lock. In this way, it was
possible to have race conditions.
Fix this by using the lan966x->mac_lock to protect parallel access to HW
for this cases.

Fixes: 25ee9561ec622 ("net: lan966x: More MAC table functionality")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 34 +++++++++++++------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index 69e343b7f4af..5893770bfd94 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -201,7 +201,6 @@ static struct lan966x_mac_entry *lan966x_mac_find_entry(struct lan966x *lan966x,
 	struct lan966x_mac_entry *res = NULL;
 	struct lan966x_mac_entry *mac_entry;
 
-	spin_lock(&lan966x->mac_lock);
 	list_for_each_entry(mac_entry, &lan966x->mac_entries, list) {
 		if (mac_entry->vid == vid &&
 		    ether_addr_equal(mac, mac_entry->mac) &&
@@ -210,7 +209,6 @@ static struct lan966x_mac_entry *lan966x_mac_find_entry(struct lan966x *lan966x,
 			break;
 		}
 	}
-	spin_unlock(&lan966x->mac_lock);
 
 	return res;
 }
@@ -253,8 +251,11 @@ int lan966x_mac_add_entry(struct lan966x *lan966x, struct lan966x_port *port,
 {
 	struct lan966x_mac_entry *mac_entry;
 
-	if (lan966x_mac_lookup(lan966x, addr, vid, ENTRYTYPE_NORMAL))
+	spin_lock(&lan966x->mac_lock);
+	if (lan966x_mac_lookup(lan966x, addr, vid, ENTRYTYPE_NORMAL)) {
+		spin_unlock(&lan966x->mac_lock);
 		return 0;
+	}
 
 	/* In case the entry already exists, don't add it again to SW,
 	 * just update HW, but we need to look in the actual HW because
@@ -263,21 +264,25 @@ int lan966x_mac_add_entry(struct lan966x *lan966x, struct lan966x_port *port,
 	 * add the entry but without the extern_learn flag.
 	 */
 	mac_entry = lan966x_mac_find_entry(lan966x, addr, vid, port->chip_port);
-	if (mac_entry)
-		return lan966x_mac_learn(lan966x, port->chip_port,
-					 addr, vid, ENTRYTYPE_LOCKED);
+	if (mac_entry) {
+		spin_unlock(&lan966x->mac_lock);
+		goto mac_learn;
+	}
 
 	mac_entry = lan966x_mac_alloc_entry(addr, vid, port->chip_port);
-	if (!mac_entry)
+	if (!mac_entry) {
+		spin_unlock(&lan966x->mac_lock);
 		return -ENOMEM;
+	}
 
-	spin_lock(&lan966x->mac_lock);
 	list_add_tail(&mac_entry->list, &lan966x->mac_entries);
 	spin_unlock(&lan966x->mac_lock);
 
-	lan966x_mac_learn(lan966x, port->chip_port, addr, vid, ENTRYTYPE_LOCKED);
 	lan966x_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED, addr, vid, port->dev);
 
+mac_learn:
+	lan966x_mac_learn(lan966x, port->chip_port, addr, vid, ENTRYTYPE_LOCKED);
+
 	return 0;
 }
 
@@ -291,8 +296,9 @@ int lan966x_mac_del_entry(struct lan966x *lan966x, const unsigned char *addr,
 				 list) {
 		if (mac_entry->vid == vid &&
 		    ether_addr_equal(addr, mac_entry->mac)) {
-			lan966x_mac_forget(lan966x, mac_entry->mac, mac_entry->vid,
-					   ENTRYTYPE_LOCKED);
+			lan966x_mac_forget_locked(lan966x, mac_entry->mac,
+						  mac_entry->vid,
+						  ENTRYTYPE_LOCKED);
 
 			list_del(&mac_entry->list);
 			kfree(mac_entry);
@@ -428,6 +434,12 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 			continue;
 
 		spin_lock(&lan966x->mac_lock);
+		mac_entry = lan966x_mac_find_entry(lan966x, mac, vid, dest_idx);
+		if (mac_entry) {
+			spin_unlock(&lan966x->mac_lock);
+			continue;
+		}
+
 		mac_entry = lan966x_mac_alloc_entry(mac, vid, dest_idx);
 		if (!mac_entry) {
 			spin_unlock(&lan966x->mac_lock);
-- 
2.35.1



