Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A7B657B3C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbiL1PTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbiL1PTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:19:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF8313F99
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:19:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FFF161551
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEA3C433EF;
        Wed, 28 Dec 2022 15:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240756;
        bh=XxJDb52vioGkGzRD2BvTmhbKHagQk5iTdGB3gLkC3Zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4g2Z8qhHFMWrE1p+dpVKJsAnsntrP+2s2nOQ1NdwkMTs4CuG/yKji3YKvbVVprUp
         5cXUelx09d58FJhvtBjpOmAg5wfUwBOinvtWqZ2hgjo3cCv3jK6Erspq9EaMxZ2Ivd
         n6252RoXFfaRdEtaX1LTzCfTRtzwmUUlFzOUorZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luoyouming <luoyouming@huawei.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 394/731] RDMA/hns: Repacing dseg_len by macros in fill_ext_sge_inl_data()
Date:   Wed, 28 Dec 2022 15:38:21 +0100
Message-Id: <20221228144307.980190998@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luoyouming <luoyouming@huawei.com>

[ Upstream commit 3b1f864c904915b3baebffb31ea05ee704b0df3c ]

The sge size is known to be constant, so it's unnecessary to use sizeof to
calculate.

Link: https://lore.kernel.org/r/20220922123315.3732205-11-xuhaoyue1@hisilicon.com
Signed-off-by: Luoyouming <luoyouming@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 8eaa6f7d569b ("RDMA/hns: Fix ext_sge num error when post send")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 1421896abaf0..5875ccf86f66 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -156,8 +156,7 @@ static int fill_ext_sge_inl_data(struct hns_roce_qp *qp,
 				 unsigned int *sge_idx, u32 msg_len)
 {
 	struct ib_device *ibdev = &(to_hr_dev(qp->ibqp.device))->ib_dev;
-	unsigned int dseg_len = sizeof(struct hns_roce_v2_wqe_data_seg);
-	unsigned int ext_sge_sz = qp->sq.max_gs * dseg_len;
+	unsigned int ext_sge_sz = qp->sq.max_gs * HNS_ROCE_SGE_SIZE;
 	unsigned int left_len_in_pg;
 	unsigned int idx = *sge_idx;
 	unsigned int i = 0;
@@ -185,7 +184,7 @@ static int fill_ext_sge_inl_data(struct hns_roce_qp *qp,
 		if (len <= left_len_in_pg) {
 			memcpy(dseg, addr, len);
 
-			idx += len / dseg_len;
+			idx += len / HNS_ROCE_SGE_SIZE;
 
 			i++;
 			if (i >= wr->num_sge)
@@ -200,7 +199,7 @@ static int fill_ext_sge_inl_data(struct hns_roce_qp *qp,
 
 			len -= left_len_in_pg;
 			addr += left_len_in_pg;
-			idx += left_len_in_pg / dseg_len;
+			idx += left_len_in_pg / HNS_ROCE_SGE_SIZE;
 			dseg = hns_roce_get_extend_sge(qp,
 						idx & (qp->sge.sge_cnt - 1));
 			left_len_in_pg = 1 << HNS_HW_PAGE_SHIFT;
-- 
2.35.1



