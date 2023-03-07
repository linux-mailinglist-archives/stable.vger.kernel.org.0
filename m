Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4406AF178
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbjCGSo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbjCGSoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:44:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4960B2579
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:34:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D6E3B819EE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2E5C433EF;
        Tue,  7 Mar 2023 18:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213971;
        bh=PWndWIZ5eDn4w4W07t6aKsMNnvxz/Hkrcq7axkgpe68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svsdUrdhNn8uMP0sIma0GDBXQB4oncg5x46II/36j3NbW1yifKpM2fVoEvdT6qYhC
         0jiKiNxP1BiARA5Ttqq629hOTEMi3ZhqmZnH9PBSai3CIVQSwlkAw+ROPru6ciKMvY
         diDKgJPFYJpoZ1SMgvFZVAILkwmBZn8I251B9o70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 680/885] scsi: mpi3mr: Remove unnecessary memcpy() to alltgt_info->dmi
Date:   Tue,  7 Mar 2023 18:00:14 +0100
Message-Id: <20230307170031.664532389@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit eeb270aee3e085411399f129fc14fa04bd6d83cf upstream.

In the function mpi3mr_get_all_tgt_info(), devmap_info points to
alltgt_info->dmi then there is no need to memcpy() data from devmap_info to
alltgt_info->dmi. Remove the unnecessary memcpy(). This also allows to
remove the local variable 'rval' and the goto label 'out'.

Link: https://lore.kernel.org/r/20230214005019.1897251-3-shinichiro.kawasaki@wdc.com
Cc: stable@vger.kernel.org
Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 72054e3a26cb..bff637702397 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -293,7 +293,6 @@ static long mpi3mr_bsg_pel_enable(struct mpi3mr_ioc *mrioc,
 static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	struct bsg_job *job)
 {
-	long rval = -EINVAL;
 	u16 num_devices = 0, i = 0, size;
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev;
@@ -304,7 +303,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	if (job->request_payload.payload_len < sizeof(u32)) {
 		dprint_bsg_err(mrioc, "%s: invalid size argument\n",
 		    __func__);
-		return rval;
+		return -EINVAL;
 	}
 
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
@@ -350,20 +349,12 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 		sizeof(*devmap_info);
 	usr_entrylen *= sizeof(*devmap_info);
 	min_entrylen = min(usr_entrylen, kern_entrylen);
-	if (min_entrylen && (!memcpy(&alltgt_info->dmi, devmap_info, min_entrylen))) {
-		dprint_bsg_err(mrioc, "%s:%d: device map info copy failed\n",
-		    __func__, __LINE__);
-		rval = -EFAULT;
-		goto out;
-	}
 
 	sg_copy_from_buffer(job->request_payload.sg_list,
 			    job->request_payload.sg_cnt,
 			    alltgt_info, (min_entrylen + sizeof(u64)));
-	rval = 0;
-out:
 	kfree(alltgt_info);
-	return rval;
+	return 0;
 }
 /**
  * mpi3mr_get_change_count - Get topology change count
-- 
2.39.2



