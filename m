Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C37D5920F7
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240639AbiHNPci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240516AbiHNPcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:32:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DE91AF2C;
        Sun, 14 Aug 2022 08:29:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7CDDB80B48;
        Sun, 14 Aug 2022 15:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED305C433C1;
        Sun, 14 Aug 2022 15:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490986;
        bh=7D0OrVKNjV5W28hSKVEGbz9KYV6kvLGpEuCpVGt/P4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeNXRAf/6seMWrn5B3jjo9QmVqC347TC49RA2wUxCARL+uhmeQYgR/SpR8D8C7/9M
         BYf1nD2nLaYdKkreKV9gGArY5HMh6jB1oEDGnwLK5pAUd6fiEywXUfWsPINfn6NBk9
         ufcMeXDVUv67ScjRyvQ9BVvxZ6Y4wV55yx68SDm+qPa+1C3rkzfv1RJs76YmQKWkRV
         Y2OWIwydUxDsCflduZI9+NN1ix4o6hWHe9004RvmsXK1fCaZzJkWypqihcgBTtLi0J
         LVWqVyesMZyvFgHUrXyqtlyYC2f/LeV86INxcW6p2WbbHOoYxFemRvoexGbzT0Dfce
         fuHxNaf1jouOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 48/64] RDMA/rxe: Limit the number of calls to each tasklet
Date:   Sun, 14 Aug 2022 11:24:21 -0400
Message-Id: <20220814152437.2374207-48-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit eff6d998ca297cb0b2e53b032a56cf8e04dd8b17 ]

Limit the maximum number of calls to each tasklet from rxe_do_task()
before yielding the cpu. When the limit is reached reschedule the tasklet
and exit the calling loop. This patch prevents one tasklet from consuming
100% of a cpu core and causing a deadlock or soft lockup.

Link: https://lore.kernel.org/r/20220630190425.2251-9-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_param.h |  6 ++++++
 drivers/infiniband/sw/rxe/rxe_task.c  | 16 ++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_param.h b/drivers/infiniband/sw/rxe/rxe_param.h
index 568a7cbd13d4..86c7a8bf3cbb 100644
--- a/drivers/infiniband/sw/rxe/rxe_param.h
+++ b/drivers/infiniband/sw/rxe/rxe_param.h
@@ -105,6 +105,12 @@ enum rxe_device_param {
 	RXE_INFLIGHT_SKBS_PER_QP_HIGH	= 64,
 	RXE_INFLIGHT_SKBS_PER_QP_LOW	= 16,
 
+	/* Max number of interations of each tasklet
+	 * before yielding the cpu to let other
+	 * work make progress
+	 */
+	RXE_MAX_ITERATIONS		= 1024,
+
 	/* Delay before calling arbiter timer */
 	RXE_NSEC_ARB_TIMER_DELAY	= 200,
 
diff --git a/drivers/infiniband/sw/rxe/rxe_task.c b/drivers/infiniband/sw/rxe/rxe_task.c
index 0c4db5bb17d7..2248cf33d776 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.c
+++ b/drivers/infiniband/sw/rxe/rxe_task.c
@@ -8,7 +8,7 @@
 #include <linux/interrupt.h>
 #include <linux/hardirq.h>
 
-#include "rxe_task.h"
+#include "rxe.h"
 
 int __rxe_do_task(struct rxe_task *task)
 
@@ -33,6 +33,7 @@ void rxe_do_task(struct tasklet_struct *t)
 	int cont;
 	int ret;
 	struct rxe_task *task = from_tasklet(task, t, tasklet);
+	unsigned int iterations = RXE_MAX_ITERATIONS;
 
 	spin_lock_bh(&task->state_lock);
 	switch (task->state) {
@@ -61,13 +62,20 @@ void rxe_do_task(struct tasklet_struct *t)
 		spin_lock_bh(&task->state_lock);
 		switch (task->state) {
 		case TASK_STATE_BUSY:
-			if (ret)
+			if (ret) {
 				task->state = TASK_STATE_START;
-			else
+			} else if (iterations--) {
 				cont = 1;
+			} else {
+				/* reschedule the tasklet and exit
+				 * the loop to give up the cpu
+				 */
+				tasklet_schedule(&task->tasklet);
+				task->state = TASK_STATE_START;
+			}
 			break;
 
-		/* soneone tried to run the task since the last time we called
+		/* someone tried to run the task since the last time we called
 		 * func, so we will call one more time regardless of the
 		 * return value
 		 */
-- 
2.35.1

