Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81685F29A0
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiJCHWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiJCHVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:21:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A181F635;
        Mon,  3 Oct 2022 00:16:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F58FB80E70;
        Mon,  3 Oct 2022 07:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94953C433D6;
        Mon,  3 Oct 2022 07:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781313;
        bh=g8ezt+zIuqYm6KOhw3hbjL5xc69Nj8LJANjkzGatBMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wN1e+CB67xIZwmePHSaFyH1EJD2rw6YVJw/r8Cjigfh/f7igxSa0ff2Og0Y23xxv8
         raamNsNqo9pE7ZXpdAHrI0UG41k34IqXczsL0AVpIHLlyFjjX+yRCsGW9tRNB3CLX/
         U7d7n+d1+5wwW5mJsI5mDFdWkglDMBmmvSuFehCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 075/101] cxgb4: fix missing unlock on ETHOFLD desc collect fail path
Date:   Mon,  3 Oct 2022 09:11:11 +0200
Message-Id: <20221003070726.328982280@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit c635ebe8d911a93bd849a9419b01a58783de76f1 ]

The label passed to the QDESC_GET for the ETHOFLD TXQ, RXQ, and FLQ, is the
'out' one, which skips the 'out_unlock' label, and thus doesn't unlock the
'uld_mutex' before returning. Additionally, since commit 5148e5950c67
("cxgb4: add EOTID tracking and software context dump"), the access to
these ETHOFLD hardware queues should be protected by the 'mqprio_mutex'
instead.

Fixes: 2d0cb84dd973 ("cxgb4: add ETHOFLD hardware queue support")
Fixes: 5148e5950c67 ("cxgb4: add EOTID tracking and software context dump")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Link: https://lore.kernel.org/r/20220922175109.764898-1-rafaelmendsr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 28 +++++++++++++------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index a7f291c89702..557c591a6ce3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -14,6 +14,7 @@
 #include "cudbg_entity.h"
 #include "cudbg_lib.h"
 #include "cudbg_zlib.h"
+#include "cxgb4_tc_mqprio.h"
 
 static const u32 t6_tp_pio_array[][IREG_NUM_ELEM] = {
 	{0x7e40, 0x7e44, 0x020, 28}, /* t6_tp_pio_regs_20_to_3b */
@@ -3458,7 +3459,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 			for (i = 0; i < utxq->ntxq; i++)
 				QDESC_GET_TXQ(&utxq->uldtxq[i].q,
 					      cudbg_uld_txq_to_qtype(j),
-					      out_unlock);
+					      out_unlock_uld);
 		}
 	}
 
@@ -3475,7 +3476,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 			for (i = 0; i < urxq->nrxq; i++)
 				QDESC_GET_RXQ(&urxq->uldrxq[i].rspq,
 					      cudbg_uld_rxq_to_qtype(j),
-					      out_unlock);
+					      out_unlock_uld);
 		}
 
 		/* ULD FLQ */
@@ -3487,7 +3488,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 			for (i = 0; i < urxq->nrxq; i++)
 				QDESC_GET_FLQ(&urxq->uldrxq[i].fl,
 					      cudbg_uld_flq_to_qtype(j),
-					      out_unlock);
+					      out_unlock_uld);
 		}
 
 		/* ULD CIQ */
@@ -3500,29 +3501,34 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 			for (i = 0; i < urxq->nciq; i++)
 				QDESC_GET_RXQ(&urxq->uldrxq[base + i].rspq,
 					      cudbg_uld_ciq_to_qtype(j),
-					      out_unlock);
+					      out_unlock_uld);
 		}
 	}
+	mutex_unlock(&uld_mutex);
+
+	if (!padap->tc_mqprio)
+		goto out;
 
+	mutex_lock(&padap->tc_mqprio->mqprio_mutex);
 	/* ETHOFLD TXQ */
 	if (s->eohw_txq)
 		for (i = 0; i < s->eoqsets; i++)
 			QDESC_GET_TXQ(&s->eohw_txq[i].q,
-				      CUDBG_QTYPE_ETHOFLD_TXQ, out);
+				      CUDBG_QTYPE_ETHOFLD_TXQ, out_unlock_mqprio);
 
 	/* ETHOFLD RXQ and FLQ */
 	if (s->eohw_rxq) {
 		for (i = 0; i < s->eoqsets; i++)
 			QDESC_GET_RXQ(&s->eohw_rxq[i].rspq,
-				      CUDBG_QTYPE_ETHOFLD_RXQ, out);
+				      CUDBG_QTYPE_ETHOFLD_RXQ, out_unlock_mqprio);
 
 		for (i = 0; i < s->eoqsets; i++)
 			QDESC_GET_FLQ(&s->eohw_rxq[i].fl,
-				      CUDBG_QTYPE_ETHOFLD_FLQ, out);
+				      CUDBG_QTYPE_ETHOFLD_FLQ, out_unlock_mqprio);
 	}
 
-out_unlock:
-	mutex_unlock(&uld_mutex);
+out_unlock_mqprio:
+	mutex_unlock(&padap->tc_mqprio->mqprio_mutex);
 
 out:
 	qdesc_info->qdesc_entry_size = sizeof(*qdesc_entry);
@@ -3559,6 +3565,10 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 #undef QDESC_GET
 
 	return rc;
+
+out_unlock_uld:
+	mutex_unlock(&uld_mutex);
+	goto out;
 }
 
 int cudbg_collect_flash(struct cudbg_init *pdbg_init,
-- 
2.35.1



