Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3C64AFA52
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239671AbiBISgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239593AbiBISg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:36:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0340BC050CCA;
        Wed,  9 Feb 2022 10:36:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 793BC61C17;
        Wed,  9 Feb 2022 18:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7EAC340EF;
        Wed,  9 Feb 2022 18:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431767;
        bh=c2qjUWotx/+jVWScedjbPHIOiQFVSNA+BiTLWlScFjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDuAa1Nhry0GntNuoF+nM9d7fhbs+PMrRE0/r+jNATFK4w8Yz+ukS+1duvGOOGG/R
         vuTa4iGHqGKL1AVumchkgO/R04NHHapTvoOOl54dVeZXjfM4gTm5Eb5bryADvO/ngp
         fNrkf/sn+OgdJS+NrNaA2+MxQqzIXJj5Q9KtvpqdXrpbUYeJHif/KC1NzejfdmDf8a
         IiRQKYVHU0GCNpR0+mM/e4P//DJjFxKeDopujTvjKdstlwd7pf8QbC+S20FGYwEYkM
         LRQlWUOU9Ncff5rp7JmUMvOZe1HlQ3VIPGInlm/mQKWhm5+IgLa2ntGzyessh1OLRU
         ifmRlBN/vSJZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 29/42] scsi: pm8001: Fix use-after-free for aborted SSP/STP sas_task
Date:   Wed,  9 Feb 2022 13:33:01 -0500
Message-Id: <20220209183335.46545-29-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183335.46545-1-sashal@kernel.org>
References: <20220209183335.46545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: John Garry <john.garry@huawei.com>

[ Upstream commit df7abcaa1246e2537ab4016077b5443bb3c09378 ]

Currently a use-after-free may occur if a sas_task is aborted by the upper
layer before we handle the I/O completion in mpi_ssp_completion() or
mpi_sata_completion().

In this case, the following are the two steps in handling those I/O
completions:

 - Call complete() to inform the upper layer handler of completion of
   the I/O.

 - Release driver resources associated with the sas_task in
   pm8001_ccb_task_free() call.

When complete() is called, the upper layer may free the sas_task. As such,
we should not touch the associated sas_task afterwards, but we do so in the
pm8001_ccb_task_free() call.

Fix by swapping the complete() and pm8001_ccb_task_free() calls ordering.

Link: https://lore.kernel.org/r/1643289172-165636-4-git-send-email-john.garry@huawei.com
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index d37365b2e88ee..26293485198aa 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2184,9 +2184,9 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		pm8001_dbg(pm8001_ha, FAIL,
 			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			   t, status, ts->resp, ts->stat);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		if (t->slow_task)
 			complete(&t->slow_task->completion);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
@@ -2801,9 +2801,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
 		pm8001_dbg(pm8001_ha, FAIL,
 			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			   t, status, ts->resp, ts->stat);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		if (t->slow_task)
 			complete(&t->slow_task->completion);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		spin_unlock_irqrestore(&circularQ->oq_lock,
-- 
2.34.1

