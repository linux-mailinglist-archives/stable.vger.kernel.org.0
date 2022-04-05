Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5F14F349F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241732AbiDEJgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236080AbiDEI7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:59:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61FE255A7;
        Tue,  5 Apr 2022 01:53:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EE63B81BD9;
        Tue,  5 Apr 2022 08:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3150C385A1;
        Tue,  5 Apr 2022 08:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148799;
        bh=uZbSp/e8RnRyXsLlnieqg+hbOw+fz3mD3VWlhSBXOG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNNm1ne8S+MAp43Uxxn05bZp8IlYRK12KbekCQ6zM/eVm/Q9ATSFq9qxlz0DWJhLE
         EbghY0HXbekkSKkyhube6gE4EXt9IvI2FEI38+H/zLfbbmfS9TqP2Begeiu/V6TMZQ
         iQO0DSQpYoX6T5+Pe7mjcSoj5X4swZSdtLVSUeO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Yang <yangx.jy@fujitsu.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0486/1017] RDMA/rxe: Check the last packet by RXE_END_MASK
Date:   Tue,  5 Apr 2022 09:23:19 +0200
Message-Id: <20220405070408.724845173@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Yang <yangx.jy@fujitsu.com>

[ Upstream commit b1377cc37f6bebd57ce8747b7e16163a475af295 ]

It's wrong to check the last packet by RXE_COMP_MASK because the flag is
to indicate if responder needs to generate a completion.

Fixes: 9fcd67d1772c ("IB/rxe: increment msn only when completing a request")
Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20211229034438.1854908-1-yangx.jy@fujitsu.com
Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index e8f435fa6e4d..380934e38923 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -814,6 +814,10 @@ static enum resp_states execute(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
 			return RESPST_ERR_INVALIDATE_RKEY;
 	}
 
+	if (pkt->mask & RXE_END_MASK)
+		/* We successfully processed this new request. */
+		qp->resp.msn++;
+
 	/* next expected psn, read handles this separately */
 	qp->resp.psn = (pkt->psn + 1) & BTH_PSN_MASK;
 	qp->resp.ack_psn = qp->resp.psn;
@@ -821,11 +825,9 @@ static enum resp_states execute(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
 	qp->resp.opcode = pkt->opcode;
 	qp->resp.status = IB_WC_SUCCESS;
 
-	if (pkt->mask & RXE_COMP_MASK) {
-		/* We successfully processed this new request. */
-		qp->resp.msn++;
+	if (pkt->mask & RXE_COMP_MASK)
 		return RESPST_COMPLETE;
-	} else if (qp_type(qp) == IB_QPT_RC)
+	else if (qp_type(qp) == IB_QPT_RC)
 		return RESPST_ACKNOWLEDGE;
 	else
 		return RESPST_CLEANUP;
-- 
2.34.1



