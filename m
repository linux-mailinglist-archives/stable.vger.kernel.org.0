Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCEEB6DE9E
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731479AbfGSEFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731593AbfGSEFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:05:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CE98218BA;
        Fri, 19 Jul 2019 04:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509123;
        bh=NYkSxEIeir9aZN0kE1CzhBw5NrjJZv98gZeE7OX9fLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VujGr2NgVyJdza39W5CLi0AzcxRujfBQxOBYOHwjb0XuppGWKwDxF0AbtgNZSLtpd
         5fZa+RfMTSEarPX83wlGQi4lrp9vaimnfTpQlFEWfYGm1y0An/UWjqaDh3sYovNN5J
         gSHZncJcE/G/cUmuJWc9ilq2dwL/OYHwx7z72VNE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Liu, Changcheng" <changcheng.liu@intel.com>,
        Changcheng Liu <changcheng.liu@aliyun.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 082/141] RDMA/i40iw: Set queue pair state when being queried
Date:   Fri, 19 Jul 2019 00:01:47 -0400
Message-Id: <20190719040246.15945-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liu, Changcheng" <changcheng.liu@intel.com>

[ Upstream commit 2e67e775845373905d2c2aecb9062c2c4352a535 ]

The API for ib_query_qp requires the driver to set qp_state and
cur_qp_state on return, add the missing sets.

Fixes: d37498417947 ("i40iw: add files for iwarp interface")
Signed-off-by: Changcheng Liu <changcheng.liu@aliyun.com>
Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index a8352e3ca23d..f8cc0eacc221 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -773,6 +773,8 @@ static int i40iw_query_qp(struct ib_qp *ibqp,
 	struct i40iw_qp *iwqp = to_iwqp(ibqp);
 	struct i40iw_sc_qp *qp = &iwqp->sc_qp;
 
+	attr->qp_state = iwqp->ibqp_state;
+	attr->cur_qp_state = attr->qp_state;
 	attr->qp_access_flags = 0;
 	attr->cap.max_send_wr = qp->qp_uk.sq_size;
 	attr->cap.max_recv_wr = qp->qp_uk.rq_size;
-- 
2.20.1

