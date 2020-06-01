Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E659B1EAC3F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbgFASRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731854AbgFASRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:17:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A796C2073B;
        Mon,  1 Jun 2020 18:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035460;
        bh=ljCTCBY5Y2V5rVf+5wQNZAtGI1sehU1LGkD4XogMnoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KylXSgKAcCPQ1kGC5+ZrKlCWJfmko+9zpXz/AFj/Tv89vwysZ2aO+20RMI4cnMEk0
         XKUcH3S0JmhprRLUsBtPA376auJUE4paHvo1/IajDvue3Q0AFrJ6EI1BljI+0QpZwr
         SIVA1WKVHKYranyBMiLMDAl1N2sBzy3yJlTxgCTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 167/177] nexthops: Move code from remove_nexthop_from_groups to remove_nh_grp_entry
Date:   Mon,  1 Jun 2020 19:55:05 +0200
Message-Id: <20200601174102.076052867@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

commit ac21753a5c2c9a6a2019997481a2ac12bbde48c8 upstream.

Move nh_grp dereference and check for removing nexthop group due to
all members gone into remove_nh_grp_entry.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/nexthop.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -694,17 +694,21 @@ static void nh_group_rebalance(struct nh
 	}
 }
 
-static void remove_nh_grp_entry(struct nh_grp_entry *nhge,
-				struct nh_group *nhg,
+static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 				struct nl_info *nlinfo)
 {
+	struct nexthop *nhp = nhge->nh_parent;
 	struct nexthop *nh = nhge->nh;
 	struct nh_grp_entry *nhges;
+	struct nh_group *nhg;
 	bool found = false;
 	int i;
 
 	WARN_ON(!nh);
 
+	list_del(&nhge->nh_list);
+
+	nhg = rtnl_dereference(nhp->nh_grp);
 	nhges = nhg->nh_entries;
 	for (i = 0; i < nhg->num_nh; ++i) {
 		if (found) {
@@ -728,7 +732,11 @@ static void remove_nh_grp_entry(struct n
 	nexthop_put(nh);
 
 	if (nlinfo)
-		nexthop_notify(RTM_NEWNEXTHOP, nhge->nh_parent, nlinfo);
+		nexthop_notify(RTM_NEWNEXTHOP, nhp, nlinfo);
+
+	/* if this group has no more entries then remove it */
+	if (!nhg->num_nh)
+		remove_nexthop(net, nhp, nlinfo);
 }
 
 static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
@@ -736,17 +744,8 @@ static void remove_nexthop_from_groups(s
 {
 	struct nh_grp_entry *nhge, *tmp;
 
-	list_for_each_entry_safe(nhge, tmp, &nh->grp_list, nh_list) {
-		struct nh_group *nhg;
-
-		list_del(&nhge->nh_list);
-		nhg = rtnl_dereference(nhge->nh_parent->nh_grp);
-		remove_nh_grp_entry(nhge, nhg, nlinfo);
-
-		/* if this group has no more entries then remove it */
-		if (!nhg->num_nh)
-			remove_nexthop(net, nhge->nh_parent, nlinfo);
-	}
+	list_for_each_entry_safe(nhge, tmp, &nh->grp_list, nh_list)
+		remove_nh_grp_entry(net, nhge, nlinfo);
 }
 
 static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)


