Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DDF420F81
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235818AbhJDNff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:35:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238074AbhJDNdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:33:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09C1461528;
        Mon,  4 Oct 2021 13:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353321;
        bh=G3bX64Pz/yxzO+NwfRrXq3ZcaGFuOEOTGDOjUvliiqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5gFzw470DSQxXvl0T8rVBUjghUMp/9lQ184Nwpupz5wYES4Jv0IesO/yXpj3V5+Y
         u0JYsmwzN9BSFii8JmQdlHSaNgbjjtNQXkL1cl9eqOgPJROTQynYSHTdBx+kXgn+17
         3bcUW560NH8ly5+A+Ax0Z+6nDkEYefJjttDjIBnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, LiLiang <liali@redhat.com>,
        Sindhu Devale <sindhu.devale@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 082/172] RDMA/irdma: Skip CQP ring during a reset
Date:   Mon,  4 Oct 2021 14:52:12 +0200
Message-Id: <20211004125047.641140749@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sindhu Devale <sindhu.devale@intel.com>

[ Upstream commit 5b1e985f7626307c451f98883f5e2665ee208e1c ]

Due to duplicate reset flags, CQP commands are processed during reset.

This leads CQP failures such as below:

 irdma0: [Delete Local MAC Entry Cmd Error][op_code=49] status=-27 waiting=1 completion_err=0 maj=0x0 min=0x0

Remove the redundant flag and set the correct reset flag so CPQ is paused
during reset

Fixes: 8498a30e1b94 ("RDMA/irdma: Register auxiliary driver and implement private channel OPs")
Link: https://lore.kernel.org/r/20210916191222.824-2-shiraz.saleem@intel.com
Reported-by: LiLiang <liali@redhat.com>
Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.c       | 4 ++--
 drivers/infiniband/hw/irdma/hw.c       | 6 +++---
 drivers/infiniband/hw/irdma/i40iw_if.c | 2 +-
 drivers/infiniband/hw/irdma/main.h     | 1 -
 drivers/infiniband/hw/irdma/utils.c    | 2 +-
 drivers/infiniband/hw/irdma/verbs.c    | 3 +--
 6 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index 6b62299abfbb..6dea0a49d171 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -3496,7 +3496,7 @@ static void irdma_cm_disconn_true(struct irdma_qp *iwqp)
 	     original_hw_tcp_state == IRDMA_TCP_STATE_TIME_WAIT ||
 	     last_ae == IRDMA_AE_RDMAP_ROE_BAD_LLP_CLOSE ||
 	     last_ae == IRDMA_AE_BAD_CLOSE ||
-	     last_ae == IRDMA_AE_LLP_CONNECTION_RESET || iwdev->reset)) {
+	     last_ae == IRDMA_AE_LLP_CONNECTION_RESET || iwdev->rf->reset)) {
 		issue_close = 1;
 		iwqp->cm_id = NULL;
 		qp->term_flags = 0;
@@ -4250,7 +4250,7 @@ void irdma_cm_teardown_connections(struct irdma_device *iwdev, u32 *ipaddr,
 				       teardown_entry);
 		attr.qp_state = IB_QPS_ERR;
 		irdma_modify_qp(&cm_node->iwqp->ibqp, &attr, IB_QP_STATE, NULL);
-		if (iwdev->reset)
+		if (iwdev->rf->reset)
 			irdma_cm_disconn(cm_node->iwqp);
 		irdma_rem_ref_cm_node(cm_node);
 	}
diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 00de5ee9a260..33c06a3a4f63 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -1489,7 +1489,7 @@ void irdma_reinitialize_ieq(struct irdma_sc_vsi *vsi)
 
 	irdma_puda_dele_rsrc(vsi, IRDMA_PUDA_RSRC_TYPE_IEQ, false);
 	if (irdma_initialize_ieq(iwdev)) {
-		iwdev->reset = true;
+		iwdev->rf->reset = true;
 		rf->gen_ops.request_reset(rf);
 	}
 }
@@ -1632,13 +1632,13 @@ void irdma_rt_deinit_hw(struct irdma_device *iwdev)
 	case IEQ_CREATED:
 		if (!iwdev->roce_mode)
 			irdma_puda_dele_rsrc(&iwdev->vsi, IRDMA_PUDA_RSRC_TYPE_IEQ,
-					     iwdev->reset);
+					     iwdev->rf->reset);
 		fallthrough;
 	case ILQ_CREATED:
 		if (!iwdev->roce_mode)
 			irdma_puda_dele_rsrc(&iwdev->vsi,
 					     IRDMA_PUDA_RSRC_TYPE_ILQ,
-					     iwdev->reset);
+					     iwdev->rf->reset);
 		break;
 	default:
 		ibdev_warn(&iwdev->ibdev, "bad init_state = %d\n", iwdev->init_state);
diff --git a/drivers/infiniband/hw/irdma/i40iw_if.c b/drivers/infiniband/hw/irdma/i40iw_if.c
index bddf88194d09..d219f64b2c3d 100644
--- a/drivers/infiniband/hw/irdma/i40iw_if.c
+++ b/drivers/infiniband/hw/irdma/i40iw_if.c
@@ -55,7 +55,7 @@ static void i40iw_close(struct i40e_info *cdev_info, struct i40e_client *client,
 
 	iwdev = to_iwdev(ibdev);
 	if (reset)
-		iwdev->reset = true;
+		iwdev->rf->reset = true;
 
 	iwdev->iw_status = 0;
 	irdma_port_ibevent(iwdev);
diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
index 743d9e143a99..b678fe712447 100644
--- a/drivers/infiniband/hw/irdma/main.h
+++ b/drivers/infiniband/hw/irdma/main.h
@@ -346,7 +346,6 @@ struct irdma_device {
 	bool roce_mode:1;
 	bool roce_dcqcn_en:1;
 	bool dcb:1;
-	bool reset:1;
 	bool iw_ooo:1;
 	enum init_completion_state init_state;
 
diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index 5bbe44e54f9a..832e9604766b 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2510,7 +2510,7 @@ void irdma_modify_qp_to_err(struct irdma_sc_qp *sc_qp)
 	struct irdma_qp *qp = sc_qp->qp_uk.back_qp;
 	struct ib_qp_attr attr;
 
-	if (qp->iwdev->reset)
+	if (qp->iwdev->rf->reset)
 		return;
 	attr.qp_state = IB_QPS_ERR;
 
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 717147ed0519..6107f37321d2 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -535,8 +535,7 @@ static int irdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	irdma_qp_rem_ref(&iwqp->ibqp);
 	wait_for_completion(&iwqp->free_qp);
 	irdma_free_lsmm_rsrc(iwqp);
-	if (!iwdev->reset)
-		irdma_cqp_qp_destroy_cmd(&iwdev->rf->sc_dev, &iwqp->sc_qp);
+	irdma_cqp_qp_destroy_cmd(&iwdev->rf->sc_dev, &iwqp->sc_qp);
 
 	if (!iwqp->user_mode) {
 		if (iwqp->iwscq) {
-- 
2.33.0



