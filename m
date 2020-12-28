Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9667C2E38AE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732239AbgL1NN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:13:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732234AbgL1NN0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:13:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3035207C9;
        Mon, 28 Dec 2020 13:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161166;
        bh=E1GYUYAbH9ykkfF4Oarmxgi3hbfAtM29mibHRjVhMaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8wI/xnHGX2q2fGTmq+N5sVy2AvFPdyPOqeRakrCINalrd0O5nnl7jP+yJB/8nsoI
         ZWF2mDo1IzZCfg62YibVVH0J3RRYwdG0kJoNH+ffXQQUdJQW0OEDuwAILvahAfPxRF
         5uGRvwpbvhDHZBEB0i0orfaF8hR6EYZaqy7Jxp3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 106/242] RDMA/cxgb4: Validate the number of CQEs
Date:   Mon, 28 Dec 2020 13:48:31 +0100
Message-Id: <20201228124909.913851885@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit 6d8285e604e0221b67bd5db736921b7ddce37d00 ]

Before create CQ, make sure that the requested number of CQEs is in the
supported range.

Fixes: cfdda9d76436 ("RDMA/cxgb4: Add driver for Chelsio T4 RNIC")
Link: https://lore.kernel.org/r/20201108132007.67537-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/cxgb4/cq.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -906,6 +906,9 @@ struct ib_cq *c4iw_create_cq(struct ib_d
 
 	rhp = to_c4iw_dev(ibdev);
 
+	if (entries < 1 || entries > ibdev->attrs.max_cqe)
+		return ERR_PTR(-EINVAL);
+
 	if (vector >= rhp->rdev.lldi.nciq)
 		return ERR_PTR(-EINVAL);
 


