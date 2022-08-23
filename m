Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF0C59D8D4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349072AbiHWJWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350672AbiHWJWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:22:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B378E0CA;
        Tue, 23 Aug 2022 01:35:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6E066132D;
        Tue, 23 Aug 2022 08:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F52C433C1;
        Tue, 23 Aug 2022 08:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243614;
        bh=7D0OrVKNjV5W28hSKVEGbz9KYV6kvLGpEuCpVGt/P4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1bBz1aGMQzxQzQ/0edetC0KZoEVLGdUgnEDluDf+mq5ay8C8fQUEp1JEZ39RN5QXL
         82AZum4swVk5TJZ4EA1hydEL2VHVf6CK3wlKo5AHCiPp3srZk77gUs4AXJmV6EufjW
         ouwuQJwbeyifiZ59fLjfvqR3UHUSy/qWUaMN1lnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 303/365] RDMA/rxe: Limit the number of calls to each tasklet
Date:   Tue, 23 Aug 2022 10:03:24 +0200
Message-Id: <20220823080130.862991649@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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



