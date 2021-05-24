Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69C138EF7A
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhEXP56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234392AbhEXP4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:56:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6DA261446;
        Mon, 24 May 2021 15:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870992;
        bh=+eUnc1haDTfcnX2Q572vSfKjYuhHi08mfvKabmkoIWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w9KRPPpOzpP6iUHK9u0qpKb14uPKYSIfHvNMiTn792sIMM2O1sj+uCocgERAMfK1e
         1rAImrkehwgERUbh8piG/2PTTGrX6zTZUaS0RxUqBb/6UW0lM5XPWxDIMPIIXk/4Qi
         SXeolBnDM1ZAS6eIYp3941aWMtp452SVHLTcVnzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 006/127] RDMA/siw: Release xarray entry
Date:   Mon, 24 May 2021 17:25:23 +0200
Message-Id: <20210524152335.069576086@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit a3d83276d98886879b5bf7b30b7c29882754e4df ]

The xarray entry is allocated in siw_qp_add(), but release was
missed in case zero-sized SQ was discovered.

Fixes: 661f385961f0 ("RDMA/siw: Fix handling of zero-sized Read and Receive Queues.")
Link: https://lore.kernel.org/r/f070b59d5a1114d5a4e830346755c2b3f141cde5.1620560472.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index d1859c56a6db..8a00c06e5f56 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -375,7 +375,7 @@ struct ib_qp *siw_create_qp(struct ib_pd *pd,
 	else {
 		/* Zero sized SQ is not supported */
 		rv = -EINVAL;
-		goto err_out;
+		goto err_out_xa;
 	}
 	if (num_rqe)
 		num_rqe = roundup_pow_of_two(num_rqe);
-- 
2.30.2



