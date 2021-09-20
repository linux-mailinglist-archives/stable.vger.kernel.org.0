Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC23412172
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350512AbhITSF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350383AbhITSC7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:02:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73F7661A80;
        Mon, 20 Sep 2021 17:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158199;
        bh=f9lH3nbC6oI0i8vHl2wYdC504QITxI+t9PGjBYQH678=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSJdNoAIKTTX5dH8S+BAlcvSoOwOAAYUjFlOwtyo6SCmS6iHyeZyFTr7oqC0FHgz7
         7OInk7+c3s8dCO+ElrEcJ7dQXaSrON/4t2vrQM+aPdzN8jXK9ZGLqt4lHprrcCyumM
         V4K6jgiLbUm8zQ3gl7GYpLvDCWo7y8aeqWcWFY8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <galpress@amazon.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/260] RDMA/efa: Remove double QP type assignment
Date:   Mon, 20 Sep 2021 18:41:03 +0200
Message-Id: <20210920163932.645313525@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index 4edae89e8e3c..17f1e59ab12e 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -745,7 +745,6 @@ struct ib_qp *efa_create_qp(struct ib_pd *ibpd,
 	rq_entry_inserted = true;
 	qp->qp_handle = create_qp_resp.qp_handle;
 	qp->ibqp.qp_num = create_qp_resp.qp_num;
-	qp->ibqp.qp_type = init_attr->qp_type;
 	qp->max_send_wr = init_attr->cap.max_send_wr;
 	qp->max_recv_wr = init_attr->cap.max_recv_wr;
 	qp->max_send_sge = init_attr->cap.max_send_sge;
-- 
2.30.2



