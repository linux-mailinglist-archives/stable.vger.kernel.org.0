Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747AC2470AB
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390506AbgHQSMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388404AbgHQQH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:07:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F5C52063A;
        Mon, 17 Aug 2020 16:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680430;
        bh=czLzkuigSE0yWbb7CWeu1dApXw6x2Ys57xFZ91ZAJVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zfSdrBrcEBKY7iC4tQqX5Z5b5qYCEC+UAxx+9CNlxq2M8YZn5Eq9WRUBpizcwKNPj
         WMuISpfL3022fGz+jGUzXml9q4FcQx6X8fj71cvBQpD+aNumULcgfbdDl/7Y3sPB5R
         8eVgp3KreTsIS+Y4aeCPcgkBhpm1tg+TMiK/aJnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markz@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/270] RDMA/netlink: Remove CAP_NET_RAW check when dump a raw QP
Date:   Mon, 17 Aug 2020 17:16:24 +0200
Message-Id: <20200817143804.925597303@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

[ Upstream commit 1d70ad0f85435a7262de802b104e49e6598c50ff ]

When dumping QPs bound to a counter, raw QPs should be allowed to dump
without the CAP_NET_RAW privilege. This is consistent with what "rdma res
show qp" does.

Fixes: c4ffee7c9bdb ("RDMA/netlink: Implement counter dumpit calback")
Link: https://lore.kernel.org/r/20200727095828.496195-1-leon@kernel.org
Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 244ebf285fc3f..e4905d9fecb05 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -702,9 +702,6 @@ static int fill_stat_counter_qps(struct sk_buff *msg,
 			continue;
 
 		qp = container_of(res, struct ib_qp, res);
-		if (qp->qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
-			continue;
-
 		if (!qp->counter || (qp->counter->id != counter->id))
 			continue;
 
-- 
2.25.1



