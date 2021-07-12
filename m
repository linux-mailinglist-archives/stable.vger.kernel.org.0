Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD5C3C543C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348171AbhGLH5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347602AbhGLHxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:53:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABEC26113A;
        Mon, 12 Jul 2021 07:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076249;
        bh=ZbOD45fwJVoU5DMT/VyWyJZkTaRCfSEj8eOcmrVZQ74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmUhxMsXeIgNbq86dEQIuT3pyHJTxVVvOx55CWRniOJmKDWaWbc0lVKQTIyRocpnv
         5sYMLEZyjKnH3EP+ePYv9ST+QtAhzE4COqmZmzj4MjkP2FeyQogWfE8EZI11EDlr5Q
         Gdlddh9gUi4KYJZLTl8iSVFL12DetggJFtA8aIbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 560/800] RDMA/hns: Add a check to ensure integer mtu is positive
Date:   Mon, 12 Jul 2021 08:09:43 +0200
Message-Id: <20210712061026.998610978@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weihang Li <liweihang@huawei.com>

[ Upstream commit fe331da0f210c60342b042a03fe53f1b564b412b ]

GCC may reports an running time assert error when a value calculated from
ib_mtu_enum_to_int() is using as 'val' in FIELD_PREDP:

include/linux/compiler_types.h:328:38: error: call to
'__compiletime_assert_1524' declared with attribute error: FIELD_PREP:
value too large for the field

So a check is added about whether integer mtu from ib_mtu_enum_to_int() is
negative to avoid this warning.

Link: https://lore.kernel.org/r/1624262443-24528-3-git-send-email-liweihang@huawei.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index cd58becf1baf..f074e2e5a5c8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4499,12 +4499,13 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	dma_addr_t trrl_ba;
 	dma_addr_t irrl_ba;
-	enum ib_mtu mtu;
+	enum ib_mtu ib_mtu;
 	u8 lp_pktn_ini;
 	u64 *mtts;
 	u8 *dmac;
 	u8 *smac;
 	u32 port;
+	int mtu;
 	int ret;
 
 	ret = config_qp_rq_buf(hr_dev, hr_qp, context, qpc_mask);
@@ -4588,19 +4589,23 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 	roce_set_field(qpc_mask->byte_52_udpspn_dmac, V2_QPC_BYTE_52_DMAC_M,
 		       V2_QPC_BYTE_52_DMAC_S, 0);
 
-	mtu = get_mtu(ibqp, attr);
-	hr_qp->path_mtu = mtu;
+	ib_mtu = get_mtu(ibqp, attr);
+	hr_qp->path_mtu = ib_mtu;
+
+	mtu = ib_mtu_enum_to_int(ib_mtu);
+	if (WARN_ON(mtu < 0))
+		return -EINVAL;
 
 	if (attr_mask & IB_QP_PATH_MTU) {
 		roce_set_field(context->byte_24_mtu_tc, V2_QPC_BYTE_24_MTU_M,
-			       V2_QPC_BYTE_24_MTU_S, mtu);
+			       V2_QPC_BYTE_24_MTU_S, ib_mtu);
 		roce_set_field(qpc_mask->byte_24_mtu_tc, V2_QPC_BYTE_24_MTU_M,
 			       V2_QPC_BYTE_24_MTU_S, 0);
 	}
 
 #define MAX_LP_MSG_LEN 65536
 	/* MTU * (2 ^ LP_PKTN_INI) shouldn't be bigger than 64KB */
-	lp_pktn_ini = ilog2(MAX_LP_MSG_LEN / ib_mtu_enum_to_int(mtu));
+	lp_pktn_ini = ilog2(MAX_LP_MSG_LEN / mtu);
 
 	roce_set_field(context->byte_56_dqpn_err, V2_QPC_BYTE_56_LP_PKTN_INI_M,
 		       V2_QPC_BYTE_56_LP_PKTN_INI_S, lp_pktn_ini);
-- 
2.30.2



