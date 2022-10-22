Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA3D60889E
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbiJVIUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbiJVITN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:19:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FD82DF448;
        Sat, 22 Oct 2022 00:58:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B633B80E4D;
        Sat, 22 Oct 2022 07:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD3CC433B5;
        Sat, 22 Oct 2022 07:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425416;
        bh=tv9L0ATtm/g+3f1svrh0qKf6P+ZJy0hTBvk3G0cON/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=taKgWB6he3HAjDBNzYi/l2yOdLSnNbrZi/Vcnw09X9OHZu5A+wsD12abKq8ULI2wN
         9VHLqzHngDQKgRIfKod+I2f2J+NnSK2IwxsvGG0qNYSCLtzxU5dC27d67kVTok3hQd
         tUJz+2HbBCHZsb+5qnaNHBhG9IkG+vzilTm/4sqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearsonhpe@gmail.com>,
        Li Zhijian <lizhijian@fujitsu.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 464/717] RDMA/rxe: Fix resize_finish() in rxe_queue.c
Date:   Sat, 22 Oct 2022 09:25:43 +0200
Message-Id: <20221022072518.828870179@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit fda5d0cf8aef12f0a4f714a96a4b2fce039a3e55 ]

Currently in resize_finish() in rxe_queue.c there is a loop which copies
the entries in the original queue into a newly allocated queue.  The
termination logic for this loop is incorrect. The call to
queue_next_index() updates cons but has no effect on whether the queue is
empty. So if the queue starts out empty nothing is copied but if it is not
then the loop will run forever. This patch changes the loop to compare the
value of cons to the original producer index.

Fixes: ae6e843fe08d0 ("RDMA/rxe: Add memory barriers to kernel queues")
Link: https://lore.kernel.org/r/20220825221446.6512-1-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Reviewed-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_queue.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_queue.c b/drivers/infiniband/sw/rxe/rxe_queue.c
index dbd4971039c0..d6dbf5a0058d 100644
--- a/drivers/infiniband/sw/rxe/rxe_queue.c
+++ b/drivers/infiniband/sw/rxe/rxe_queue.c
@@ -112,23 +112,25 @@ static int resize_finish(struct rxe_queue *q, struct rxe_queue *new_q,
 			 unsigned int num_elem)
 {
 	enum queue_type type = q->type;
+	u32 new_prod;
 	u32 prod;
 	u32 cons;
 
 	if (!queue_empty(q, q->type) && (num_elem < queue_count(q, type)))
 		return -EINVAL;
 
-	prod = queue_get_producer(new_q, type);
+	new_prod = queue_get_producer(new_q, type);
+	prod = queue_get_producer(q, type);
 	cons = queue_get_consumer(q, type);
 
-	while (!queue_empty(q, type)) {
-		memcpy(queue_addr_from_index(new_q, prod),
+	while ((prod - cons) & q->index_mask) {
+		memcpy(queue_addr_from_index(new_q, new_prod),
 		       queue_addr_from_index(q, cons), new_q->elem_size);
-		prod = queue_next_index(new_q, prod);
+		new_prod = queue_next_index(new_q, new_prod);
 		cons = queue_next_index(q, cons);
 	}
 
-	new_q->buf->producer_index = prod;
+	new_q->buf->producer_index = new_prod;
 	q->buf->consumer_index = cons;
 
 	/* update private index copies */
-- 
2.35.1



