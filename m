Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9E6E54C3
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 21:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfJYT66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 15:58:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:21296 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfJYT66 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 15:58:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 12:58:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,229,1569308400"; 
   d="scan'208";a="210432647"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by fmsmga001.fm.intel.com with ESMTP; 25 Oct 2019 12:58:45 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id x9PJwiKw024314;
        Fri, 25 Oct 2019 12:58:44 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id x9PJwg56112008;
        Fri, 25 Oct 2019 15:58:43 -0400
Subject: [PATCH for-rc 4/4] IB/hfi1: TID RDMA WRITE should not return
 IB_WC_RNR_RETRY_EXC_ERR
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Date:   Fri, 25 Oct 2019 15:58:42 -0400
Message-ID: <20191025195842.106825.71532.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20191025161717.106825.14421.stgit@awfm-01.aw.intel.com>
References: <20191025161717.106825.14421.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

Normal RDMA WRITE request never returns IB_WC_RNR_RETRY_EXC_ERR to ULPs
because it does not need post receive buffer on the responder side.
Consequently, as an enhancement to normal RDMA WRITE request inside
the hfi1 driver, TID RDMA WRITE request should not return such an
error status to ULPs, although it does receive RNR NAKs from the
responder when TID resources are not available. This behavior is
violated when qp->s_rnr_retry_cnt is set in current hfi1
implementation.

This patch enforces this semantics by avoiding any reaction to the
updates of the RNR QP attributes.

Fixes: 3c6cb20a0d17 ("IB/hfi1: Add TID RDMA WRITE functionality into RDMA verbs")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/rc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 513a8aa..1a3c647 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -2209,15 +2209,15 @@ int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
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

