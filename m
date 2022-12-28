Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486A3657B40
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbiL1PTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbiL1PTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:19:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFED313F95
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:19:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EEEAB816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08F2C433EF;
        Wed, 28 Dec 2022 15:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240767;
        bh=NWsKFQuy+O3Gk9MuwuwP0V8CdgP4uEkBPe+U0Z11uTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPqjkwEnJzb2oa2CR0naD/hCj18F8o9xI1BzW7VgdaA1viFN+OBPOUwNhAXr45cJe
         vcFwftoUDCAyUS9NOa4nUWln/UVj99MgB4IN5FyyVb1q713BWchv6t3rcSHr6vPGJQ
         14GB0SY+8vRnznILhIJkuTdOHMk/3dA9YWu/7p4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luoyouming <luoyouming@huawei.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 395/731] RDMA/hns: Fix ext_sge num error when post send
Date:   Wed, 28 Dec 2022 15:38:22 +0100
Message-Id: <20221228144308.009872480@linuxfoundation.org>
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

[ Upstream commit 8eaa6f7d569b4a22bfc1b0a3fdfeeb401feb65a4 ]

In the HNS ROCE driver, The sge is divided into standard sge and extended
sge.  There are 2 standard sge in RC/XRC, and the UD standard sge is 0.
In the scenario of RC SQ inline, if the data does not exceed 32bytes, the
standard sge will be used. If it exceeds, only the extended sge will be
used to fill the data.

Currently, when filling the extended sge, max_gs is directly used as the
number of the extended sge, which did not subtract the number of standard
sge.  There is a logical error. The new algorithm subtracts the number of
standard sge from max_gs to get the actual number of extended sge.

Fixes: 30b707886aeb ("RDMA/hns: Support inline data in extented sge space for RC")
Link: https://lore.kernel.org/r/20221108133847.2304539-2-xuhaoyue1@hisilicon.com
Signed-off-by: Luoyouming <luoyouming@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 5875ccf86f66..94f3a0a87dfd 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -151,20 +151,29 @@ static void set_atomic_seg(const struct ib_send_wr *wr,
 	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_SGE_NUM, valid_num_sge);
 }
 
+static unsigned int get_std_sge_num(struct hns_roce_qp *qp)
+{
+	if (qp->ibqp.qp_type == IB_QPT_GSI || qp->ibqp.qp_type == IB_QPT_UD)
+		return 0;
+
+	return HNS_ROCE_SGE_IN_WQE;
+}
+
 static int fill_ext_sge_inl_data(struct hns_roce_qp *qp,
 				 const struct ib_send_wr *wr,
 				 unsigned int *sge_idx, u32 msg_len)
 {
 	struct ib_device *ibdev = &(to_hr_dev(qp->ibqp.device))->ib_dev;
-	unsigned int ext_sge_sz = qp->sq.max_gs * HNS_ROCE_SGE_SIZE;
 	unsigned int left_len_in_pg;
 	unsigned int idx = *sge_idx;
+	unsigned int std_sge_num;
 	unsigned int i = 0;
 	unsigned int len;
 	void *addr;
 	void *dseg;
 
-	if (msg_len > ext_sge_sz) {
+	std_sge_num = get_std_sge_num(qp);
+	if (msg_len > (qp->sq.max_gs - std_sge_num) * HNS_ROCE_SGE_SIZE) {
 		ibdev_err(ibdev,
 			  "no enough extended sge space for inline data.\n");
 		return -EINVAL;
-- 
2.35.1



