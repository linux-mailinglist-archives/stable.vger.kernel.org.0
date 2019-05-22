Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DD826ED5
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbfEVTwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:52:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731848AbfEVT0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:26:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBE58206BA;
        Wed, 22 May 2019 19:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553163;
        bh=6oDsoBwBdPplGnR02/CoHmR6NLlRgHypLVoD++FUT18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUtgWlTO8mwdThTy5in98N1NO3DeVYFETKXZ0TyBYhTDtQAsRkNmbWH/jPfj+trZR
         TjBreT48XP9LOL4d9CftRK6NeMGCA3XbaTk9nFbzOiLkWYKO93V0n+ppLv9qViQFxb
         M/zm1F2n8/bOmE7jRBIpZ1aqN3B+FeSEiY3tUVLU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parav Pandit <parav@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 088/317] RDMA/cma: Consider scope_id while binding to ipv6 ll address
Date:   Wed, 22 May 2019 15:19:49 -0400
Message-Id: <20190522192338.23715-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 5d7ed2f27bbd482fd29e6b2e204b1a1ee8a0b268 ]

When two netdev have same link local addresses (such as vlan and non
vlan), two rdma cm listen id should be able to bind to following different
addresses.

listener-1: addr=lla, scope_id=A, port=X
listener-2: addr=lla, scope_id=B, port=X

However while comparing the addresses only addr and port are considered,
due to which 2nd listener fails to listen.

In below example of two listeners, 2nd listener is failing with address in
use error.

$ rping -sv -a fe80::268a:7ff:feb3:d113%ens2f1 -p 4545&

$ rping -sv -a fe80::268a:7ff:feb3:d113%ens2f1.200 -p 4545
rdma_bind_addr: Address already in use

To overcome this, consider the scope_ids as well which forms the accurate
IPv6 link local address.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 81bded0d37d1e..cb482f3389504 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1170,18 +1170,31 @@ static inline bool cma_any_addr(const struct sockaddr *addr)
 	return cma_zero_addr(addr) || cma_loopback_addr(addr);
 }
 
-static int cma_addr_cmp(struct sockaddr *src, struct sockaddr *dst)
+static int cma_addr_cmp(const struct sockaddr *src, const struct sockaddr *dst)
 {
 	if (src->sa_family != dst->sa_family)
 		return -1;
 
 	switch (src->sa_family) {
 	case AF_INET:
-		return ((struct sockaddr_in *) src)->sin_addr.s_addr !=
-		       ((struct sockaddr_in *) dst)->sin_addr.s_addr;
-	case AF_INET6:
-		return ipv6_addr_cmp(&((struct sockaddr_in6 *) src)->sin6_addr,
-				     &((struct sockaddr_in6 *) dst)->sin6_addr);
+		return ((struct sockaddr_in *)src)->sin_addr.s_addr !=
+		       ((struct sockaddr_in *)dst)->sin_addr.s_addr;
+	case AF_INET6: {
+		struct sockaddr_in6 *src_addr6 = (struct sockaddr_in6 *)src;
+		struct sockaddr_in6 *dst_addr6 = (struct sockaddr_in6 *)dst;
+		bool link_local;
+
+		if (ipv6_addr_cmp(&src_addr6->sin6_addr,
+					  &dst_addr6->sin6_addr))
+			return 1;
+		link_local = ipv6_addr_type(&dst_addr6->sin6_addr) &
+			     IPV6_ADDR_LINKLOCAL;
+		/* Link local must match their scope_ids */
+		return link_local ? (src_addr6->sin6_scope_id !=
+				     dst_addr6->sin6_scope_id) :
+				    0;
+	}
+
 	default:
 		return ib_addr_cmp(&((struct sockaddr_ib *) src)->sib_addr,
 				   &((struct sockaddr_ib *) dst)->sib_addr);
-- 
2.20.1

