Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED3C3C53A2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348269AbhGLHza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350554AbhGLHvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45EC561A46;
        Mon, 12 Jul 2021 07:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075973;
        bh=Ci28GTuQaGNWOQyEUaKdjuh/8/brGs9MOauW9RUo9B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTM7+iTVHv6PNC9YG1pDXfllSLnkJ54yfzc5pK/6kI8AKOVXhqBeTYe9WuYme8LiE
         +avZDEYt5bs/WCWEFQj/2PYPcQ0b7FP5qffmDG2//6K1M6+9EeH9QYiWNb55s/2mQ8
         pOlYO8MtvoNwJPlg9e5FgNSg1FiGWeHhFInNWvqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xi Wang <wangxi11@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 427/800] RDMA/hns: Fix wrong timer context buffer page size
Date:   Mon, 12 Jul 2021 08:07:30 +0200
Message-Id: <20210712061012.550086354@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xi Wang <wangxi11@huawei.com>

[ Upstream commit 5e6370d7cc75134b0eb5b15916aab40b628db9e1 ]

The HEM page size for QPC timer and CQC timer is always 4K and there's no
need to calculate a different size by the hns driver, otherwise the ROCEE
may access an invalid address.

Fixes: 719d13415f59 ("RDMA/hns: Remove duplicated hem page size config code")
Link: https://lore.kernel.org/r/1621589395-2435-4-git-send-email-liweihang@huawei.com
Signed-off-by: Xi Wang <wangxi11@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 49bb4f51466c..d7289b6587f1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2092,12 +2092,6 @@ static void set_hem_page_size(struct hns_roce_dev *hr_dev)
 	calc_pg_sz(caps->max_cqes, caps->cqe_sz, caps->cqe_hop_num,
 		   1, &caps->cqe_buf_pg_sz, &caps->cqe_ba_pg_sz, HEM_TYPE_CQE);
 
-	if (caps->cqc_timer_entry_sz)
-		calc_pg_sz(caps->num_cqc_timer, caps->cqc_timer_entry_sz,
-			   caps->cqc_timer_hop_num, caps->cqc_timer_bt_num,
-			   &caps->cqc_timer_buf_pg_sz,
-			   &caps->cqc_timer_ba_pg_sz, HEM_TYPE_CQC_TIMER);
-
 	/* SRQ */
 	if (caps->flags & HNS_ROCE_CAP_FLAG_SRQ) {
 		calc_pg_sz(caps->num_srqs, caps->srqc_entry_sz,
-- 
2.30.2



