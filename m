Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B431F5A4537
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 10:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiH2Ifb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 04:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiH2IfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 04:35:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B916DFAC
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 01:35:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99D5260EFF
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 08:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F049C433C1;
        Mon, 29 Aug 2022 08:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661762117;
        bh=sh+CREkjpZFXY0MXq5e58nBfs4UVZifszkAEpSc58P0=;
        h=Subject:To:Cc:From:Date:From;
        b=unDBVNJ+Hc4x3qsk8g48cZCdFIzu8rYE3epOiJwKw8IRx8GWlr1BzNgBUG49oo/UG
         A54RPezCoySRfikElLwmfPxiYDz9Cd2RXhGoqduvdJvKiOCdJqk9nVSE3bAFpP/oDK
         BbytivVThiPLFnLvrmwjv20e2U+u7piy86Azz3PQ=
Subject: FAILED: patch "[PATCH] net: dsa: microchip: make learning configurable and keep it" failed to apply to 4.14-stable tree
To:     vladimir.oltean@nxp.com, b.hutchman@gmail.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 10:35:00 +0200
Message-ID: <1661762100131117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 15f7cfae912ea1739c8844b7edf3621ba981a37a Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Thu, 18 Aug 2022 19:48:09 +0300
Subject: [PATCH] net: dsa: microchip: make learning configurable and keep it
 off while standalone

Address learning should initially be turned off by the driver for port
operation in standalone mode, then the DSA core handles changes to it
via ds->ops->port_bridge_flags().

Leaving address learning enabled while ports are standalone breaks any
kind of communication which involves port B receiving what port A has
sent. Notably it breaks the ksz9477 driver used with a (non offloaded,
ports act as if standalone) bonding interface in active-backup mode,
when the ports are connected together through external switches, for
redundancy purposes.

This fixes a major design flaw in the ksz9477 and ksz8795 drivers, which
unconditionally leave address learning enabled even while ports operate
as standalone.

Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Link: https://lore.kernel.org/netdev/CAFZh4h-JVWt80CrQWkFji7tZJahMfOToUJQgKS5s0_=9zzpvYQ@mail.gmail.com/
Reported-by: Brian Hutchinson <b.hutchman@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220818164809.3198039-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 7461272a6d41..6bd69a7e6809 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -968,6 +968,7 @@ static void ksz_update_port_member(struct ksz_device *dev, int port)
 static int ksz_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p;
 	const u16 *regs;
 	int ret;
 
@@ -1007,6 +1008,14 @@ static int ksz_setup(struct dsa_switch *ds)
 			return ret;
 	}
 
+	/* Start with learning disabled on standalone user ports, and enabled
+	 * on the CPU port. In lack of other finer mechanisms, learning on the
+	 * CPU port will avoid flooding bridge local addresses on the network
+	 * in some cases.
+	 */
+	p = &dev->ports[dev->cpu_port];
+	p->learning = true;
+
 	/* start switch */
 	regmap_update_bits(dev->regmap[0], regs[S_START_CTRL],
 			   SW_START, SW_START);
@@ -1283,6 +1292,8 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 	ksz_pread8(dev, port, regs[P_STP_CTRL], &data);
 	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
 
+	p = &dev->ports[port];
+
 	switch (state) {
 	case BR_STATE_DISABLED:
 		data |= PORT_LEARN_DISABLE;
@@ -1292,9 +1303,13 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 		break;
 	case BR_STATE_LEARNING:
 		data |= PORT_RX_ENABLE;
+		if (!p->learning)
+			data |= PORT_LEARN_DISABLE;
 		break;
 	case BR_STATE_FORWARDING:
 		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
+		if (!p->learning)
+			data |= PORT_LEARN_DISABLE;
 		break;
 	case BR_STATE_BLOCKING:
 		data |= PORT_LEARN_DISABLE;
@@ -1306,12 +1321,38 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 
 	ksz_pwrite8(dev, port, regs[P_STP_CTRL], data);
 
-	p = &dev->ports[port];
 	p->stp_state = state;
 
 	ksz_update_port_member(dev, port);
 }
 
+static int ksz_port_pre_bridge_flags(struct dsa_switch *ds, int port,
+				     struct switchdev_brport_flags flags,
+				     struct netlink_ext_ack *extack)
+{
+	if (flags.mask & ~BR_LEARNING)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int ksz_port_bridge_flags(struct dsa_switch *ds, int port,
+				 struct switchdev_brport_flags flags,
+				 struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p = &dev->ports[port];
+
+	if (flags.mask & BR_LEARNING) {
+		p->learning = !!(flags.val & BR_LEARNING);
+
+		/* Make the change take effect immediately */
+		ksz_port_stp_state_set(ds, port, p->stp_state);
+	}
+
+	return 0;
+}
+
 static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 						  int port,
 						  enum dsa_tag_protocol mp)
@@ -1725,6 +1766,8 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.port_bridge_join	= ksz_port_bridge_join,
 	.port_bridge_leave	= ksz_port_bridge_leave,
 	.port_stp_state_set	= ksz_port_stp_state_set,
+	.port_pre_bridge_flags	= ksz_port_pre_bridge_flags,
+	.port_bridge_flags	= ksz_port_bridge_flags,
 	.port_fast_age		= ksz_port_fast_age,
 	.port_vlan_filtering	= ksz_port_vlan_filtering,
 	.port_vlan_add		= ksz_port_vlan_add,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 764ada3a0f42..0d9520dc6d2d 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -65,6 +65,7 @@ struct ksz_chip_data {
 
 struct ksz_port {
 	bool remove_tag;		/* Remove Tag flag set, for ksz8795 only */
+	bool learning;
 	int stp_state;
 	struct phy_device phydev;
 

