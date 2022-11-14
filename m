Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB7F627FED
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237707AbiKNNCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbiKNNCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:02:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160D229379
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:02:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 289B96117F
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3755CC433D6;
        Mon, 14 Nov 2022 13:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430954;
        bh=XakzJafjnFCfmrPdIS3umIchry8nwl6BLOoOu94Gd6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sru/ATQNq/CFw3p4KLMExMl43NtTE95+OZ5bZ+iX5kRRpb8tWaUKY43GNYCiXI23C
         qvRpyGcN9oJe2haTc6682pZnkhNZo92XSrGB/KXVLkD7rNz6Cvu6ZKGBbzm271XJLJ
         vay9+pLYoGuxoWknuqQkInGaHJCT6BCUuky6ff6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ratheesh Kannoth <rkannoth@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 039/190] octeontx2-pf: NIX TX overwrites SQ_CTX_HW_S[SQ_INT]
Date:   Mon, 14 Nov 2022 13:44:23 +0100
Message-Id: <20221114124500.491015609@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit 51afe9026d0c63263abe9840e629f118d7405b36 ]

In scenarios where multiple errors have occurred
for a SQ before SW starts handling error interrupt,
SQ_CTX[OP_INT] may get overwritten leading to
NIX_LF_SQ_OP_INT returning incorrect value.
To workaround this read LMT, MNQ and SQ individual
error status registers to determine the cause of error.

Fixes: 4ff7d1488a84 ("octeontx2-pf: Error handling support")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 135 ++++++++++++++----
 .../marvell/octeontx2/nic/otx2_struct.h       |  57 ++++++++
 2 files changed, 162 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 9376d0e62914..80fde101df96 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -15,6 +15,7 @@
 #include <net/ip.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <linux/bitfield.h>
 
 #include "otx2_reg.h"
 #include "otx2_common.h"
@@ -1161,6 +1162,59 @@ int otx2_set_real_num_queues(struct net_device *netdev,
 }
 EXPORT_SYMBOL(otx2_set_real_num_queues);
 
