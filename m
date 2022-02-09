Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808044AFA54
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbiBISgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239661AbiBISg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:36:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2342C050CC9;
        Wed,  9 Feb 2022 10:36:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66487B82385;
        Wed,  9 Feb 2022 18:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33225C340E7;
        Wed,  9 Feb 2022 18:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431766;
        bh=jSX6Ft0yEbQig0uJNyduPU6XZS9xYQjm4RT3TZsxxsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYU7ns+HCA2upvdd2GVYAqmBekEh+KkH1GPGTKkDkK0L6EpyGpZ3W7/i1sSHRqmgc
         QA5/OF5FpEheInJ+nqU1QDO212EgybhsFNNID4UkrKWJUPm3mJyfd9/LI0gRhADNH0
         ElMIkI/LkR9O65+EfePTYOGOwyBFn7QGqdfJX+gVW4qIHosFLTfnNCV5Qzz91gMCfV
         sKTbF+VF8JYFB0apD6f/Sq9I/XrpfM/ObPsMVAxEvjKhe8aXmm+6G9bHiXW58wdqYO
         wxV6eEVLgAeu4/1oVxdkQ0ijFHlNC0gLWL9ZyPvKFoYBsxdKZvpTupRjQZ6jcyKSUx
         T31hm22qbNO/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 28/42] scsi: pm8001: Fix use-after-free for aborted TMF sas_task
Date:   Wed,  9 Feb 2022 13:33:00 -0500
Message-Id: <20220209183335.46545-28-sashal@kernel.org>
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

[ Upstream commit 61f162aa4381845acbdc7f2be4dfb694d027c018 ]

Currently a use-after-free may occur if a TMF sas_task is aborted before we
handle the IO completion in mpi_ssp_completion(). The abort occurs due to
timeout.

When the timeout occurs, the SAS_TASK_STATE_ABORTED flag is set and the
sas_task is freed in pm8001_exec_internal_tmf_task().

However, if the I/O completion occurs later, the I/O completion still
thinks that the sas_task is available. Fix this by clearing the ccb->task
if the TMF times out - the I/O completion handler does nothing if this
pointer is cleared.

Link: https://lore.kernel.org/r/1643289172-165636-3-git-send-email-john.garry@huawei.com
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 83e73009db5cd..c0b45b8a513d7 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -753,8 +753,13 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 		res = -TMF_RESP_FUNC_FAILED;
 		/* Even TMF timed out, return direct. */
 		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
+			struct pm8001_ccb_info *ccb = task->lldd_task;
+
 			pm8001_dbg(pm8001_ha, FAIL, "TMF task[%x]timeout.\n",
 				   tmf->tmf);
+
+			if (ccb)
+				ccb->task = NULL;
 			goto ex_err;
 		}
 
-- 
2.34.1

