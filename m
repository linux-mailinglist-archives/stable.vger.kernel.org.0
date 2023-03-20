Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880586C0724
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjCTAzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjCTAyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:54:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A641E5EE;
        Sun, 19 Mar 2023 17:53:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BD7B611F3;
        Mon, 20 Mar 2023 00:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C58C4339C;
        Mon, 20 Mar 2023 00:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273624;
        bh=SdOk40AzdtEARY4waWJeAh1gvbyptGVEnJMaObhKGtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qIufIf/rHRnOdUbbEDMrECau/ECiR68U52gpnM9x0/z56DQ/MO0jm4h0VY6OMvlLx
         pavXsnN49RdH/GKdGMq+IyPUotP+fcH9BG9OM974up90VFepigcO/qpkyInXoFL/HV
         9J8owVJHLu2YHOAtx4wdPgC94ty+HVP5riZexShBfLLLPrl3SGmgrDPC2p9/OPMHeN
         yzzoP8grzj/S0Qa2Jzo0qSIuEoyMJFxmoF/Obd7+YduPesmXxssBz5ADA/SSx8eugA
         bL1lN1jERBNhG/BSHNxXLlYlthTcqwNFH05sIw23pLiumMRmnY4X/TmQiH7ffXRPLl
         McYtP6fWZXODg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        jejb@linux.ibm.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 19/30] scsi: mpi3mr: Return proper values for failures in firmware init path
Date:   Sun, 19 Mar 2023 20:52:44 -0400
Message-Id: <20230320005258.1428043-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005258.1428043-1-sashal@kernel.org>
References: <20230320005258.1428043-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit ba8a9ba41fbde250fd8b0ed1e5dad0dc9318df46 ]

Return proper non-zero return values for all the cases when the controller
initialization and re-initialization fails.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Link: https://lore.kernel.org/r/20230228140835.4075-5-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index fa903a70baac8..29acf6111db30 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3840,8 +3840,10 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	dprint_init(mrioc, "allocating config page buffers\n");
 	mrioc->cfg_page = dma_alloc_coherent(&mrioc->pdev->dev,
 	    MPI3MR_DEFAULT_CFG_PAGE_SZ, &mrioc->cfg_page_dma, GFP_KERNEL);
-	if (!mrioc->cfg_page)
+	if (!mrioc->cfg_page) {
+		retval = -1;
 		goto out_failed_noretry;
+	}
 
 	mrioc->cfg_page_sz = MPI3MR_DEFAULT_CFG_PAGE_SZ;
 
@@ -3903,8 +3905,10 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		dprint_init(mrioc, "allocating memory for throttle groups\n");
 		sz = sizeof(struct mpi3mr_throttle_group_info);
 		mrioc->throttle_groups = kcalloc(mrioc->num_io_throttle_group, sz, GFP_KERNEL);
-		if (!mrioc->throttle_groups)
+		if (!mrioc->throttle_groups) {
+			retval = -1;
 			goto out_failed_noretry;
+		}
 	}
 
 	retval = mpi3mr_enable_events(mrioc);
@@ -3924,6 +3928,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		mpi3mr_memset_buffers(mrioc);
 		goto retry_init;
 	}
+	retval = -1;
 out_failed_noretry:
 	ioc_err(mrioc, "controller initialization failed\n");
 	mpi3mr_issue_reset(mrioc, MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
@@ -4036,6 +4041,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		ioc_err(mrioc,
 		    "cannot create minimum number of operational queues expected:%d created:%d\n",
 		    mrioc->shost->nr_hw_queues, mrioc->num_op_reply_q);
+		retval = -1;
 		goto out_failed_noretry;
 	}
 
@@ -4102,6 +4108,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		mpi3mr_memset_buffers(mrioc);
 		goto retry_init;
 	}
+	retval = -1;
 out_failed_noretry:
 	ioc_err(mrioc, "controller %s is failed\n",
 	    (is_resume)?"resume":"re-initialization");
-- 
2.39.2

