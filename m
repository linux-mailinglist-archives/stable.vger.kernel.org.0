Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBB851FA6C
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiEIKvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiEIKus (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:50:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7535122242C
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:46:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32EEEB810E8
        for <stable@vger.kernel.org>; Mon,  9 May 2022 10:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE7BC385AB;
        Mon,  9 May 2022 10:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652093160;
        bh=y1xP3nO3uQPnmvdP/dVlySWJIlTleWtMGgGAz4ab/Q4=;
        h=Subject:To:Cc:From:Date:From;
        b=HNjThEfITVJmWwwREdE4+P+gfKGqkH+bLdWe6Px+t7LbA4mf4tgUT4JkuaD3GyqC5
         9alO7Wr/m8xWNGULnWh7xL0vx623Mcn63eUUGQMAhQ+wAsBxGhmdGJzUDyvTdimcAG
         wgswwcjJDyXnFiSrvdUKNyd1VIcukPeVz/ehDTew=
Subject: FAILED: patch "[PATCH] net: dsa: ksz9477: port mirror sniffing limited to one port" failed to apply to 4.14-stable tree
To:     arun.ramadoss@microchip.com, kuba@kernel.org,
        prasanna.vengateshan@microchip.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 12:45:56 +0200
Message-ID: <1652093156103195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fee34dd199384a483f84806a5cbcf8d657a481cc Mon Sep 17 00:00:00 2001
From: Arun Ramadoss <arun.ramadoss@microchip.com>
Date: Thu, 28 Apr 2022 12:37:09 +0530
Subject: [PATCH] net: dsa: ksz9477: port mirror sniffing limited to one port

This patch limits the sniffing to only one port during the mirror add.
And during the mirror_del it checks for all the ports using the sniff,
if and only if no other ports are referring, sniffing is disabled.
The code is updated based on the review comments of LAN937x port mirror
patch.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20210422094257.1641396-8-prasanna.vengateshan@microchip.com/
Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Link: https://lore.kernel.org/r/20220428070709.7094-1-arun.ramadoss@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 8222c8a6c5ec..7310d19d1f06 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1021,14 +1021,32 @@ static int ksz9477_port_mirror_add(struct dsa_switch *ds, int port,
 				   bool ingress, struct netlink_ext_ack *extack)
 {
 	struct ksz_device *dev = ds->priv;
+	u8 data;
+	int p;
+
+	/* Limit to one sniffer port
+	 * Check if any of the port is already set for sniffing
+	 * If yes, instruct the user to remove the previous entry & exit
+	 */
+	for (p = 0; p < dev->port_cnt; p++) {
+		/* Skip the current sniffing port */
+		if (p == mirror->to_local_port)
+			continue;
+
+		ksz_pread8(dev, p, P_MIRROR_CTRL, &data);
+
+		if (data & PORT_MIRROR_SNIFFER) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Sniffer port is already configured, delete existing rules & retry");
+			return -EBUSY;
+		}
+	}
 
 	if (ingress)
 		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, true);
 	else
 		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, true);
 
-	ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_SNIFFER, false);
-
 	/* configure mirror port */
 	ksz_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
 		     PORT_MIRROR_SNIFFER, true);
@@ -1042,16 +1060,28 @@ static void ksz9477_port_mirror_del(struct dsa_switch *ds, int port,
 				    struct dsa_mall_mirror_tc_entry *mirror)
 {
 	struct ksz_device *dev = ds->priv;
+	bool in_use = false;
 	u8 data;
+	int p;
 
 	if (mirror->ingress)
 		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, false);
 	else
 		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, false);
 
-	ksz_pread8(dev, port, P_MIRROR_CTRL, &data);
 
-	if (!(data & (PORT_MIRROR_RX | PORT_MIRROR_TX)))
+	/* Check if any of the port is still referring to sniffer port */
+	for (p = 0; p < dev->port_cnt; p++) {
+		ksz_pread8(dev, p, P_MIRROR_CTRL, &data);
+
+		if ((data & (PORT_MIRROR_RX | PORT_MIRROR_TX))) {
+			in_use = true;
+			break;
+		}
+	}
+
+	/* delete sniffing if there are no other mirroring rules */
+	if (!in_use)
 		ksz_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
 			     PORT_MIRROR_SNIFFER, false);
 }

