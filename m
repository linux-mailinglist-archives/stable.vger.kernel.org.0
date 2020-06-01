Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FA81EAD47
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgFASn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:43:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730477AbgFASLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:11:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F61F206E2;
        Mon,  1 Jun 2020 18:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035064;
        bh=Ku7SeBRPKctbDs9kFxC9F7jkNt5OLICrrA9kqwMBLac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5JRm0jMySJ50SLCZlsO4Z1qe9RS7USPREx9o2a99orurZvMc7EJTpeHjn+qvwdMQ
         PZiWyp2JkbBU5E7OSAR/uYtITCTL1CKTt+Lklggd1YTz2HJ+xnzayQl04bk45yI4bw
         LpsbJthSoHrYLm980AkjFPCWdsZunCjB888dnSOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 135/142] ipv4: nexthop version of fib_info_nh_uses_dev
Date:   Mon,  1 Jun 2020 19:54:53 +0200
Message-Id: <20200601174051.690845158@linuxfoundation.org>
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

From: David Ahern <dsahern@gmail.com>

commit 1fd1c768f3624a5e66766e7b4ddb9b607cd834a5 upstream.

Similar to the last path, need to fix fib_info_nh_uses_dev for
external nexthops to avoid referencing multiple nh_grp structs.
Move the device check in fib_info_nh_uses_dev to a helper and
create a nexthop version that is called if the fib_info uses an
external nexthop.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/ip_fib.h    |   10 ++++++++++
 include/net/nexthop.h   |   25 +++++++++++++++++++++++++
 net/ipv4/fib_frontend.c |   19 ++++++++++---------
 3 files changed, 45 insertions(+), 9 deletions(-)

--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -422,6 +422,16 @@ static inline int fib_num_tclassid_users
 #endif
 int fib_unmerge(struct net *net);
 
+static inline bool nhc_l3mdev_matches_dev(const struct fib_nh_common *nhc,
+const struct net_device *dev)
+{
+	if (nhc->nhc_dev == dev ||
+	    l3mdev_master_ifindex_rcu(nhc->nhc_dev) == dev->ifindex)
+		return true;
+
+	return false;
+}
+
 /* Exported by fib_semantics.c */
 int ip_fib_check_default(__be32 gw, struct net_device *dev);
 int fib_sync_down_dev(struct net_device *dev, unsigned long event, bool force);
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -233,6 +233,31 @@ struct fib_nh_common *nexthop_fib_nhc(st
 	return &nhi->fib_nhc;
 }
 
+static inline bool nexthop_uses_dev(const struct nexthop *nh,
+				    const struct net_device *dev)
+{
+	struct nh_info *nhi;
+
+	if (nh->is_group) {
+		struct nh_group *nhg = rcu_dereference(nh->nh_grp);
+		int i;
+
+		for (i = 0; i < nhg->num_nh; i++) {
+			struct nexthop *nhe = nhg->nh_entries[i].nh;
+
+			nhi = rcu_dereference(nhe->nh_info);
+			if (nhc_l3mdev_matches_dev(&nhi->fib_nhc, dev))
+				return true;
+		}
+	} else {
+		nhi = rcu_dereference(nh->nh_info);
+		if (nhc_l3mdev_matches_dev(&nhi->fib_nhc, dev))
+			return true;
+	}
+
+	return false;
+}
+
 static inline unsigned int fib_info_num_path(const struct fib_info *fi)
 {
 	if (unlikely(fi->nh))
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -319,17 +319,18 @@ bool fib_info_nh_uses_dev(struct fib_inf
 {
 	bool dev_match = false;
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
-	int ret;
+	if (unlikely(fi->nh)) {
+		dev_match = nexthop_uses_dev(fi->nh, dev);
+	} else {
+		int ret;
 
-	for (ret = 0; ret < fib_info_num_path(fi); ret++) {
-		const struct fib_nh_common *nhc = fib_info_nhc(fi, ret);
+		for (ret = 0; ret < fib_info_num_path(fi); ret++) {
+			const struct fib_nh_common *nhc = fib_info_nhc(fi, ret);
 
-		if (nhc->nhc_dev == dev) {
-			dev_match = true;
-			break;
-		} else if (l3mdev_master_ifindex_rcu(nhc->nhc_dev) == dev->ifindex) {
-			dev_match = true;
-			break;
+			if (nhc_l3mdev_matches_dev(nhc, dev)) {
+				dev_match = true;
+				break;
+			}
 		}
 	}
 #else


