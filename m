Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 916EC13E14C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgAPQsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:48:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729159AbgAPQsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:48:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54940207FF;
        Thu, 16 Jan 2020 16:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193325;
        bh=ycRmT9sRbS81XuZirTeHL/gVTGCSjJ5DRDrn/KZa9sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNZCZfxz1frs5JvzZ/0zuc7u56SyE4chpxiTEPK44I2HGDO9K7jqR3VRE/qh0Zsav
         kLmmEdPwDB0nTY2kbhrcrNyAjPrw5HrekAyt51ClrCUTCTFVuxCqZgOUHdvq/zGNtN
         uRz4O1eyqhi927BaGbIcD8OF50aOFlnnnSNzyBmY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijun Ou <oulijun@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 075/205] RDMA/hns: Fix to support 64K page for srq
Date:   Thu, 16 Jan 2020 11:40:50 -0500
Message-Id: <20200116164300.6705-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 5c7e76fb7cb5071be800c938ebf2c475e140d3f0 ]

SRQ's page size configuration of BA and buffer should depend on current
PAGE_SHIFT, or it can't work in scenario of 64K page.

Fixes: c7bcb13442e1 ("RDMA/hns: Add SRQ support for hip08 kernel mode")
Link: https://lore.kernel.org/r/1571908917-16220-2-git-send-email-liweihang@hisilicon.com
Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 926cb97483f9..1e1609addccf 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6088,11 +6088,11 @@ static void hns_roce_v2_write_srqc(struct hns_roce_dev *hr_dev,
 	roce_set_field(srq_context->byte_44_idxbufpgsz_addr,
 		       SRQC_BYTE_44_SRQ_IDX_BA_PG_SZ_M,
 		       SRQC_BYTE_44_SRQ_IDX_BA_PG_SZ_S,
-		       hr_dev->caps.idx_ba_pg_sz);
+		       hr_dev->caps.idx_ba_pg_sz + PG_SHIFT_OFFSET);
 	roce_set_field(srq_context->byte_44_idxbufpgsz_addr,
 		       SRQC_BYTE_44_SRQ_IDX_BUF_PG_SZ_M,
 		       SRQC_BYTE_44_SRQ_IDX_BUF_PG_SZ_S,
-		       hr_dev->caps.idx_buf_pg_sz);
+		       hr_dev->caps.idx_buf_pg_sz + PG_SHIFT_OFFSET);
 
 	srq_context->idx_nxt_blk_addr =
 		cpu_to_le32(mtts_idx[1] >> PAGE_ADDR_SHIFT);
-- 
2.20.1

