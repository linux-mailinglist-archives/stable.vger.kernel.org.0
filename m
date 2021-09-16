Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E47B40E61B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343542AbhIPRSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244033AbhIPRP6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:15:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA28161BA9;
        Thu, 16 Sep 2021 16:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810406;
        bh=2c564s1YOaZHirVIPzFibjwRVW4tqyevA+HN7Iu96gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4DgvKc30QFLGhK5PPeHLgDZuMirv0QunDGN6ZBW2RSYsN4Qj0dx9Yr2q/ny1/TYd
         Zz5nZOrfSry7uBroGmtRc0fyqOHEqBQ++lVdDZvozSfzC6+lTTQMC/evLW79w7ME+M
         k6o8zP4yDM5vT5BoxmvAIMp+z3mcqvdE3Sedkhaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <galpress@amazon.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 097/432] RDMA/efa: Remove double QP type assignment
Date:   Thu, 16 Sep 2021 17:57:26 +0200
Message-Id: <20210916155814.069583847@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit f9193d266347fe9bed5c173e7a1bf96268142a79 ]

The QP type is set by the IB/core and shouldn't be set in the driver.

Fixes: 40909f664d27 ("RDMA/efa: Add EFA verbs implementation")
Link: https://lore.kernel.org/r/838c40134c1590167b888ca06ad51071139ff2ae.1627040189.git.leonro@nvidia.com
Acked-by: Gal Pressman <galpress@amazon.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_verbs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index be6d3ff0f1be..29c9df9f25aa 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -717,7 +717,6 @@ struct ib_qp *efa_create_qp(struct ib_pd *ibpd,
 
 	qp->qp_handle = create_qp_resp.qp_handle;
 	qp->ibqp.qp_num = create_qp_resp.qp_num;
-	qp->ibqp.qp_type = init_attr->qp_type;
 	qp->max_send_wr = init_attr->cap.max_send_wr;
 	qp->max_recv_wr = init_attr->cap.max_recv_wr;
 	qp->max_send_sge = init_attr->cap.max_send_sge;
-- 
2.30.2



