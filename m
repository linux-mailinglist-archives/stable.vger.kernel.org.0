Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C36611AF32
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730947AbfLKPLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:11:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730973AbfLKPLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E06EC24656;
        Wed, 11 Dec 2019 15:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077103;
        bh=Fhbul9K/HMLRSX3c55X5Ifo4uMXJN3nyNeySuYAWwxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZEKJZXftrDHcEcDUUeIE5OVD+dxS41OYH4z+AxaMnGDsX0rYpVP3GE6iu+KFX6JG
         mqVy3ZQw57ZLdZBT5fNflWhCmr/cb7+TJf5jX7ySizyR+K6R1tTIJRTFK0OJHVaeQS
         X01AaTdY37Th8j8fp/CKm2vDxYCp+UsmMV9NO3SE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 018/105] RDMA/hns: Correct the value of srq_desc_size
Date:   Wed, 11 Dec 2019 16:05:07 +0100
Message-Id: <20191211150225.287486982@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit 411c1e6774e2e1f96b1ccce4f119376b94ade3e4 ]

srq_desc_size should be rounded up to pow of two before used, or related
calculation may cause allocating wrong size of memory for srq buffer.

Fixes: c7bcb13442e1 ("RDMA/hns: Add SRQ support for hip08 kernel mode")
Link: https://lore.kernel.org/r/1572575610-52530-3-git-send-email-liweihang@hisilicon.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_srq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 38bb548eaa6d8..9768e377cd22c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -221,7 +221,7 @@ int hns_roce_create_srq(struct ib_srq *ib_srq,
 	srq->max = roundup_pow_of_two(srq_init_attr->attr.max_wr + 1);
 	srq->max_gs = srq_init_attr->attr.max_sge;
 
-	srq_desc_size = max(16, 16 * srq->max_gs);
+	srq_desc_size = roundup_pow_of_two(max(16, 16 * srq->max_gs));
 
 	srq->wqe_shift = ilog2(srq_desc_size);
 
-- 
2.20.1



