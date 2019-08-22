Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 270AB99DE1
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391573AbfHVRqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391683AbfHVRW6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:58 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 581DC23402;
        Thu, 22 Aug 2019 17:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494577;
        bh=Xc5OMN/+A9L0ei6L7NpIsibPfNtCCMTOms0AB/X0oM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h36Fq7tAQsyoauWWkDL6oTqjNa9Pz8aPIJ1hmB8RYBD4eIRc5WEKjYyIbhpzSZmQh
         4z1X6MN6IDz4629sSuK0MGW7cR0s2nd6Z3Q7w6OaUCdvKox0wRKNr4iu9jvICiXOYc
         HcxRTwCuEfSNdD+scy9QFhtlrrytnT00gO/61znA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.4 69/78] RDMA: Directly cast the sockaddr union to sockaddr
Date:   Thu, 22 Aug 2019 10:19:13 -0700
Message-Id: <20190822171834.026854849@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 641114d2af312d39ca9bbc2369d18a5823da51c6 upstream.

gcc 9 now does allocation size tracking and thinks that passing the member
of a union and then accessing beyond that member's bounds is an overflow.

Instead of using the union member, use the entire union with a cast to
get to the sockaddr. gcc will now know that the memory extends the full
size of the union.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/addr.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -481,14 +481,13 @@ int rdma_addr_find_dmac_by_grh(const uni
 	struct net_device *dev;
 
 	union {
-		struct sockaddr     _sockaddr;
 		struct sockaddr_in  _sockaddr_in;
 		struct sockaddr_in6 _sockaddr_in6;
 	} sgid_addr, dgid_addr;
 
 
-	rdma_gid2ip(&sgid_addr._sockaddr, sgid);
-	rdma_gid2ip(&dgid_addr._sockaddr, dgid);
+	rdma_gid2ip((struct sockaddr *)&sgid_addr, sgid);
+	rdma_gid2ip((struct sockaddr *)&dgid_addr, dgid);
 
 	memset(&dev_addr, 0, sizeof(dev_addr));
 	dev_addr.bound_dev_if = if_index;
@@ -496,8 +495,9 @@ int rdma_addr_find_dmac_by_grh(const uni
 
 	ctx.addr = &dev_addr;
 	init_completion(&ctx.comp);
-	ret = rdma_resolve_ip(&self, &sgid_addr._sockaddr, &dgid_addr._sockaddr,
-			&dev_addr, 1000, resolve_cb, &ctx);
+	ret = rdma_resolve_ip(&self, (struct sockaddr *)&sgid_addr,
+			      (struct sockaddr *)&dgid_addr, &dev_addr, 1000,
+			      resolve_cb, &ctx);
 	if (ret)
 		return ret;
 
@@ -519,16 +519,15 @@ int rdma_addr_find_smac_by_sgid(union ib
 	int ret = 0;
 	struct rdma_dev_addr dev_addr;
 	union {
-		struct sockaddr     _sockaddr;
 		struct sockaddr_in  _sockaddr_in;
 		struct sockaddr_in6 _sockaddr_in6;
 	} gid_addr;
 
-	rdma_gid2ip(&gid_addr._sockaddr, sgid);
+	rdma_gid2ip((struct sockaddr *)&gid_addr, sgid);
 
 	memset(&dev_addr, 0, sizeof(dev_addr));
 	dev_addr.net = &init_net;
-	ret = rdma_translate_ip(&gid_addr._sockaddr, &dev_addr, vlan_id);
+	ret = rdma_translate_ip((struct sockaddr *)&gid_addr, &dev_addr, vlan_id);
 	if (ret)
 		return ret;
 


