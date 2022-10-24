Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7985160AC59
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbiJXOGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbiJXOD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:03:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA3CC14BD;
        Mon, 24 Oct 2022 05:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA7CF61257;
        Mon, 24 Oct 2022 12:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6959C433D6;
        Mon, 24 Oct 2022 12:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615732;
        bh=uoL8KYvLmqiYOgLbt1BZk+v5+ngS5M6ut9BacMM7LMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvYxW8v3sexJkaUR7SvqdoYwq3/lDwvPu9PWVgvG53lU/naM4mnnYqQgfJMQ5Gn2w
         8v2xUHAImGoUtGVCgJLPWLtC4J58UFU2FyrXmfPN7GoDlmILJgYkmg/nq9s6Awq1Yf
         x1K4ocDaYAg+ZLlhCtnesdDYdpmTIHH0aXypFBn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        Duoming Zhou <duoming@zju.edu.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 332/530] scsi: libsas: Fix use-after-free bug in smp_execute_task_sg()
Date:   Mon, 24 Oct 2022 13:31:16 +0200
Message-Id: <20221024113100.042146539@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 46ba53c30666717cb06c2b3c5d896301cd00d0c0 ]

When executing SMP task failed, the smp_execute_task_sg() calls del_timer()
to delete "slow_task->timer". However, if the timer handler
sas_task_internal_timedout() is running, the del_timer() in
smp_execute_task_sg() will not stop it and a UAF will happen. The process
is shown below:

      (thread 1)               |        (thread 2)
smp_execute_task_sg()          | sas_task_internal_timedout()
 ...                           |
 del_timer()                   |
 ...                           |  ...
 sas_free_task(task)           |
  kfree(task->slow_task) //FREE|
                               |  task->slow_task->... //USE

Fix by calling del_timer_sync() in smp_execute_task_sg(), which makes sure
the timer handler have finished before the "task->slow_task" is
deallocated.

Link: https://lore.kernel.org/r/20220920144213.10536-1-duoming@zju.edu.cn
Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_expander.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index c2150a818423..9ae35631135d 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -85,7 +85,7 @@ static int smp_execute_task_sg(struct domain_device *dev,
 		res = i->dft->lldd_execute_task(task, GFP_KERNEL);
 
 		if (res) {
-			del_timer(&task->slow_task->timer);
+			del_timer_sync(&task->slow_task->timer);
 			pr_notice("executing SMP task failed:%d\n", res);
 			break;
 		}
-- 
2.35.1



