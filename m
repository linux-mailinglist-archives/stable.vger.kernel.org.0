Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8113D60AC
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237687AbhGZPXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:23:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237628AbhGZPXl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:23:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86FD860F5B;
        Mon, 26 Jul 2021 16:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315450;
        bh=9rtWSqTmb6FLPUpTaJo3Fw6FtU2QwxOMw4AoCQiLDBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AozWkOdxhAhEXF6n04yxIeK9O33cnJXbax5vumLQEZ+08ENyBsLclv/Z81pcHtm7Y
         YhItso0VK4MvzAbACnY59yStITC6+N/xa1YwDzR5Ibqpx27QzGTwrD4VUGjk09sU81
         fgGkncidhTAQKJBt3L/oOUwFQqVHObUoK1hunios=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/167] net: dsa: sja1105: make VID 4095 a bridge VLAN too
Date:   Mon, 26 Jul 2021 17:38:53 +0200
Message-Id: <20210726153842.750755628@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit e40cba9490bab1414d45c2d62defc0ad4f6e4136 ]

This simple series of commands:

ip link add br0 type bridge vlan_filtering 1
ip link set swp0 master br0

fails on sja1105 with the following error:
[   33.439103] sja1105 spi0.1: vlan-lookup-table needs to have at least the default untagged VLAN
[   33.447710] sja1105 spi0.1: Invalid config, cannot upload
Warning: sja1105: Failed to change VLAN Ethertype.

For context, sja1105 has 3 operating modes:
- SJA1105_VLAN_UNAWARE: the dsa_8021q_vlans are committed to hardware
- SJA1105_VLAN_FILTERING_FULL: the bridge_vlans are committed to hardware
- SJA1105_VLAN_FILTERING_BEST_EFFORT: both the dsa_8021q_vlans and the
  bridge_vlans are committed to hardware

Swapping out a VLAN list and another in happens in
sja1105_build_vlan_table(), which performs a delta update procedure.
That function is called from a few places, notably from
sja1105_vlan_filtering() which is called from the
SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING handler.

The above set of 2 commands fails when run on a kernel pre-commit
8841f6e63f2c ("net: dsa: sja1105: make devlink property
best_effort_vlan_filtering true by default"). So the priv->vlan_state
transition that takes place is between VLAN-unaware and full VLAN
filtering. So the dsa_8021q_vlans are swapped out and the bridge_vlans
are swapped in.

So why does it fail?

Well, the bridge driver, through nbp_vlan_init(), first sets up the
SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING attribute, and only then
proceeds to call nbp_vlan_add for the default_pvid.

So when we swap out the dsa_8021q_vlans and swap in the bridge_vlans in
the SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING handler, there are no bridge
VLANs (yet). So we have wiped the VLAN table clean, and the low-level
static config checker complains of an invalid configuration. We _will_
add the bridge VLANs using the dynamic config interface, albeit later,
when nbp_vlan_add() calls us. So it is natural that it fails.

So why did it ever work?

Surprisingly, it looks like I only tested this configuration with 2
things set up in a particular way:
- a network manager that brings all ports up
- a kernel with CONFIG_VLAN_8021Q=y

It is widely known that commit ad1afb003939 ("vlan_dev: VLAN 0 should be
treated as "no vlan tag" (802.1p packet)") installs VID 0 to every net
device that comes up. DSA treats these VLANs as bridge VLANs, and
therefore, in my testing, the list of bridge_vlans was never empty.

However, if CONFIG_VLAN_8021Q is not enabled, or the port is not up when
it joins a VLAN-aware bridge, the bridge_vlans list will be temporarily
empty, and the sja1105_static_config_reload() call from
sja1105_vlan_filtering() will fail.

To fix this, the simplest thing is to keep VID 4095, the one used for
CPU-injected control packets since commit ed040abca4c1 ("net: dsa:
sja1105: use 4095 as the private VLAN for untagged traffic"), in the
list of bridge VLANs too, not just the list of tag_8021q VLANs. This
ensures that the list of bridge VLANs will never be empty.

Fixes: ec5ae61076d0 ("net: dsa: sja1105: save/restore VLANs using a delta commit method")
Reported-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 82852c57cc0e..82b918d36117 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -350,6 +350,12 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 		if (dsa_is_cpu_port(ds, port))
 			v->pvid = true;
 		list_add(&v->list, &priv->dsa_8021q_vlans);
+
+		v = kmemdup(v, sizeof(*v), GFP_KERNEL);
+		if (!v)
+			return -ENOMEM;
+
+		list_add(&v->list, &priv->bridge_vlans);
 	}
 
 	((struct sja1105_vlan_lookup_entry *)table->entries)[0] = pvid;
-- 
2.30.2



