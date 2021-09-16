Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8962540DF5E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhIPQJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:09:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233417AbhIPQH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:07:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B20D260F5B;
        Thu, 16 Sep 2021 16:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808397;
        bh=kwXb65ngb3Yluy6mC2lK115LE0OqELi2xKnKY6rV1ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuFN3lcSDMS79oJY+b+IhUYBY+P1GYp7MNYjMQyHLKCuzlfFWhfJZdkcvfKV/OCjN
         SwUwtVE+iWl+PcWTPo88hpugoQrXlz47fumLc4mH2K3fQ2cFjbnxiG5xORLranv7J7
         zi9GD7exAk/OEzPcYLx07z9V61Tip6SlNMxmw2fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <galpress@amazon.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/306] RDMA/efa: Remove double QP type assignment
Date:   Thu, 16 Sep 2021 17:56:54 +0200
Message-Id: <20210916155756.407874071@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index 4e940fc50bba..2ece682c7835 100644
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



