Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12505594633
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347383AbiHOWTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350345AbiHOWRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:17:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7925440BC6;
        Mon, 15 Aug 2022 12:41:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB6DFB80EB2;
        Mon, 15 Aug 2022 19:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEAAC433D6;
        Mon, 15 Aug 2022 19:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592454;
        bh=Jb5GjFZLTcVeXQn+3A9lDRbfEAoGBt20h7nDXicjZJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGHYfF0t6Jv1XGnDygHEnQYcJTyGZPPSjm8nbXrs00Eqx7CPy1EgkWqVi9pAa06ns
         1UYaqw0TkfsXsC3xsQCx6IsV/PA/XaG4P05l+/dVQy4vd5j8CY3Bvus/7xyIuKWEZq
         C5PbXx3J0lnIHPqm6y3XoIOAt3As8XOtrYSA0XE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0789/1095] RDMA/rxe: Fix rnr retry behavior
Date:   Mon, 15 Aug 2022 20:03:08 +0200
Message-Id: <20220815180501.875863590@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 445fd4f4fb76d513de6b05b08b3a4d0bb980fc80 ]

Currently the completer tasklet when retransmit timer or the rnr timer
fires the same flag (qp->req.need_retry) is set so that if either timer
fires it will attempt to perform a retry flow on the send queue.  This has
the effect of responding to an RNR NAK at the first retransmit timer event
which might not allow the requested rnr timeout.

This patch adds a new flag (qp->req.wait_for_rnr_timer) which, if set,
prevents a retry flow until the rnr nak timer fires.

This patch fixes rnr retry errors which can be observed by running the
pyverbs test_rdmacm_async_traffic_external_qp multiple times. With this
patch applied they do not occur.

Link: https://lore.kernel.org/linux-rdma/a8287823-1408-4273-bc22-99a0678db640@gmail.com/
Link: https://lore.kernel.org/linux-rdma/2bafda9e-2bb6-186d-12a1-179e8f6a2678@talpey.com/
Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20220630190425.2251-6-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c  |  8 +++++++-
 drivers/infiniband/sw/rxe/rxe_qp.c    |  1 +
 drivers/infiniband/sw/rxe/rxe_req.c   | 15 +++++++++++++--
 drivers/infiniband/sw/rxe/rxe_verbs.h |  1 +
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 138b3e7d3a5f..ec671e171f13 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -114,6 +114,8 @@ void retransmit_timer(struct timer_list *t)
 {
 	struct rxe_qp *qp = from_timer(qp, t, retrans_timer);
 
+	pr_debug("%s: fired for qp#%d\n", __func__, qp->elem.index);
+
 	if (qp->valid) {
 		qp->comp.timeout = 1;
 		rxe_run_task(&qp->comp.task, 1);
@@ -729,11 +731,15 @@ int rxe_completer(void *arg)
 			break;
 
 		case COMPST_RNR_RETRY:
+			/* we come here if we received an RNR NAK */
 			if (qp->comp.rnr_retry > 0) {
 				if (qp->comp.rnr_retry != 7)
 					qp->comp.rnr_retry--;
 
-				qp->req.need_retry = 1;
+				/* don't start a retry flow until the
+				 * rnr timer has fired
+				 */
+				qp->req.wait_for_rnr_timer = 1;
 				pr_debug("qp#%d set rnr nak timer\n",
 					 qp_num(qp));
 				mod_timer(&qp->rnr_nak_timer,
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 62acf890af6c..7d0c4432d3fd 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -513,6 +513,7 @@ static void rxe_qp_reset(struct rxe_qp *qp)
 	atomic_set(&qp->ssn, 0);
 	qp->req.opcode = -1;
 	qp->req.need_retry = 0;
+	qp->req.wait_for_rnr_timer = 0;
 	qp->req.noack_pkts = 0;
 	qp->resp.msn = 0;
 	qp->resp.opcode = -1;
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index d574c47099b8..90669b3c56af 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -103,7 +103,11 @@ void rnr_nak_timer(struct timer_list *t)
 {
 	struct rxe_qp *qp = from_timer(qp, t, rnr_nak_timer);
 
-	pr_debug("qp#%d rnr nak timer fired\n", qp_num(qp));
+	pr_debug("%s: fired for qp#%d\n", __func__, qp_num(qp));
+
+	/* request a send queue retry */
+	qp->req.need_retry = 1;
+	qp->req.wait_for_rnr_timer = 0;
 	rxe_run_task(&qp->req.task, 1);
 }
 
@@ -626,10 +630,17 @@ int rxe_requester(void *arg)
 		qp->req.need_rd_atomic = 0;
 		qp->req.wait_psn = 0;
 		qp->req.need_retry = 0;
+		qp->req.wait_for_rnr_timer = 0;
 		goto exit;
 	}
 
-	if (unlikely(qp->req.need_retry)) {
+	/* we come here if the retransmot timer has fired
+	 * or if the rnr timer has fired. If the retransmit
+	 * timer fires while we are processing an RNR NAK wait
+	 * until the rnr timer has fired before starting the
+	 * retry flow
+	 */
+	if (unlikely(qp->req.need_retry && !qp->req.wait_for_rnr_timer)) {
 		req_retry(qp);
 		qp->req.need_retry = 0;
 	}
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index e7eff1ca75e9..33e8d0547553 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -123,6 +123,7 @@ struct rxe_req_info {
 	int			need_rd_atomic;
 	int			wait_psn;
 	int			need_retry;
+	int			wait_for_rnr_timer;
 	int			noack_pkts;
 	struct rxe_task		task;
 };
-- 
2.35.1



