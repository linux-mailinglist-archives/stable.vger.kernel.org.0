Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18655278798
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgIYMsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728702AbgIYMsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:48:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADA3721741;
        Fri, 25 Sep 2020 12:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038131;
        bh=sWcrSjXVX6igZJnbs/kgA7rS9CTZPvuGV5tIOowXLkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3XtIX8PK1AI6J+D5PkH5DhFb0lQGJA7I6//CdGTPErRuqcK2NQbMkIl3/jdm4K2R
         gvfnB0Tc23Z8hINxbzenfix018EQTDG+UJkfRsJcfjpni0+VarDTSJ26J7FsH3E8Js
         L5d+y2MSIlsIroUr3GZIEqd5oygLM3dhpcqICnXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 15/56] net: bridge: br_vlan_get_pvid_rcu() should dereference the VLAN group under RCU
Date:   Fri, 25 Sep 2020 14:48:05 +0200
Message-Id: <20200925124730.105544984@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 99f62a746066fa436aa15d4606a538569540db08 ]

When calling the RCU brother of br_vlan_get_pvid(), lockdep warns:

=============================
WARNING: suspicious RCU usage
5.9.0-rc3-01631-g13c17acb8e38-dirty #814 Not tainted
-----------------------------
net/bridge/br_private.h:1054 suspicious rcu_dereference_protected() usage!

Call trace:
 lockdep_rcu_suspicious+0xd4/0xf8
 __br_vlan_get_pvid+0xc0/0x100
 br_vlan_get_pvid_rcu+0x78/0x108

The warning is because br_vlan_get_pvid_rcu() calls nbp_vlan_group()
which calls rtnl_dereference() instead of rcu_dereference(). In turn,
rtnl_dereference() calls rcu_dereference_protected() which assumes
operation under an RCU write-side critical section, which obviously is
not the case here. So, when the incorrect primitive is used to access
the RCU-protected VLAN group pointer, READ_ONCE() is not used, which may
cause various unexpected problems.

I'm sad to say that br_vlan_get_pvid() and br_vlan_get_pvid_rcu() cannot
share the same implementation. So fix the bug by splitting the 2
functions, and making br_vlan_get_pvid_rcu() retrieve the VLAN groups
under proper locking annotations.

Fixes: 7582f5b70f9a ("bridge: add br_vlan_get_pvid_rcu()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_vlan.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1288,11 +1288,13 @@ void br_vlan_get_stats(const struct net_
 	}
 }
 
-static int __br_vlan_get_pvid(const struct net_device *dev,
-			      struct net_bridge_port *p, u16 *p_pvid)
+int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid)
 {
 	struct net_bridge_vlan_group *vg;
+	struct net_bridge_port *p;
 
+	ASSERT_RTNL();
+	p = br_port_get_check_rtnl(dev);
 	if (p)
 		vg = nbp_vlan_group(p);
 	else if (netif_is_bridge_master(dev))
@@ -1303,18 +1305,23 @@ static int __br_vlan_get_pvid(const stru
 	*p_pvid = br_get_pvid(vg);
 	return 0;
 }
-
-int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid)
-{
-	ASSERT_RTNL();
-
-	return __br_vlan_get_pvid(dev, br_port_get_check_rtnl(dev), p_pvid);
-}
 EXPORT_SYMBOL_GPL(br_vlan_get_pvid);
 
 int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid)
 {
-	return __br_vlan_get_pvid(dev, br_port_get_check_rcu(dev), p_pvid);
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_port *p;
+
+	p = br_port_get_check_rcu(dev);
+	if (p)
+		vg = nbp_vlan_group_rcu(p);
+	else if (netif_is_bridge_master(dev))
+		vg = br_vlan_group_rcu(netdev_priv(dev));
+	else
+		return -EINVAL;
+
+	*p_pvid = br_get_pvid(vg);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(br_vlan_get_pvid_rcu);
 


