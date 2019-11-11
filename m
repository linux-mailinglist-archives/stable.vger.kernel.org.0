Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA7D7F7DA3
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbfKKS6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:58:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730977AbfKKS6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:58:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D99142184C;
        Mon, 11 Nov 2019 18:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498719;
        bh=q+/jCqcut4LydO1NERwoV16ZPIJQWPpvwuLKWTBQk5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zob6TdkH+Hn4PKC5e1GZgPiCc8Ah2Ph33VUwiLHpFbPw6rPVjwoz9zcZmc+cuddUM
         zpafTynfnUUHKNSI7f+jJfD22185hssPlUiS3+ZvaCt+WKJ5Sd5vGnBLq0clnKexz+
         0wcyIwdEWfgwDya2bPzxOZstAzIBPtDJFU5/t3Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 160/193] net: mscc: ocelot: fix vlan_filtering when enslaving to bridge before link is up
Date:   Mon, 11 Nov 2019 19:29:02 +0100
Message-Id: <20191111181512.928613356@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit 1c44ce560b4de639f237b458be1729489ff44d0a ]

Background information: the driver operates the hardware in a mode where
a single VLAN can be transmitted as untagged on a particular egress
port. That is the "native VLAN on trunk port" use case. Its value is
held in port->vid.

Consider the following command sequence (no network manager, all
interfaces are down, debugging prints added by me):

$ ip link add dev br0 type bridge vlan_filtering 1
$ ip link set dev swp0 master br0

Kernel code path during last command:

br_add_slave -> ocelot_netdevice_port_event (NETDEV_CHANGEUPPER):
[   21.401901] ocelot_vlan_port_apply: port 0 vlan aware 0 pvid 0 vid 0

br_add_slave -> nbp_vlan_init -> switchdev_port_attr_set -> ocelot_port_attr_set (SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING):
[   21.413335] ocelot_vlan_port_apply: port 0 vlan aware 1 pvid 0 vid 0

br_add_slave -> nbp_vlan_init -> nbp_vlan_add -> br_switchdev_port_vlan_add -> switchdev_port_obj_add -> ocelot_port_obj_add -> ocelot_vlan_vid_add
[   21.667421] ocelot_vlan_port_apply: port 0 vlan aware 1 pvid 1 vid 1

So far so good. The bridge has replaced the driver's default pvid used
in standalone mode (0) with its own default_pvid (1). The port's vid
(native VLAN) has also changed from 0 to 1.

$ ip link set dev swp0 up

[   31.722956] 8021q: adding VLAN 0 to HW filter on device swp0
do_setlink -> dev_change_flags -> vlan_vid_add -> ocelot_vlan_rx_add_vid -> ocelot_vlan_vid_add:
[   31.728700] ocelot_vlan_port_apply: port 0 vlan aware 1 pvid 1 vid 0

The 8021q module uses the .ndo_vlan_rx_add_vid API on .ndo_open to make
ports be able to transmit and receive 802.1p-tagged traffic by default.
This API is supposed to offload a VLAN sub-interface, which for a switch
port means to add a VLAN that is not a pvid, and tagged on egress.

But the driver implementation of .ndo_vlan_rx_add_vid is wrong: it adds
back vid 0 as "egress untagged". Now back to the initial paragraph:
there is a single untagged VID that the driver keeps track of, and that
has just changed from 1 (the pvid) to 0. So this breaks the bridge
core's expectation, because it has changed vid 1 from untagged to
tagged, when what the user sees is.

$ bridge vlan
port    vlan ids
swp0     1 PVID Egress Untagged

br0      1 PVID Egress Untagged

But curiously, instead of manifesting itself as "untagged and
pvid-tagged traffic gets sent as tagged on egress", the bug:

- is hidden when vlan_filtering=0
- manifests as dropped traffic when vlan_filtering=1, due to this setting:

	if (port->vlan_aware && !port->vid)
		/* If port is vlan-aware and tagged, drop untagged and priority
		 * tagged frames.
		 */
		val |= ANA_PORT_DROP_CFG_DROP_UNTAGGED_ENA |
		       ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
		       ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA;

which would have made sense if it weren't for this bug. The setting's
intention was "this is a trunk port with no native VLAN, so don't accept
untagged traffic". So the driver was never expecting to set VLAN 0 as
the value of the native VLAN, 0 was just encoding for "invalid".

So the fix is to not send 802.1p traffic as untagged, because that would
change the port's native vlan to 0, unbeknownst to the bridge, and
trigger unexpected code paths in the driver.

Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Fixes: 7142529f1688 ("net: mscc: ocelot: add VLAN filtering")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index dc78940f08fb1..07ca3e0cdf92b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -877,7 +877,7 @@ end:
 static int ocelot_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 				  u16 vid)
 {
-	return ocelot_vlan_vid_add(dev, vid, false, true);
+	return ocelot_vlan_vid_add(dev, vid, false, false);
 }
 
 static int ocelot_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
-- 
2.20.1



