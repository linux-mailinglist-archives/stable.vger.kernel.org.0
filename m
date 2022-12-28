Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE78658007
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbiL1QNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiL1QM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:12:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994106396
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:10:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 270E0B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7D5C433D2;
        Wed, 28 Dec 2022 16:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243841;
        bh=I2Xhz/Jdna+flkvroMELK0RP2K8ACcsMbkJMnpkalaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Biusnuyljl0SJ6hUJVysjQUGkUoT4EDqrk6xgLX3yue7pUiUiYnlHjbOfhE521mWl
         vX7iLnHmC6dLSmVXovKfhpssqDfYBBsfCwRWz5squNAhqKLVGL0ITwlnyWG6DyjFxL
         mJRX8lBBzIxHLU8fLOqOd52f3kkTG49WsPoRjGB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0597/1073] scsi: scsi_debug: Fix a warning in resp_write_scat()
Date:   Wed, 28 Dec 2022 15:36:25 +0100
Message-Id: <20221228144344.262869857@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 7346098c1c68..1355820b9733 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3785,7 +3785,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
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



