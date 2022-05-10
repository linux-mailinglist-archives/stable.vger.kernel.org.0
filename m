Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FBE521AB1
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244583AbiEJOD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245384AbiEJN5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:57:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA50BA99A;
        Tue, 10 May 2022 06:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2FC9615E9;
        Tue, 10 May 2022 13:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28F3C385A6;
        Tue, 10 May 2022 13:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189955;
        bh=Npll0bIzELg7Cimq0/UJWbziWMNdzG1D97DZlEZJQ9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNPHuRS+t372bNTfwy4zOjxVLZ8zFoE5/0Z2FXbxZ/QpC72NhgruVcTqF0Tmzbk44
         sO5+vX0bHG2GqIPepGobegzw8lzPLTn/96WmCyQtW4/IjmJaUNJB80treqwBlRZLdN
         cLFj25D3SRCqMgdsTR7oDuBRQJFGsH6IpYFfPeu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.17 080/140] RDMA/irdma: Flush iWARP QP if modified to ERR from RTR state
Date:   Tue, 10 May 2022 15:07:50 +0200
Message-Id: <20220510130743.901483246@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tatyana Nikolova <tatyana.e.nikolova@intel.com>

commit 7b8943b821bafab492f43aafbd006b57c6b65845 upstream.

When connection establishment fails in iWARP mode, an app can drain the
QPs and hang because flush isn't issued when the QP is modified from RTR
state to error. Issue a flush in this case using function
irdma_cm_disconn().

Update irdma_cm_disconn() to do flush when cm_id is NULL, which is the
case when the QP is in RTR state and there is an error in the connection
establishment.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Link: https://lore.kernel.org/r/20220425181703.1634-2-shiraz.saleem@intel.com
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/irdma/cm.c    |   16 +++++-----------
 drivers/infiniband/hw/irdma/verbs.c |    4 ++--
 2 files changed, 7 insertions(+), 13 deletions(-)

--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -3465,12 +3465,6 @@ static void irdma_cm_disconn_true(struct
 	}
 
 	cm_id = iwqp->cm_id;
-	/* make sure we havent already closed this connection */
-	if (!cm_id) {
-		spin_unlock_irqrestore(&iwqp->lock, flags);
-		return;
-	}
-
 	original_hw_tcp_state = iwqp->hw_tcp_state;
 	original_ibqp_state = iwqp->ibqp_state;
 	last_ae = iwqp->last_aeq;
@@ -3492,11 +3486,11 @@ static void irdma_cm_disconn_true(struct
 			disconn_status = -ECONNRESET;
 	}
 
-	if ((original_hw_tcp_state == IRDMA_TCP_STATE_CLOSED ||
-	     original_hw_tcp_state == IRDMA_TCP_STATE_TIME_WAIT ||
-	     last_ae == IRDMA_AE_RDMAP_ROE_BAD_LLP_CLOSE ||
-	     last_ae == IRDMA_AE_BAD_CLOSE ||
-	     last_ae == IRDMA_AE_LLP_CONNECTION_RESET || iwdev->rf->reset)) {
+	if (original_hw_tcp_state == IRDMA_TCP_STATE_CLOSED ||
+	    original_hw_tcp_state == IRDMA_TCP_STATE_TIME_WAIT ||
+	    last_ae == IRDMA_AE_RDMAP_ROE_BAD_LLP_CLOSE ||
+	    last_ae == IRDMA_AE_BAD_CLOSE ||
+	    last_ae == IRDMA_AE_LLP_CONNECTION_RESET || iwdev->rf->reset || !cm_id) {
 		issue_close = 1;
 		iwqp->cm_id = NULL;
 		qp->term_flags = 0;
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1620,13 +1620,13 @@ int irdma_modify_qp(struct ib_qp *ibqp,
 
 	if (issue_modify_qp && iwqp->ibqp_state > IB_QPS_RTS) {
 		if (dont_wait) {
-			if (iwqp->cm_id && iwqp->hw_tcp_state) {
+			if (iwqp->hw_tcp_state) {
 				spin_lock_irqsave(&iwqp->lock, flags);
 				iwqp->hw_tcp_state = IRDMA_TCP_STATE_CLOSED;
 				iwqp->last_aeq = IRDMA_AE_RESET_SENT;
 				spin_unlock_irqrestore(&iwqp->lock, flags);
-				irdma_cm_disconn(iwqp);
 			}
+			irdma_cm_disconn(iwqp);
 		} else {
 			int close_timer_started;
 


