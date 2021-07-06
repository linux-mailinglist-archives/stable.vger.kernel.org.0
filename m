Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14303BCD63
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbhGFLVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:21:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233184AbhGFLUN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:20:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB1DA61C66;
        Tue,  6 Jul 2021 11:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570238;
        bh=qMPU3zfiHGCSq5ZYLRlXr/Vg957eiNDmbSieY5bsNkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqhhWAqH0HrIePT/dytRt005RYhgm6VL2hhchBWPXO6QQgF1NleEPaesmsFN7TfFJ
         vYz88WIgZ2639q0GrZ18EsJHCR6xrFJgJaxugzMP+27cF/cS8g4BTohOz327cVqkj5
         HC2ftRDgSpDzBWpK8d37/mcVIr1p4X9vo0Tc3p1MxSq0x166HWoXbqfaIm5Ec/moU0
         3os1xC2NodbTOvON4G3HbPoefpNrsibrNCThK5fCqWJrLd0y1HqfP/SKeore+mNBQL
         VEZ/hgEtD2Vhj/LYvhVlzXpG90d4g3j1VzBSh39vD+4bUxnaDpU8rjor7qubdP3W/s
         fdV062Zibp3eA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Weihang Li <liweihang@huawei.com>,
        kernel test robot <lkp@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 140/189] RDMA/hns: Add a check to ensure integer mtu is positive
Date:   Tue,  6 Jul 2021 07:13:20 -0400
Message-Id: <20210706111409.2058071-140-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7652dafe32ec..bedb0d1caeee 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4485,12 +4485,13 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
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
@@ -4574,19 +4575,23 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
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

