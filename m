Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8AE6C07DB
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbjCTBCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjCTBAi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:00:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F361B22DF7;
        Sun, 19 Mar 2023 17:57:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A774B80D53;
        Mon, 20 Mar 2023 00:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C270C4339B;
        Mon, 20 Mar 2023 00:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273690;
        bh=q7UJfo6NwOY9VIrBaKXIFeOu0aWzwN+x8ftA5Ue6vL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z32p9MPS//ZJGDVD5F4sram1xmax6+5Ofo/E+bJaWRbN3BVEO+x2jJjcyB3+sC/dr
         ICiHMFRrbYvNLs0aOAlk78R51aXCxQGmFPvmMOmWpA4Z8Syv5jjpHqyBhnJQrszFBe
         y7ytDZUD0CpaQG/1YUatgV7cEWyYW3u2dDxI1lLlalhVwRRD7HtgEKumga3n2Kh+pW
         10KDJ1UwFD14dpDuKsdDNx1K9ODkoy73daLouNO3Y7nzhJJOlV1eUURv1hyDn1wbpP
         chlWHJ0Xixprseca3ajqOrfElM0C4Wy+qwoDGGHLd55X8SpYjDqYPPOJc/TEoolG2N
         M+vR/P5srhnHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        jejb@linux.ibm.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 16/29] scsi: mpi3mr: Driver unload crashes host when enhanced logging is enabled
Date:   Sun, 19 Mar 2023 20:53:58 -0400
Message-Id: <20230320005413.1428452-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005413.1428452-1-sashal@kernel.org>
References: <20230320005413.1428452-1-sashal@kernel.org>
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

