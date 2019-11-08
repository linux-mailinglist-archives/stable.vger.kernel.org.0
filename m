Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F5EF5570
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390527AbfKHTC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:02:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390525AbfKHTC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:02:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C4F421D82;
        Fri,  8 Nov 2019 19:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239746;
        bh=AvAhBb92t4ilr172IFW8Pm/offWP+vNdDrPrS8MqKX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfZq75g4Nn8fc2av+hE5rNGjTJxSu/kpa0p8U8CFRTN4Cf48pPAWjhawrKeGMiF2H
         IscbIUFRrs1eVIpQv4BrfRgAG/DJS1lqZ6uHE3B0L5yJclwf/Rh+s8SzD/77d/RmJW
         Qv4Nd1goa5tRUh93gJy3JwsugKNGpaDZ9FsckZbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 48/79] netns: fix GFP flags in rtnl_net_notifyid()
Date:   Fri,  8 Nov 2019 19:50:28 +0100
Message-Id: <20191108174813.350259628@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit d4e4fdf9e4a27c87edb79b1478955075be141f67 ]

In rtnl_net_notifyid(), we certainly can't pass a null GFP flag to
rtnl_notify(). A GFP_KERNEL flag would be fine in most circumstances,
but there are a few paths calling rtnl_net_notifyid() from atomic
context or from RCU critical sections. The later also precludes the use
of gfp_any() as it wouldn't detect the RCU case. Also, the nlmsg_new()
call is wrong too, as it uses GFP_KERNEL unconditionally.

Therefore, we need to pass the GFP flags as parameter and propagate it
through function calls until the proper flags can be determined.

In most cases, GFP_KERNEL is fine. The exceptions are:
  * openvswitch: ovs_vport_cmd_get() and ovs_vport_cmd_dump()
    indirectly call rtnl_net_notifyid() from RCU critical section,

  * rtnetlink: rtmsg_ifinfo_build_skb() already receives GFP flags as
    parameter.

Also, in ovs_vport_cmd_build_info(), let's change the GFP flags used
by nlmsg_new(). The function is allowed to sleep, so better make the
flags consistent with the ones used in the following
ovs_vport_cmd_fill_info() call.

Found by code inspection.

Fixes: 9a9634545c70 ("netns: notify netns id events")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/net_namespace.h |    2 +-
 net/core/dev.c              |    2 +-
 net/core/net_namespace.c    |   17 +++++++++--------
 net/core/rtnetlink.c        |   14 +++++++-------
 net/openvswitch/datapath.c  |   20 +++++++++++---------
 5 files changed, 29 insertions(+), 26 deletions(-)

