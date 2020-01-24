Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2994147FB5
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388533AbgAXLEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:04:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387885AbgAXLEf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:04:35 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1532421569;
        Fri, 24 Jan 2020 11:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863874;
        bh=IpPioV8lCiMOOuH55E5v/acN+ajIQat14WbJGNLwhVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDZZxPlWbEyhUZtU4qaforV6UhTnXm+GcIaujjBQPjIfQlkzQ9nDenjK7P4Q0T1Pb
         vpoRmuoejBaDvhOVz4BvKVPGNkoxnzpOgc2DMHiNzD8BVIKqXTOTjFiG1Ba0A4uaTN
         6G0Oi/SezznPJmivY0uK1BSOc5r+CMe0d1cFERXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/639] vxlan: changelink: Fix handling of default remotes
Date:   Fri, 24 Jan 2020 10:24:28 +0100
Message-Id: <20200124093059.605060688@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
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
index 613f366818536..df88981e796a4 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3496,7 +3496,6 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 	struct vxlan_rdst *dst = &vxlan->default_dst;
 	struct vxlan_rdst old_dst;
 	struct vxlan_config conf;
-	struct vxlan_fdb *f = NULL;
 	int err;
 
 	err = vxlan_nl2conf(tb, data,
@@ -3522,19 +3521,19 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
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



