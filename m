Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE994BDDC3
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241715AbiBUJvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:51:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352017AbiBUJq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:46:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDE131207;
        Mon, 21 Feb 2022 01:18:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A801BCE0E90;
        Mon, 21 Feb 2022 09:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871FCC340E9;
        Mon, 21 Feb 2022 09:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435134;
        bh=cCeCFh09Il9xAvv0HNxIb0KqsWpXXevhDhL7xNZNzAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUYqCKYmnh+2BmfQG5UbAWPoiCBlvUJX810a+WcrZWlr72w2xnaMMRI3NidAAWdF2
         WQHKhJIELgBlq0121iTHyMNtBHopRs7B96UNLWJOOXR+Z19CbbHXhKcZFEY0hT40lO
         WPSx1uq9Ac7IgOsge0tEWYac0ZKqqzVaU/zDCGp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 057/227] scsi: pm8001: Fix use-after-free for aborted SSP/STP sas_task
Date:   Mon, 21 Feb 2022 09:47:56 +0100
Message-Id: <20220221084936.775956553@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
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
index 885bc9e71ff64..ca4820d99dc70 100644
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



