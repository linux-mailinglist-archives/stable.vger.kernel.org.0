Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8082A475E84
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245306AbhLORWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:22:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43484 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245293AbhLORWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:22:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41AF2619F2;
        Wed, 15 Dec 2021 17:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294FBC36AE2;
        Wed, 15 Dec 2021 17:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588956;
        bh=AKlDEE4ctpvaezV6ZJDEhNLRn7g02YZwyv/qcnq3KmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QW2SC8IZsdWPw+LoMQ3CZQm2TEpf5XSOOhmJU6WOOiFU3qNMfublc0Mpmo1MY1O2y
         s1jfXF2iPk4KmBMaIRIxE+nRXbYnhRdaicmdNTSNVmZB9pYMYWc24daTYAMgobvBpF
         ut24FLEu0sQ5i5ltVUEpy3QU1CdZB0X7WV/VttZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/42] RDMA/irdma: Fix a user-after-free in add_pble_prm
Date:   Wed, 15 Dec 2021 18:20:53 +0100
Message-Id: <20211215172027.059077799@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

[ Upstream commit 1e11a39a82e95ce86f849f40dda0d9c0498cebd9 ]

When irdma_hmc_sd_one fails, 'chunk' is freed while its still on the PBLE
info list.

Add the chunk entry to the PBLE info list only after successful setting of
the SD in irdma_hmc_sd_one.

Fixes: e8c4dbc2fcac ("RDMA/irdma: Add PBLE resource manager")
Link: https://lore.kernel.org/r/20211207152135.2192-1-shiraz.saleem@intel.com
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/pble.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/pble.c b/drivers/infiniband/hw/irdma/pble.c
index aeeb1c310965d..da032b952755e 100644
--- a/drivers/infiniband/hw/irdma/pble.c
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -283,7 +283,6 @@ add_pble_prm(struct irdma_hmc_pble_rsrc *pble_rsrc)
 		  "PBLE: next_fpm_addr = %llx chunk_size[%llu] = 0x%llx\n",
 		  pble_rsrc->next_fpm_addr, chunk->size, chunk->size);
 	pble_rsrc->unallocated_pble -= (u32)(chunk->size >> 3);
-	list_add(&chunk->list, &pble_rsrc->pinfo.clist);
 	sd_reg_val = (sd_entry_type == IRDMA_SD_TYPE_PAGED) ?
 			     sd_entry->u.pd_table.pd_page_addr.pa :
 			     sd_entry->u.bp.addr.pa;
@@ -295,6 +294,7 @@ add_pble_prm(struct irdma_hmc_pble_rsrc *pble_rsrc)
 			goto error;
 	}
 
+	list_add(&chunk->list, &pble_rsrc->pinfo.clist);
 	sd_entry->valid = true;
 	return 0;
 
-- 
2.33.0



