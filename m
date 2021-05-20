Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1938638A448
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbhETKDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234936AbhETKB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9ED86191D;
        Thu, 20 May 2021 09:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503566;
        bh=wc2f9ho+L9XPJcFs4VOnTopaVG8HjPKl2gTGzl3PhmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMkAWDBN+yPYvltJXvNTaXpQipxcfnjnHtnT0cmwy9qLc6c6+UoZl5HekwEJc4Zyp
         5JZK5wHNAwwbZ6HYUWSPk+rxVY7DsRXC8A+owbWHV2VLFvGdN5ACYNFLeQQ+EODdHT
         KWn7Fjno0kNmA0ZBn/pjE+0snZfnr7x+yFDE7knM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sindhu Devale <sindhu.devale@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 279/425] RDMA/i40iw: Fix error unwinding when i40iw_hmc_sd_one fails
Date:   Thu, 20 May 2021 11:20:48 +0200
Message-Id: <20210520092140.609763390@linuxfoundation.org>
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

From: Sindhu Devale <sindhu.devale@intel.com>

[ Upstream commit 783a11bf2400e5d5c42a943c3083dc0330751842 ]

When i40iw_hmc_sd_one fails, chunk is freed without the deletion of chunk
entry in the PBLE info list.

Fix it by adding the chunk entry to the PBLE info list only after
successful addition of SD in i40iw_hmc_sd_one.

This fixes a static checker warning reported here:
  https://lore.kernel.org/linux-rdma/YHV4CFXzqTm23AOZ@mwanda/

Fixes: 9715830157be ("i40iw: add pble resource files")
Link: https://lore.kernel.org/r/20210416002104.323-1-shiraz.saleem@intel.com
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/i40iw/i40iw_pble.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_pble.c b/drivers/infiniband/hw/i40iw/i40iw_pble.c
index 540aab5e502d..3fafc5424e76 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_pble.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_pble.c
@@ -392,12 +392,9 @@ static enum i40iw_status_code add_pble_pool(struct i40iw_sc_dev *dev,
 	i40iw_debug(dev, I40IW_DEBUG_PBLE, "next_fpm_addr = %llx chunk_size[%u] = 0x%x\n",
 		    pble_rsrc->next_fpm_addr, chunk->size, chunk->size);
 	pble_rsrc->unallocated_pble -= (chunk->size >> 3);
-	list_add(&chunk->list, &pble_rsrc->pinfo.clist);
 	sd_reg_val = (sd_entry_type == I40IW_SD_TYPE_PAGED) ?
 			sd_entry->u.pd_table.pd_page_addr.pa : sd_entry->u.bp.addr.pa;
-	if (sd_entry->valid)
-		return 0;
-	if (dev->is_pf) {
+	if (dev->is_pf && !sd_entry->valid) {
 		ret_code = i40iw_hmc_sd_one(dev, hmc_info->hmc_fn_id,
 					    sd_reg_val, idx->sd_idx,
 					    sd_entry->entry_type, true);
@@ -408,6 +405,7 @@ static enum i40iw_status_code add_pble_pool(struct i40iw_sc_dev *dev,
 	}
 
 	sd_entry->valid = true;
+	list_add(&chunk->list, &pble_rsrc->pinfo.clist);
 	return 0;
  error:
 	kfree(chunk);
-- 
2.30.2



