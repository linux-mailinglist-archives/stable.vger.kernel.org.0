Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC0166C781
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbjAPQbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbjAPQaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:30:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5054E2798B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:19:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BB9F1CE1280
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB018C433D2;
        Mon, 16 Jan 2023 16:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885964;
        bh=UmATE5XzdjunoxpDpj7McMnprvCz2VeSZVP8YmHFV1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNrXYn5YfidGPOugGVTA4s56CvbKgtqOlxnwuvOLEn71nvrckX9ni4dlAm/qBFkWI
         2y3grnUkHEJsr/8Ct+x2+CkE6YOJt6FuSD9wQZ3qiVgFEbitIVUedbOd5glhz2O4sj
         1FDW+qBH4o8128hW5OmHPOKHbruOWIq1xDomVfZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 249/658] scsi: scsi_debug: Fix a warning in resp_write_scat()
Date:   Mon, 16 Jan 2023 16:45:37 +0100
Message-Id: <20230116154920.949936065@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 216e179724c1d9f57a8ababf8bd7aaabef67f01b ]

As 'lbdof_blen' is coming from user, if the size in kzalloc() is >=
MAX_ORDER then we hit a warning.

Call trace:

sg_ioctl
 sg_ioctl_common
   scsi_ioctl
    sg_scsi_ioctl
     blk_execute_rq
      blk_mq_sched_insert_request
       blk_mq_run_hw_queue
        __blk_mq_delay_run_hw_queue
         __blk_mq_run_hw_queue
          blk_mq_sched_dispatch_requests
           __blk_mq_sched_dispatch_requests
            blk_mq_dispatch_rq_list
             scsi_queue_rq
              scsi_dispatch_cmd
               scsi_debug_queuecommand
                schedule_resp
                 resp_write_scat

If you try to allocate a memory larger than(>=) MAX_ORDER, then kmalloc()
will definitely fail.  It creates a stack trace and messes up dmesg.  The
user controls the size here so if they specify a too large size it will
fail.

Add __GFP_NOWARN in order to avoid too large allocation warning.  This is
detected by static analysis using smatch.

Fixes: 481b5e5c7949 ("scsi: scsi_debug: add resp_write_scat function")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20221111100526.1790533-1-harshit.m.mogalapalli@oracle.com
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 408166bd20f3..2c86ed1dc4b5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3139,7 +3139,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
 		return illegal_condition_result;
 	}
-	lrdp = kzalloc(lbdof_blen, GFP_ATOMIC);
+	lrdp = kzalloc(lbdof_blen, GFP_ATOMIC | __GFP_NOWARN);
 	if (lrdp == NULL)
 		return SCSI_MLQUEUE_HOST_BUSY;
 	if (sdebug_verbose)
-- 
2.35.1



