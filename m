Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320923ED669
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236882AbhHPNU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238323AbhHPNSb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:18:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB316632F4;
        Mon, 16 Aug 2021 13:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119640;
        bh=8bGJjCOK9oNDWp11wwW3PeetT7VyQgYIuGeG96ipbQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osAtszU7DdZSQ1Ij0QbBX6L+5msfgfCz1uZ5XRI9FJViNw2C/YsdTcN/MriTaINw2
         98qwW74r8DCgAs0GfoEVGp428eAE4ZMvqlsJkpS9THT5xE88Jr9lnICKwBRDsFTj5v
         hWEJ+2dYl48d5N0/aNw6J7lfvYVXEY70JoAxweuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 105/151] net: bridge: fix flags interpretation for extern learn fdb entries
Date:   Mon, 16 Aug 2021 15:02:15 +0200
Message-Id: <20210816125447.532925808@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

[ Upstream commit 45a687879b31caae4032abd1c2402e289d2b8083 ]

Ignore fdb flags when adding port extern learn entries and always set
BR_FDB_LOCAL flag when adding bridge extern learn entries. This is
closest to the behaviour we had before and avoids breaking any use cases
which were allowed.

This patch fixes iproute2 calls which assume NUD_PERMANENT and were
allowed before, example:
$ bridge fdb add 00:11:22:33:44:55 dev swp1 extern_learn

Extern learn entries are allowed to roam, but do not expire, so static
or dynamic flags make no sense for them.

Also add a comment for future reference.

Fixes: eb100e0e24a2 ("net: bridge: allow to add externally learned entries from user-space")
Fixes: 0541a6293298 ("net: bridge: validate the NUD_PERMANENT bit when adding an extern_learn FDB entry")
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20210810110010.43859-1-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/neighbour.h |  7 +++++--
 net/bridge/br.c                |  3 +--
 net/bridge/br_fdb.c            | 11 ++++-------
 net/bridge/br_private.h        |  2 +-
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index dc8b72201f6c..00a60695fa53 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -66,8 +66,11 @@ enum {
 #define NUD_NONE	0x00
 
 /* NUD_NOARP & NUD_PERMANENT are pseudostates, they never change
-   and make no address resolution or NUD.
-   NUD_PERMANENT also cannot be deleted by garbage collectors.
+ * and make no address resolution or NUD.
+ * NUD_PERMANENT also cannot be deleted by garbage collectors.
+ * When NTF_EXT_LEARNED is set for a bridge fdb entry the different cache entry
+ * states don't make sense and thus are ignored. Such entries don't age and
+ * can roam.
  */
 
 struct nda_cacheinfo {
diff --git a/net/bridge/br.c b/net/bridge/br.c
index bbab9984f24e..ef743f94254d 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -166,8 +166,7 @@ static int br_switchdev_event(struct notifier_block *unused,
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
 		fdb_info = ptr;
 		err = br_fdb_external_learn_add(br, p, fdb_info->addr,
-						fdb_info->vid,
-						fdb_info->is_local, false);
+						fdb_info->vid, false);
 		if (err) {
 			err = notifier_from_errno(err);
 			break;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 87ce52bba649..3451c888ff79 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1026,10 +1026,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 					   "FDB entry towards bridge must be permanent");
 			return -EINVAL;
 		}
-
-		err = br_fdb_external_learn_add(br, p, addr, vid,
-						ndm->ndm_state & NUD_PERMANENT,
-						true);
+		err = br_fdb_external_learn_add(br, p, addr, vid, true);
 	} else {
 		spin_lock_bh(&br->hash_lock);
 		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
@@ -1257,7 +1254,7 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
 }
 
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
-			      const unsigned char *addr, u16 vid, bool is_local,
+			      const unsigned char *addr, u16 vid,
 			      bool swdev_notify)
 {
 	struct net_bridge_fdb_entry *fdb;
@@ -1275,7 +1272,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		if (swdev_notify)
 			flags |= BIT(BR_FDB_ADDED_BY_USER);
 
-		if (is_local)
+		if (!p)
 			flags |= BIT(BR_FDB_LOCAL);
 
 		fdb = fdb_create(br, p, addr, vid, flags);
@@ -1304,7 +1301,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		if (swdev_notify)
 			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 
-		if (is_local)
+		if (!p)
 			set_bit(BR_FDB_LOCAL, &fdb->flags);
 
 		if (modified)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 4e3d26e0a2d1..e013d33f1c7c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -707,7 +707,7 @@ int br_fdb_get(struct sk_buff *skb, struct nlattr *tb[], struct net_device *dev,
 int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p);
 void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p);
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
-			      const unsigned char *addr, u16 vid, bool is_local,
+			      const unsigned char *addr, u16 vid,
 			      bool swdev_notify);
 int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
-- 
2.30.2



