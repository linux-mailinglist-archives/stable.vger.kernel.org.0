Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F736E9213
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 13:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbjDTLHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 07:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235516AbjDTLFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 07:05:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DB9A243;
        Thu, 20 Apr 2023 04:03:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6C4363EA6;
        Thu, 20 Apr 2023 11:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C67C433A7;
        Thu, 20 Apr 2023 11:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681988580;
        bh=bu8vS+mCAOz4URE9Wdvm46xUj8MlgItfn6idQuIEVNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YiYDEiN/ZrkNsno/vB5fyh0UDxDRVcXV0GrmDZ2uYjaFGHS1aKwp2sTH2J/KeH0jf
         Iy9DjHHsLrd2YTGVUdJesS8L8xTmYHPB560OZUpxn0ntfXyrQ2qJL1LT4+pzoVhP2f
         CFLur97IRxFFQ6Efb6YIeBfw3cKboYeKp1Pge8sh2TwRfBnemhFMGRWCOsnWot7LTG
         ZqsjfFSCMKV7Zu6CjAba8m2R+nDyUhKZXvd2AkUcMpqf/667L64bKExReAJCp9oBZX
         fYmPeBzm8smRjoWyv/4fn5Jhsfxl8FgA/9TvpFYLBtQTKopapZzZnDMlLYD5Vc1SAZ
         49e62Lh90RGRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ranjan Kumar <ranjan.kumar@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        sreekanth.reddy@broadcom.com, jejb@linux.ibm.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 11/15] scsi: mpi3mr: Handle soft reset in progress fault code (0xF002)
Date:   Thu, 20 Apr 2023 07:02:25 -0400
Message-Id: <20230420110231.505992-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420110231.505992-1-sashal@kernel.org>
References: <20230420110231.505992-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

