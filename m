Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07A9583074
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242675AbiG0RiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242533AbiG0Rh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:37:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2695186C0B;
        Wed, 27 Jul 2022 09:50:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5DDC60D3B;
        Wed, 27 Jul 2022 16:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57A8C433D6;
        Wed, 27 Jul 2022 16:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940609;
        bh=MB48tir69+UgtBlHJV7vcCVKs43QLs5qQdmeSAwoAEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvX1sHmxirNuM/WSsZYBP1g5B+aoN2FTm0XrbIzOjUr+/qCs5As3PufZavFzuRLbU
         rNX+KQ6XphA5WoIiNGTznEZtUg+KZzPIC3ACbi7QBHgFHVKZ/yi/Mrcr2jCFEe7jVK
         Bl5e7bSqSi1u8xwow7HZZwJdlAYlaW8PPB4cBdxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 084/158] net: lan966x: Fix taking rtnl_lock while holding spin_lock
Date:   Wed, 27 Jul 2022 18:12:28 +0200
Message-Id: <20220727161024.861930432@linuxfoundation.org>
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

[ Upstream commit 45533a534a45cb12c20c81615d17306176cb1c57 ]

When the HW deletes an entry in MAC table then it generates an
interrupt. The SW will go through it's own list of MAC entries and if it
is not found then it would notify the listeners about this. The problem
is that when the SW will go through it's own list it would take a spin
lock(lan966x->mac_lock) and when it notifies that the entry is deleted.
But to notify the listeners it taking the rtnl_lock which is illegal.

This is fixed by instead of notifying right away that the entry is
deleted, move the entry on a temp list and once, it checks all the
entries then just notify that the entries from temp list are deleted.

Fixes: 5ccd66e01cbe ("net: lan966x: add support for interrupts from analyzer")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 27 ++++++++++++-------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index 005e56ea5da1..2d2b83c03796 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -325,10 +325,13 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 {
 	struct lan966x_mac_entry *mac_entry, *tmp;
 	unsigned char mac[ETH_ALEN] __aligned(2);
+	struct list_head mac_deleted_entries;
 	u32 dest_idx;
 	u32 column;
 	u16 vid;
 
+	INIT_LIST_HEAD(&mac_deleted_entries);
+
 	spin_lock(&lan966x->mac_lock);
 	list_for_each_entry_safe(mac_entry, tmp, &lan966x->mac_entries, list) {
 		bool found = false;
@@ -362,20 +365,26 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 		}
 
 		if (!found) {
-			/* Notify the bridge that the entry doesn't exist
-			 * anymore in the HW and remove the entry from the SW
-			 * list
-			 */
-			lan966x_mac_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
-					      mac_entry->mac, mac_entry->vid,
-					      lan966x->ports[mac_entry->port_index]->dev);
-
 			list_del(&mac_entry->list);
-			kfree(mac_entry);
+			/* Move the entry from SW list to a tmp list such that
+			 * it would be deleted later
+			 */
+			list_add_tail(&mac_entry->list, &mac_deleted_entries);
 		}
 	}
 	spin_unlock(&lan966x->mac_lock);
 
+	list_for_each_entry_safe(mac_entry, tmp, &mac_deleted_entries, list) {
+		/* Notify the bridge that the entry doesn't exist
+		 * anymore in the HW
+		 */
+		lan966x_mac_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
+				      mac_entry->mac, mac_entry->vid,
+				      lan966x->ports[mac_entry->port_index]->dev);
+		list_del(&mac_entry->list);
+		kfree(mac_entry);
+	}
+
 	/* Now go to the list of columns and see if any entry was not in the SW
 	 * list, then that means that the entry is new so it needs to notify the
 	 * bridge.
-- 
2.35.1



