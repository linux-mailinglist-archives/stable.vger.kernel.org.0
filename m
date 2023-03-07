Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E8A6AF17C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbjCGSod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbjCGSoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:44:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D4BB5B46
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:34:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB03EB819CD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A91FC4339C;
        Tue,  7 Mar 2023 18:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213968;
        bh=+wK4g2EQI9MsPKrylAVSy3lz9m2TkGnuANr2zCXqWiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAmvXb8iiYBrGixGG3BX/lXaXQ5Q8Y86sfeJ9JmGr6tcR6tlHVHo70blbqIBMB+Yb
         8ORNonTDNBd2IyhXl3YmGuPD4ZOoFDegfLPHsDcwiUCCvdoUX3YM/Xq/jO/vSoY1xl
         CvaH9XQeEbykkDf3xL6r1AGSYmeETZNLCej0thUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 679/885] scsi: mpi3mr: Fix issues in mpi3mr_get_all_tgt_info()
Date:   Tue,  7 Mar 2023 18:00:13 +0100
Message-Id: <20230307170031.627813726@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit fb428a2005fc1260d18b989cc5199f281617f44d upstream.

The function mpi3mr_get_all_tgt_info() has four issues:

1) It calculates valid entry length in alltgt_info assuming the header part
   of the struct mpi3mr_device_map_info would equal to sizeof(u32).  The
   correct size is sizeof(u64).

2) When it calculates the valid entry length kern_entrylen, it excludes one
   entry by subtracting 1 from num_devices.

3) It copies num_device by calling memcpy(). Substitution is enough.

4) It does not specify the calculated length to sg_copy_from_buffer().
   Instead, it specifies the payload length which is larger than the
   alltgt_info size. It causes "BUG: KASAN: slab-out-of-bounds".

Fix the issues by using the correct header size, removing the subtraction
from num_devices, replacing the memcpy() with substitution and specifying
the correct length to sg_copy_from_buffer().

Link: https://lore.kernel.org/r/20230214005019.1897251-2-shinichiro.kawasaki@wdc.com
Cc: stable@vger.kernel.org
Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 9baac224b213..72054e3a26cb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -312,7 +312,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 		num_devices++;
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
-	if ((job->request_payload.payload_len == sizeof(u32)) ||
+	if ((job->request_payload.payload_len <= sizeof(u64)) ||
 		list_empty(&mrioc->tgtdev_list)) {
 		sg_copy_from_buffer(job->request_payload.sg_list,
 				    job->request_payload.sg_cnt,
@@ -320,14 +320,14 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 		return 0;
 	}
 
-	kern_entrylen = (num_devices - 1) * sizeof(*devmap_info);
-	size = sizeof(*alltgt_info) + kern_entrylen;
+	kern_entrylen = num_devices * sizeof(*devmap_info);
+	size = sizeof(u64) + kern_entrylen;
 	alltgt_info = kzalloc(size, GFP_KERNEL);
 	if (!alltgt_info)
 		return -ENOMEM;
 
 	devmap_info = alltgt_info->dmi;
-	memset((u8 *)devmap_info, 0xFF, (kern_entrylen + sizeof(*devmap_info)));
+	memset((u8 *)devmap_info, 0xFF, kern_entrylen);
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
 		if (i < num_devices) {
@@ -344,9 +344,10 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	num_devices = i;
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
-	memcpy(&alltgt_info->num_devices, &num_devices, sizeof(num_devices));
+	alltgt_info->num_devices = num_devices;
 
-	usr_entrylen = (job->request_payload.payload_len - sizeof(u32)) / sizeof(*devmap_info);
+	usr_entrylen = (job->request_payload.payload_len - sizeof(u64)) /
+		sizeof(*devmap_info);
 	usr_entrylen *= sizeof(*devmap_info);
 	min_entrylen = min(usr_entrylen, kern_entrylen);
 	if (min_entrylen && (!memcpy(&alltgt_info->dmi, devmap_info, min_entrylen))) {
@@ -358,7 +359,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 
 	sg_copy_from_buffer(job->request_payload.sg_list,
 			    job->request_payload.sg_cnt,
-			    alltgt_info, job->request_payload.payload_len);
+			    alltgt_info, (min_entrylen + sizeof(u64)));
 	rval = 0;
 out:
 	kfree(alltgt_info);
-- 
2.39.2



