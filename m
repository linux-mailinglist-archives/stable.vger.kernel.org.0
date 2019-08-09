Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DED087BF8
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406642AbfHINrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436577AbfHINrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:47:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8109A214C6;
        Fri,  9 Aug 2019 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358428;
        bh=5O/qCdf5EeoEXV+hINy4coar5n+yKm8x+R7wXINU+U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXMD4B0RTMe0DnBVRIJ2I0vMXPw6sGkEcpvI5bZ8LuCAh25CAmXRXF3zd+1tPibjs
         5Zthbcj9v/iz5AftRxQHDoAMsfeixxCEzgrD4ESB4ZxrEjnzCnGbSu4NZUBmdY2R+X
         1wochU3mfRAiwNwjQtey6OAKuVTj2Gp812lNlhbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 20/32] net: sched: Fix a possible null-pointer dereference in dequeue_func()
Date:   Fri,  9 Aug 2019 15:45:23 +0200
Message-Id: <20190809133923.599973260@linuxfoundation.org>
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

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 051c7b39be4a91f6b7d8c4548444e4b850f1f56c ]

In dequeue_func(), there is an if statement on line 74 to check whether
skb is NULL:
    if (skb)

When skb is NULL, it is used on line 77:
    prefetch(&skb->end);

Thus, a possible null-pointer dereference may occur.

To fix this bug, skb->end is used when skb is not NULL.

This bug is found by a static analysis tool STCheck written by us.

Fixes: 76e3cc126bb2 ("codel: Controlled Delay AQM")
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_codel.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -71,10 +71,10 @@ static struct sk_buff *dequeue_func(stru
 	struct Qdisc *sch = ctx;
 	struct sk_buff *skb = __qdisc_dequeue_head(&sch->q);
 
-	if (skb)
+	if (skb) {
 		sch->qstats.backlog -= qdisc_pkt_len(skb);
-
-	prefetch(&skb->end); /* we'll need skb_shinfo() */
+		prefetch(&skb->end); /* we'll need skb_shinfo() */
+	}
 	return skb;
 }
 


