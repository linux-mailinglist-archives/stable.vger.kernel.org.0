Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEC13B6366
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhF1O4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232644AbhF1Owz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:52:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B3E661D32;
        Mon, 28 Jun 2021 14:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891037;
        bh=6eGUlXJ0zTfZv83a75Wr/75CS0zZoR2gC7cf6oeZV9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBfw7rzz8JQTKzjXBnwfO6rMHf6XQ2TLN1DHZNvWpN8W9cfAMUY01yRaiUfsRwPaq
         odWVExGPdLDz7vaaQFDOYXP9mLY5D46LywxgEwNgaog+HJcNZWQ0Q7Mm705ojBbvgm
         yyekgv+0k7TBPziSMbqKI5Q+4ADHvWUx26QpPvwVSBHAl3jwUED9alr86D3nmeOgBz
         m9HVOixedirckyskwszEC2lPcnwPYrzyUcOD2Nuwrss9tyzcT03tOSAM6csO35fzT/
         IrePbXc5lHcIooMBxLv6riNqnCTq6Th6OvaRrnPdRt5FnrEdhs1CZ10li9Y8reEZ/1
         l8avvpl4om0Xg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 55/88] net: bridge: fix vlan tunnel dst null pointer dereference
Date:   Mon, 28 Jun 2021 10:35:55 -0400
Message-Id: <20210628143628.33342-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

commit 58e2071742e38f29f051b709a5cca014ba51166f upstream.

This patch fixes a tunnel_dst null pointer dereference due to lockless
access in the tunnel egress path. When deleting a vlan tunnel the
tunnel_dst pointer is set to NULL without waiting a grace period (i.e.
while it's still usable) and packets egressing are dereferencing it
without checking. Use READ/WRITE_ONCE to annotate the lockless use of
tunnel_id, use RCU for accessing tunnel_dst and make sure it is read
only once and checked in the egress path. The dst is already properly RCU
protected so we don't need to do anything fancy than to make sure
tunnel_id and tunnel_dst are read only once and checked in the egress path.

Cc: stable@vger.kernel.org
Fixes: 11538d039ac6 ("bridge: vlan dst_metadata hooks in ingress and egress paths")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_private.h     |  4 ++--
 net/bridge/br_vlan_tunnel.c | 38 +++++++++++++++++++++++--------------
 2 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 14ff034e561c..50a55553a25c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -93,8 +93,8 @@ struct br_vlan_stats {
 };
 
 struct br_tunnel_info {
-	__be64			tunnel_id;
-	struct metadata_dst	*tunnel_dst;
+	__be64				tunnel_id;
+	struct metadata_dst __rcu	*tunnel_dst;
 };
 
 /**
diff --git a/net/bridge/br_vlan_tunnel.c b/net/bridge/br_vlan_tunnel.c
index 6d2c4eed2dc8..4d5100677c68 100644
--- a/net/bridge/br_vlan_tunnel.c
+++ b/net/bridge/br_vlan_tunnel.c
@@ -46,26 +46,33 @@ static struct net_bridge_vlan *br_vlan_tunnel_lookup(struct rhashtable *tbl,
 				      br_vlan_tunnel_rht_params);
 }
 
+static void vlan_tunnel_info_release(struct net_bridge_vlan *vlan)
+{
+	struct metadata_dst *tdst = rtnl_dereference(vlan->tinfo.tunnel_dst);
+
+	WRITE_ONCE(vlan->tinfo.tunnel_id, 0);
+	RCU_INIT_POINTER(vlan->tinfo.tunnel_dst, NULL);
+	dst_release(&tdst->dst);
+}
+
 void vlan_tunnel_info_del(struct net_bridge_vlan_group *vg,
 			  struct net_bridge_vlan *vlan)
 {
-	if (!vlan->tinfo.tunnel_dst)
+	if (!rcu_access_pointer(vlan->tinfo.tunnel_dst))
 		return;
 	rhashtable_remove_fast(&vg->tunnel_hash, &vlan->tnode,
 			       br_vlan_tunnel_rht_params);
-	vlan->tinfo.tunnel_id = 0;
-	dst_release(&vlan->tinfo.tunnel_dst->dst);
-	vlan->tinfo.tunnel_dst = NULL;
+	vlan_tunnel_info_release(vlan);
 }
 
 static int __vlan_tunnel_info_add(struct net_bridge_vlan_group *vg,
 				  struct net_bridge_vlan *vlan, u32 tun_id)
 {
-	struct metadata_dst *metadata = NULL;
+	struct metadata_dst *metadata = rtnl_dereference(vlan->tinfo.tunnel_dst);
 	__be64 key = key32_to_tunnel_id(cpu_to_be32(tun_id));
 	int err;
 
-	if (vlan->tinfo.tunnel_dst)
+	if (metadata)
 		return -EEXIST;
 
 	metadata = __ip_tun_set_dst(0, 0, 0, 0, 0, TUNNEL_KEY,
@@ -74,8 +81,8 @@ static int __vlan_tunnel_info_add(struct net_bridge_vlan_group *vg,
 		return -EINVAL;
 
 	metadata->u.tun_info.mode |= IP_TUNNEL_INFO_TX | IP_TUNNEL_INFO_BRIDGE;
-	vlan->tinfo.tunnel_dst = metadata;
-	vlan->tinfo.tunnel_id = key;
+	rcu_assign_pointer(vlan->tinfo.tunnel_dst, metadata);
+	WRITE_ONCE(vlan->tinfo.tunnel_id, key);
 
 	err = rhashtable_lookup_insert_fast(&vg->tunnel_hash, &vlan->tnode,
 					    br_vlan_tunnel_rht_params);
@@ -84,9 +91,7 @@ static int __vlan_tunnel_info_add(struct net_bridge_vlan_group *vg,
 
 	return 0;
 out:
-	dst_release(&vlan->tinfo.tunnel_dst->dst);
-	vlan->tinfo.tunnel_dst = NULL;
-	vlan->tinfo.tunnel_id = 0;
+	vlan_tunnel_info_release(vlan);
 
 	return err;
 }
@@ -186,12 +191,15 @@ int br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
 int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 				 struct net_bridge_vlan *vlan)
 {
+	struct metadata_dst *tunnel_dst;
+	__be64 tunnel_id;
 	int err;
 
-	if (!vlan || !vlan->tinfo.tunnel_id)
+	if (!vlan)
 		return 0;
 
-	if (unlikely(!skb_vlan_tag_present(skb)))
+	tunnel_id = READ_ONCE(vlan->tinfo.tunnel_id);
+	if (!tunnel_id || unlikely(!skb_vlan_tag_present(skb)))
 		return 0;
 
 	skb_dst_drop(skb);
@@ -199,7 +207,9 @@ int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	skb_dst_set(skb, dst_clone(&vlan->tinfo.tunnel_dst->dst));
+	tunnel_dst = rcu_dereference(vlan->tinfo.tunnel_dst);
+	if (tunnel_dst)
+		skb_dst_set(skb, dst_clone(&tunnel_dst->dst));
 
 	return 0;
 }
-- 
2.30.2

