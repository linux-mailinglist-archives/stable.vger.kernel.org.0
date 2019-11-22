Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AADA41060FB
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfKVFxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:53:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728818AbfKVFxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:53:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDEB220855;
        Fri, 22 Nov 2019 05:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401995;
        bh=vcbbtx5fa7hoC405k+4mun5v2mhS5aagt5+8weXXYMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOuvu0jeE5lq6VwHMnnXCG0SY51Z6Z1Vnytt53aFqSgPqIAlqw0r+P0JxMllVK1JV
         xkPlQzUeIOzeTadFao+YElWk7gVGZcAUKcQ9gdO3d3F9WvSITb0R/gxVQjuv1zrn51
         K8nD5pSaFeN344uXdgxl3foLpruruAGB43PbMw1w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yixian Liu <liuyixian@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 213/219] RDMA/hns: Fix the state of rereg mr
Date:   Fri, 22 Nov 2019 00:49:04 -0500
Message-Id: <20191122054911.1750-205-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yixian Liu <liuyixian@huawei.com>

[ Upstream commit ab22bf05216a6bb4812448f3a8609489047cf311 ]

The state of mr after reregister operation should be set to valid
state. Otherwise, it will keep the same as the state before reregistered.

Signed-off-by: Yixian Liu <liuyixian@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 587db5cf3be15..9ab3ab3c4219f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1773,6 +1773,9 @@ static int hns_roce_v2_rereg_write_mtpt(struct hns_roce_dev *hr_dev,
 	struct hns_roce_v2_mpt_entry *mpt_entry = mb_buf;
 	int ret = 0;
 
+	roce_set_field(mpt_entry->byte_4_pd_hop_st, V2_MPT_BYTE_4_MPT_ST_M,
+		       V2_MPT_BYTE_4_MPT_ST_S, V2_MPT_ST_VALID);
+
 	if (flags & IB_MR_REREG_PD) {
 		roce_set_field(mpt_entry->byte_4_pd_hop_st, V2_MPT_BYTE_4_PD_M,
 			       V2_MPT_BYTE_4_PD_S, pdn);
-- 
2.20.1

