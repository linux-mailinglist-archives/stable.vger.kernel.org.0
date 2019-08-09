Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F3C87BC6
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407195AbfHINrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407191AbfHINrB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:47:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C262C214C6;
        Fri,  9 Aug 2019 13:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358420;
        bh=VfjukXimkLBJ7zj57fr8FMKr1+qhPqWQu8e8nmqmtAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybN8nFUI+vUjfwX8073IXaA9lucszVWGe1JoOFuAkum/0Kl2TXYQf1Ick0vBGnqGF
         GmZXpdWefFg3cBlvuJzcw1jG77O3V03CASk8fgeAnGp9lFAGCFwkq086NSZdaKaiFm
         yzTopgzOFwCBLkTMt5PLfYD0wUI4tUKv5ZleiYO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 17/32] net: bridge: mcast: dont delete permanent entries when fast leave is enabled
Date:   Fri,  9 Aug 2019 15:45:20 +0200
Message-Id: <20190809133923.514427197@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809133922.945349906@linuxfoundation.org>
References: <20190809133922.945349906@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

[ Upstream commit 5c725b6b65067909548ac9ca9bc777098ec9883d ]

When permanent entries were introduced by the commit below, they were
exempt from timing out and thus igmp leave wouldn't affect them unless
fast leave was enabled on the port which was added before permanent
entries existed. It shouldn't matter if fast leave is enabled or not
if the user added a permanent entry it shouldn't be deleted on igmp
leave.

Before:
$ echo 1 > /sys/class/net/eth4/brport/multicast_fast_leave
$ bridge mdb add dev br0 port eth4 grp 229.1.1.1 permanent
$ bridge mdb show
dev br0 port eth4 grp 229.1.1.1 permanent

< join and leave 229.1.1.1 on eth4 >

$ bridge mdb show
$

After:
$ echo 1 > /sys/class/net/eth4/brport/multicast_fast_leave
$ bridge mdb add dev br0 port eth4 grp 229.1.1.1 permanent
$ bridge mdb show
dev br0 port eth4 grp 229.1.1.1 permanent

< join and leave 229.1.1.1 on eth4 >

$ bridge mdb show
dev br0 port eth4 grp 229.1.1.1 permanent

Fixes: ccb1c31a7a87 ("bridge: add flags to distinguish permanent mdb entires")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1489,6 +1489,9 @@ br_multicast_leave_group(struct net_brid
 			if (p->port != port)
 				continue;
 
+			if (p->flags & MDB_PG_FLAGS_PERMANENT)
+				break;
+
 			rcu_assign_pointer(*pp, p->next);
 			hlist_del_init(&p->mglist);
 			del_timer(&p->timer);


