Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C2737CDC7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343732AbhELQ6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244210AbhELQmm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF8A561C73;
        Wed, 12 May 2021 16:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835905;
        bh=F2Xbx4ZbDCbVce8wwywteEk5TPUIk/G3oAtbYB1YHAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otLpmZnFq273eXUkKuPC7g5Tsw/VDoYcEG0iK/291DOhjgC+3GUlclOM0m9MljawF
         uBKHzSQjFyC8kS8BqSXLqBY3RGW7lSyEq95UTH1OHF9OjZ0i35JQvhhH/rUjpWB4ci
         Ghoc5m/GbE14AfeikYnXSmEzlyPVtf1tqqCpyEwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 486/677] RDMA/core: Fix corrupted SL on passive side
Date:   Wed, 12 May 2021 16:48:52 +0200
Message-Id: <20210512144853.525636321@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit 194f64a3cad3ab9e381e996a13089de3215d1887 ]

On RoCE systems, a CM REQ contains a Primary Hop Limit > 1 and Primary
Subnet Local is zero.

In cm_req_handler(), the cm_process_routed_req() function is called. Since
the Primary Subnet Local value is zero in the request, and since this is
RoCE (Primary Local LID is permissive), the following statement will be
executed:

      IBA_SET(CM_REQ_PRIMARY_SL, req_msg, wc->sl);

This corrupts SL in req_msg if it was different from zero. In other words,
a request to setup a connection using an SL != zero, will not be honored,
and a connection using SL zero will be created instead.

Fixed by not calling cm_process_routed_req() on RoCE systems, the
cm_process_route_req() is only for IB anyhow.

Fixes: 3971c9f6dbf2 ("IB/cm: Add interim support for routed paths")
Link: https://lore.kernel.org/r/1616420132-31005-1-git-send-email-haakon.bugge@oracle.com
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 3d194bb60840..6adbaea358ae 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -2138,7 +2138,8 @@ static int cm_req_handler(struct cm_work *work)
 		goto destroy;
 	}
 
-	cm_process_routed_req(req_msg, work->mad_recv_wc->wc);
+	if (cm_id_priv->av.ah_attr.type != RDMA_AH_ATTR_TYPE_ROCE)
+		cm_process_routed_req(req_msg, work->mad_recv_wc->wc);
 
 	memset(&work->path[0], 0, sizeof(work->path[0]));
 	if (cm_req_has_alt_path(req_msg))
-- 
2.30.2



