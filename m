Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF07583071
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242548AbiG0RiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242653AbiG0RiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:38:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D578086C27;
        Wed, 27 Jul 2022 09:50:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09BDE616BD;
        Wed, 27 Jul 2022 16:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A7AC433C1;
        Wed, 27 Jul 2022 16:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940617;
        bh=S0pWMV/TRcjMiJTSJysZSUB2PC/SsjxITO9QWcWCoMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rxr+1ZWryFBFCdb5UQbONkUKmBnfryXCztkS59EsOEC2VDIWl0PXBfCIjDa3+2LJr
         GS0u7tdeQs+K6rud937Njr2+YviQRYpC/2JiNg4svtH3evqKTcgHTdwoP03FuMyF3h
         OBhcHGqYU1/GJ3xergB+OHN+tQ0fIKG8C7PycYcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 087/158] net: lan966x: Fix usage of lan966x->mac_lock inside lan966x_mac_irq_handler
Date:   Wed, 27 Jul 2022 18:12:31 +0200
Message-Id: <20220727161024.965216524@linuxfoundation.org>
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

[ Upstream commit c1924684369762b112428a333ad00eac6ca89d96 ]

The problem with this spin lock is that it was just protecting the list
of the MAC entries in SW and not also the access to the MAC entries in HW.
Because the access to HW is indirect, then it could happen to have race
conditions.
For example when SW introduced an entry in MAC table and the irq mac is
trying to read something from the MAC.
Update such that also the access to MAC entries in HW is protected by
this lock.

Fixes: 5ccd66e01cbef ("net: lan966x: add support for interrupts from analyzer")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index d0b8eba0a66d..69e343b7f4af 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -183,7 +183,7 @@ static struct lan966x_mac_entry *lan966x_mac_alloc_entry(const unsigned char *ma
 {
 	struct lan966x_mac_entry *mac_entry;
 
-	mac_entry = kzalloc(sizeof(*mac_entry), GFP_KERNEL);
+	mac_entry = kzalloc(sizeof(*mac_entry), GFP_ATOMIC);
 	if (!mac_entry)
 		return NULL;
 
@@ -310,8 +310,8 @@ void lan966x_mac_purge_entries(struct lan966x *lan966x)
 	spin_lock(&lan966x->mac_lock);
 	list_for_each_entry_safe(mac_entry, tmp, &lan966x->mac_entries,
 				 list) {
-		lan966x_mac_forget(lan966x, mac_entry->mac, mac_entry->vid,
-				   ENTRYTYPE_LOCKED);
+		lan966x_mac_forget_locked(lan966x, mac_entry->mac,
+					  mac_entry->vid, ENTRYTYPE_LOCKED);
 
 		list_del(&mac_entry->list);
 		kfree(mac_entry);
@@ -427,13 +427,14 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 		if (WARN_ON(dest_idx >= lan966x->num_phys_ports))
 			continue;
 
+		spin_lock(&lan966x->mac_lock);
 		mac_entry = lan966x_mac_alloc_entry(mac, vid, dest_idx);
-		if (!mac_entry)
+		if (!mac_entry) {
+			spin_unlock(&lan966x->mac_lock);
 			return;
+		}
 
 		mac_entry->row = row;
-
-		spin_lock(&lan966x->mac_lock);
 		list_add_tail(&mac_entry->list, &lan966x->mac_entries);
 		spin_unlock(&lan966x->mac_lock);
 
@@ -455,6 +456,7 @@ irqreturn_t lan966x_mac_irq_handler(struct lan966x *lan966x)
 	       lan966x, ANA_MACTINDX);
 
 	while (1) {
+		spin_lock(&lan966x->mac_lock);
 		lan_rmw(ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_SYNC_GET_NEXT),
 			ANA_MACACCESS_MAC_TABLE_CMD,
 			lan966x, ANA_MACACCESS);
@@ -478,12 +480,15 @@ irqreturn_t lan966x_mac_irq_handler(struct lan966x *lan966x)
 			stop = false;
 
 		if (column == LAN966X_MAC_COLUMNS - 1 &&
-		    index == 0 && stop)
+		    index == 0 && stop) {
+			spin_unlock(&lan966x->mac_lock);
 			break;
+		}
 
 		entry[column].mach = lan_rd(lan966x, ANA_MACHDATA);
 		entry[column].macl = lan_rd(lan966x, ANA_MACLDATA);
 		entry[column].maca = lan_rd(lan966x, ANA_MACACCESS);
+		spin_unlock(&lan966x->mac_lock);
 
 		/* Once all the columns are read process them */
 		if (column == LAN966X_MAC_COLUMNS - 1) {
-- 
2.35.1



