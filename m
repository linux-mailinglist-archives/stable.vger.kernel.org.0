Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1D56C073C
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjCTA4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjCTAzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:55:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFD612859;
        Sun, 19 Mar 2023 17:54:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E056F61122;
        Mon, 20 Mar 2023 00:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34494C433D2;
        Mon, 20 Mar 2023 00:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273621;
        bh=q7UJfo6NwOY9VIrBaKXIFeOu0aWzwN+x8ftA5Ue6vL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLCewqdQiTPxG9Nnyce0Ardimf2Ig2S5D5d8/qh4drhEzr4xU9eTCnpv4V+a9gmyY
         0MfvT7K2OfUl6O/T3idtbxW6r5UUOlhs8q7VxFoB8FmQorlZEbNUacPdFEegjNFZI1
         T+XEN6hACDOyalOGZiNDUS2PIDRJRsrn0s+gpu6kDeoKtVeOUQRpVtDtD5UB3b7zMx
         qpoQLzPu/C63UC/nAFZbOdqfXltredADYXAEmOTfXSJEPHpyr9xzzHdmbEi1lOwHFz
         0keFeGdBNBdO5hen/tlmL5F2ykR9mlfESdqbmcznHPqCVvEtzta4fw8jcmJhMQHUka
         0ZAzSQ0ydodYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        jejb@linux.ibm.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 17/30] scsi: mpi3mr: Driver unload crashes host when enhanced logging is enabled
Date:   Sun, 19 Mar 2023 20:52:42 -0400
Message-Id: <20230320005258.1428043-17-sashal@kernel.org>
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

[ Upstream commit 5b06a7169c59ce0c77ef8b9c82aa07c478f82aac ]

Prevent driver from trying to dereference a NULL pointer in a debug print
while removing a device during driver unload.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Link: https://lore.kernel.org/r/20230228140835.4075-3-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 3b61815979dab..b795a325534d3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1552,7 +1552,8 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 
 	list_for_each_entry_safe(mr_sas_phy, next_phy,
 	    &mr_sas_port->phy_list, port_siblings) {
-		if ((mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
+		if ((!mrioc->stop_drv_processing) &&
+		    (mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
 			dev_info(&mr_sas_port->port->dev,
 			    "remove: sas_address(0x%016llx), phy(%d)\n",
 			    (unsigned long long)
-- 
2.39.2

