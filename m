Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0E4529072
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346808AbiEPUMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350561AbiEPUBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC0A49FAE;
        Mon, 16 May 2022 12:55:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31D2E60FD9;
        Mon, 16 May 2022 19:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224E5C34115;
        Mon, 16 May 2022 19:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730931;
        bh=EwrlZFOvzJnjMTJ2FyUy85Q/vhUk54CTxzJFzMEnSow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRfmpfg2IkhsoTRP76maCmxcghA2OAjC3LhOKJWNVlaXLhvoaOO3PC8w2D0DLAKSD
         7ppZUIPq1wX6zWJr1WiVefef3xCP2458mDKrFLVCbOlNNCQg7YtHTSNU8hFVWmi9Nd
         wOrhzLvk8W8uimKOgBuurhTCkOZRKOUI6uIwO74I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 051/114] RDMA/irdma: Fix deadlock in irdma_cleanup_cm_core()
Date:   Mon, 16 May 2022 21:36:25 +0200
Message-Id: <20220516193626.959658720@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 082a3ddb0fa3..632f65e53b63 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -3242,15 +3242,10 @@ enum irdma_status_code irdma_setup_cm_core(struct irdma_device *iwdev,
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



