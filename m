Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F224C4A66
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 17:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242799AbiBYQTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 11:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242803AbiBYQTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 11:19:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DCC403CD
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 08:18:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9652361B44
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 16:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A636AC340E7;
        Fri, 25 Feb 2022 16:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645805920;
        bh=Pdb3QmvBRQMF6L0SfcgC368sBl6PCupwOW4IZ9WwFVQ=;
        h=Subject:To:Cc:From:Date:From;
        b=o8eIKOwR5JMKRWf8qoXgfxdBHYfFkGAP2vs6Mdfngf0D3udElHg48DOe41CJxXr8j
         3JerA7cpYuMmiNRoVViAO/w6e6VNMMsPoOr66R4vkUDkJhGaU47twF8poP6ROCEiCB
         9iIIin2xtW71YCnhttMF4kkeY8JEtjipaNx1SmQU=
Subject: FAILED: patch "[PATCH] net: dsa: microchip: fix bridging with more than two member" failed to apply to 5.16-stable tree
To:     sss@secomea.com, davem@davemloft.net, o.rempel@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 17:16:11 +0100
Message-ID: <164580577118139@kroah.com>
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


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3d00827a90db6f79abc7cdc553887f89a2e0a184 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Svenning=20S=C3=B8rensen?= <sss@secomea.com>
Date: Fri, 18 Feb 2022 11:27:01 +0000
Subject: [PATCH] net: dsa: microchip: fix bridging with more than two member
 ports
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")
plugged a packet leak between ports that were members of different bridges.
Unfortunately, this broke another use case, namely that of more than two
ports that are members of the same bridge.

After that commit, when a port is added to a bridge, hardware bridging
between other member ports of that bridge will be cleared, preventing
packet exchange between them.

Fix by ensuring that the Port VLAN Membership bitmap includes any existing
ports in the bridge, not just the port being added.

Fixes: b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")
Signed-off-by: Svenning Sørensen <sss@secomea.com>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 55dbda04ea62..243f8ad6d06e 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -26,7 +26,7 @@ void ksz_update_port_member(struct ksz_device *dev, int port)
 	struct dsa_switch *ds = dev->ds;
 	u8 port_member = 0, cpu_port;
 	const struct dsa_port *dp;
-	int i;
+	int i, j;
 
 	if (!dsa_is_user_port(ds, port))
 		return;
@@ -45,13 +45,33 @@ void ksz_update_port_member(struct ksz_device *dev, int port)
 			continue;
 		if (!dsa_port_bridge_same(dp, other_dp))
 			continue;
+		if (other_p->stp_state != BR_STATE_FORWARDING)
+			continue;
 
-		if (other_p->stp_state == BR_STATE_FORWARDING &&
-		    p->stp_state == BR_STATE_FORWARDING) {
+		if (p->stp_state == BR_STATE_FORWARDING) {
 			val |= BIT(port);
 			port_member |= BIT(i);
 		}
 
+		/* Retain port [i]'s relationship to other ports than [port] */
+		for (j = 0; j < ds->num_ports; j++) {
+			const struct dsa_port *third_dp;
+			struct ksz_port *third_p;
+
+			if (j == i)
+				continue;
+			if (j == port)
+				continue;
+			if (!dsa_is_user_port(ds, j))
+				continue;
+			third_p = &dev->ports[j];
+			if (third_p->stp_state != BR_STATE_FORWARDING)
+				continue;
+			third_dp = dsa_to_port(ds, j);
+			if (dsa_port_bridge_same(other_dp, third_dp))
+				val |= BIT(j);
+		}
+
 		dev->dev_ops->cfg_port_member(dev, i, val | cpu_port);
 	}
 

