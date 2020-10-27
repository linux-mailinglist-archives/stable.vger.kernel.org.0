Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A724429BC5E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802541AbgJ0Pt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:49:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801321AbgJ0Pjx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:39:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C7942231B;
        Tue, 27 Oct 2020 15:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813192;
        bh=IOepFnYSDzZY5hqPZVdlAcnSTyzEtSc01jf4GC/tIx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXhpz18Z016JxHf1uSs7p8gu0Gccp6EqSLuHnmoS4IJaZzNx7IkZIirYRO7K6aT+B
         6rcYu8kZPq2iuxVZ+9f4yCDj+DqXngNflK3PmQvSZZoi3ornx3a0anQWucRvwq4T65
         +56Jm2x8udiwfVgr/ACAmKYQnahybq8XIxNTymJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 468/757] RDMA/hns: Fix configuration of ack_req_freq in QPC
Date:   Tue, 27 Oct 2020 14:51:58 +0100
Message-Id: <20201027135512.476339782@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weihang Li <liweihang@huawei.com>

[ Upstream commit fbed9d2be292504e04caa2057e3a9477a1e1d040 ]

The hardware will add AckReq flag in BTH header according to the value of
ack_req_freq to request ACK from responder for the packets with this flag.
It should be greater than or equal to lp_pktn_ini instead of using a fixed
value.

Fixes: 7b9bd73ed13d ("RDMA/hns: Fix wrong assignment of lp_pktn_ini in QPC")
Link: https://lore.kernel.org/r/1600509802-44382-8-git-send-email-liweihang@huawei.com
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 9eaed58fbaee0..f72ee3b5d05f6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3641,9 +3641,6 @@ static void modify_qp_reset_to_init(struct ib_qp *ibqp,
 			     V2_QPC_BYTE_76_SRQ_EN_S, 1);
 	}
 
-	roce_set_field(context->byte_172_sq_psn, V2_QPC_BYTE_172_ACK_REQ_FREQ_M,
-		       V2_QPC_BYTE_172_ACK_REQ_FREQ_S, 4);
-
 	roce_set_bit(context->byte_172_sq_psn, V2_QPC_BYTE_172_FRE_S, 1);
 
 	hr_qp->access_flags = attr->qp_access_flags;
@@ -3954,6 +3951,7 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 	dma_addr_t trrl_ba;
 	dma_addr_t irrl_ba;
 	enum ib_mtu mtu;
+	u8 lp_pktn_ini;
 	u8 port_num;
 	u64 *mtts;
 	u8 *dmac;
@@ -4061,13 +4059,21 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 	}
 
 #define MAX_LP_MSG_LEN 65536
-	/* MTU*(2^LP_PKTN_INI) shouldn't be bigger than 64kb */
+	/* MTU * (2 ^ LP_PKTN_INI) shouldn't be bigger than 64KB */
+	lp_pktn_ini = ilog2(MAX_LP_MSG_LEN / ib_mtu_enum_to_int(mtu));
+
 	roce_set_field(context->byte_56_dqpn_err, V2_QPC_BYTE_56_LP_PKTN_INI_M,
-		       V2_QPC_BYTE_56_LP_PKTN_INI_S,
-		       ilog2(MAX_LP_MSG_LEN / ib_mtu_enum_to_int(mtu)));
+		       V2_QPC_BYTE_56_LP_PKTN_INI_S, lp_pktn_ini);
 	roce_set_field(qpc_mask->byte_56_dqpn_err, V2_QPC_BYTE_56_LP_PKTN_INI_M,
 		       V2_QPC_BYTE_56_LP_PKTN_INI_S, 0);
 
+	/* ACK_REQ_FREQ should be larger than or equal to LP_PKTN_INI */
+	roce_set_field(context->byte_172_sq_psn, V2_QPC_BYTE_172_ACK_REQ_FREQ_M,
+		       V2_QPC_BYTE_172_ACK_REQ_FREQ_S, lp_pktn_ini);
+	roce_set_field(qpc_mask->byte_172_sq_psn,
+		       V2_QPC_BYTE_172_ACK_REQ_FREQ_M,
+		       V2_QPC_BYTE_172_ACK_REQ_FREQ_S, 0);
+
 	roce_set_bit(qpc_mask->byte_108_rx_reqepsn,
 		     V2_QPC_BYTE_108_RX_REQ_PSN_ERR_S, 0);
 	roce_set_field(qpc_mask->byte_96_rx_reqmsn, V2_QPC_BYTE_96_RX_REQ_MSN_M,
-- 
2.25.1



