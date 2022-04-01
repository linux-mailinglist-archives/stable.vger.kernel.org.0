Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25734EF396
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346211AbiDAOvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348301AbiDAOmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:42:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4AA294A02;
        Fri,  1 Apr 2022 07:34:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CE4A60AD8;
        Fri,  1 Apr 2022 14:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8172C3410F;
        Fri,  1 Apr 2022 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823682;
        bh=DrqH9cql0k3eM6eCKUpNDdtUpEA96OPz/k7Lh2O7sJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfO26ec7jn2wb61+WHj7lbjuBp5BUNuTSzIJCaXYemXh7DmJdmRaVg424jwBoSdQp
         8bsJw6x8ANiunMr8RkZwphHpc/4BD85iM5Gy3WDSbxZsQGyKKMefOOEJ4kWrejDc5v
         8MmilGppg3TJOe9KaEpzubT5BvDFlK/IvK9eOkb7eyQ8IbKrAWI4nUzhxEZ485Dvos
         /Cmc1k5ZIwTlXCdPtwUDdxavMPY/2L+yrPjdKtAsrXxYJXzuxXzpqP70G0GUcNv1jW
         6cDRTloFjptA7vXRJW3SUEniP1djRQE7Y4LgZK3LStaK2nCBvp+tDRyjgl6Wr1I2kJ
         t+5R3plIun1ow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Don Brace <don.brace@microchip.com>,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Kevin Barnett <kevin.barnett@microchip.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        storagedev@microchip.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 037/109] scsi: smartpqi: Fix rmmod stack trace
Date:   Fri,  1 Apr 2022 10:31:44 -0400
Message-Id: <20220401143256.1950537-37-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
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

From: Don Brace <don.brace@microchip.com>

[ Upstream commit c4ff687d25c05919382a759503bd3821689f4e2f ]

Prevent "BUG: scheduling while atomic: rmmod" stack trace.

Stop setting spin_locks before calling OS functions to remove devices.

Link: https://lore.kernel.org/r/164375207296.440833.4996145011193819683.stgit@brunhilda.pdev.net
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f0897d587454..2db9f874cc51 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2513,17 +2513,15 @@ static void pqi_remove_all_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 	struct pqi_scsi_dev *device;
 	struct pqi_scsi_dev *next;
 
-	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
-
 	list_for_each_entry_safe(device, next, &ctrl_info->scsi_device_list,
 		scsi_device_list_entry) {
 		if (pqi_is_device_added(device))
 			pqi_remove_device(ctrl_info, device);
+		spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 		list_del(&device->scsi_device_list_entry);
 		pqi_free_device(device);
+		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 	}
-
-	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 }
 
 static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info)
-- 
2.34.1

