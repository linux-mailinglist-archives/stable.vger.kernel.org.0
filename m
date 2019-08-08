Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AC4869F4
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405084AbfHHTLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405456AbfHHTLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:11:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9F8F2189D;
        Thu,  8 Aug 2019 19:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291478;
        bh=ggenjE5LiEMQLOfGTzk0MuJWLto8UFnLRyhpO9WAWQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lphfvApEuZkDFBitxcXHG9Nw6eq3QX5NckzZMGqiHjZUS4nopfvb/Au8xijh7b0mS
         CndlxME5Fu0QbAcaQNM2qjWuQUJnSEzNJet9DetZAPDUK5qwC+tzM/ZFA/xmRHuYVe
         uzQMmJLEs+C7xzrJ2PG/wwRwQydQU81cS51VN3Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.14 08/33] RDMA: Directly cast the sockaddr union to sockaddr
Date:   Thu,  8 Aug 2019 21:05:15 +0200
Message-Id: <20190808190453.987970978@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
References: <20190808190453.582417307@linuxfoundation.org>
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
 drivers/infiniband/core/addr.c           |   15 +++++++--------
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c |    5 ++---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |    5 ++---
 3 files changed, 11 insertions(+), 14 deletions(-)

--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -794,14 +794,13 @@ int rdma_addr_find_l2_eth_by_grh(const u
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
 	if (if_index)
@@ -810,8 +809,9 @@ int rdma_addr_find_l2_eth_by_grh(const u
 
 	ctx.addr = &dev_addr;
 	init_completion(&ctx.comp);
-	ret = rdma_resolve_ip(&self, &sgid_addr._sockaddr, &dgid_addr._sockaddr,
-			&dev_addr, 1000, resolve_cb, &ctx);
+	ret = rdma_resolve_ip(&self, (struct sockaddr *)&sgid_addr,
+			      (struct sockaddr *)&dgid_addr, &dev_addr, 1000,
+			      resolve_cb, &ctx);
 	if (ret)
 		return ret;
 
@@ -841,16 +841,15 @@ int rdma_addr_find_smac_by_sgid(union ib
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
@@ -2508,7 +2508,6 @@ static int ocrdma_set_av_params(struct o
 	u32 vlan_id = 0xFFFF;
 	u8 mac_addr[6], hdr_type;
 	union {
-		struct sockaddr     _sockaddr;
 		struct sockaddr_in  _sockaddr_in;
 		struct sockaddr_in6 _sockaddr_in6;
 	} sgid_addr, dgid_addr;
@@ -2556,8 +2555,8 @@ static int ocrdma_set_av_params(struct o
 
 	hdr_type = ib_gid_to_network_type(sgid_attr.gid_type, &sgid);
 	if (hdr_type == RDMA_NETWORK_IPV4) {
-		rdma_gid2ip(&sgid_addr._sockaddr, &sgid);
-		rdma_gid2ip(&dgid_addr._sockaddr, &grh->dgid);
+		rdma_gid2ip((struct sockaddr *)&sgid_addr, &sgid);
+		rdma_gid2ip((struct sockaddr *)&dgid_addr, &grh->dgid);
 		memcpy(&cmd->params.dgid[0],
 		       &dgid_addr._sockaddr_in.sin_addr.s_addr, 4);
 		memcpy(&cmd->params.sgid[0],


