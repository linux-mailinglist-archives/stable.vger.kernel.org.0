Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060C58698D
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404491AbfHHTIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404924AbfHHTIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D7532173E;
        Thu,  8 Aug 2019 19:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291310;
        bh=1v3C4Er5CSvndpqfC+4XC6Cn6pCNievAd8A4fILvc/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQYBq8BrT2n1hSYLGLQq7WbCwHD4skAtvJ3OSbF+LJ3inEWeqauWlINC1o0zQqDfr
         RS75wpjaKlkinRm44eHXkaINL2CaFk9+BNqyUiai/oaABGYYwFwj/GuOBHpYPw9UCb
         teDoE0p2LnqaCgU17cDZurF4ZpUoCqYSzQ13wMKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.19 11/45] [PATCH] IB: directly cast the sockaddr union to aockaddr
Date:   Thu,  8 Aug 2019 21:04:57 +0200
Message-Id: <20190808190454.404366737@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Like commit 641114d2af31 ("RDMA: Directly cast the sockaddr union to
sockaddr") we need to quiet gcc 9 from warning about this crazy union.
That commit did not fix all of the warnings in 4.19 and older kernels
because the logic in roce_resolve_route_from_path() was rewritten
between 4.19 and 5.2 when that change happened.

Cc: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/sa_query.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1232,7 +1232,6 @@ static int roce_resolve_route_from_path(
 {
 	struct rdma_dev_addr dev_addr = {};
 	union {
-		struct sockaddr     _sockaddr;
 		struct sockaddr_in  _sockaddr_in;
 		struct sockaddr_in6 _sockaddr_in6;
 	} sgid_addr, dgid_addr;
@@ -1249,12 +1248,12 @@ static int roce_resolve_route_from_path(
 	 */
 	dev_addr.net = &init_net;
 
-	rdma_gid2ip(&sgid_addr._sockaddr, &rec->sgid);
-	rdma_gid2ip(&dgid_addr._sockaddr, &rec->dgid);
+	rdma_gid2ip((struct sockaddr *)&sgid_addr, &rec->sgid);
+	rdma_gid2ip((struct sockaddr *)&dgid_addr, &rec->dgid);
 
 	/* validate the route */
-	ret = rdma_resolve_ip_route(&sgid_addr._sockaddr,
-				    &dgid_addr._sockaddr, &dev_addr);
+	ret = rdma_resolve_ip_route((struct sockaddr *)&sgid_addr,
+				    (struct sockaddr *)&dgid_addr, &dev_addr);
 	if (ret)
 		return ret;
 


