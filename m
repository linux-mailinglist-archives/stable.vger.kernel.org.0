Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65864BDB7B
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiBUJN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:13:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347896AbiBUJKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:10:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D86A1EC41;
        Mon, 21 Feb 2022 01:02:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05161B80EB5;
        Mon, 21 Feb 2022 09:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B865C340E9;
        Mon, 21 Feb 2022 09:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434163;
        bh=PuqeZjP8n5+z4Xnrox4z6+i3H+J6DathD7t+AFuJ8nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UC5+WetxSUUQJJmnWVg9/Od1zrHxDtiEQRmTZ1NAN3rAOpPTA1Kr7/+CsDMyZbdNH
         vhxcoomR+kZFrwIncrtiOOh4GAxP7rszqTTgPUEv1G/HkYWGifxddF49PhiEO7DjPG
         cmQY7Ca8iN7EAoZzTJgCF2Il4AKMqGe5i1X81rJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/121] scsi: pm8001: Fix use-after-free for aborted TMF sas_task
Date:   Mon, 21 Feb 2022 09:48:47 +0100
Message-Id: <20220221084922.377881789@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
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
index c3bb58885033b..75ac4d86d9c4b 100644
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



