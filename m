Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6F437C66A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhELPvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236665AbhELPpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:45:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0F34619A7;
        Wed, 12 May 2021 15:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833004;
        bh=Wz1vQYGjMtqr2LWXbeUWRRYsqD4GG77I2JGVxe91OnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3E77AaDPhaAxQhhtNg8bFUoUq6ApTzh2BUmSGGYRcDh9mkV7g1mfHPvNIAwuzTyE
         RwXpA5YsZXekhZ21PYx4E3To191ZJW3Rj93mJKEVwsHwSCGBWnaQ2GPJos9sJOwEjg
         LFGDUDw5j31vHvn/zaNTDQ6tHpIBmhnQmE14U3gA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 509/530] RDMA/bnxt_re: Fix a double free in bnxt_qplib_alloc_res
Date:   Wed, 12 May 2021 16:50:19 +0200
Message-Id: <20210512144836.490247199@linuxfoundation.org>
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

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 34b39efa5ae82fc0ad0acc27653c12a56328dbbe ]

In bnxt_qplib_alloc_res, it calls bnxt_qplib_alloc_dpi_tbl().  Inside
bnxt_qplib_alloc_dpi_tbl, dpit->dbr_bar_reg_iomem is freed via
pci_iounmap() in unmap_io error branch. After the callee returns err code,
bnxt_qplib_alloc_res calls
bnxt_qplib_free_res()->bnxt_qplib_free_dpi_tbl() in the fail branch. Then
dpit->dbr_bar_reg_iomem is freed in the second time by pci_iounmap().

My patch set dpit->dbr_bar_reg_iomem to NULL after it is freed by
pci_iounmap() in the first time, to avoid the double free.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Link: https://lore.kernel.org/r/20210426140614.6722-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Acked-by: Devesh Sharma <devesh.sharma@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index fa7878336100..3ca47004b752 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -854,6 +854,7 @@ static int bnxt_qplib_alloc_dpi_tbl(struct bnxt_qplib_res     *res,
 
 unmap_io:
 	pci_iounmap(res->pdev, dpit->dbr_bar_reg_iomem);
+	dpit->dbr_bar_reg_iomem = NULL;
 	return -ENOMEM;
 }
 
-- 
2.30.2



