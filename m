Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08F05939DC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245513AbiHOT24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245752AbiHOT0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:26:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20042E692;
        Mon, 15 Aug 2022 11:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63BCBB8105C;
        Mon, 15 Aug 2022 18:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E05CC433D6;
        Mon, 15 Aug 2022 18:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588888;
        bh=YcOJxycpi4cPibHqtgkK5q4CTB0pAgpHo75/oWB9Fpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLYqUmF6bdWXvoJ40Rsa4CKDRbBXRc6LXSrnrRqA66HfcyxaBWYEg9QdiecQx8a4e
         lPG99oYUC4Kgo0Nz4gLA1K9gs5EaWnl71UWmz6BRpfWc2NW/LAEqIIKEUR+pl09sqj
         HG7YESjfgUcqTrFy9uIj/2J3jxGUpUdO0o9ZYpxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+833061116fa28df97f3b@syzkaller.appspotmail.com,
        Zhu Yanjun <yanjun.zhu@linux.dev>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 546/779] RDMA/rxe: Fix error unwind in rxe_create_qp()
Date:   Mon, 15 Aug 2022 20:03:10 +0200
Message-Id: <20220815180400.648278997@linuxfoundation.org>
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

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit fd5382c5805c4bcb50fd25b7246247d3f7114733 ]

In the function rxe_create_qp(), rxe_qp_from_init() is called to
initialize qp, internally things like the spin locks are not setup until
rxe_qp_init_req().

If an error occures before this point then the unwind will call
rxe_cleanup() and eventually to rxe_qp_do_cleanup()/rxe_cleanup_task()
which will oops when trying to access the uninitialized spinlock.

Move the spinlock initializations earlier before any failures.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20220731063621.298405-1-yanjun.zhu@linux.dev
Reported-by: syzbot+833061116fa28df97f3b@syzkaller.appspotmail.com
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 5731bc15991c..661b83d65af3 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -195,6 +195,14 @@ static void rxe_qp_init_misc(struct rxe_dev *rxe, struct rxe_qp *qp,
 	spin_lock_init(&qp->grp_lock);
 	spin_lock_init(&qp->state_lock);
 
+	spin_lock_init(&qp->req.task.state_lock);
+	spin_lock_init(&qp->resp.task.state_lock);
+	spin_lock_init(&qp->comp.task.state_lock);
+
+	spin_lock_init(&qp->sq.sq_lock);
+	spin_lock_init(&qp->rq.producer_lock);
+	spin_lock_init(&qp->rq.consumer_lock);
+
 	atomic_set(&qp->ssn, 0);
 	atomic_set(&qp->skb_out, 0);
 }
@@ -255,7 +263,6 @@ static int rxe_qp_init_req(struct rxe_dev *rxe, struct rxe_qp *qp,
 	qp->req.opcode		= -1;
 	qp->comp.opcode		= -1;
 
-	spin_lock_init(&qp->sq.sq_lock);
 	skb_queue_head_init(&qp->req_pkts);
 
 	rxe_init_task(rxe, &qp->req.task, qp,
@@ -306,9 +313,6 @@ static int rxe_qp_init_resp(struct rxe_dev *rxe, struct rxe_qp *qp,
 		}
 	}
 
-	spin_lock_init(&qp->rq.producer_lock);
-	spin_lock_init(&qp->rq.consumer_lock);
-
 	skb_queue_head_init(&qp->resp_pkts);
 
 	rxe_init_task(rxe, &qp->resp.task, qp,
-- 
2.35.1



