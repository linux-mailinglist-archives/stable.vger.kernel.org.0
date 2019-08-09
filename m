Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB1E87BD8
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407279AbfHINrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436628AbfHINrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:47:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CE4C21783;
        Fri,  9 Aug 2019 13:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358466;
        bh=VpUaPtBQSyxfzF0SQEcUpF4jUmm349/aEi0TrQXcHvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROY1N4NhcbIf2YXVpqWBz5yde7snrRzEvL0UvfBjJQkfr7fxMbXzk0L8+eIYfL5ig
         14TxBn0/LrGBg/mH8rcebjjcYOfcOqxmNJGr9MVytT+hWpIB+aH05p+UAUHtX6IEPi
         NHLNKgSC/5GBwTv0VcUM3WC85x9tIX0wsEJgcM3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.9 11/32] [PATCH] IB: directly cast the sockaddr union to aockaddr
Date:   Fri,  9 Aug 2019 15:45:14 +0200
Message-Id: <20190809133923.318510362@linuxfoundation.org>
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
@@ -1109,7 +1109,6 @@ int ib_init_ah_from_path(struct ib_devic
 						 .net = rec->net ? rec->net :
 							 &init_net};
 		union {
-			struct sockaddr     _sockaddr;
 			struct sockaddr_in  _sockaddr_in;
 			struct sockaddr_in6 _sockaddr_in6;
 		} sgid_addr, dgid_addr;
@@ -1117,12 +1116,13 @@ int ib_init_ah_from_path(struct ib_devic
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
 


