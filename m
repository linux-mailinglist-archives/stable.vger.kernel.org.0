Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507DD26B4F3
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgIOXem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:34:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbgIOOgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:36:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2C27222E7;
        Tue, 15 Sep 2020 14:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179977;
        bh=aVCQPC1uDildNSTSS9c0m5IXtC8LNq6LKlT83+/al3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0OWQ2k+zEAlLK1tk8LZDN/PLPOWfc6leYxlTc1qmxvoSPPbINjvZ0JgEM26rS3WIh
         Q3Cc5K/YT8rd8ENN8AnHV0NcKZjSzEgBk3uwQxm1uOZPStxjHavDbD1X1CCy5gHgm6
         0JKb+wpmq/ZMtoojb2mDExWry997PcmOeO3ZPRFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xi Wang <wangxi11@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 030/177] RDMA/core: Fix unsafe linked list traversal after failing to allocate CQ
Date:   Tue, 15 Sep 2020 16:11:41 +0200
Message-Id: <20200915140655.083201980@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xi Wang <wangxi11@huawei.com>

[ Upstream commit 8aa64be019567c4f90d45c5082a4b6f22e182d00 ]

It's not safe to access the next CQ in list_for_each_entry() after
invoking ib_free_cq(), because the CQ has already been freed in current
iteration.  It should be replaced by list_for_each_entry_safe().

Fixes: c7ff819aefea ("RDMA/core: Introduce shared CQ pool API")
Link: https://lore.kernel.org/r/1598963935-32335-1-git-send-email-liweihang@huawei.com
Signed-off-by: Xi Wang <wangxi11@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index 513825e424bff..a92fc3f90bb5b 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -379,7 +379,7 @@ static int ib_alloc_cqs(struct ib_device *dev, unsigned int nr_cqes,
 {
 	LIST_HEAD(tmp_list);
 	unsigned int nr_cqs, i;
-	struct ib_cq *cq;
+	struct ib_cq *cq, *n;
 	int ret;
 
 	if (poll_ctx > IB_POLL_LAST_POOL_TYPE) {
@@ -412,7 +412,7 @@ static int ib_alloc_cqs(struct ib_device *dev, unsigned int nr_cqes,
 	return 0;
 
 out_free_cqs:
-	list_for_each_entry(cq, &tmp_list, pool_entry) {
+	list_for_each_entry_safe(cq, n, &tmp_list, pool_entry) {
 		cq->shared = false;
 		ib_free_cq(cq);
 	}
-- 
2.25.1