+static char *nix_sqoperr_e_str[NIX_SQOPERR_MAX] = {
+	"NIX_SQOPERR_OOR",
+	"NIX_SQOPERR_CTX_FAULT",
+	"NIX_SQOPERR_CTX_POISON",
+	"NIX_SQOPERR_DISABLED",
+	"NIX_SQOPERR_SIZE_ERR",
+	"NIX_SQOPERR_OFLOW",
+	"NIX_SQOPERR_SQB_NULL",
+	"NIX_SQOPERR_SQB_FAULT",
+	"NIX_SQOPERR_SQE_SZ_ZERO",
+};
+
+static char *nix_mnqerr_e_str[NIX_MNQERR_MAX] = {
+	"NIX_MNQERR_SQ_CTX_FAULT",
+	"NIX_MNQERR_SQ_CTX_POISON",
+	"NIX_MNQERR_SQB_FAULT",
+	"NIX_MNQERR_SQB_POISON",
+	"NIX_MNQERR_TOTAL_ERR",
+	"NIX_MNQERR_LSO_ERR",
+	"NIX_MNQERR_CQ_QUERY_ERR",
+	"NIX_MNQERR_MAX_SQE_SIZE_ERR",
+	"NIX_MNQERR_MAXLEN_ERR",
+	"NIX_MNQERR_SQE_SIZEM1_ZERO",
+};
+
+static char *nix_snd_status_e_str[NIX_SND_STATUS_MAX] =  {
+	"NIX_SND_STATUS_GOOD",
+	"NIX_SND_STATUS_SQ_CTX_FAULT",
+	"NIX_SND_STATUS_SQ_CTX_POISON",
+	"NIX_SND_STATUS_SQB_FAULT",
+	"NIX_SND_STATUS_SQB_POISON",
+	"NIX_SND_STATUS_HDR_ERR",
+	"NIX_SND_STATUS_EXT_ERR",
+	"NIX_SND_STATUS_JUMP_FAULT",
+	"NIX_SND_STATUS_JUMP_POISON",
+	"NIX_SND_STATUS_CRC_ERR",
+	"NIX_SND_STATUS_IMM_ERR",
+	"NIX_SND_STATUS_SG_ERR",
+	"NIX_SND_STATUS_MEM_ERR",
+	"NIX_SND_STATUS_INVALID_SUBDC",
+	"NIX_SND_STATUS_SUBDC_ORDER_ERR",
+	"NIX_SND_STATUS_DATA_FAULT",
+	"NIX_SND_STATUS_DATA_POISON",
+	"NIX_SND_STATUS_NPC_DROP_ACTION",
+	"NIX_SND_STATUS_LOCK_VIOL",
+	"NIX_SND_STATUS_NPC_UCAST_CHAN_ERR",
+	"NIX_SND_STATUS_NPC_MCAST_CHAN_ERR",
+	"NIX_SND_STATUS_NPC_MCAST_ABORT",
+	"NIX_SND_STATUS_NPC_VTAG_PTR_ERR",
+	"NIX_SND_STATUS_NPC_VTAG_SIZE_ERR",
+	"NIX_SND_STATUS_SEND_STATS_ERR",
+};
+
 static irqreturn_t otx2_q_intr_handler(int irq, void *data)
 {
 	struct otx2_nic *pf = data;
@@ -1194,46 +1248,67 @@ static irqreturn_t otx2_q_intr_handler(int irq, void *data)
 
 	/* SQ */
 	for (qidx = 0; qidx < pf->hw.tot_tx_queues; qidx++) {
+		u64 sq_op_err_dbg, mnq_err_dbg, snd_err_dbg;
+		u8 sq_op_err_code, mnq_err_code, snd_err_code;
+
+		/* Below debug registers captures first errors corresponding to
+		 * those registers. We don't have to check against SQ qid as
+		 * these are fatal errors.
+		 */
+
 		ptr = otx2_get_regaddr(pf, NIX_LF_SQ_OP_INT);
 		val = otx2_atomic64_add((qidx << 44), ptr);
 		otx2_write64(pf, NIX_LF_SQ_OP_INT, (qidx << 44) |
 			     (val & NIX_SQINT_BITS));
 
-		if (!(val & (NIX_SQINT_BITS | BIT_ULL(42))))
-			continue;
-
 		if (val & BIT_ULL(42)) {
 			netdev_err(pf->netdev, "SQ%lld: error reading NIX_LF_SQ_OP_INT, NIX_LF_ERR_INT 0x%llx\n",
 				   qidx, otx2_read64(pf, NIX_LF_ERR_INT));
-		} else {
-			if (val & BIT_ULL(NIX_SQINT_LMT_ERR)) {
-				netdev_err(pf->netdev, "SQ%lld: LMT store error NIX_LF_SQ_OP_ERR_DBG:0x%llx",
-					   qidx,
-					   otx2_read64(pf,
-						       NIX_LF_SQ_OP_ERR_DBG));
-				otx2_write64(pf, NIX_LF_SQ_OP_ERR_DBG,
-					     BIT_ULL(44));
-			}
-			if (val & BIT_ULL(NIX_SQINT_MNQ_ERR)) {
-				netdev_err(pf->netdev, "SQ%lld: Meta-descriptor enqueue error NIX_LF_MNQ_ERR_DGB:0x%llx\n",
-					   qidx,
-					   otx2_read64(pf, NIX_LF_MNQ_ERR_DBG));
-				otx2_write64(pf, NIX_LF_MNQ_ERR_DBG,
-					     BIT_ULL(44));
-			}
-			if (val & BIT_ULL(NIX_SQINT_SEND_ERR)) {
-				netdev_err(pf->netdev, "SQ%lld: Send error, NIX_LF_SEND_ERR_DBG 0x%llx",
-					   qidx,
-					   otx2_read64(pf,
-						       NIX_LF_SEND_ERR_DBG));
-				otx2_write64(pf, NIX_LF_SEND_ERR_DBG,
-					     BIT_ULL(44));
-			}
-			if (val & BIT_ULL(NIX_SQINT_SQB_ALLOC_FAIL))
-				netdev_err(pf->netdev, "SQ%lld: SQB allocation failed",
-					   qidx);
+			goto done;
 		}
 
+		sq_op_err_dbg = otx2_read64(pf, NIX_LF_SQ_OP_ERR_DBG);
+		if (!(sq_op_err_dbg & BIT(44)))
+			goto chk_mnq_err_dbg;
+
+		sq_op_err_code = FIELD_GET(GENMASK(7, 0), sq_op_err_dbg);
+		netdev_err(pf->netdev, "SQ%lld: NIX_LF_SQ_OP_ERR_DBG(%llx)  err=%s\n",
+			   qidx, sq_op_err_dbg, nix_sqoperr_e_str[sq_op_err_code]);
+
+		otx2_write64(pf, NIX_LF_SQ_OP_ERR_DBG, BIT_ULL(44));
+
+		if (sq_op_err_code == NIX_SQOPERR_SQB_NULL)
+			goto chk_mnq_err_dbg;
+
+		/* Err is not NIX_SQOPERR_SQB_NULL, call aq function to read SQ structure.
+		 * TODO: But we are in irq context. How to call mbox functions which does sleep
+		 */
+
+chk_mnq_err_dbg:
+		mnq_err_dbg = otx2_read64(pf, NIX_LF_MNQ_ERR_DBG);
+		if (!(mnq_err_dbg & BIT(44)))
+			goto chk_snd_err_dbg;
+
+		mnq_err_code = FIELD_GET(GENMASK(7, 0), mnq_err_dbg);
+		netdev_err(pf->netdev, "SQ%lld: NIX_LF_MNQ_ERR_DBG(%llx)  err=%s\n",
+			   qidx, mnq_err_dbg,  nix_mnqerr_e_str[mnq_err_code]);
+		otx2_write64(pf, NIX_LF_MNQ_ERR_DBG, BIT_ULL(44));
+
+chk_snd_err_dbg:
+		snd_err_dbg = otx2_read64(pf, NIX_LF_SEND_ERR_DBG);
+		if (snd_err_dbg & BIT(44)) {
+			snd_err_code = FIELD_GET(GENMASK(7, 0), snd_err_dbg);
+			netdev_err(pf->netdev, "SQ%lld: NIX_LF_SND_ERR_DBG:0x%llx err=%s\n",
+				   qidx, snd_err_dbg, nix_snd_status_e_str[snd_err_code]);
+			otx2_write64(pf, NIX_LF_SEND_ERR_DBG, BIT_ULL(44));
+		}
+
+done:
+		/* Print values and reset */
+		if (val & BIT_ULL(NIX_SQINT_SQB_ALLOC_FAIL))
+			netdev_err(pf->netdev, "SQ%lld: SQB allocation failed",
+				   qidx);
+
 		schedule_work(&pf->reset_task);
 	}
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
index 4bbd12ff26e6..e5f30fd778fc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
@@ -274,4 +274,61 @@ enum nix_sqint_e {
 			BIT_ULL(NIX_SQINT_SEND_ERR) | \
 			BIT_ULL(NIX_SQINT_SQB_ALLOC_FAIL))
 
+enum nix_sqoperr_e {
+	NIX_SQOPERR_OOR = 0,
+	NIX_SQOPERR_CTX_FAULT = 1,
+	NIX_SQOPERR_CTX_POISON = 2,
+	NIX_SQOPERR_DISABLED = 3,
+	NIX_SQOPERR_SIZE_ERR = 4,
+	NIX_SQOPERR_OFLOW = 5,
+	NIX_SQOPERR_SQB_NULL = 6,
+	NIX_SQOPERR_SQB_FAULT = 7,
+	NIX_SQOPERR_SQE_SZ_ZERO = 8,
+	NIX_SQOPERR_MAX,
+};
+
+enum nix_mnqerr_e {
+	NIX_MNQERR_SQ_CTX_FAULT = 0,
+	NIX_MNQERR_SQ_CTX_POISON = 1,
+	NIX_MNQERR_SQB_FAULT = 2,
+	NIX_MNQERR_SQB_POISON = 3,
+	NIX_MNQERR_TOTAL_ERR = 4,
+	NIX_MNQERR_LSO_ERR = 5,
+	NIX_MNQERR_CQ_QUERY_ERR = 6,
+	NIX_MNQERR_MAX_SQE_SIZE_ERR = 7,
+	NIX_MNQERR_MAXLEN_ERR = 8,
+	NIX_MNQERR_SQE_SIZEM1_ZERO = 9,
+	NIX_MNQERR_MAX,
+};
+
+enum nix_snd_status_e {
+	NIX_SND_STATUS_GOOD = 0x0,
+	NIX_SND_STATUS_SQ_CTX_FAULT = 0x1,
+	NIX_SND_STATUS_SQ_CTX_POISON = 0x2,
+	NIX_SND_STATUS_SQB_FAULT = 0x3,
+	NIX_SND_STATUS_SQB_POISON = 0x4,
+	NIX_SND_STATUS_HDR_ERR = 0x5,
+	NIX_SND_STATUS_EXT_ERR = 0x6,
+	NIX_SND_STATUS_JUMP_FAULT = 0x7,
+	NIX_SND_STATUS_JUMP_POISON = 0x8,
+	NIX_SND_STATUS_CRC_ERR = 0x9,
+	NIX_SND_STATUS_IMM_ERR = 0x10,
+	NIX_SND_STATUS_SG_ERR = 0x11,
+	NIX_SND_STATUS_MEM_ERR = 0x12,
+	NIX_SND_STATUS_INVALID_SUBDC = 0x13,
+	NIX_SND_STATUS_SUBDC_ORDER_ERR = 0x14,
+	NIX_SND_STATUS_DATA_FAULT = 0x15,
+	NIX_SND_STATUS_DATA_POISON = 0x16,
+	NIX_SND_STATUS_NPC_DROP_ACTION = 0x17,
+	NIX_SND_STATUS_LOCK_VIOL = 0x18,
+	NIX_SND_STATUS_NPC_UCAST_CHAN_ERR = 0x19,
+	NIX_SND_STATUS_NPC_MCAST_CHAN_ERR = 0x20,
+	NIX_SND_STATUS_NPC_MCAST_ABORT = 0x21,
+	NIX_SND_STATUS_NPC_VTAG_PTR_ERR = 0x22,
+	NIX_SND_STATUS_NPC_VTAG_SIZE_ERR = 0x23,
+	NIX_SND_STATUS_SEND_MEM_FAULT = 0x24,
+	NIX_SND_STATUS_SEND_STATS_ERR = 0x25,
+	NIX_SND_STATUS_MAX,
+};
+
 #endif /* OTX2_STRUCT_H */
-- 
2.35.1



