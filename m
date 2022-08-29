Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA2C5A4A9B
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiH2Log (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiH2LnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:43:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723BE85FA7;
        Mon, 29 Aug 2022 04:27:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BE1861217;
        Mon, 29 Aug 2022 11:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C60C43470;
        Mon, 29 Aug 2022 11:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771759;
        bh=kQCijyuw7j/mlMJ+Z5Ca6uWY1ult5VQ9AzN2khBH1h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lx8Tvj1X4BWt9LvwGqpmx8xXDx+mIRd196WD8WsA1QxHJ1CP4laUWTti3BnJ6KBHJ
         fYJYZX5rIUpZfGKn/+e61a9zv6YyE0UGTBxJua+UcCoBW101f3IEgbrtrZhsqCMGi9
         eG1JQ9ySJhksVM80K7WrFmy6hK8AhFUtipdDE2js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, R Mohamed Shah <mohamed@pensando.io>,
        Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 089/158] ionic: VF initial random MAC address if no assigned mac
Date:   Mon, 29 Aug 2022 12:58:59 +0200
Message-Id: <20220829105812.791386473@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: R Mohamed Shah <mohamed@pensando.io>

[ Upstream commit 19058be7c48ceb3e60fa3948e24da1059bd68ee4 ]

Assign a random mac address to the VF interface station
address if it boots with a zero mac address in order to match
similar behavior seen in other VF drivers.  Handle the errors
where the older firmware does not allow the VF to set its own
station address.

Newer firmware will allow the VF to set the station mac address
if it hasn't already been set administratively through the PF.
Setting it will also be allowed if the VF has trust.

Fixes: fbb39807e9ae ("ionic: support sr-iov operations")
Signed-off-by: R Mohamed Shah <mohamed@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 92 ++++++++++++++++++-
 1 file changed, 87 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index d4226999547e8..0be79c5167813 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1564,8 +1564,67 @@ static int ionic_set_features(struct net_device *netdev,
 	return err;
 }
 
+static int ionic_set_attr_mac(struct ionic_lif *lif, u8 *mac)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = IONIC_CMD_LIF_SETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_MAC,
+		},
+	};
+
+	ether_addr_copy(ctx.cmd.lif_setattr.mac, mac);
+	return ionic_adminq_post_wait(lif, &ctx);
+}
+
+static int ionic_get_attr_mac(struct ionic_lif *lif, u8 *mac_addr)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_getattr = {
+			.opcode = IONIC_CMD_LIF_GETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_MAC,
+		},
+	};
+	int err;
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err)
+		return err;
+
+	ether_addr_copy(mac_addr, ctx.comp.lif_getattr.mac);
+	return 0;
+}
+
+static int ionic_program_mac(struct ionic_lif *lif, u8 *mac)
+{
+	u8  get_mac[ETH_ALEN];
+	int err;
+
+	err = ionic_set_attr_mac(lif, mac);
+	if (err)
+		return err;
+
+	err = ionic_get_attr_mac(lif, get_mac);
+	if (err)
+		return err;
+
+	/* To deal with older firmware that silently ignores the set attr mac:
+	 * doesn't actually change the mac and doesn't return an error, so we
+	 * do the get attr to verify whether or not the set actually happened
+	 */
+	if (!ether_addr_equal(get_mac, mac))
+		return 1;
+
+	return 0;
+}
+
 static int ionic_set_mac_address(struct net_device *netdev, void *sa)
 {
+	struct ionic_lif *lif = netdev_priv(netdev);
 	struct sockaddr *addr = sa;
 	u8 *mac;
 	int err;
@@ -1574,6 +1633,14 @@ static int ionic_set_mac_address(struct net_device *netdev, void *sa)
 	if (ether_addr_equal(netdev->dev_addr, mac))
 		return 0;
 
+	err = ionic_program_mac(lif, mac);
+	if (err < 0)
+		return err;
+
+	if (err > 0)
+		netdev_dbg(netdev, "%s: SET and GET ATTR Mac are not equal-due to old FW running\n",
+			   __func__);
+
 	err = eth_prepare_mac_addr_change(netdev, addr);
 	if (err)
 		return err;
@@ -3172,6 +3239,7 @@ static int ionic_station_set(struct ionic_lif *lif)
 			.attr = IONIC_LIF_ATTR_MAC,
 		},
 	};
+	u8 mac_address[ETH_ALEN];
 	struct sockaddr addr;
 	int err;
 
@@ -3180,8 +3248,23 @@ static int ionic_station_set(struct ionic_lif *lif)
 		return err;
 	netdev_dbg(lif->netdev, "found initial MAC addr %pM\n",
 		   ctx.comp.lif_getattr.mac);
-	if (is_zero_ether_addr(ctx.comp.lif_getattr.mac))
-		return 0;
+	ether_addr_copy(mac_address, ctx.comp.lif_getattr.mac);
+
+	if (is_zero_ether_addr(mac_address)) {
+		eth_hw_addr_random(netdev);
+		netdev_dbg(netdev, "Random Mac generated: %pM\n", netdev->dev_addr);
+		ether_addr_copy(mac_address, netdev->dev_addr);
+
+		err = ionic_program_mac(lif, mac_address);
+		if (err < 0)
+			return err;
+
+		if (err > 0) {
+			netdev_dbg(netdev, "%s:SET/GET ATTR Mac are not same-due to old FW running\n",
+				   __func__);
+			return 0;
+		}
+	}
 
 	if (!is_zero_ether_addr(netdev->dev_addr)) {
 		/* If the netdev mac is non-zero and doesn't match the default
@@ -3189,12 +3272,11 @@ static int ionic_station_set(struct ionic_lif *lif)
 		 * likely here again after a fw-upgrade reset.  We need to be
 		 * sure the netdev mac is in our filter list.
 		 */
-		if (!ether_addr_equal(ctx.comp.lif_getattr.mac,
-				      netdev->dev_addr))
+		if (!ether_addr_equal(mac_address, netdev->dev_addr))
 			ionic_lif_addr_add(lif, netdev->dev_addr);
 	} else {
 		/* Update the netdev mac with the device's mac */
-		memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev->addr_len);
+		ether_addr_copy(addr.sa_data, mac_address);
 		addr.sa_family = AF_INET;
 		err = eth_prepare_mac_addr_change(netdev, &addr);
 		if (err) {
-- 
2.35.1



