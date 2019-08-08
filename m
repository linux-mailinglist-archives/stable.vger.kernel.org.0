Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBE1869F5
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405469AbfHHTLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405466AbfHHTLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:11:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84D4921743;
        Thu,  8 Aug 2019 19:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291481;
        bh=LS87dti7zdc7kX7Pyq3fOGJGubx/ROvQrnb62CiV/2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wz8QxP82wpXmuDWkBEzaxRj8iVa+ikqDIuXjBXl0TfrS2vS/5ndhq24QLg081VGNO
         +POtwsSXinM8p1QcsrVpNKy4Fir8YZOQp7Mf4iOlGOf0me9YPui6deh7DduguLdutw
         UetD3t9AMG6Gw1lzH4COBGXeuRAG2oMCTK1SvlmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.14 09/33] [PATCH] IB: directly cast the sockaddr union to aockaddr
Date:   Thu,  8 Aug 2019 21:05:16 +0200
Message-Id: <20190808190454.035338318@linuxfoundation.org>
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

Like commit 641114d2af31 ("RDMA: Directly cast the sockaddr union to
sockaddr") we need to quiet gcc 9 from warning about this crazy union.
That commit did not fix all of the warnings in 4.19 and older kernels
because the logic in roce_resolve_route_from_path() was rewritten
between 4.19 and 5.2 when that change happened.

Cc: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/sa_query.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1263,7 +1263,6 @@ int ib_init_ah_from_path(struct ib_devic
 				&init_net
 		};
 		union {
-			struct sockaddr     _sockaddr;
 			struct sockaddr_in  _sockaddr_in;
 			struct sockaddr_in6 _sockaddr_in6;
 		} sgid_addr, dgid_addr;
@@ -1271,12 +1270,13 @@ int ib_init_ah_from_path(struct ib_devic
 		if (!device->get_netdev)
 			return -EOPNOTSUPP;
 
-		rdma_gid2ip(&sgid_addr._sockaddr, &rec->sgid);
-		rdma_gid2ip(&dgid_addr._sockaddr, &rec->dgid);
+		rdma_gid2ip((struct sockaddr *)&sgid_addr, &rec->sgid);
+		rdma_gid2ip((struct sockaddr *)&dgid_addr, &rec->dgid);
 
 		/* validate the route */
-		ret = rdma_resolve_ip_route(&sgid_addr._sockaddr,
-					    &dgid_addr._sockaddr, &dev_addr);
+		ret = rdma_resolve_ip_route((struct sockaddr *)&sgid_addr,
+					    (struct sockaddr *)&dgid_addr,
+					    &dev_addr);
 		if (ret)
 			return ret;
 


