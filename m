Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2AF4EF072
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347578AbiDAOfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347798AbiDAOdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:33:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B581A28788D;
        Fri,  1 Apr 2022 07:30:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43033B82507;
        Fri,  1 Apr 2022 14:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA61AC36AE3;
        Fri,  1 Apr 2022 14:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823439;
        bh=QXdemaWGxPall05wmK517tfbkYG67C2DKNUAs3QRy70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gy5uqBS6QC7Q/gMJFmOa86ZEtVvhBpVT9WO5jL5Xo5GicRd117uitmv+Bk2rbT6aU
         H1HINon6m+lidzS10mOiFHi27Y5LQGT8mo6DebPRdyDO1zVawUbICsSSRBsEaHXhlQ
         z23H21sILM4oB17+Lu0rXYKNm5VKH5C60Qtz6Pl+gIfSvhrQ33x80Eaw1/ftk753NA
         hGxetF6j14RDXjTwppxwHz0G2bCkthuFHNUh0ULh+PnTDkleRvfjkCkxEwONUjb8Zd
         bnw64iVGhYcOXUFdmUYOwlDggXRFB3nHMV8Cl9+4p1fWM61URgbgVYN5h+gNI7jZ1g
         N6oLTZUAMcRrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 096/149] scsi: pm8001: Fix task leak in pm8001_send_abort_all()
Date:   Fri,  1 Apr 2022 10:24:43 -0400
Message-Id: <20220401142536.1948161-96-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit f90a74892f3acf0cdec5844e90fc8686ca13e7d7 ]

In pm8001_send_abort_all(), make sure to free the allocated sas task
if pm8001_tag_alloc() or pm8001_mpi_build_cmd() fail.

Link: https://lore.kernel.org/r/20220220031810.738362-21-damien.lemoal@opensource.wdc.com
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index e12b3ea4153a..1cf3878b47f3 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1765,7 +1765,6 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	}
 
 	task = sas_alloc_slow_task(GFP_ATOMIC);
-
 	if (!task) {
 		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task\n");
 		return;
@@ -1774,8 +1773,10 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	task->task_done = pm8001_task_done;
 
 	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-	if (res)
+	if (res) {
+		sas_free_task(task);
 		return;
+	}
 
 	ccb = &pm8001_ha->ccb_info[ccb_tag];
 	ccb->device = pm8001_ha_dev;
@@ -1791,8 +1792,10 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
 			sizeof(task_abort), 0);
-	if (ret)
+	if (ret) {
+		sas_free_task(task);
 		pm8001_tag_free(pm8001_ha, ccb_tag);
+	}
 
 }
 
-- 
2.34.1

