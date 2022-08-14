Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4C659224E
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240462AbiHNPrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241454AbiHNPoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:44:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170CA2DC8;
        Sun, 14 Aug 2022 08:34:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B711760CF1;
        Sun, 14 Aug 2022 15:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A419C43470;
        Sun, 14 Aug 2022 15:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491242;
        bh=mhYzhf2NtlHkk2TbX4QwhCx9pIGj1WFByfOUC1Lr1yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otNdf/FyB1JE62TgbLrOpRkidra+OSqSbQi2LAYuKtFF50fMQnF3R5iUauVVd3Nhs
         vUi3I42TcHeiMT3fs9OOXW9MOGr2o+ra5t4SIZtJs40f4ftSihrdGdw5DomZWLcT+0
         28TCSim/5Lh6gaAzFGebXX2I2+LAHphsJzfQptD7FX2MN7S+MY3TERH4rzWsD+DV/7
         aLD4m1iYlmRATycV2VqyAOS1h3F2mlrh4W8VuotASkQmiN/yF1wijAzIBu/3s8DRab
         cNnR0lxyvlRPaEbgDqwZjplN6iYoIY2ctK0bFGT8k640aiPC8CGNJGhSMGwYgPAjpj
         3fYIVzVTH3q7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 34/46] RDMA/rxe: Limit the number of calls to each tasklet
Date:   Sun, 14 Aug 2022 11:32:35 -0400
Message-Id: <20220814153247.2378312-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153247.2378312-1-sashal@kernel.org>
References: <20220814153247.2378312-1-sashal@kernel.org>
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
index b5a70cbe94aa..872389870106 100644
--- a/drivers/infiniband/sw/rxe/rxe_param.h
+++ b/drivers/infiniband/sw/rxe/rxe_param.h
@@ -103,6 +103,12 @@ enum rxe_device_param {
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
index 6951fdcb31bf..568cf56c236b 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.c
+++ b/drivers/infiniband/sw/rxe/rxe_task.c
@@ -8,7 +8,7 @@
 #include <linux/interrupt.h>
 #include <linux/hardirq.h>
 
-#include "rxe_task.h"
+#include "rxe.h"
 
 int __rxe_do_task(struct rxe_task *task)
 
@@ -34,6 +34,7 @@ void rxe_do_task(struct tasklet_struct *t)
 	int ret;
 	unsigned long flags;
 	struct rxe_task *task = from_tasklet(task, t, tasklet);
+	unsigned int iterations = RXE_MAX_ITERATIONS;
 
 	spin_lock_irqsave(&task->state_lock, flags);
 	switch (task->state) {
@@ -62,13 +63,20 @@ void rxe_do_task(struct tasklet_struct *t)
 		spin_lock_irqsave(&task->state_lock, flags);
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

