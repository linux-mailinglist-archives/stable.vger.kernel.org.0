Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A583A917
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389064AbfFIRGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389048AbfFIRGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:06:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D90A3204EC;
        Sun,  9 Jun 2019 17:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560100000;
        bh=XgetBVUHZB7IorlSzlXg19e6QMGcHjs8QXLzyfF8Hg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCoTG0RsqdY46YWe4X/jbchv52UH0aNeXdSnJ7zyWJ8Cq3b1JCx4Qp8Uy0eGB+1gl
         XqJurXKWNTSQxe0kgMzeH0G8FWqpzKR0nt3Lmt4xiFr7m0yU7FnzdjGp8ZCZODlyhY
         tBnCYIlLrrZSBP8S6hwb/tjVhOHE7WHMqYpLOFoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 230/241] neighbor: Call __ipv4_neigh_lookup_noref in neigh_xmit
Date:   Sun,  9 Jun 2019 18:42:52 +0200
Message-Id: <20190609164155.367695468@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 4b2a2bfeb3f056461a90bd621e8bd7d03fa47f60 ]

Commit cd9ff4de0107 changed the key for IFF_POINTOPOINT devices to
INADDR_ANY but neigh_xmit which is used for MPLS encapsulations was not
updated to use the altered key. The result is that every packet Tx does
a lookup on the gateway address which does not find an entry, a new one
is created only to find the existing one in the table right before the
insert since arp_constructor was updated to reset the primary key. This
is seen in the allocs and destroys counters:
    ip -s -4 ntable show | head -10 | grep alloc

which increase for each packet showing the unnecessary overhread.

Fix by having neigh_xmit use __ipv4_neigh_lookup_noref for NEIGH_ARP_TABLE.

Fixes: cd9ff4de0107 ("ipv4: Make neigh lookup keys for loopback/point-to-point devices be INADDR_ANY")
Reported-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Tested-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/neighbour.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -30,6 +30,7 @@
 #include <linux/times.h>
 #include <net/net_namespace.h>
 #include <net/neighbour.h>
+#include <net/arp.h>
 #include <net/dst.h>
 #include <net/sock.h>
 #include <net/netevent.h>
@@ -2490,7 +2491,13 @@ int neigh_xmit(int index, struct net_dev
 		if (!tbl)
 			goto out;
 		rcu_read_lock_bh();
-		neigh = __neigh_lookup_noref(tbl, addr, dev);
+		if (index == NEIGH_ARP_TABLE) {
+			u32 key = *((u32 *)addr);
+
+			neigh = __ipv4_neigh_lookup_noref(dev, key);
+		} else {
+			neigh = __neigh_lookup_noref(tbl, addr, dev);
+		}
 		if (!neigh)
 			neigh = __neigh_create(tbl, addr, dev, false);
 		err = PTR_ERR(neigh);


