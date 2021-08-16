Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A4B3ED54E
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbhHPNKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236619AbhHPNJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:09:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1136D610A1;
        Mon, 16 Aug 2021 13:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119271;
        bh=JjQF0/IFbP28eS/8fY6KNZ8hBKAnwDM0QDsaYI1RRZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dV8pu6d2+ijr7BNKGW9CaL6sEoE1axSLnVBddpjyEdDrrsfoRN44jyOFnujha2qSV
         g/EGu0//NuqoUE/qFKGtLa+4C0GbpBbpfXNZ3RZ0Lb1fB+etj410bTrYJ3IXK1cdRS
         4Gd3+EpAldVplDxlDgAJIWP5vmJ9bHagJXYG63RE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 58/96] net: bridge: validate the NUD_PERMANENT bit when adding an extern_learn FDB entry
Date:   Mon, 16 Aug 2021 15:02:08 +0200
Message-Id: <20210816125436.889975962@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 0541a6293298fb52789de389dfb27ef54df81f73 ]

Currently it is possible to add broken extern_learn FDB entries to the
bridge in two ways:

1. Entries pointing towards the bridge device that are not local/permanent:

ip link add br0 type bridge
bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn static

2. Entries pointing towards the bridge device or towards a port that
are marked as local/permanent, however the bridge does not process the
'permanent' bit in any way, therefore they are recorded as though they
aren't permanent:

ip link add br0 type bridge
bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn permanent

Since commit 52e4bec15546 ("net: bridge: switchdev: treat local FDBs the
same as entries towards the bridge"), these incorrect FDB entries can
even trigger NULL pointer dereferences inside the kernel.

This is because that commit made the assumption that all FDB entries
that are not local/permanent have a valid destination port. For context,
local / permanent FDB entries either have fdb->dst == NULL, and these
point towards the bridge device and are therefore local and not to be
used for forwarding, or have fdb->dst == a net_bridge_port structure
(but are to be treated in the same way, i.e. not for forwarding).

That assumption _is_ correct as long as things are working correctly in
the bridge driver, i.e. we cannot logically have fdb->dst == NULL under
any circumstance for FDB entries that are not local. However, the
extern_learn code path where FDB entries are managed by a user space
controller show that it is possible for the bridge kernel driver to
misinterpret the NUD flags of an entry transmitted by user space, and
end up having fdb->dst == NULL while not being a local entry. This is
invalid and should be rejected.

Before, the two commands listed above both crashed the kernel in this
check from br_switchdev_fdb_notify:

	struct net_device *dev = info.is_local ? br->dev : dst->dev;

info.is_local == false, dst == NULL.

After this patch, the invalid entry added by the first command is
rejected:

ip link add br0 type bridge && bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn static; ip link del br0
Error: bridge: FDB entry towards bridge must be permanent.

and the valid entry added by the second command is properly treated as a
local address and does not crash br_switchdev_fdb_notify anymore:

ip link add br0 type bridge && bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn permanent; ip link del br0

Fixes: eb100e0e24a2 ("net: bridge: allow to add externally learned entries from user-space")
Reported-by: syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Link: https://lore.kernel.org/r/20210801231730.7493-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br.c         |  3 ++-
 net/bridge/br_fdb.c     | 30 ++++++++++++++++++++++++------
 net/bridge/br_private.h |  2 +-
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index 1b169f8e7491..a416b01ee773 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -166,7 +166,8 @@ static int br_switchdev_event(struct notifier_block *unused,
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
 		fdb_info = ptr;
 		err = br_fdb_external_learn_add(br, p, fdb_info->addr,
-						fdb_info->vid, false);
+						fdb_info->vid,
+						fdb_info->is_local, false);
 		if (err) {
 			err = notifier_from_errno(err);
 			break;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 32ac8343b0ba..a729786e0f03 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -950,7 +950,8 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 
 static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 			struct net_bridge_port *p, const unsigned char *addr,
-			u16 nlh_flags, u16 vid, struct nlattr *nfea_tb[])
+			u16 nlh_flags, u16 vid, struct nlattr *nfea_tb[],
+			struct netlink_ext_ack *extack)
 {
 	int err = 0;
 
@@ -969,7 +970,15 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 		rcu_read_unlock();
 		local_bh_enable();
 	} else if (ndm->ndm_flags & NTF_EXT_LEARNED) {
-		err = br_fdb_external_learn_add(br, p, addr, vid, true);
+		if (!p && !(ndm->ndm_state & NUD_PERMANENT)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "FDB entry towards bridge must be permanent");
+			return -EINVAL;
+		}
+
+		err = br_fdb_external_learn_add(br, p, addr, vid,
+						ndm->ndm_state & NUD_PERMANENT,
+						true);
 	} else {
 		spin_lock_bh(&br->hash_lock);
 		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
@@ -1041,9 +1050,11 @@ int br_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 		}
 
 		/* VID was specified, so use it. */
-		err = __br_fdb_add(ndm, br, p, addr, nlh_flags, vid, nfea_tb);
+		err = __br_fdb_add(ndm, br, p, addr, nlh_flags, vid, nfea_tb,
+				   extack);
 	} else {
-		err = __br_fdb_add(ndm, br, p, addr, nlh_flags, 0, nfea_tb);
+		err = __br_fdb_add(ndm, br, p, addr, nlh_flags, 0, nfea_tb,
+				   extack);
 		if (err || !vg || !vg->num_vlans)
 			goto out;
 
@@ -1055,7 +1066,7 @@ int br_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 			if (!br_vlan_should_use(v))
 				continue;
 			err = __br_fdb_add(ndm, br, p, addr, nlh_flags, v->vid,
-					   nfea_tb);
+					   nfea_tb, extack);
 			if (err)
 				goto out;
 		}
@@ -1195,7 +1206,7 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
 }
 
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
-			      const unsigned char *addr, u16 vid,
+			      const unsigned char *addr, u16 vid, bool is_local,
 			      bool swdev_notify)
 {
 	struct net_bridge_fdb_entry *fdb;
@@ -1212,6 +1223,10 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 
 		if (swdev_notify)
 			flags |= BIT(BR_FDB_ADDED_BY_USER);
+
+		if (is_local)
+			flags |= BIT(BR_FDB_LOCAL);
+
 		fdb = fdb_create(br, p, addr, vid, flags);
 		if (!fdb) {
 			err = -ENOMEM;
@@ -1238,6 +1253,9 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		if (swdev_notify)
 			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 
+		if (is_local)
+			set_bit(BR_FDB_LOCAL, &fdb->flags);
+
 		if (modified)
 			fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 5e5726048a1a..26f311b2cc11 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -708,7 +708,7 @@ int br_fdb_get(struct sk_buff *skb, struct nlattr *tb[], struct net_device *dev,
 int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p);
 void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p);
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
-			      const unsigned char *addr, u16 vid,
+			      const unsigned char *addr, u16 vid, bool is_local,
 			      bool swdev_notify);
 int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
-- 
2.30.2



