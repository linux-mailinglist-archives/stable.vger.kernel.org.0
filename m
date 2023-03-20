Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C3D6C072C
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjCTAzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjCTAye (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:54:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE53520566;
        Sun, 19 Mar 2023 17:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA917B80D40;
        Mon, 20 Mar 2023 00:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D27CC4339E;
        Mon, 20 Mar 2023 00:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273627;
        bh=Ue0q6EIYpFFcF6kK/Q/G8eHwOKg83zfAohN1NQwVa8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCioELd2++m1auqF1hkIJiZPpHwSULHm2iu9Dp01uhzinT9WMONRUqloqV8cmJ9RD
         GN3O9DgY4LlpxUEHyfwJxEo3xGJiB0C8hHfVKfXmmlWVdP+V7QFba3Fg1ONbP8Q2f1
         nnYUAW4QsCXLNBKZd0zsG+lh2k6xbVQub1SPCeO2tIe0hsiIYvYsWVzvMx8iIkx9Al
         vIMA6FspK/x1i1qeiKORxq7aOyRdx5InEbAwL4GYJewBzxVI9xUh9crKuwr4dzcoDm
         WBf7Dg4KOHnKxPXfiXRSD08MBWckf1wkTcfuMteEfBHJgI9jWx1xPO8arphnRTPogd
         imZ8/SbSYCa6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        jejb@linux.ibm.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 21/30] scsi: mpi3mr: Bad drive in topology results kernel crash
Date:   Sun, 19 Mar 2023 20:52:46 -0400
Message-Id: <20230320005258.1428043-21-sashal@kernel.org>
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

[ Upstream commit 8e45183978d64699df639e795235433a60f35047 ]

When the SAS Transport Layer support is enabled and a device exposed to
the OS by the driver fails INQUIRY commands, the driver frees up the memory
allocated for an internal HBA port data structure. However, in some places,
the reference to the freed memory is not cleared. When the firmware sends
the Device Info change event for the same device again, the freed memory is
accessed and that leads to memory corruption and OS crash.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Link: https://lore.kernel.org/r/20230228140835.4075-7-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index b795a325534d3..be25f242fa794 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -2358,15 +2358,16 @@ int mpi3mr_report_tgtdev_to_sas_transport(struct mpi3mr_ioc *mrioc,
 	tgtdev->host_exposed = 1;
 	if (!mpi3mr_sas_port_add(mrioc, tgtdev->dev_handle,
 	    sas_address_parent, hba_port)) {
-		tgtdev->host_exposed = 0;
 		retval = -1;
-	} else if ((!tgtdev->starget)) {
-		if (!mrioc->is_driver_loading)
+		} else if ((!tgtdev->starget) && (!mrioc->is_driver_loading)) {
 			mpi3mr_sas_port_remove(mrioc, sas_address,
 			    sas_address_parent, hba_port);
-		tgtdev->host_exposed = 0;
 		retval = -1;
 	}
+	if (retval) {
+		tgtdev->dev_spec.sas_sata_inf.hba_port = NULL;
+		tgtdev->host_exposed = 0;
+	}
 	return retval;
 }
 
@@ -2395,6 +2396,7 @@ void mpi3mr_remove_tgtdev_from_sas_transport(struct mpi3mr_ioc *mrioc,
 	mpi3mr_sas_port_remove(mrioc, sas_address, sas_address_parent,
 	    hba_port);
 	tgtdev->host_exposed = 0;
+	tgtdev->dev_spec.sas_sata_inf.hba_port = NULL;
 }
 
 /**
@@ -2451,7 +2453,7 @@ static u8 mpi3mr_get_port_id_by_rphy(struct mpi3mr_ioc *mrioc, struct sas_rphy *
 
 		tgtdev = __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
 			    rphy->identify.sas_address, rphy);
-		if (tgtdev) {
+		if (tgtdev && tgtdev->dev_spec.sas_sata_inf.hba_port) {
 			port_id =
 				tgtdev->dev_spec.sas_sata_inf.hba_port->port_id;
 			mpi3mr_tgtdev_put(tgtdev);
-- 
2.39.2

