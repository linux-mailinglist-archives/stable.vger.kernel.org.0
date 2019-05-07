Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0290215AD7
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbfEGFtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:49:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbfEGFkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:40:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58BE920578;
        Tue,  7 May 2019 05:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207631;
        bh=t/Br6gIcSiZmlrPC7V3vb+4t9UEZaeU+lmbv8eZ3UJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqMTMFfNiAdmOTFz6IRJSh1OzTHCw+F8+JdFUgr8JXsy6OYrMC/U3z/LM+lAJxd+2
         xlyLSQA6woMkon6KhWrh2KOzoVyJsfwfOvcZiI7lNkosOttSUE0s3dpkucqR4Aim6x
         CUVIVnkXsSzF47bGYqiAcpVshRB1jaHsmO3T3pWw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adit Ranadive <aditr@vmware.com>,
        Ruishuang Wang <ruishuangw@vmware.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 68/95] RDMA/vmw_pvrdma: Return the correct opcode when creating WR
Date:   Tue,  7 May 2019 01:37:57 -0400
Message-Id: <20190507053826.31622-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adit Ranadive <aditr@vmware.com>

[ Upstream commit 6325e01b6cdf4636b721cf7259c1616e3cf28ce2 ]

Since the IB_WR_REG_MR opcode value changed, let's set the PVRDMA device
opcodes explicitly.

Reported-by: Ruishuang Wang <ruishuangw@vmware.com>
Fixes: 9a59739bd01f ("IB/rxe: Revise the ib_wr_opcode enum")
Cc: stable@vger.kernel.org
Reviewed-by: Bryan Tan <bryantan@vmware.com>
Reviewed-by: Ruishuang Wang <ruishuangw@vmware.com>
Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
Signed-off-by: Adit Ranadive <aditr@vmware.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h    | 35 +++++++++++++++++++-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c |  6 ++++
 include/uapi/rdma/vmw_pvrdma-abi.h           |  1 +
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
index 984aa3484928..4463e1c1a764 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -407,7 +407,40 @@ static inline enum ib_qp_state pvrdma_qp_state_to_ib(enum pvrdma_qp_state state)
 
 static inline enum pvrdma_wr_opcode ib_wr_opcode_to_pvrdma(enum ib_wr_opcode op)
 {
-	return (enum pvrdma_wr_opcode)op;
+	switch (op) {
+	case IB_WR_RDMA_WRITE:
+		return PVRDMA_WR_RDMA_WRITE;
+	case IB_WR_RDMA_WRITE_WITH_IMM:
+		return PVRDMA_WR_RDMA_WRITE_WITH_IMM;
+	case IB_WR_SEND:
+		return PVRDMA_WR_SEND;
+	case IB_WR_SEND_WITH_IMM:
+		return PVRDMA_WR_SEND_WITH_IMM;
+	case IB_WR_RDMA_READ:
+		return PVRDMA_WR_RDMA_READ;
+	case IB_WR_ATOMIC_CMP_AND_SWP:
+		return PVRDMA_WR_ATOMIC_CMP_AND_SWP;
+	case IB_WR_ATOMIC_FETCH_AND_ADD:
+		return PVRDMA_WR_ATOMIC_FETCH_AND_ADD;
+	case IB_WR_LSO:
+		return PVRDMA_WR_LSO;
+	case IB_WR_SEND_WITH_INV:
+		return PVRDMA_WR_SEND_WITH_INV;
+	case IB_WR_RDMA_READ_WITH_INV:
+		return PVRDMA_WR_RDMA_READ_WITH_INV;
+	case IB_WR_LOCAL_INV:
+		return PVRDMA_WR_LOCAL_INV;
+	case IB_WR_REG_MR:
+		return PVRDMA_WR_FAST_REG_MR;
+	case IB_WR_MASKED_ATOMIC_CMP_AND_SWP:
+		return PVRDMA_WR_MASKED_ATOMIC_CMP_AND_SWP;
+	case IB_WR_MASKED_ATOMIC_FETCH_AND_ADD:
+		return PVRDMA_WR_MASKED_ATOMIC_FETCH_AND_ADD;
+	case IB_WR_REG_SIG_MR:
+		return PVRDMA_WR_REG_SIG_MR;
+	default:
+		return PVRDMA_WR_ERROR;
+	}
 }
 
 static inline enum ib_wc_status pvrdma_wc_status_to_ib(
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index d7162f2b7979..4d9c99dd366b 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -695,6 +695,12 @@ int pvrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		    wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM)
 			wqe_hdr->ex.imm_data = wr->ex.imm_data;
 
+		if (unlikely(wqe_hdr->opcode == PVRDMA_WR_ERROR)) {
+			*bad_wr = wr;
+			ret = -EINVAL;
+			goto out;
+		}
+
 		switch (qp->ibqp.qp_type) {
 		case IB_QPT_GSI:
 		case IB_QPT_UD:
diff --git a/include/uapi/rdma/vmw_pvrdma-abi.h b/include/uapi/rdma/vmw_pvrdma-abi.h
index 912ea1556a0b..fd801c7be120 100644
--- a/include/uapi/rdma/vmw_pvrdma-abi.h
+++ b/include/uapi/rdma/vmw_pvrdma-abi.h
@@ -76,6 +76,7 @@ enum pvrdma_wr_opcode {
 	PVRDMA_WR_MASKED_ATOMIC_FETCH_AND_ADD,
 	PVRDMA_WR_BIND_MW,
 	PVRDMA_WR_REG_SIG_MR,
+	PVRDMA_WR_ERROR,
 };
 
 enum pvrdma_wc_status {
-- 
2.20.1

