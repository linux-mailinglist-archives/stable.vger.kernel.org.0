Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA72147BC5
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733154AbgAXJpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:45:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387494AbgAXJpw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:45:52 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24DC2206D5;
        Fri, 24 Jan 2020 09:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859151;
        bh=lNplR4tDt1jyg23J92fgnARO6VnMRiPf7zY0FDJAqR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zlpOYvOOYiraI+UyzLXgE1Y7mI3ZE0EYcIA7CUtFbBIssKg/7t6osic3TnDqZffxE
         QtkAvLnR1WGJl8vRx+F2dpEkyOF+6rBPsYzd19ot81iizXE9lXR3Zj3mON3JPOyKmH
         ePYFip4xjxhulsevGPUuJ2l9d1wiKOVqoHE6k+BE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 041/343] vxlan: changelink: Fix handling of default remotes
Date:   Fri, 24 Jan 2020 10:27:39 +0100
Message-Id: <20200124092925.206453662@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit ce5e098f7a10b4bf8e948c12fa350320c5c3afad ]

Default remotes are stored as FDB entries with an Ethernet address of
00:00:00:00:00:00. When a request is made to change a remote address of
a VXLAN device, vxlan_changelink() first deletes the existing default
remote, and then creates a new FDB entry.

This works well as long as the list of default remotes matches exactly
the configuration of a VXLAN remote address. Thus when the VXLAN device
has a remote of X, there should be exactly one default remote FDB entry
X. If the VXLAN device has no remote address, there should be no such
entry.

Besides using "ip link set", it is possible to manipulate the list of
default remotes by using the "bridge fdb". It is therefore easy to break
the above condition. Under such circumstances, the __vxlan_fdb_delete()
call doesn't delete the FDB entry itself, but just one remote. The
following vxlan_fdb_create() then creates a new FDB entry, leading to a
situation where two entries exist for the address 00:00:00:00:00:00,
each with a different subset of default remotes.

An even more obvious breakage rooted in the same cause can be observed
when a remote address is configured for a VXLAN device that did not have
one before. In that case vxlan_changelink() doesn't remove any remote,
and just creates a new FDB entry for the new address:

$ ip link add name vx up type vxlan id 2000 dstport 4789
$ bridge fdb ap dev vx 00:00:00:00:00:00 dst 192.0.2.20 self permanent
$ bridge fdb ap dev vx 00:00:00:00:00:00 dst 192.0.2.30 self permanent
$ ip link set dev vx type vxlan remote 192.0.2.30
$ bridge fdb sh dev vx | grep 00:00:00:00:00:00
00:00:00:00:00:00 dst 192.0.2.30 self permanent <- new entry, 1 rdst
00:00:00:00:00:00 dst 192.0.2.20 self permanent <- orig. entry, 2 rdsts
00:00:00:00:00:00 dst 192.0.2.30 self permanent

To fix this, instead of calling vxlan_fdb_create() directly, defer to
vxlan_fdb_update(). That has logic to handle the duplicates properly.
Additionally, it also handles notifications, so drop that call from
changelink as well.

Fixes: 0241b836732f ("vxlan: fix default fdb entry netlink notify ordering during netdev create")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5aa7d5091f4d0..4d97a7b5fe3ca 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3494,7 +3494,6 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 	struct vxlan_rdst *dst = &vxlan->default_dst;
 	struct vxlan_rdst old_dst;
 	struct vxlan_config conf;
-	struct vxlan_fdb *f = NULL;
 	int err;
 
 	err = vxlan_nl2conf(tb, data,
@@ -3520,19 +3519,19 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 					   old_dst.remote_ifindex, 0);
 
 		if (!vxlan_addr_any(&dst->remote_ip)) {
-			err = vxlan_fdb_create(vxlan, all_zeros_mac,
+			err = vxlan_fdb_update(vxlan, all_zeros_mac,
 					       &dst->remote_ip,
 					       NUD_REACHABLE | NUD_PERMANENT,
+					       NLM_F_APPEND | NLM_F_CREATE,
 					       vxlan->cfg.dst_port,
 					       dst->remote_vni,
 					       dst->remote_vni,
 					       dst->remote_ifindex,
-					       NTF_SELF, &f);
+					       NTF_SELF);
 			if (err) {
 				spin_unlock_bh(&vxlan->hash_lock);
 				return err;
 			}
-			vxlan_fdb_notify(vxlan, f, first_remote_rtnl(f), RTM_NEWNEIGH);
 		}
 		spin_unlock_bh(&vxlan->hash_lock);
 	}
-- 
2.20.1



