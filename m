Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7AF3106100
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbfKVFxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:53:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727664AbfKVFxR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:53:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E95E72084D;
        Fri, 22 Nov 2019 05:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401996;
        bh=fQn98bLhgm6bfWPbcu3qdZ9JqgF7NX3bu10YEr5k6fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zk14JjbbSgnW+M7qIrO0C2Uky8b0kUB6V7xbAmsgH82NMANtEaprhZ/68sDpcA/VV
         yoo/SlhjGKKulqyHB4fg6VB9W4PuQdzM44Y/ipyZmLBUjoXFKtDJwUKthXRIOGrbGz
         O3jPIpXI5ZwDFC93baT8bnF4LO5eAVlgcpemdXfg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 214/219] RDMA/hns: Use GFP_ATOMIC in hns_roce_v2_modify_qp
Date:   Fri, 22 Nov 2019 00:49:05 -0500
Message-Id: <20191122054911.1750-206-sashal@kernel.org>
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

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 4e69cf1fe2c52d189acdd06c1fd99cc258aba61f ]

The the below commit, hns_roce_v2_modify_qp is called inside spinlock
while using GFP_KERNEL. Change it to GFP_ATOMIC.

Fixes: 0425e3e6e0c7 ("RDMA/hns: Support flush cqe for hip08 in kernel space")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 9ab3ab3c4219f..2caa95ed966c5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3442,7 +3442,7 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 	struct device *dev = hr_dev->dev;
 	int ret = -EINVAL;
 
-	context = kcalloc(2, sizeof(*context), GFP_KERNEL);
+	context = kcalloc(2, sizeof(*context), GFP_ATOMIC);
 	if (!context)
 		return -ENOMEM;
 
-- 
2.20.1

