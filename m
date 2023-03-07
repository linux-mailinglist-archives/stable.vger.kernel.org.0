Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2AB6AEC20
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjCGRwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbjCGRwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:52:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E72A4B36
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:46:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0637DB819C7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A1EC433EF;
        Tue,  7 Mar 2023 17:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211185;
        bh=NiNFn6FeKiBGfKYJaiyIAfUoEEPS2QismeyVd4s17AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8YySk4g1HJ48YXhAAqXu1Mx5yxyWUsmZbEMyn/3jt9D6U5NcLC0FAvQUGCv6Qz83
         vdiKaz8LNVolwKSrAXxzbglbsare4F1ejx0KoR6yhFj74u/FVWbgwNu0ec2plXEx0N
         0XoOO0qvlbcYodz1uV6fUxU0fDRTWABMMGcfo2Mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.2 0780/1001] scsi: mpi3mr: Fix issues in mpi3mr_get_all_tgt_info()
Date:   Tue,  7 Mar 2023 17:59:12 +0100
Message-Id: <20230307170055.600074998@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
 drivers/scsi/mpi3mr/mpi3mr_app.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -312,7 +312,7 @@ static long mpi3mr_get_all_tgt_info(stru
 		num_devices++;
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
-	if ((job->request_payload.payload_len == sizeof(u32)) ||
+	if ((job->request_payload.payload_len <= sizeof(u64)) ||
 		list_empty(&mrioc->tgtdev_list)) {
 		sg_copy_from_buffer(job->request_payload.sg_list,
 				    job->request_payload.sg_cnt,
@@ -320,14 +320,14 @@ static long mpi3mr_get_all_tgt_info(stru
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
@@ -344,9 +344,10 @@ static long mpi3mr_get_all_tgt_info(stru
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
@@ -358,7 +359,7 @@ static long mpi3mr_get_all_tgt_info(stru
 
 	sg_copy_from_buffer(job->request_payload.sg_list,
 			    job->request_payload.sg_cnt,
-			    alltgt_info, job->request_payload.payload_len);
+			    alltgt_info, (min_entrylen + sizeof(u64)));
 	rval = 0;
 out:
 	kfree(alltgt_info);


