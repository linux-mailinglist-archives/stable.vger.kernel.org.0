Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2CC55CBB6
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfGBIEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:04:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbfGBIEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:04:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0989F21841;
        Tue,  2 Jul 2019 08:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054679;
        bh=BTSRS7krKf0ykVWMx0adRYJYzVZlruXljy9zoQppowA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urPeLJ1J2ScKfGKzkAMV1w0zYDYh1sL4jhiubadli5Ynaq/I3R/kR8q3FqKMzJID/
         bJR6lOcmDKiOX1kg3NABP9dvK04IizGoJDpGgK7nYW2oOJOveEP+7IkMx4Vkw3fdrX
         9cayqIVxi0z2NWUA00oE4Iv1l1hzXth3k4JyX/Nc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.1 53/55] RDMA: Directly cast the sockaddr union to sockaddr
Date:   Tue,  2 Jul 2019 10:02:01 +0200
Message-Id: <20190702080126.810631450@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
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
 drivers/infiniband/core/addr.c           |   16 ++++++++--------
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c |    5 ++---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |    5 ++---
 3 files changed, 12 insertions(+), 14 deletions(-)

--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -730,8 +730,8 @@ int roce_resolve_route_from_path(struct
 	if (rec->roce.route_resolved)
 		return 0;
 
-	rdma_gid2ip(&sgid._sockaddr, &rec->sgid);
-	rdma_gid2ip(&dgid._sockaddr, &rec->dgid);
+	rdma_gid2ip((struct sockaddr *)&sgid, &rec->sgid);
+	rdma_gid2ip((struct sockaddr *)&dgid, &rec->dgid);
 
 	if (sgid._sockaddr.sa_family != dgid._sockaddr.sa_family)
 		return -EINVAL;
@@ -742,7 +742,7 @@ int roce_resolve_route_from_path(struct
 	dev_addr.net = &init_net;
 	dev_addr.sgid_attr = attr;
 
-	ret = addr_resolve(&sgid._sockaddr, &dgid._sockaddr,
+	ret = addr_resolve((struct sockaddr *)&sgid, (struct sockaddr *)&dgid,
 			   &dev_addr, false, true, 0);
 	if (ret)
 		return ret;
@@ -814,22 +814,22 @@ int rdma_addr_find_l2_eth_by_grh(const u
 	struct rdma_dev_addr dev_addr;
 	struct resolve_cb_context ctx;
 	union {
-		struct sockaddr     _sockaddr;
 		struct sockaddr_in  _sockaddr_in;
 		struct sockaddr_in6 _sockaddr_in6;
 	} sgid_addr, dgid_addr;
 	int ret;
 
-	rdma_gid2ip(&sgid_addr._sockaddr, sgid);
-	rdma_gid2ip(&dgid_addr._sockaddr, dgid);
+	rdma_gid2ip((struct sockaddr *)&sgid_addr, sgid);
+	rdma_gid2ip((struct sockaddr *)&dgid_addr, dgid);
 
 	memset(&dev_addr, 0, sizeof(dev_addr));
 	dev_addr.net = &init_net;
 	dev_addr.sgid_attr = sgid_attr;
 
 	init_completion(&ctx.comp);
-	ret = rdma_resolve_ip(&sgid_addr._sockaddr, &dgid_addr._sockaddr,
-			      &dev_addr, 1000, resolve_cb, true, &ctx);
+	ret = rdma_resolve_ip((struct sockaddr *)&sgid_addr,
+			      (struct sockaddr *)&dgid_addr, &dev_addr, 1000,
+			      resolve_cb, true, &ctx);
 	if (ret)
 		return ret;
 
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -83,7 +83,6 @@ static inline int set_av_attr(struct ocr
 	struct iphdr ipv4;
 	const struct ib_global_route *ib_grh;
 	union {
-		struct sockaddr     _sockaddr;
 		struct sockaddr_in  _sockaddr_in;
 		struct sockaddr_in6 _sockaddr_in6;
 	} sgid_addr, dgid_addr;
@@ -133,9 +132,9 @@ static inline int set_av_attr(struct ocr
 		ipv4.tot_len = htons(0);
 		ipv4.ttl = ib_grh->hop_limit;
 		ipv4.protocol = nxthdr;
-		rdma_gid2ip(&sgid_addr._sockaddr, sgid);
+		rdma_gid2ip((struct sockaddr *)&sgid_addr, sgid);
 		ipv4.saddr = sgid_addr._sockaddr_in.sin_addr.s_addr;
-		rdma_gid2ip(&dgid_addr._sockaddr, &ib_grh->dgid);
+		rdma_gid2ip((struct sockaddr*)&dgid_addr, &ib_grh->dgid);
 		ipv4.daddr = dgid_addr._sockaddr_in.sin_addr.s_addr;
 		memcpy((u8 *)ah->av + eth_sz, &ipv4, sizeof(struct iphdr));
 	} else {
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2499,7 +2499,6 @@ static int ocrdma_set_av_params(struct o
 	u32 vlan_id = 0xFFFF;
 	u8 mac_addr[6], hdr_type;
 	union {
-		struct sockaddr     _sockaddr;
 		struct sockaddr_in  _sockaddr_in;
 		struct sockaddr_in6 _sockaddr_in6;
 	} sgid_addr, dgid_addr;
@@ -2541,8 +2540,8 @@ static int ocrdma_set_av_params(struct o
 
 	hdr_type = rdma_gid_attr_network_type(sgid_attr);
 	if (hdr_type == RDMA_NETWORK_IPV4) {
-		rdma_gid2ip(&sgid_addr._sockaddr, &sgid_attr->gid);
-		rdma_gid2ip(&dgid_addr._sockaddr, &grh->dgid);
+		rdma_gid2ip((struct sockaddr *)&sgid_addr, &sgid_attr->gid);
+		rdma_gid2ip((struct sockaddr *)&dgid_addr, &grh->dgid);
 		memcpy(&cmd->params.dgid[0],
 		       &dgid_addr._sockaddr_in.sin_addr.s_addr, 4);
 		memcpy(&cmd->params.sgid[0],


