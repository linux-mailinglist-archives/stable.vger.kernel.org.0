Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCEE60BA08
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiJXUY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbiJXUXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:23:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F61349A3;
        Mon, 24 Oct 2022 11:38:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D291B815DA;
        Mon, 24 Oct 2022 12:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6317DC433D6;
        Mon, 24 Oct 2022 12:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613531;
        bh=Eq053hQgh5hot3gFniUkU0XCEGYQXU6z0x6OdiZi4KQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ciSoZHLSmjYelPs7J4blb48JzNkjfZS5yekCOzQqBtYr1yGWIMNB16s3znGxuPldz
         3LdP/qmZZwRM8EEeL+06ssTdpfnl2nUjiRE43DHcBXL968RawoOggiDAc15U7ENwco
         ESCyKaLtZvvT5UE3tbLK5x+h9EGVvcCE3rFgXJS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        Duoming Zhou <duoming@zju.edu.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 155/255] scsi: libsas: Fix use-after-free bug in smp_execute_task_sg()
Date:   Mon, 24 Oct 2022 13:31:05 +0200
Message-Id: <20221024113007.799761629@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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
index 9fdb9c9fbda4..173f91ae38f0 100644
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



