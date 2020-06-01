Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43351EAD39
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731052AbgFASLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731055AbgFASLB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:11:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA0572065C;
        Mon,  1 Jun 2020 18:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035060;
        bh=W43aGQ00dTwqe1H56y9e1QDiJiLZoILO1W7ABeFmDmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzdvdqVLqSw4SOufgL/qh6aSBQoaE5GL6X2aw6w4pzbizLQLmWZgFy0Ou16XZPtfn
         EnI9m4K5LleqMmKzzOvI1V10hVOFdQoTJYgRRcK5cwsYucq8WYRT2o66O8hr/FV0kN
         ICsQut4EBEIvqDQxrzJRFVMPiJaB1wFaaaAyjf/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 133/142] nexthops: dont modify published nexthop groups
Date:   Mon,  1 Jun 2020 19:54:51 +0200
Message-Id: <20200601174051.520155690@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

commit 90f33bffa382598a32cc82abfeb20adc92d041b6 upstream.

We must avoid modifying published nexthop groups while they might be
in use, otherwise we might see NULL ptr dereferences. In order to do
that we allocate 2 nexthoup group structures upon nexthop creation
and swap between them when we have to delete an entry. The reason is
that we can't fail nexthop group removal, so we can't handle allocation
failure thus we move the extra allocation on creation where we can
safely fail and return ENOMEM.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/nexthop.h |    1 
 net/ipv4/nexthop.c    |   91 +++++++++++++++++++++++++++++++-------------------
 2 files changed, 59 insertions(+), 33 deletions(-)

--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -70,6 +70,7 @@ struct nh_grp_entry {
 };
 
 struct nh_group {
+	struct nh_group		*spare; /* spare group for removals */
 	u16			num_nh;
 	bool			mpath;
 	bool			has_v4;
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -64,9 +64,16 @@ static void nexthop_free_mpath(struct ne
 	int i;
 
 	nhg = rcu_dereference_raw(nh->nh_grp);
-	for (i = 0; i < nhg->num_nh; ++i)
-		WARN_ON(nhg->nh_entries[i].nh);
+	for (i = 0; i < nhg->num_nh; ++i) {
+		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
 
+		WARN_ON(!list_empty(&nhge->nh_list));
+		nexthop_put(nhge->nh);
+	}
+
+	WARN_ON(nhg->spare == nhg);
+
+	kfree(nhg->spare);
 	kfree(nhg);
 }
 
@@ -698,46 +705,53 @@ static void nh_group_rebalance(struct nh
 static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 				struct nl_info *nlinfo)
 {
+	struct nh_grp_entry *nhges, *new_nhges;
 	struct nexthop *nhp = nhge->nh_parent;
 	struct nexthop *nh = nhge->nh;
-	struct nh_grp_entry *nhges;
-	struct nh_group *nhg;
-	bool found = false;
-	int i;
+	struct nh_group *nhg, *newg;
+	int i, j;
 
 	WARN_ON(!nh);
 
-	list_del(&nhge->nh_list);
-
 	nhg = rtnl_dereference(nhp->nh_grp);
-	nhges = nhg->nh_entries;
-	for (i = 0; i < nhg->num_nh; ++i) {
-		if (found) {
-			nhges[i-1].nh = nhges[i].nh;
-			nhges[i-1].weight = nhges[i].weight;
-			list_del(&nhges[i].nh_list);
-			list_add(&nhges[i-1].nh_list, &nhges[i-1].nh->grp_list);
-		} else if (nhg->nh_entries[i].nh == nh) {
-			found = true;
-		}
-	}
+	newg = nhg->spare;
 
-	if (WARN_ON(!found))
+	/* last entry, keep it visible and remove the parent */
+	if (nhg->num_nh == 1) {
+		remove_nexthop(net, nhp, nlinfo);
 		return;
+	}
 
-	nhg->num_nh--;
-	nhg->nh_entries[nhg->num_nh].nh = NULL;
+	newg->has_v4 = nhg->has_v4;
+	newg->mpath = nhg->mpath;
+	newg->num_nh = nhg->num_nh;
 
-	nh_group_rebalance(nhg);
+	/* copy old entries to new except the one getting removed */
+	nhges = nhg->nh_entries;
+	new_nhges = newg->nh_entries;
+	for (i = 0, j = 0; i < nhg->num_nh; ++i) {
+		/* current nexthop getting removed */
+		if (nhg->nh_entries[i].nh == nh) {
+			newg->num_nh--;
+			continue;
+		}
 
-	nexthop_put(nh);
+		list_del(&nhges[i].nh_list);
+		new_nhges[j].nh_parent = nhges[i].nh_parent;
+		new_nhges[j].nh = nhges[i].nh;
+		new_nhges[j].weight = nhges[i].weight;
+		list_add(&new_nhges[j].nh_list, &new_nhges[j].nh->grp_list);
+		j++;
+	}
+
+	nh_group_rebalance(newg);
+	rcu_assign_pointer(nhp->nh_grp, newg);
+
+	list_del(&nhge->nh_list);
+	nexthop_put(nhge->nh);
 
 	if (nlinfo)
 		nexthop_notify(RTM_NEWNEXTHOP, nhp, nlinfo);
-
-	/* if this group has no more entries then remove it */
-	if (!nhg->num_nh)
-		remove_nexthop(net, nhp, nlinfo);
 }
 
 static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
@@ -747,6 +761,9 @@ static void remove_nexthop_from_groups(s
 
 	list_for_each_entry_safe(nhge, tmp, &nh->grp_list, nh_list)
 		remove_nh_grp_entry(net, nhge, nlinfo);
+
+	/* make sure all see the newly published array before releasing rtnl */
+	synchronize_rcu();
 }
 
 static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)
@@ -760,10 +777,7 @@ static void remove_nexthop_group(struct
 		if (WARN_ON(!nhge->nh))
 			continue;
 
-		list_del(&nhge->nh_list);
-		nexthop_put(nhge->nh);
-		nhge->nh = NULL;
-		nhg->num_nh--;
+		list_del_init(&nhge->nh_list);
 	}
 }
 
@@ -1086,6 +1100,7 @@ static struct nexthop *nexthop_create_gr
 {
 	struct nlattr *grps_attr = cfg->nh_grp;
 	struct nexthop_grp *entry = nla_data(grps_attr);
+	u16 num_nh = nla_len(grps_attr) / sizeof(*entry);
 	struct nh_group *nhg;
 	struct nexthop *nh;
 	int i;
@@ -1096,12 +1111,21 @@ static struct nexthop *nexthop_create_gr
 
 	nh->is_group = 1;
 
-	nhg = nexthop_grp_alloc(nla_len(grps_attr) / sizeof(*entry));
+	nhg = nexthop_grp_alloc(num_nh);
 	if (!nhg) {
 		kfree(nh);
 		return ERR_PTR(-ENOMEM);
 	}
 
+	/* spare group used for removals */
+	nhg->spare = nexthop_grp_alloc(num_nh);
+	if (!nhg) {
+		kfree(nhg);
+		kfree(nh);
+		return NULL;
+	}
+	nhg->spare->spare = nhg;
+
 	for (i = 0; i < nhg->num_nh; ++i) {
 		struct nexthop *nhe;
 		struct nh_info *nhi;
@@ -1133,6 +1157,7 @@ out_no_nh:
 	for (; i >= 0; --i)
 		nexthop_put(nhg->nh_entries[i].nh);
 
+	kfree(nhg->spare);
 	kfree(nhg);
 	kfree(nh);
 


