Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC423ED554
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239037AbhHPNKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:10:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237047AbhHPNJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:09:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C28D0632BF;
        Mon, 16 Aug 2021 13:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119274;
        bh=mGTHCyArj6iYkifHDKGMhMHY6UIOB5mqtNIVHge2nMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nEVy1BuhREpnilseCyg+hj/pTmC8qBHDhttJxwQuf0PkZx8o9aC5w/GGa1iWllwlU
         iGqLSzzoqOj3rXnNBhUm4I4j8jNmnLOZ9rEaFhwjNyU28F1AA/nTLcGEpfPpQfmC8T
         pzk1trioxFql7qR/1cdBB+jg16E2yqEjDeAOLIJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 59/96] net: bridge: fix flags interpretation for extern learn fdb entries
Date:   Mon, 16 Aug 2021 15:02:09 +0200
Message-Id: <20210816125436.920736695@linuxfoundation.org>
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
index a416b01ee773..1b169f8e7491 100644
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
index a729786e0f03..8a6470a21702 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -975,10 +975,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
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
@@ -1206,7 +1203,7 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
 }
 
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
-			      const unsigned char *addr, u16 vid, bool is_local,
+			      const unsigned char *addr, u16 vid,
 			      bool swdev_notify)
 {
 	struct net_bridge_fdb_entry *fdb;
@@ -1224,7 +1221,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		if (swdev_notify)
 			flags |= BIT(BR_FDB_ADDED_BY_USER);
 
-		if (is_local)
+		if (!p)
 			flags |= BIT(BR_FDB_LOCAL);
 
 		fdb = fdb_create(br, p, addr, vid, flags);
@@ -1253,7 +1250,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		if (swdev_notify)
 			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 
-		if (is_local)
+		if (!p)
 			set_bit(BR_FDB_LOCAL, &fdb->flags);
 
 		if (modified)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 26f311b2cc11..5e5726048a1a 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -708,7 +708,7 @@ int br_fdb_get(struct sk_buff *skb, struct nlattr *tb[], struct net_device *dev,
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



