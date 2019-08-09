Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A07987C0E
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406662AbfHINpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfHINpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:45:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26BE6214C6;
        Fri,  9 Aug 2019 13:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358345;
        bh=nD31jO9i+Ksl0ih0bdxsGGZ7r1uRwlVrdDU7Q2V65V0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zn8l+gPu1BjH9OInnLoEaCTtHwYGz2Sh27jNbuBIPZlToGi+dFzrHffkYovnaRsnf
         AMRH+RylQpM7N01Zd8VaiMZI4OrKWwAS5Vx+Av6+vTbr2khxDnGujpvK5IbstxlZIQ
         iiEYEZRr91bU+9g2pVpKdteavkvJDYnQaBgvYjSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 10/21] net: sched: Fix a possible null-pointer dereference in dequeue_func()
Date:   Fri,  9 Aug 2019 15:45:14 +0200
Message-Id: <20190809134242.004869565@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809134241.565496442@linuxfoundation.org>
References: <20190809134241.565496442@linuxfoundation.org>
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
 net/sched/sch_codel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -68,7 +68,8 @@ static struct sk_buff *dequeue(struct co
 {
 	struct sk_buff *skb = __skb_dequeue(&sch->q);
 
-	prefetch(&skb->end); /* we'll need skb_shinfo() */
+	if (skb)
+		prefetch(&skb->end); /* we'll need skb_shinfo() */
 	return skb;
 }
 


