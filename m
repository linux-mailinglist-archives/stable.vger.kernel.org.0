Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936D2593955
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241222AbiHOTM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241407AbiHOTJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:09:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C900EE1C;
        Mon, 15 Aug 2022 11:36:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C540DB8105D;
        Mon, 15 Aug 2022 18:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2711FC433C1;
        Mon, 15 Aug 2022 18:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588581;
        bh=9x+bpN8wLnOjkwbTRQPKw8W/hBE2mJhuV0IMW/PEOQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AS8tG0p3jli8Tw7jmRQPqUWPQAhxly1Eb3TzZsafisIEqeqs3yVntgBqLE71l4d45
         BcQl5fdqoNclYMso2PcIrJNzQwpfFT4BqUun6p3X3Y2tcGKvvUokExFnlDwxORfPqF
         HaRByIgh2aM9wZNBtqUCX8nu2sdxi4D6pnt3Z9zE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jenny Hack <jhack@hpe.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 449/779] RDMA/rxe: Fix deadlock in rxe_do_local_ops()
Date:   Mon, 15 Aug 2022 20:01:33 +0200
Message-Id: <20220815180356.477304299@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

[ Upstream commit 7cb33d1bc1ac8e51fd88928f96674d392f8e07c4 ]

When a local operation (invalidate mr, reg mr, bind mw) is finished there
will be no ack packet coming from a responder to cause the wqe to be
completed. This may happen anyway if a subsequent wqe performs
IO. Currently if the wqe is signalled the completer tasklet is scheduled
immediately but not otherwise.

This leads to a deadlock if the next wqe has the fence bit set in send
flags and the operation is not signalled. This patch removes the condition
that the wqe must be signalled in order to schedule the completer tasklet
which is the simplest fix for this deadlock and is fairly low cost. This
is the analog for local operations of always setting the ackreq bit in all
last or only request packets even if the operation is not signalled.

Link: https://lore.kernel.org/r/20220523223251.15350-1-rpearsonhpe@gmail.com
Reported-by: Jenny Hack <jhack@hpe.com>
Fixes: c1a411268a4b ("RDMA/rxe: Move local ops to subroutine")
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 7812e3d6a6c2..4ea9319f0d52 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -612,9 +612,11 @@ static int rxe_do_local_ops(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	wqe->status = IB_WC_SUCCESS;
 	qp->req.wqe_index = next_index(qp->sq.queue, qp->req.wqe_index);
 
-	if ((wqe->wr.send_flags & IB_SEND_SIGNALED) ||
-	    qp->sq_sig_type == IB_SIGNAL_ALL_WR)
-		rxe_run_task(&qp->comp.task, 1);
+	/* There is no ack coming for local work requests
+	 * which can lead to a deadlock. So go ahead and complete
+	 * it now.
+	 */
+	rxe_run_task(&qp->comp.task, 1);
 
 	return 0;
 }
-- 
2.35.1



