Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA64460B19A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbiJXQ2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiJXQ1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:27:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8AE474D4;
        Mon, 24 Oct 2022 08:14:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB3446127C;
        Mon, 24 Oct 2022 12:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC45DC433C1;
        Mon, 24 Oct 2022 12:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614392;
        bh=qGhiw56H1/lUFsIpPvRlT9JAzi56ogDfYrZcj4vISEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4uOr85JkjwQlZafeVdQWz+3SvClCu+1WTQ2FumKl0BOWEtMWZkU1PF2bno/8wnI5
         eT9QBaHTa6nxS6R72fsYuMk8YyEy1/APntZz/eXMqNmIlSaW5eHzcihmMdQKSTAsOC
         dEqL17IGsgNr1uu4Kq83f+gqm/qY0es+3+yrfid8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        Duoming Zhou <duoming@zju.edu.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/390] scsi: libsas: Fix use-after-free bug in smp_execute_task_sg()
Date:   Mon, 24 Oct 2022 13:30:40 +0200
Message-Id: <20221024113033.180284498@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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
index 8d6bcc19359f..51485d0251f2 100644
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



