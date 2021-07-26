Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EDA3D5EEB
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbhGZPPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:15:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237065AbhGZPKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:10:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D820C60F9C;
        Mon, 26 Jul 2021 15:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314642;
        bh=LAYIWFN4Dlr4KrybvkxdoCCGnzcDD/G6iK6Ou3ujJrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1h7l7QAmMyhgbVCojrgprr791qaL1t1cJRCN/2XoHVm+tdOL1p743QR+welVHbSCN
         fNUOUwjgnUrFl4+1O3yo7TmkpHcpRZV86O6XMcBmPbPnDtOHoAMRIxays6STpBdUVJ
         d5jGW+AMf3SFVlQzdEO/9ll/9gClm6Xoa+44HD2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfgang Bumiller <w.bumiller@proxmox.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 040/120] net: bridge: sync fdb to new unicast-filtering ports
Date:   Mon, 26 Jul 2021 17:38:12 +0200
Message-Id: <20210726153833.681340708@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfgang Bumiller <w.bumiller@proxmox.com>

commit a019abd8022061b917da767cd1a66ed823724eab upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_if.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -564,7 +564,7 @@ int br_add_if(struct net_bridge *br, str
 	struct net_bridge_port *p;
 	int err = 0;
 	unsigned br_hr, dev_hr;
-	bool changed_addr;
+	bool changed_addr, fdb_synced = false;
 
 	/* Don't allow bridging non-ethernet like devices, or DSA-enabled
 	 * master network devices since the bridge layer rx_handler prevents
@@ -640,6 +640,19 @@ int br_add_if(struct net_bridge *br, str
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
 
@@ -680,6 +693,8 @@ int br_add_if(struct net_bridge *br, str
 	return 0;
 
 err7:
+	if (fdb_synced)
+		br_fdb_unsync_static(br, p);
 	list_del_rcu(&p->list);
 	br_fdb_delete_by_port(br, p, 0, 1);
 	nbp_update_port_count(br);


