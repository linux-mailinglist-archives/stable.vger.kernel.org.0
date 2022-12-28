Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33C365809E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbiL1QSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbiL1QSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:18:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8ADC18B13
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:17:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EF71B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4942C433D2;
        Wed, 28 Dec 2022 16:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244221;
        bh=5UizsMV9wiYyZ4JDG+DlLKc7fGxS6bLAGUQI6Vk/jmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gW7JFRvZoits1tJe/OjuUHQGHwNfS+bg9KAvXSh5NHhR/Ccpj7GXUMg6IQ7o8Hq6B
         dzy7krYRLDDOav85+V6piF6juDmrU6VPDmBzP6DZyMZuMMEVQjswACZm3+uM5JBnVp
         4l/HdgNnn+1CBYtGMMUbjE1ROjWP/7EnAzdtkqLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Chengchang Tang <tangchengchang@huawei.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0648/1073] RDMA/hns: Fix AH attr queried by query_qp
Date:   Wed, 28 Dec 2022 15:37:16 +0100
Message-Id: <20221228144345.644543042@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit bc34c04f7b97c3794dec5a6d6d27ffd5f0e4f5c8 ]

The queried AH attr is invalid. This patch fix it.

This problem is found by rdma-core test test_mr_rereg_pd

ERROR: test_mr_rereg_pd (tests.test_mr.MRTest)
Test that cover rereg MR's PD with this flow:
----------------------------------------------------------------------
Traceback (most recent call last):
  File "./tests/test_mr.py", line 157, in test_mr_rereg_pd
    self.restate_qps()
  File "./tests/test_mr.py", line 113, in restate_qps
    self.server.qp.to_rts(self.server_qp_attr)
  File "qp.pyx", line 1137, in pyverbs.qp.QP.to_rts
  File "qp.pyx", line 1123, in pyverbs.qp.QP.to_rtr
pyverbs.pyverbs_error.PyverbsRDMAError: Failed to modify QP state to RTR.
Errno: 22, Invalid argument

Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Link: https://lore.kernel.org/r/20221126102911.2921820-3-xuhaoyue1@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index d242fa192f0d..ba60496c8f01 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5470,6 +5470,8 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 
 		rdma_ah_set_sl(&qp_attr->ah_attr,
 			       hr_reg_read(&context, QPC_SL));
+		rdma_ah_set_port_num(&qp_attr->ah_attr, hr_qp->port + 1);
+		rdma_ah_set_ah_flags(&qp_attr->ah_attr, IB_AH_GRH);
 		grh->flow_label = hr_reg_read(&context, QPC_FL);
 		grh->sgid_index = hr_reg_read(&context, QPC_GMV_IDX);
 		grh->hop_limit = hr_reg_read(&context, QPC_HOPLIMIT);
-- 
2.35.1



