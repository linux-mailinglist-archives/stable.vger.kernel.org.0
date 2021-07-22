Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B989C3D267B
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 17:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhGVOdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 10:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232317AbhGVOdD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 10:33:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A767461029;
        Thu, 22 Jul 2021 15:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626966816;
        bh=IJWpl5dKR+FWISYbcw+AYModhD4ziKPsZqNZo0zqJC0=;
        h=Subject:To:Cc:From:Date:From;
        b=lJJTXMEhBTHG3KjAYYrB4g/VvyOMRtuto/l43M348gdv87a1OGxNtjED421pkgVy2
         LsDPBPpRMA2gKwc3hULJM5P47sg0Cgwtq3VcAp3Cv6XEtj81BjTycXCQp8PVI+HrLS
         GR6o0JXxVQ9XXArl4u7nMjOmUWOOGhjGEg1iZVSU=
Subject: FAILED: patch "[PATCH] net: bridge: sync fdb to new unicast-filtering ports" failed to apply to 4.4-stable tree
To:     w.bumiller@proxmox.com, davem@davemloft.net, nikolay@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 22 Jul 2021 17:13:33 +0200
Message-ID: <1626966813254147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a019abd8022061b917da767cd1a66ed823724eab Mon Sep 17 00:00:00 2001
From: Wolfgang Bumiller <w.bumiller@proxmox.com>
Date: Fri, 2 Jul 2021 14:07:36 +0200
Subject: [PATCH] net: bridge: sync fdb to new unicast-filtering ports

Since commit 2796d0c648c9 ("bridge: Automatically manage
port promiscuous mode.")
bridges with `vlan_filtering 1` and only 1 auto-port don't
set IFF_PROMISC for unicast-filtering-capable ports.

Normally on port changes `br_manage_promisc` is called to
update the promisc flags and unicast filters if necessary,
but it cannot distinguish between *new* ports and ones
losing their promisc flag, and new ports end up not
receiving the MAC address list.

Fix this by calling `br_fdb_sync_static` in `br_add_if`
after the port promisc flags are updated and the unicast
filter was supposed to have been filled.

Fixes: 2796d0c648c9 ("bridge: Automatically manage port promiscuous mode.")
Signed-off-by: Wolfgang Bumiller <w.bumiller@proxmox.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index f7d2f472ae24..6e4a32354a13 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -562,7 +562,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	struct net_bridge_port *p;
 	int err = 0;
 	unsigned br_hr, dev_hr;
-	bool changed_addr;
+	bool changed_addr, fdb_synced = false;
 
 	/* Don't allow bridging non-ethernet like devices. */
 	if ((dev->flags & IFF_LOOPBACK) ||
@@ -652,6 +652,19 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	list_add_rcu(&p->list, &br->port_list);
 
 	nbp_update_port_count(br);
+	if (!br_promisc_port(p) && (p->dev->priv_flags & IFF_UNICAST_FLT)) {
+		/* When updating the port count we also update all ports'
+		 * promiscuous mode.
+		 * A port leaving promiscuous mode normally gets the bridge's
+		 * fdb synced to the unicast filter (if supported), however,
+		 * `br_port_clear_promisc` does not distinguish between
+		 * non-promiscuous ports and *new* ports, so we need to
+		 * sync explicitly here.
+		 */
+		fdb_synced = br_fdb_sync_static(br, p) == 0;
+		if (!fdb_synced)
+			netdev_err(dev, "failed to sync bridge static fdb addresses to this port\n");
+	}
 
 	netdev_update_features(br->dev);
 
@@ -701,6 +714,8 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	return 0;
 
 err7:
+	if (fdb_synced)
+		br_fdb_unsync_static(br, p);
 	list_del_rcu(&p->list);
 	br_fdb_delete_by_port(br, p, 0, 1);
 	nbp_update_port_count(br);

