Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95CE40E253
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244448AbhIPQhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243690AbhIPQeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:34:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D51996187C;
        Thu, 16 Sep 2021 16:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809252;
        bh=GFivrLNfYikRkIGU0RCP5Susx/2uB0bCQUn10YbB0cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUWgZAAh2qtQqHTkgZUZY788E+CYp7xquxzwqENSrrk0Ft+ZlfxueWT7jtAsyHKwm
         lEE8Ef8L6UYo6KpNg0aF69pLQyBijSFYclKr+TkEtjyj/rJyhr8yPWmj4xaoWTIT16
         Y93rkepiitHg79sl0gpvFtAuqqIFl0q5UJLMQ8Pc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <galpress@amazon.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 087/380] RDMA/efa: Remove double QP type assignment
Date:   Thu, 16 Sep 2021 17:57:24 +0200
Message-Id: <20210916155807.006270517@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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
index 51572f1dc611..72621ecd81f7 100644
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



