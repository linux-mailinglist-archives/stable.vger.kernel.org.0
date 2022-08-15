Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B842594282
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbiHOVvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349876AbiHOVsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:48:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119FF606B8;
        Mon, 15 Aug 2022 12:32:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2640461133;
        Mon, 15 Aug 2022 19:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D65C433C1;
        Mon, 15 Aug 2022 19:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591926;
        bh=cRcGwfrIuzA+tBZlDTT6JWtbArYGci7x41RI+xWkygM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3+KWOYgzLfiZ2g/LTKQPdRQkL3Y5OJI5A5HJnSLYpwgVc8R+dtwBBUzKkglzJm88
         efI7MXD9O2isrfneKHtJh+RlqyfXx/gJnpfmDsnl7zqpA5xy7zmGVtQT/QRGGXxy25
         x4Qy+c6d07530W1zioSRaTsNIosCnsikon3/i+dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jenny Hack <jhack@hpe.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0705/1095] RDMA/rxe: Fix deadlock in rxe_do_local_ops()
Date:   Mon, 15 Aug 2022 20:01:44 +0200
Message-Id: <20220815180458.543648823@linuxfoundation.org>
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
index 8a1cff80a68e..d574c47099b8 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -586,9 +586,11 @@ static int rxe_do_local_ops(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	wqe->status = IB_WC_SUCCESS;
 	qp->req.wqe_index = queue_next_index(qp->sq.queue, qp->req.wqe_index);
 
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



