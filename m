Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433AE37C5BD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhELPmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:42:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236446AbhELPh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:37:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0FCE61998;
        Wed, 12 May 2021 15:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832788;
        bh=6BKg3WyU3FvHuei4CU0LAZrPY7WWOUaPTzCUmbBQKeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcIy7b//jD5pdiu7fOztA0/2OUAwxsV/NDptJjSAZisfZ1IznS74OgFASaR4/Iw8P
         gPnhSxwwjZC4mQPvUo4Mqg6SW/8pVj/E2Fd9PmQRIzNVLtP1viqH2GyOOw9pMoeZxo
         XZHNNzzEOhSXHF4EpaKNgGH2DukbnsKmLoq7vdrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Wensheng <wangwensheng4@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 423/530] RDMA/bnxt_re: Fix error return code in bnxt_qplib_cq_process_terminal()
Date:   Wed, 12 May 2021 16:48:53 +0200
Message-Id: <20210512144833.675720068@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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