--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -322,7 +322,7 @@ static inline struct net *read_pnet(cons
 #define __net_initconst	__initconst
 #endif
 
-int peernet2id_alloc(struct net *net, struct net *peer);
+int peernet2id_alloc(struct net *net, struct net *peer, gfp_t gfp);
 int peernet2id(struct net *net, struct net *peer);
 bool peernet_has_id(struct net *net, struct net *peer);
 struct net *get_net_ns_by_id(struct net *net, int id);
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9211,7 +9211,7 @@ int dev_change_net_namespace(struct net_
 	call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
 	rcu_barrier();
 
-	new_nsid = peernet2id_alloc(dev_net(dev), net);
+	new_nsid = peernet2id_alloc(dev_net(dev), net, GFP_KERNEL);
 	/* If there is an ifindex conflict assign a new one */
 	if (__dev_get_by_index(net, dev->ifindex))
 		new_ifindex = dev_new_index(net);
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -226,11 +226,11 @@ static int __peernet2id(struct net *net,
 	return __peernet2id_alloc(net, peer, &no);
 }
 
-static void rtnl_net_notifyid(struct net *net, int cmd, int id);
+static void rtnl_net_notifyid(struct net *net, int cmd, int id, gfp_t gfp);
 /* This function returns the id of a peer netns. If no id is assigned, one will
  * be allocated and returned.
  */
-int peernet2id_alloc(struct net *net, struct net *peer)
+int peernet2id_alloc(struct net *net, struct net *peer, gfp_t gfp)
 {
 	bool alloc = false, alive = false;
 	int id;
@@ -249,7 +249,7 @@ int peernet2id_alloc(struct net *net, st
 	id = __peernet2id_alloc(net, peer, &alloc);
 	spin_unlock_bh(&net->nsid_lock);
 	if (alloc && id >= 0)
-		rtnl_net_notifyid(net, RTM_NEWNSID, id);
+		rtnl_net_notifyid(net, RTM_NEWNSID, id, gfp);
 	if (alive)
 		put_net(peer);
 	return id;
@@ -495,7 +495,8 @@ static void unhash_nsid(struct net *net,
 			idr_remove(&tmp->netns_ids, id);
 		spin_unlock_bh(&tmp->nsid_lock);
 		if (id >= 0)
-			rtnl_net_notifyid(tmp, RTM_DELNSID, id);
+			rtnl_net_notifyid(tmp, RTM_DELNSID, id,
+					  GFP_KERNEL);
 		if (tmp == last)
 			break;
 	}
@@ -720,7 +721,7 @@ static int rtnl_net_newid(struct sk_buff
 	err = alloc_netid(net, peer, nsid);
 	spin_unlock_bh(&net->nsid_lock);
 	if (err >= 0) {
-		rtnl_net_notifyid(net, RTM_NEWNSID, err);
+		rtnl_net_notifyid(net, RTM_NEWNSID, err, GFP_KERNEL);
 		err = 0;
 	} else if (err == -ENOSPC && nsid >= 0) {
 		err = -EEXIST;
@@ -862,12 +863,12 @@ static int rtnl_net_dumpid(struct sk_buf
 	return skb->len;
 }
 
-static void rtnl_net_notifyid(struct net *net, int cmd, int id)
+static void rtnl_net_notifyid(struct net *net, int cmd, int id, gfp_t gfp)
 {
 	struct sk_buff *msg;
 	int err = -ENOMEM;
 
-	msg = nlmsg_new(rtnl_net_get_size(), GFP_KERNEL);
+	msg = nlmsg_new(rtnl_net_get_size(), gfp);
 	if (!msg)
 		goto out;
 
@@ -875,7 +876,7 @@ static void rtnl_net_notifyid(struct net
 	if (err < 0)
 		goto err_out;
 
-	rtnl_notify(msg, net, 0, RTNLGRP_NSID, NULL, 0);
+	rtnl_notify(msg, net, 0, RTNLGRP_NSID, NULL, gfp);
 	return;
 
 err_out:
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1519,7 +1519,7 @@ static noinline_for_stack int nla_put_if
 
 static int rtnl_fill_link_netnsid(struct sk_buff *skb,
 				  const struct net_device *dev,
-				  struct net *src_net)
+				  struct net *src_net, gfp_t gfp)
 {
 	bool put_iflink = false;
 
@@ -1527,7 +1527,7 @@ static int rtnl_fill_link_netnsid(struct
 		struct net *link_net = dev->rtnl_link_ops->get_link_net(dev);
 
 		if (!net_eq(dev_net(dev), link_net)) {
-			int id = peernet2id_alloc(src_net, link_net);
+			int id = peernet2id_alloc(src_net, link_net, gfp);
 
 			if (nla_put_s32(skb, IFLA_LINK_NETNSID, id))
 				return -EMSGSIZE;
@@ -1585,7 +1585,7 @@ static int rtnl_fill_ifinfo(struct sk_bu
 			    int type, u32 pid, u32 seq, u32 change,
 			    unsigned int flags, u32 ext_filter_mask,
 			    u32 event, int *new_nsid, int new_ifindex,
-			    int tgt_netnsid)
+			    int tgt_netnsid, gfp_t gfp)
 {
 	struct ifinfomsg *ifm;
 	struct nlmsghdr *nlh;
@@ -1677,7 +1677,7 @@ static int rtnl_fill_ifinfo(struct sk_bu
 			goto nla_put_failure;
 	}
 
-	if (rtnl_fill_link_netnsid(skb, dev, src_net))
+	if (rtnl_fill_link_netnsid(skb, dev, src_net, gfp))
 		goto nla_put_failure;
 
 	if (new_nsid &&
@@ -1933,7 +1933,7 @@ static int rtnl_dump_ifinfo(struct sk_bu
 					       cb->nlh->nlmsg_seq, 0,
 					       flags,
 					       ext_filter_mask, 0, NULL, 0,
-					       netnsid);
+					       netnsid, GFP_KERNEL);
 
 			if (err < 0) {
 				if (likely(skb->len))
@@ -3215,7 +3215,7 @@ static int rtnl_getlink(struct sk_buff *
 	err = rtnl_fill_ifinfo(nskb, dev, net,
 			       RTM_NEWLINK, NETLINK_CB(skb).portid,
 			       nlh->nlmsg_seq, 0, 0, ext_filter_mask,
-			       0, NULL, 0, netnsid);
+			       0, NULL, 0, netnsid, GFP_KERNEL);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_size */
 		WARN_ON(err == -EMSGSIZE);
@@ -3325,7 +3325,7 @@ struct sk_buff *rtmsg_ifinfo_build_skb(i
 
 	err = rtnl_fill_ifinfo(skb, dev, dev_net(dev),
 			       type, 0, 0, change, 0, 0, event,
-			       new_nsid, new_ifindex, -1);
+			       new_nsid, new_ifindex, -1, flags);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_size() */
 		WARN_ON(err == -EMSGSIZE);
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1843,7 +1843,7 @@ static struct genl_family dp_datapath_ge
 /* Called with ovs_mutex or RCU read lock. */
 static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 				   struct net *net, u32 portid, u32 seq,
-				   u32 flags, u8 cmd)
+				   u32 flags, u8 cmd, gfp_t gfp)
 {
 	struct ovs_header *ovs_header;
 	struct ovs_vport_stats vport_stats;
@@ -1864,7 +1864,7 @@ static int ovs_vport_cmd_fill_info(struc
 		goto nla_put_failure;
 
 	if (!net_eq(net, dev_net(vport->dev))) {
-		int id = peernet2id_alloc(net, dev_net(vport->dev));
+		int id = peernet2id_alloc(net, dev_net(vport->dev), gfp);
 
 		if (nla_put_s32(skb, OVS_VPORT_ATTR_NETNSID, id))
 			goto nla_put_failure;
@@ -1905,11 +1905,12 @@ struct sk_buff *ovs_vport_cmd_build_info
 	struct sk_buff *skb;
 	int retval;
 
-	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-	retval = ovs_vport_cmd_fill_info(vport, skb, net, portid, seq, 0, cmd);
+	retval = ovs_vport_cmd_fill_info(vport, skb, net, portid, seq, 0, cmd,
+					 GFP_KERNEL);
 	BUG_ON(retval < 0);
 
 	return skb;
@@ -2042,7 +2043,7 @@ restart:
 
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_NEW);
+				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
 
 	if (netdev_get_fwd_headroom(vport->dev) > dp->max_headroom)
 		update_headroom(dp);
@@ -2101,7 +2102,7 @@ static int ovs_vport_cmd_set(struct sk_b
 
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_NEW);
+				      OVS_VPORT_CMD_NEW, GFP_ATOMIC);
 	BUG_ON(err < 0);
 
 	ovs_unlock();
@@ -2140,7 +2141,7 @@ static int ovs_vport_cmd_del(struct sk_b
 
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_DEL);
+				      OVS_VPORT_CMD_DEL, GFP_KERNEL);
 	BUG_ON(err < 0);
 
 	/* the vport deletion may trigger dp headroom update */
@@ -2182,7 +2183,7 @@ static int ovs_vport_cmd_get(struct sk_b
 		goto exit_unlock_free;
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_NEW);
+				      OVS_VPORT_CMD_NEW, GFP_ATOMIC);
 	BUG_ON(err < 0);
 	rcu_read_unlock();
 
@@ -2218,7 +2219,8 @@ static int ovs_vport_cmd_dump(struct sk_
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
 						    NLM_F_MULTI,
-						    OVS_VPORT_CMD_NEW) < 0)
+						    OVS_VPORT_CMD_NEW,
+						    GFP_ATOMIC) < 0)
 				goto out;
 
 			j++;


