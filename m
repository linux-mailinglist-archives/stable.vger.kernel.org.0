Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9347190AF
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfEISrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727857AbfEISrn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:47:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99FAC217F4;
        Thu,  9 May 2019 18:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427663;
        bh=mTZClnFqCCBmAW3TC0MUDg6DwdLkumXIHKHkr8/5FDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msLoASfh57H6oyqyBCgXgIeTdsVs0mKslXkXzBm3Mq1d4rzkHOSDgVHnFMTfK7IsJ
         kN+A+ws1gcBrD7+YmrTCY31L+UcmYtpPJvhTmh89LsW6f7/0LKFIFo3sw9XmbsMhgr
         yO2H5wEwPMI0OsOTl1PGeswxD/C9v0AbfyoclyWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/66] IB/hfi1: Eliminate opcode tests on mr deref
Date:   Thu,  9 May 2019 20:41:59 +0200
Message-Id: <20190509181304.454656970@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a8639a79e85c18c16c10089edd589c7948f19bbd ]

When an old ack_queue entry is used to store an incoming request, it may
need to clean up the old entry if it is still referencing the
MR. Originally only RDMA READ request needed to reference MR on the
responder side and therefore the opcode was tested when cleaning up the
old entry. The introduction of tid rdma specific operations in the
ack_queue makes the specific opcode tests wrong.  Multiple opcodes (RDMA
READ, TID RDMA READ, and TID RDMA WRITE) may need MR ref cleanup.

Remove the opcode specific tests associated with the ack_queue.

Fixes: f48ad614c100 ("IB/hfi1: Move driver out of staging")
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/rc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 6f013a565353f..770c78c657306 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -2303,7 +2303,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 			update_ack_queue(qp, next);
 		}
 		e = &qp->s_ack_queue[qp->r_head_ack_queue];
-		if (e->opcode == OP(RDMA_READ_REQUEST) && e->rdma_sge.mr) {
+		if (e->rdma_sge.mr) {
 			rvt_put_mr(e->rdma_sge.mr);
 			e->rdma_sge.mr = NULL;
 		}
@@ -2377,7 +2377,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 			update_ack_queue(qp, next);
 		}
 		e = &qp->s_ack_queue[qp->r_head_ack_queue];
-		if (e->opcode == OP(RDMA_READ_REQUEST) && e->rdma_sge.mr) {
+		if (e->rdma_sge.mr) {
 			rvt_put_mr(e->rdma_sge.mr);
 			e->rdma_sge.mr = NULL;
 		}
-- 
2.20.1



