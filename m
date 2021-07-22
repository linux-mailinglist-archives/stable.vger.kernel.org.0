Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E633D2A14
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbhGVQIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:08:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235144AbhGVQHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:07:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 839AE61DC8;
        Thu, 22 Jul 2021 16:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972454;
        bh=CrbInbfMLwaJCWkdJMUVbqZyG8JGnoFBmNvvEcNncxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L78MG3UELyuFWEX7tcMvVQCufpG0HlslvJcPKG9cBivSY8TtwhYSu9p8CTKZkv4R9
         XtPRX2ZoSU0OzMTKDn9WQzGXo3/ehlnMQHDWRw8h+6O8L4Mg3JAH3xltAjNofLTkw2
         fP4uNNjRFVTqSeNBcK64SaSYQAknSwxO7qfliBSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfgang Bumiller <w.bumiller@proxmox.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 121/156] net: bridge: sync fdb to new unicast-filtering ports
Date:   Thu, 22 Jul 2021 18:31:36 +0200
Message-Id: <20210722155632.276909905@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
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
@@ -562,7 +562,7 @@ int br_add_if(struct net_bridge *br, str
 	struct net_bridge_port *p;
 	int err = 0;
 	unsigned br_hr, dev_hr;
-	bool changed_addr;
+	bool changed_addr, fdb_synced = false;
 
 	/* Don't allow bridging non-ethernet like devices. */
 	if ((dev->flags & IFF_LOOPBACK) ||
@@ -652,6 +652,19 @@ int br_add_if(struct net_bridge *br, str
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
 
@@ -701,6 +714,8 @@ int br_add_if(struct net_bridge *br, str
 	return 0;
 
 err7:
+	if (fdb_synced)
+		br_fdb_unsync_static(br, p);
 	list_del_rcu(&p->list);
 	br_fdb_delete_by_port(br, p, 0, 1);
 	nbp_update_port_count(br);


