Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F70237C5BB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbhELPmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236408AbhELPhw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:37:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6290F61991;
        Wed, 12 May 2021 15:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832780;
        bh=quYTqScXBKdkK2nY62PQh4Yv5vVqF+oswUkrvv22/r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1B1puvBaxzh5mFuvYENuix0HEryjB19sMIs2XPVs3bWvwbNrm+7/XO7EEAZM2gdI
         ThSoYSIvpXc1mWD3MuBfegCI/z9JdNvJWDxlaWxxwklN2Q9X/u687+PAncJJqiwFWX
         nL/FV9/2uPwaQ4I5kfBKb9vhNL6vxX9Ya+rVxTFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Wensheng <wangwensheng4@huawei.com>,
        =?UTF-8?q?Michal=20Kalderon=C2=A0?= <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 421/530] RDMA/qedr: Fix error return code in qedr_iw_connect()
Date:   Wed, 12 May 2021 16:48:51 +0200
Message-Id: <20210512144833.606749748@linuxfoundation.org>
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

[ Upstream commit 10dd83dbcd157baf7a78a09ddb2f84c627bc7f1d ]

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Fixes: 82af6d19d8d9 ("RDMA/qedr: Fix synchronization methods and memory leaks in qedr")
Link: https://lore.kernel.org/r/20210408113135.92165-1-wangwensheng4@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/qedr_iw_cm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
index c4bc58736e48..1715fbe0719d 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -636,8 +636,10 @@ int qedr_iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	memcpy(in_params.local_mac_addr, dev->ndev->dev_addr, ETH_ALEN);
 
 	if (test_and_set_bit(QEDR_IWARP_CM_WAIT_FOR_CONNECT,
-			     &qp->iwarp_cm_flags))
+			     &qp->iwarp_cm_flags)) {
+		rc = -ENODEV;
 		goto err; /* QP already being destroyed */
+	}
 
 	rc = dev->ops->iwarp_connect(dev->rdma_ctx, &in_params, &out_params);
 	if (rc) {
-- 
2.30.2



