Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43BF87BE8
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406803AbfHINrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406849AbfHINro (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:47:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90C6621874;
        Fri,  9 Aug 2019 13:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358464;
        bh=8AqG7ieUPkUuhCqZXmd44lbtH44NYq5D2oVblWSaJFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZWqwu1zYw55X7xz6Tt8ftcJbEOw62MdyOS406/sf5+E7dUv4HWsPw5kPoOiniywG
         Wdrgggic8rALIdsZUCkF9dWY1796rjeHZuvdy0oUIRQpV3xGV93ONB5B5dCYRrVdft
         IkE3gu46M6eJTuq7d00EyGby+Djk7kx/I/XPpfqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.9 10/32] RDMA: Directly cast the sockaddr union to sockaddr
Date:   Fri,  9 Aug 2019 15:45:13 +0200
Message-Id: <20190809133923.280736045@linuxfoundation.org>
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
@@ -735,14 +735,13 @@ int rdma_addr_find_l2_eth_by_grh(const u
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
@@ -751,8 +750,9 @@ int rdma_addr_find_l2_eth_by_grh(const u
 
 	ctx.addr = &dev_addr;
 	init_completion(&ctx.comp);
-	ret = rdma_resolve_ip(&self, &sgid_addr._sockaddr, &dgid_addr._sockaddr,
-			&dev_addr, 1000, resolve_cb, &ctx);
+	ret = rdma_resolve_ip(&self, (struct sockaddr *)&sgid_addr,
+			      (struct sockaddr *)&dgid_addr, &dev_addr, 1000,
+			      resolve_cb, &ctx);
 	if (ret)
 		return ret;
 
@@ -782,16 +782,15 @@ int rdma_addr_find_smac_by_sgid(union ib
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
@@ -82,7 +82,6 @@ static inline int set_av_attr(struct ocr
 	u8 nxthdr = 0x11;
 	struct iphdr ipv4;
 	union {
-		struct sockaddr     _sockaddr;
 		struct sockaddr_in  _sockaddr_in;
 		struct sockaddr_in6 _sockaddr_in6;
 	} sgid_addr, dgid_addr;
@@ -131,9 +130,9 @@ static inline int set_av_attr(struct ocr
 		ipv4.tot_len = htons(0);
 		ipv4.ttl = attr->grh.hop_limit;
 		ipv4.protocol = nxthdr;
-		rdma_gid2ip(&sgid_addr._sockaddr, sgid);
+		rdma_gid2ip((struct sockaddr *)&sgid_addr, sgid);
 		ipv4.saddr = sgid_addr._sockaddr_in.sin_addr.s_addr;
-		rdma_gid2ip(&dgid_addr._sockaddr, &attr->grh.dgid);
+		rdma_gid2ip((struct sockaddr *)&dgid_addr, &attr->grh.dgid);
 		ipv4.daddr = dgid_addr._sockaddr_in.sin_addr.s_addr;
 		memcpy((u8 *)ah->av + eth_sz, &ipv4, sizeof(struct iphdr));
 	} else {
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2505,7 +2505,6 @@ static int ocrdma_set_av_params(struct o
 	u32 vlan_id = 0xFFFF;
 	u8 mac_addr[6], hdr_type;
 	union {
-		struct sockaddr     _sockaddr;
 		struct sockaddr_in  _sockaddr_in;
 		struct sockaddr_in6 _sockaddr_in6;
 	} sgid_addr, dgid_addr;
@@ -2550,8 +2549,8 @@ static int ocrdma_set_av_params(struct o
 
 	hdr_type = ib_gid_to_network_type(sgid_attr.gid_type, &sgid);
 	if (hdr_type == RDMA_NETWORK_IPV4) {
-		rdma_gid2ip(&sgid_addr._sockaddr, &sgid);
-		rdma_gid2ip(&dgid_addr._sockaddr, &ah_attr->grh.dgid);
+		rdma_gid2ip((struct sockaddr *)&sgid_addr, &sgid);
+		rdma_gid2ip((struct sockaddr *)&dgid_addr, &ah_attr->grh.dgid);
 		memcpy(&cmd->params.dgid[0],
 		       &dgid_addr._sockaddr_in.sin_addr.s_addr, 4);
 		memcpy(&cmd->params.sgid[0],


