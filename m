Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DC229BC5A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802533AbgJ0Pt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801319AbgJ0Pjs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:39:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC04122283;
        Tue, 27 Oct 2020 15:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813186;
        bh=Y36RkweFJ4q8GKMDFEBjLwQz1r5HdSwplcRlWjclvwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hR8JygSkQGgk9tduB6rIXmSXA4Sl2/48pSPmKaBrk64S8b2/NFaI+a88vSTWrn8Va
         EGNFhdgLBHLtDiQJcUyuMDd2dLSmdpqu501sAdgNHYgrL6Adkv7yXcds6IUhsAuwKh
         cpZunPDKbdYWKPMwQMTgAmHn6Ti5M/mc5JJ1Gv8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaran Zhang <zhangjiaran@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 466/757] RDMA/hns: Solve the overflow of the calc_pg_sz()
Date:   Tue, 27 Oct 2020 14:51:56 +0100
Message-Id: <20201027135512.379823885@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

[ Upstream commit 768202a0825d447de785e87ff1ea1d3c86a71727 ]

calc_pg_sz() may gets a data calculation overflow if the PAGE_SIZE is 64 KB
and hop_num is 2. It is because that all variables involved in calculation
are defined in type of int. So change the type of bt_chunk_size,
buf_chunk_size and obj_per_chunk_default to u64.

Fixes: ba6bb7e97421 ("RDMA/hns: Add interfaces to get pf capabilities from firmware")
Link: https://lore.kernel.org/r/1600509802-44382-6-git-send-email-liweihang@huawei.com
Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 59087d5811ba3..547f8c7dcf561 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1770,9 +1770,9 @@ static void calc_pg_sz(int obj_num, int obj_size, int hop_num, int ctx_bt_num,
 		       int *buf_page_size, int *bt_page_size, u32 hem_type)
 {
 	u64 obj_per_chunk;
-	int bt_chunk_size = 1 << PAGE_SHIFT;
-	int buf_chunk_size = 1 << PAGE_SHIFT;
-	int obj_per_chunk_default = buf_chunk_size / obj_size;
+	u64 bt_chunk_size = PAGE_SIZE;
+	u64 buf_chunk_size = PAGE_SIZE;
+	u64 obj_per_chunk_default = buf_chunk_size / obj_size;
 
 	*buf_page_size = 0;
 	*bt_page_size = 0;
-- 
2.25.1



