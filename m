Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFBC4FD49D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351910AbiDLHXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353031AbiDLHOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:14:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C25F255B1;
        Mon, 11 Apr 2022 23:55:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 089FD61451;
        Tue, 12 Apr 2022 06:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8DBC385A6;
        Tue, 12 Apr 2022 06:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746543;
        bh=RPqEzanMnDxC24UF3o+CM9LqcNRSJxwgPiVt2BV2MzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxiHDDvLmEoEDBfyIN+Lsjwa2vqTbKbSaLyI05ke9JCceLoH0wDJFhRyTrfTNAf6R
         ZCV+8MAXfJrV04NCzzIyE3KRqxKB/JQ06en8JFztkDoE2jBxXhCuYNXiwJpNjhwS2m
         Jk+S2VthMa4s6Tmv507qgi0ZM34ta+EXvS4lC49s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Kevin Barnett <kevin.barnett@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 044/285] scsi: smartpqi: Fix rmmod stack trace
Date:   Tue, 12 Apr 2022 08:28:21 +0200
Message-Id: <20220412062944.947521357@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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
2.35.1



