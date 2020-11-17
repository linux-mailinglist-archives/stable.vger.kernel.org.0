Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF4A2B65D8
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgKQN6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:58:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:51454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730403AbgKQNSt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:18:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52A7C206D5;
        Tue, 17 Nov 2020 13:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619129;
        bh=PiXDgQ6Qjv2Jyg0jv9aUr4EpW3sTnP1XqLlFuDY47nE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCpGgF2qQGrjJUDYYuWx7+PLr67q2ft7oEtekUNyfKLXrrv/9H4guGpVa37pBMnIX
         35OPpnbaDzO+UplBUAd/EOsZPn1DJV1iX3Ocpo7/FuMWn0efDnmxRVAq0X9LMAnzXd
         hA8+DVMN/RzlJ+YxahV2EA0Xm3XSYw/r5+cwEwlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        zhuoliang zhang <zhuoliang.zhang@mediatek.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 010/101] net: xfrm: fix a race condition during allocing spi
Date:   Tue, 17 Nov 2020 14:04:37 +0100
Message-Id: <20201117122113.600997647@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhuoliang zhang <zhuoliang.zhang@mediatek.com>

[ Upstream commit a779d91314ca7208b7feb3ad817b62904397c56d ]

we found that the following race condition exists in
xfrm_alloc_userspi flow:

user thread                                    state_hash_work thread
----                                           ----
xfrm_alloc_userspi()
 __find_acq_core()
   /*alloc new xfrm_state:x*/
   xfrm_state_alloc()
   /*schedule state_hash_work thread*/
   xfrm_hash_grow_check()   	               xfrm_hash_resize()
 xfrm_alloc_spi                                  /*hold lock*/
      x->id.spi = htonl(spi)                     spin_lock_bh(&net->xfrm.xfrm_state_lock)
      /*waiting lock release*/                     xfrm_hash_transfer()
      spin_lock_bh(&net->xfrm.xfrm_state_lock)      /*add x into hlist:net->xfrm.state_byspi*/
	                                                hlist_add_head_rcu(&x->byspi)
                                                 spin_unlock_bh(&net->xfrm.xfrm_state_lock)

    /*add x into hlist:net->xfrm.state_byspi 2 times*/
    hlist_add_head_rcu(&x->byspi)

1. a new state x is alloced in xfrm_state_alloc() and added into the bydst hlist
in  __find_acq_core() on the LHS;
2. on the RHS, state_hash_work thread travels the old bydst and tranfers every xfrm_state
(include x) into the new bydst hlist and new byspi hlist;
3. user thread on the LHS gets the lock and adds x into the new byspi hlist again.

So the same xfrm_state (x) is added into the same list_hash
(net->xfrm.state_byspi) 2 times that makes the list_hash become
an inifite loop.

To fix the race, x->id.spi = htonl(spi) in the xfrm_alloc_spi() is moved
to the back of spin_lock_bh, sothat state_hash_work thread no longer add x
which id.spi is zero into the hash_list.

Fixes: f034b5d4efdf ("[XFRM]: Dynamic xfrm_state hash table sizing.")
Signed-off-by: zhuoliang zhang <zhuoliang.zhang@mediatek.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index a649d7c2f48ca..84dea0ad16661 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1825,6 +1825,7 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high)
 	int err = -ENOENT;
 	__be32 minspi = htonl(low);
 	__be32 maxspi = htonl(high);
+	__be32 newspi = 0;
 	u32 mark = x->mark.v & x->mark.m;
 
 	spin_lock_bh(&x->lock);
@@ -1843,21 +1844,22 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high)
 			xfrm_state_put(x0);
 			goto unlock;
 		}
-		x->id.spi = minspi;
+		newspi = minspi;
 	} else {
 		u32 spi = 0;
 		for (h = 0; h < high-low+1; h++) {
 			spi = low + prandom_u32()%(high-low+1);
 			x0 = xfrm_state_lookup(net, mark, &x->id.daddr, htonl(spi), x->id.proto, x->props.family);
 			if (x0 == NULL) {
-				x->id.spi = htonl(spi);
+				newspi = htonl(spi);
 				break;
 			}
 			xfrm_state_put(x0);
 		}
 	}
-	if (x->id.spi) {
+	if (newspi) {
 		spin_lock_bh(&net->xfrm.xfrm_state_lock);
+		x->id.spi = newspi;
 		h = xfrm_spi_hash(net, &x->id.daddr, x->id.spi, x->id.proto, x->props.family);
 		hlist_add_head_rcu(&x->byspi, net->xfrm.state_byspi + h);
 		spin_unlock_bh(&net->xfrm.xfrm_state_lock);
-- 
2.27.0



