Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638E360ABEB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbiJXN7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237050AbiJXN7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:59:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AC07F247;
        Mon, 24 Oct 2022 05:46:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B3786134B;
        Mon, 24 Oct 2022 12:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA36C433D6;
        Mon, 24 Oct 2022 12:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615586;
        bh=rfi8zWtM/ki3ZWFA+yFjT9l/uoyGt+P8QhJjKAkOuE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1ObVR2Pcy5LOttfcwk+SyjSnXiIR/mIathqEVpBnKDfb60+K8QauSxW5R/OlMngy
         xioJwTenPQEfY5nvAsS3UR9e0nlRZNv9fgKfbQYw4tISXpBBl5E0qOi+bWuPQPNtnw
         K6Hx+jfytMKxmwqadNOpaJOa18ubiPpXCC5NhTGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sindhu-Devale <sindhu.devale@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 308/530] RDMA/irdma: Align AE id codes to correct flush code and event
Date:   Mon, 24 Oct 2022 13:30:52 +0200
Message-Id: <20221024113058.995060886@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sindhu-Devale <sindhu.devale@intel.com>

[ Upstream commit 7f51a961f8c6b84752a48e950074a8c4a0808d91 ]

A number of asynchronous event (AE) ids were not aligned to the
correct flush_code and event_type. Fix these up so that the
correct IBV error and event codes are returned to application.

Also, add handling for new AE ids like IRDMA_AE_INVALID_REQUEST to
return the correct WC error code.

Fixes: 44d9e52977a1 ("RDMA/irdma: Implement device initialization definitions")
Signed-off-by: Sindhu-Devale <sindhu.devale@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20220907191324.1173-2-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/defs.h  |  1 +
 drivers/infiniband/hw/irdma/hw.c    | 51 +++++++++++++++++------------
 drivers/infiniband/hw/irdma/type.h  |  1 +
 drivers/infiniband/hw/irdma/user.h  |  1 +
 drivers/infiniband/hw/irdma/utils.c |  3 ++
 drivers/infiniband/hw/irdma/verbs.c |  2 ++
 6 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/defs.h b/drivers/infiniband/hw/irdma/defs.h
