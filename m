Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71015582FCE
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241982AbiG0RaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242120AbiG0R1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:27:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073267F53E;
        Wed, 27 Jul 2022 09:47:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 142C5614DE;
        Wed, 27 Jul 2022 16:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E517CC43150;
        Wed, 27 Jul 2022 16:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940440;
        bh=gWy067auv1cIDDz1ieWzLMz4GbK/yZ0iwF/UgHgWv7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4EMfRj5i2SklB7VYp4LtmPwtca++mWbvqNjyFn3YUUXbIKffroT5WzpE1keElOvj
         7wemqKyLm16HC66jJyjOzdYwNBHy/HvwfzCL5FN8VlhK7pqnDgMYae1KWt8Mx5AJA3
         W3luGrszD/obwtYGOWkd82jMDdrs4TZdVq3EXX7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 023/158] RDMA/irdma: Do not advertise 1GB page size for x722
Date:   Wed, 27 Jul 2022 18:11:27 +0200
Message-Id: <20220727161022.406069939@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 5e8afb8792f3b6ae7ccf700f8c19225382636401 ]

x722 does not support 1GB page size but the irdma driver incorrectly
advertises 1GB page size support for x722 device to ib_core to compute the
best page size to use on this MR.  This could lead to incorrect start
offsets computed by hardware on the MR.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/i40iw_hw.c  | 1 +
 drivers/infiniband/hw/irdma/icrdma_hw.c | 1 +
 drivers/infiniband/hw/irdma/irdma.h     | 1 +
 drivers/infiniband/hw/irdma/verbs.c     | 4 ++--
 4 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/i40iw_hw.c b/drivers/infiniband/hw/irdma/i40iw_hw.c
index e46fc110004d..50299f58b6b3 100644
--- a/drivers/infiniband/hw/irdma/i40iw_hw.c
+++ b/drivers/infiniband/hw/irdma/i40iw_hw.c
@@ -201,6 +201,7 @@ void i40iw_init_hw(struct irdma_sc_dev *dev)
 	dev->hw_attrs.uk_attrs.max_hw_read_sges = I40IW_MAX_SGE_RD;
 	dev->hw_attrs.max_hw_device_pages = I40IW_MAX_PUSH_PAGE_COUNT;
 	dev->hw_attrs.uk_attrs.max_hw_inline = I40IW_MAX_INLINE_DATA_SIZE;
+	dev->hw_attrs.page_size_cap = SZ_4K | SZ_2M;
 	dev->hw_attrs.max_hw_ird = I40IW_MAX_IRD_SIZE;
 	dev->hw_attrs.max_hw_ord = I40IW_MAX_ORD_SIZE;
 	dev->hw_attrs.max_hw_wqes = I40IW_MAX_WQ_ENTRIES;
diff --git a/drivers/infiniband/hw/irdma/icrdma_hw.c b/drivers/infiniband/hw/irdma/icrdma_hw.c
index cf53b17510cd..5986fd906308 100644
--- a/drivers/infiniband/hw/irdma/icrdma_hw.c
+++ b/drivers/infiniband/hw/irdma/icrdma_hw.c
@@ -139,6 +139,7 @@ void icrdma_init_hw(struct irdma_sc_dev *dev)
 	dev->cqp_db = dev->hw_regs[IRDMA_CQPDB];
 	dev->cq_ack_db = dev->hw_regs[IRDMA_CQACK];
 	dev->irq_ops = &icrdma_irq_ops;
+	dev->hw_attrs.page_size_cap = SZ_4K | SZ_2M | SZ_1G;
 	dev->hw_attrs.max_hw_ird = ICRDMA_MAX_IRD_SIZE;
 	dev->hw_attrs.max_hw_ord = ICRDMA_MAX_ORD_SIZE;
 	dev->hw_attrs.max_stat_inst = ICRDMA_MAX_STATS_COUNT;
diff --git a/drivers/infiniband/hw/irdma/irdma.h b/drivers/infiniband/hw/irdma/irdma.h
index 46c12334c735..4789e85d717b 100644
--- a/drivers/infiniband/hw/irdma/irdma.h
+++ b/drivers/infiniband/hw/irdma/irdma.h
@@ -127,6 +127,7 @@ struct irdma_hw_attrs {
 	u64 max_hw_outbound_msg_size;
 	u64 max_hw_inbound_msg_size;
 	u64 max_mr_size;
+	u64 page_size_cap;
 	u32 min_hw_qp_id;
 	u32 min_hw_aeq_size;
 	u32 max_hw_aeq_size;
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 52f3e88f8569..6daa149dcbda 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -30,7 +30,7 @@ static int irdma_query_device(struct ib_device *ibdev,
 	props->vendor_part_id = pcidev->device;
 
 	props->hw_ver = rf->pcidev->revision;
-	props->page_size_cap = SZ_4K | SZ_2M | SZ_1G;
+	props->page_size_cap = hw_attrs->page_size_cap;
 	props->max_mr_size = hw_attrs->max_mr_size;
 	props->max_qp = rf->max_qp - rf->used_qps;
 	props->max_qp_wr = hw_attrs->max_qp_wr;
@@ -2764,7 +2764,7 @@ static struct ib_mr *irdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
 
 	if (req.reg_type == IRDMA_MEMREG_TYPE_MEM) {
 		iwmr->page_size = ib_umem_find_best_pgsz(region,
-							 SZ_4K | SZ_2M | SZ_1G,
+							 iwdev->rf->sc_dev.hw_attrs.page_size_cap,
 							 virt);
 		if (unlikely(!iwmr->page_size)) {
 			kfree(iwmr);
-- 
2.35.1



