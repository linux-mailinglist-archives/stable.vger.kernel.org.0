Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6521B38A48C
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbhETKGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235217AbhETKDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:03:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F43061423;
        Thu, 20 May 2021 09:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503606;
        bh=D513QAe6+ds8yHQQ538gonVJ6YmkA0l+bGeNrXMecJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVb9+J0B+F7pmlJWAYy+zW1p/v4ThdL+xLn67EKWudc55Zw6sj16tuSxlrKPiMCuG
         +ftLFsolOCtWiPVAayNh1LlCPULL31GJJny8jfXInC38O1gZVdCsHkG5bBDV/zu4Ev
         I2f7R6OuHjlGrV0nCjDj4QhsfUeOZ2vVeKxo92Og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 290/425] RDMA/bnxt_re: Fix a double free in bnxt_qplib_alloc_res
Date:   Thu, 20 May 2021 11:20:59 +0200
Message-Id: <20210520092140.982238864@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 539a5d44e6db..655952a6c0e6 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -725,6 +725,7 @@ static int bnxt_qplib_alloc_dpi_tbl(struct bnxt_qplib_res     *res,
 
 unmap_io:
 	pci_iounmap(res->pdev, dpit->dbr_bar_reg_iomem);
+	dpit->dbr_bar_reg_iomem = NULL;
 	return -ENOMEM;
 }
 
-- 
2.30.2