index cc3d9a365b35..b8c10a6ccede 100644
--- a/drivers/infiniband/hw/irdma/defs.h
+++ b/drivers/infiniband/hw/irdma/defs.h
@@ -314,6 +314,7 @@ enum irdma_cqp_op_type {
 #define IRDMA_AE_IB_REMOTE_ACCESS_ERROR					0x020d
 #define IRDMA_AE_IB_REMOTE_OP_ERROR					0x020e
 #define IRDMA_AE_WQE_LSMM_TOO_LONG					0x0220
+#define IRDMA_AE_INVALID_REQUEST					0x0223
 #define IRDMA_AE_DDP_INVALID_MSN_GAP_IN_MSN				0x0301
 #define IRDMA_AE_DDP_UBE_DDP_MESSAGE_TOO_LONG_FOR_AVAILABLE_BUFFER	0x0303
 #define IRDMA_AE_DDP_UBE_INVALID_DDP_VERSION				0x0304
diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 3d5d3f8d5ded..c14f19cff534 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -138,59 +138,68 @@ static void irdma_set_flush_fields(struct irdma_sc_qp *qp,
 	qp->event_type = IRDMA_QP_EVENT_CATASTROPHIC;
 
 	switch (info->ae_id) {
-	case IRDMA_AE_AMP_UNALLOCATED_STAG:
 	case IRDMA_AE_AMP_BOUNDS_VIOLATION:
 	case IRDMA_AE_AMP_INVALID_STAG:
-		qp->event_type = IRDMA_QP_EVENT_ACCESS_ERR;
-		fallthrough;
+	case IRDMA_AE_AMP_RIGHTS_VIOLATION:
+	case IRDMA_AE_AMP_UNALLOCATED_STAG:
 	case IRDMA_AE_AMP_BAD_PD:
-	case IRDMA_AE_UDA_XMIT_BAD_PD:
+	case IRDMA_AE_AMP_BAD_QP:
+	case IRDMA_AE_AMP_BAD_STAG_KEY:
+	case IRDMA_AE_AMP_BAD_STAG_INDEX:
+	case IRDMA_AE_AMP_TO_WRAP:
+	case IRDMA_AE_PRIV_OPERATION_DENIED:
 		qp->flush_code = FLUSH_PROT_ERR;
+		qp->event_type = IRDMA_QP_EVENT_ACCESS_ERR;
 		break;
-	case IRDMA_AE_AMP_BAD_QP:
+	case IRDMA_AE_UDA_XMIT_BAD_PD:
 	case IRDMA_AE_WQE_UNEXPECTED_OPCODE:
 		qp->flush_code = FLUSH_LOC_QP_OP_ERR;
+		qp->event_type = IRDMA_QP_EVENT_CATASTROPHIC;
+		break;
+	case IRDMA_AE_UDA_XMIT_DGRAM_TOO_LONG:
+	case IRDMA_AE_UDA_XMIT_DGRAM_TOO_SHORT:
+	case IRDMA_AE_UDA_L4LEN_INVALID:
+	case IRDMA_AE_DDP_UBE_INVALID_MO:
+	case IRDMA_AE_DDP_UBE_DDP_MESSAGE_TOO_LONG_FOR_AVAILABLE_BUFFER:
+		qp->flush_code = FLUSH_LOC_LEN_ERR;
+		qp->event_type = IRDMA_QP_EVENT_CATASTROPHIC;
 		break;
-	case IRDMA_AE_AMP_BAD_STAG_KEY:
-	case IRDMA_AE_AMP_BAD_STAG_INDEX:
-	case IRDMA_AE_AMP_TO_WRAP:
-	case IRDMA_AE_AMP_RIGHTS_VIOLATION:
 	case IRDMA_AE_AMP_INVALIDATE_NO_REMOTE_ACCESS_RIGHTS:
-	case IRDMA_AE_PRIV_OPERATION_DENIED:
-	case IRDMA_AE_IB_INVALID_REQUEST:
 	case IRDMA_AE_IB_REMOTE_ACCESS_ERROR:
 		qp->flush_code = FLUSH_REM_ACCESS_ERR;
 		qp->event_type = IRDMA_QP_EVENT_ACCESS_ERR;
 		break;
 	case IRDMA_AE_LLP_SEGMENT_TOO_SMALL:
-	case IRDMA_AE_DDP_UBE_DDP_MESSAGE_TOO_LONG_FOR_AVAILABLE_BUFFER:
-	case IRDMA_AE_UDA_XMIT_DGRAM_TOO_LONG:
-	case IRDMA_AE_UDA_XMIT_DGRAM_TOO_SHORT:
-	case IRDMA_AE_UDA_L4LEN_INVALID:
+	case IRDMA_AE_LLP_RECEIVED_MPA_CRC_ERROR:
 	case IRDMA_AE_ROCE_RSP_LENGTH_ERROR:
-		qp->flush_code = FLUSH_LOC_LEN_ERR;
+	case IRDMA_AE_IB_REMOTE_OP_ERROR:
+		qp->flush_code = FLUSH_REM_OP_ERR;
+		qp->event_type = IRDMA_QP_EVENT_CATASTROPHIC;
 		break;
 	case IRDMA_AE_LCE_QP_CATASTROPHIC:
 		qp->flush_code = FLUSH_FATAL_ERR;
+		qp->event_type = IRDMA_QP_EVENT_CATASTROPHIC;
 		break;
-	case IRDMA_AE_DDP_UBE_INVALID_MO:
 	case IRDMA_AE_IB_RREQ_AND_Q1_FULL:
-	case IRDMA_AE_LLP_RECEIVED_MPA_CRC_ERROR:
 		qp->flush_code = FLUSH_GENERAL_ERR;
 		break;
 	case IRDMA_AE_LLP_TOO_MANY_RETRIES:
 		qp->flush_code = FLUSH_RETRY_EXC_ERR;
+		qp->event_type = IRDMA_QP_EVENT_CATASTROPHIC;
 		break;
 	case IRDMA_AE_AMP_MWBIND_INVALID_RIGHTS:
 	case IRDMA_AE_AMP_MWBIND_BIND_DISABLED:
 	case IRDMA_AE_AMP_MWBIND_INVALID_BOUNDS:
 		qp->flush_code = FLUSH_MW_BIND_ERR;
+		qp->event_type = IRDMA_QP_EVENT_ACCESS_ERR;
 		break;
-	case IRDMA_AE_IB_REMOTE_OP_ERROR:
-		qp->flush_code = FLUSH_REM_OP_ERR;
+	case IRDMA_AE_IB_INVALID_REQUEST:
+		qp->flush_code = FLUSH_REM_INV_REQ_ERR;
+		qp->event_type = IRDMA_QP_EVENT_REQ_ERR;
 		break;
 	default:
-		qp->flush_code = FLUSH_FATAL_ERR;
+		qp->flush_code = FLUSH_GENERAL_ERR;
+		qp->event_type = IRDMA_QP_EVENT_CATASTROPHIC;
 		break;
 	}
 }
diff --git a/drivers/infiniband/hw/irdma/type.h b/drivers/infiniband/hw/irdma/type.h
index 874bc25a938b..1241e5988c10 100644
--- a/drivers/infiniband/hw/irdma/type.h
+++ b/drivers/infiniband/hw/irdma/type.h
@@ -99,6 +99,7 @@ enum irdma_term_mpa_errors {
 enum irdma_qp_event_type {
 	IRDMA_QP_EVENT_CATASTROPHIC,
 	IRDMA_QP_EVENT_ACCESS_ERR,
+	IRDMA_QP_EVENT_REQ_ERR,
 };
 
 enum irdma_hw_stats_index_32b {
diff --git a/drivers/infiniband/hw/irdma/user.h b/drivers/infiniband/hw/irdma/user.h
index 3dcbb1fbf2c6..7c3cb4288969 100644
--- a/drivers/infiniband/hw/irdma/user.h
+++ b/drivers/infiniband/hw/irdma/user.h
@@ -104,6 +104,7 @@ enum irdma_flush_opcode {
 	FLUSH_FATAL_ERR,
 	FLUSH_RETRY_EXC_ERR,
 	FLUSH_MW_BIND_ERR,
+	FLUSH_REM_INV_REQ_ERR,
 };
 
 enum irdma_cmpl_status {
diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index 85d4212f59db..db7d0a300069 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2535,6 +2535,9 @@ void irdma_ib_qp_event(struct irdma_qp *iwqp, enum irdma_qp_event_type event)
 	case IRDMA_QP_EVENT_ACCESS_ERR:
 		ibevent.event = IB_EVENT_QP_ACCESS_ERR;
 		break;
+	case IRDMA_QP_EVENT_REQ_ERR:
+		ibevent.event = IB_EVENT_QP_REQ_ERR;
+		break;
 	}
 	ibevent.device = iwqp->ibqp.device;
 	ibevent.element.qp = &iwqp->ibqp;
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 5275616398d8..911902d2b93e 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3359,6 +3359,8 @@ static enum ib_wc_status irdma_flush_err_to_ib_wc_status(enum irdma_flush_opcode
 		return IB_WC_RETRY_EXC_ERR;
 	case FLUSH_MW_BIND_ERR:
 		return IB_WC_MW_BIND_ERR;
+	case FLUSH_REM_INV_REQ_ERR:
+		return IB_WC_REM_INV_REQ_ERR;
 	case FLUSH_FATAL_ERR:
 	default:
 		return IB_WC_FATAL_ERR;
-- 
2.35.1



