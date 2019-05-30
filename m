Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596922F630
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfE3Ex5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728126AbfE3DKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:31 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA62B244C8;
        Thu, 30 May 2019 03:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185830;
        bh=Tc8OrLISn/6K0CKtw3ADXYDLTGuQZovzyj8UNyrDsK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Era6vT4Xs50LNYFIVFL9Xkf7dB8pwfar6ujYFUVpm4MNywmYe5NwTWD08JWdZCNwg
         lzewSE4DxPwbHGmYKNmNqM6MA4yDxyIzQdUpVjnd6k/Nj5chOi/zjt3/du/Bgi+aVV
         HwC+vkLYArVj1VCRbPwKcX0LoKPz1vXnmRLIeoi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 134/405] RDMA/cma: Consider scope_id while binding to ipv6 ll address
Date:   Wed, 29 May 2019 20:02:12 -0700
Message-Id: <20190530030547.872189825@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 68c997be24293..c54da16df0beb 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1173,18 +1173,31 @@ static inline bool cma_any_addr(const struct sockaddr *addr)
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



