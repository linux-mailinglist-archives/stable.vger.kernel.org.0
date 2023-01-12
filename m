Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5DD6675D3
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbjALO0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236821AbjALOZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:25:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38115BA31
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:16:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DD1BB81E6D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207F9C433D2;
        Thu, 12 Jan 2023 14:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533001;
        bh=iGvBcBUgaVNdf7n8wtoCoxy3zK00qlXInSFCQuL4eBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtF/mJn3qQOHz0NnqZBbg3esbW3B0PFgMuLQ1k6F5ukBlxgsM+onXSgq6WdEIuJ96
         h40YBudak+B6jIEZOvvuqyx9S+GIGhyeMPwSnq5nVDrUy6Q/vOadHDnVaCOgkcHhbA
         uCJyW5+Tc0yQSH349EVkG1erfEGPJThMmsK8vnyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luoyouming <luoyouming@huawei.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 306/783] RDMA/hns: Fix ext_sge num error when post send
Date:   Thu, 12 Jan 2023 14:50:22 +0100
Message-Id: <20230112135538.507348608@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 4836090ec817..e1395590edfd 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -154,20 +154,29 @@ static void set_atomic_seg(const struct ib_send_wr *wr,
 		       V2_RC_SEND_WQE_BYTE_16_SGE_NUM_S, valid_num_sge);
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



