Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D9A101904
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfKSFV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:21:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727539AbfKSFVy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:21:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E5612231E;
        Tue, 19 Nov 2019 05:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140913;
        bh=FBXtfcqgNgTv3eFRYajpHeZCHGp/in2KKwzbydDtM7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Op8b/F2JyqP7ElmWa5Z4jv6uLF0g6ast4AuaTL5qmb7Bu6iY4H9sVrAf9y4eO9ZsG
         LGEwKEsj7dCSRpRZ4FT35CNhmsbpwjUVFWRF/i67i7KODEA0S2rOeM7vevbIG0Mk5V
         UA8LKpffK8gNvix8gtEGxtiUlbiYTo4vLoWyRExw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.3 29/48] IB/hfi1: TID RDMA WRITE should not return IB_WC_RNR_RETRY_EXC_ERR
Date:   Tue, 19 Nov 2019 06:19:49 +0100
Message-Id: <20191119051010.504303261@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit ce8e8087cf3b5b4f19d29248bfc7deef95525490 upstream.

Normal RDMA WRITE request never returns IB_WC_RNR_RETRY_EXC_ERR to ULPs
because it does not need post receive buffer on the responder side.
Consequently, as an enhancement to normal RDMA WRITE request inside the
hfi1 driver, TID RDMA WRITE request should not return such an error status
to ULPs, although it does receive RNR NAKs from the responder when TID
resources are not available. This behavior is violated when
qp->s_rnr_retry_cnt is set in current hfi1 implementation.

This patch enforces these semantics by avoiding any reaction to the updates
of the RNR QP attributes.

Fixes: 3c6cb20a0d17 ("IB/hfi1: Add TID RDMA WRITE functionality into RDMA verbs")
Link: https://lore.kernel.org/r/20191025195842.106825.71532.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/rc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -2210,15 +2210,15 @@ int do_rc_ack(struct rvt_qp *qp, u32 aet
 		if (qp->s_flags & RVT_S_WAIT_RNR)
 			goto bail_stop;
 		rdi = ib_to_rvt(qp->ibqp.device);
-		if (qp->s_rnr_retry == 0 &&
-		    !((rdi->post_parms[wqe->wr.opcode].flags &
-		      RVT_OPERATION_IGN_RNR_CNT) &&
-		      qp->s_rnr_retry_cnt == 0)) {
-			status = IB_WC_RNR_RETRY_EXC_ERR;
-			goto class_b;
+		if (!(rdi->post_parms[wqe->wr.opcode].flags &
+		       RVT_OPERATION_IGN_RNR_CNT)) {
+			if (qp->s_rnr_retry == 0) {
+				status = IB_WC_RNR_RETRY_EXC_ERR;
+				goto class_b;
+			}
+			if (qp->s_rnr_retry_cnt < 7 && qp->s_rnr_retry_cnt > 0)
+				qp->s_rnr_retry--;
 		}
-		if (qp->s_rnr_retry_cnt < 7 && qp->s_rnr_retry_cnt > 0)
-			qp->s_rnr_retry--;
 
 		/*
 		 * The last valid PSN is the previous PSN. For TID RDMA WRITE


