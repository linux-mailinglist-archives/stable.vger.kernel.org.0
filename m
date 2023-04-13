Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D686E0469
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjDMCii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjDMChu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:37:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A377AB2;
        Wed, 12 Apr 2023 19:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D31C063A94;
        Thu, 13 Apr 2023 02:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D177C433EF;
        Thu, 13 Apr 2023 02:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353435;
        bh=bu8vS+mCAOz4URE9Wdvm46xUj8MlgItfn6idQuIEVNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRaq7zeQN0r0+DMjWgmMXdpRqZzb2KumMycjbLx08tKOuNjofDX0DMkSVaL13/Sn2
         lT6ltCCGmy03sjC3nGdbCBdON+QSKZSYFNIYZofyEGimdwFiowQcU1no/YPjXsoTE5
         VEerBDHU0OjbIjQWBxAfj1d7Ibc5OwG1QJbOOnaV12//kCW7Egm2alCuhOYG0mQ8J2
         P5KwEknCGdgTgt78DcQaYoSHxteSCiRT1Hw5UHRPqI+fht9x+nZXhuuaCNHq3Gj2Z/
         MKz2HTJg1Bo4qMBUGyzoEzz8t+r82Qy+Ag0/OtENhSrIu4RCK0LcnSIo400eLNTd7o
         KwJpYlY8opHMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ranjan Kumar <ranjan.kumar@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        sreekanth.reddy@broadcom.com, jejb@linux.ibm.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 11/17] scsi: mpi3mr: Handle soft reset in progress fault code (0xF002)
Date:   Wed, 12 Apr 2023 22:36:39 -0400
Message-Id: <20230413023647.74661-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023647.74661-1-sashal@kernel.org>
References: <20230413023647.74661-1-sashal@kernel.org>
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

[ Upstream commit a3d27dfdcfc27ac3f46de5391bb6d24f04af7941 ]

The driver is exiting from the fault watchdog thread if it sees the 0xF002
(Soft reset in progress) fault code.

If the driver initiates the soft reset, then the driver restarts the
watchdog at the end of the soft reset completion.  However, if the soft
reset is initiated by the firmware asynchronously, then the driver will
never restart the watchdog and never re-initialize the controller after the
asynchronous soft reset completion.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20230331122317.11391-1-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index ea9e69fb62826..64355d0baa5fb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2526,7 +2526,7 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 		mrioc->unrecoverable = 1;
 		goto schedule_work;
 	case MPI3_SYSIF_FAULT_CODE_SOFT_RESET_IN_PROGRESS:
-		return;
+		goto schedule_work;
 	case MPI3_SYSIF_FAULT_CODE_CI_ACTIVATION_RESET:
 		reset_reason = MPI3MR_RESET_FROM_CIACTIV_FAULT;
 		break;
-- 
2.39.2

