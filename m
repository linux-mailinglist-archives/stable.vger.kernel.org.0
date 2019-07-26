Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F88876E25
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388182AbfGZPjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388135AbfGZP0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:26:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F271322BF5;
        Fri, 26 Jul 2019 15:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154814;
        bh=V7+Br9o9LhsUH2f7E9v51PJEkEZe8FFACI/PZu6wLkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CGuDKjbayr8TVcJZOF4Lzvr+GfB4hufSdPc/KkcYUonHVkKZ3UnEVaI6wpXomKWNf
         nqu0sQdJ7iam5FY9nTM6Sdc3ps1VcoGcBDmXhkJCT0YLhznkIiNqKg3V38lt3HFAZY
         HxzktTrQxHloWGevLEzN4U3UXlmhW7wlefOEASJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Alexander Petrovskiy <alexpe@mellanox.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 07/66] ipv6: Unlink sibling route in case of failure
Date:   Fri, 26 Jul 2019 17:24:06 +0200
Message-Id: <20190726152302.707755084@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 54851aa90cf27041d64b12f65ac72e9f97bd90fd ]

When a route needs to be appended to an existing multipath route,
fib6_add_rt2node() first appends it to the siblings list and increments
the number of sibling routes on each sibling.

Later, the function notifies the route via call_fib6_entry_notifiers().
In case the notification is vetoed, the route is not unlinked from the
siblings list, which can result in a use-after-free.

Fix this by unlinking the route from the siblings list before returning
an error.

Audited the rest of the call sites from which the FIB notification chain
is called and could not find more problems.

Fixes: 2233000cba40 ("net/ipv6: Move call_fib6_entry_notifiers up for route adds")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Alexander Petrovskiy <alexpe@mellanox.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_fib.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1104,8 +1104,24 @@ add:
 		err = call_fib6_entry_notifiers(info->nl_net,
 						FIB_EVENT_ENTRY_ADD,
 						rt, extack);
-		if (err)
+		if (err) {
+			struct fib6_info *sibling, *next_sibling;
+
+			/* If the route has siblings, then it first
+			 * needs to be unlinked from them.
+			 */
+			if (!rt->fib6_nsiblings)
+				return err;
+
+			list_for_each_entry_safe(sibling, next_sibling,
+						 &rt->fib6_siblings,
+						 fib6_siblings)
+				sibling->fib6_nsiblings--;
+			rt->fib6_nsiblings = 0;
+			list_del_init(&rt->fib6_siblings);
+			rt6_multipath_rebalance(next_sibling);
 			return err;
+		}
 
 		rcu_assign_pointer(rt->fib6_next, iter);
 		fib6_info_hold(rt);


