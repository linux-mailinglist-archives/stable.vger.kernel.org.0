Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0C434C659
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhC2IGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231924AbhC2IGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:06:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AF0961990;
        Mon, 29 Mar 2021 08:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005161;
        bh=gltyxeeSlIhsEvei6S2jaqXd8nHCdzZDieIF/uUj3Iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMo9MPmS8CKd4zr/bGBQ0p0gMcyIUuFrYKLdYCbFzg1rOCWYvvCOhoG/pgQfPj6FN
         G3Dv2SYvfd8WT9Ik6pJVmTBm55xFRpEHMwg8chf3VGUjsmFhJKmc+GjHz6bsRBlDqR
         W7ftgp1NLb9EyJR3dpaKKZlkG9qoCzYgEvWVYtaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 47/59] RDMA/cxgb4: Fix adapter LE hash errors while destroying ipv6 listening server
Date:   Mon, 29 Mar 2021 09:58:27 +0200
Message-Id: <20210329075610.428976861@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Potnuri Bharat Teja <bharat@chelsio.com>

[ Upstream commit 3408be145a5d6418ff955fe5badde652be90e700 ]

Not setting the ipv6 bit while destroying ipv6 listening servers may
result in potential fatal adapter errors due to lookup engine memory hash
errors. Therefore always set ipv6 field while destroying ipv6 listening
servers.

Fixes: 830662f6f032 ("RDMA/cxgb4: Add support for active and passive open connection with IPv6 address")
Link: https://lore.kernel.org/r/20210324190453.8171-1-bharat@chelsio.com
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 5aa545f9a423..72e2031993fb 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3492,13 +3492,13 @@ int c4iw_destroy_listen(struct iw_cm_id *cm_id)
 	    ep->com.local_addr.ss_family == AF_INET) {
 		err = cxgb4_remove_server_filter(
 			ep->com.dev->rdev.lldi.ports[0], ep->stid,
-			ep->com.dev->rdev.lldi.rxq_ids[0], 0);
+			ep->com.dev->rdev.lldi.rxq_ids[0], false);
 	} else {
 		struct sockaddr_in6 *sin6;
 		c4iw_init_wr_wait(&ep->com.wr_wait);
 		err = cxgb4_remove_server(
 				ep->com.dev->rdev.lldi.ports[0], ep->stid,
-				ep->com.dev->rdev.lldi.rxq_ids[0], 0);
+				ep->com.dev->rdev.lldi.rxq_ids[0], true);
 		if (err)
 			goto done;
 		err = c4iw_wait_for_reply(&ep->com.dev->rdev, &ep->com.wr_wait,
-- 
2.30.1



