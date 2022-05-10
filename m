Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C06521F44
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346107AbiEJPrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244300AbiEJPrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:47:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED8227BC6D;
        Tue, 10 May 2022 08:43:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D96426142F;
        Tue, 10 May 2022 15:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216D7C385CB;
        Tue, 10 May 2022 15:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197426;
        bh=+l9VM40uiVb+n4IVUTtTjvorAX2ljEdfYbnI8zg2EbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVmr/tyGVilFu/pZ3pf9X7wruC7ddqhwaGJ/bWbNXUGRpb7O29EqAt80EqMz4tL4n
         oeIegy7u03DEiLYp0Pg5C9Bx0wJyVoYqiSfq93RD/YWsjOCO6JD7KFW+CLHnwd0Js8
         F9YR5/ZdflWnyGuTxDhYkI9Ob57P5bGSGUxeCPjM7Evl/XXJZvtWIYQqFQSU/UOM8h
         Mpyu3oTu1Sn+MKv9ikmqy5ON7OWhwj8yT0eROQeT9AZoBUb2dI6pvCQqfm0/43hVqt
         vtXXFRzLGeR7OM/KgCMU41dqfwqL2cgbSUFHxaxMkDqOgBmpUXTrSuTz+iyXE9HS/T
         LUsEuOAG8n6qA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, mustafa.ismail@intel.com,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 03/21] RDMA/irdma: Fix deadlock in irdma_cleanup_cm_core()
Date:   Tue, 10 May 2022 11:43:22 -0400
Message-Id: <20220510154340.153400-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154340.153400-1-sashal@kernel.org>
References: <20220510154340.153400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 679ab61bf5f5f519377d812afb4fb93634782c74 ]

There is a deadlock in irdma_cleanup_cm_core(), which is shown below:

   (Thread 1)              |      (Thread 2)
                           | irdma_schedule_cm_timer()
irdma_cleanup_cm_core()    |  add_timer()
 spin_lock_irqsave() //(1) |  (wait a time)
 ...                       | irdma_cm_timer_tick()
 del_timer_sync()          |  spin_lock_irqsave() //(2)
 (wait timer to stop)      |  ...

We hold cm_core->ht_lock in position (1) of thread 1 and use
del_timer_sync() to wait timer to stop, but timer handler also need
cm_core->ht_lock in position (2) of thread 2.  As a result,
irdma_cleanup_cm_core() will block forever.

This patch removes the check of timer_pending() in
irdma_cleanup_cm_core(), because the del_timer_sync() function will just
return directly if there isn't a pending timer. As a result, the lock is
redundant, because there is no resource it could protect.

Link: https://lore.kernel.org/r/20220418153322.42524-1-duoming@zju.edu.cn
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index 6dea0a49d171..41703c7ebca5 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -3244,15 +3244,10 @@ enum irdma_status_code irdma_setup_cm_core(struct irdma_device *iwdev,
  */
 void irdma_cleanup_cm_core(struct irdma_cm_core *cm_core)
 {
-	unsigned long flags;
-
 	if (!cm_core)
 		return;
 
-	spin_lock_irqsave(&cm_core->ht_lock, flags);
-	if (timer_pending(&cm_core->tcp_timer))
-		del_timer_sync(&cm_core->tcp_timer);
-	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
+	del_timer_sync(&cm_core->tcp_timer);
 
 	destroy_workqueue(cm_core->event_wq);
 	cm_core->dev->ws_reset(&cm_core->iwdev->vsi);
-- 
2.35.1

