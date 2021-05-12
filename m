Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D7937CE50
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239444AbhELRE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244306AbhELQmx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7138D61D4A;
        Wed, 12 May 2021 16:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835949;
        bh=6BKg3WyU3FvHuei4CU0LAZrPY7WWOUaPTzCUmbBQKeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/LTrTGFjtpDwEI3GUG4r+ht2eUrFmSfX/uquBMcZmFI4Tz5IgnTLhvr8PKsyBhRu
         7NxdTN45mOVPJUviTLrdzgAJheL/03OczzuQpQYfyL71u9W6a+yJScWE2+pWlCdvZr
         76yrr+K8uu4vZxYujU4TiNhev5Gj1h2LG1YfCQpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Wensheng <wangwensheng4@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 549/677] RDMA/bnxt_re: Fix error return code in bnxt_qplib_cq_process_terminal()
Date:   Wed, 12 May 2021 16:49:55 +0200
Message-Id: <20210512144855.626323979@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Wensheng <wangwensheng4@huawei.com>

[ Upstream commit 22efb0a8d130c6379c1eb64cbace1542b27e37ff ]

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Link: https://lore.kernel.org/r/20210408113137.97202-1-wangwensheng4@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 995d4633b0a1..d4d4959c2434 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -2784,6 +2784,7 @@ do_rq:
 		dev_err(&cq->hwq.pdev->dev,
 			"FP: CQ Processed terminal reported rq_cons_idx 0x%x exceeds max 0x%x\n",
 			cqe_cons, rq->max_wqe);
+		rc = -EINVAL;
 		goto done;
 	}
 
-- 
2.30.2



