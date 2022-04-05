Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4324F332D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245634AbiDEI4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbiDEIdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:33:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEE3DE7;
        Tue,  5 Apr 2022 01:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1970F61001;
        Tue,  5 Apr 2022 08:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264CCC385A1;
        Tue,  5 Apr 2022 08:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147514;
        bh=tzu4ubjxmqozK98KomH+7/MS5yAMop4h8j39lIkn8Dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sp2ayaC7Q0UOMT7+2UrkmAnJayYWkziRqIhhif8wrVoGo9x+8rFqBf66oHiMIX38W
         OOImkwqV/L5j0nfCTWUpCO/ogdY6+RIX5Jm+pvzLQQLvYKdU9V6QTgqRtWxUpZo5Mm
         s+nF/OrJ4y59Qlv2wf2bcvzIpM9Za61nHiHXDdFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurence Oberman <loberman@redhat.com>,
        Ming Lei <ming.lei@redhat.com>,
        David Jeffery <djeffery@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0023/1017] scsi: fnic: Finish scsi_cmnd before dropping the spinlock
Date:   Tue,  5 Apr 2022 09:15:36 +0200
Message-Id: <20220405070354.863867911@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: David Jeffery <djeffery@redhat.com>

[ Upstream commit 733ab7e1b5d1041204c4ca7373f6e6f9d08e3283 ]

When aborting a SCSI command through fnic, there is a race with the fnic
interrupt handler which can result in the SCSI command and its request
being completed twice. If the interrupt handler claims the command by
setting CMD_SP to NULL first, the abort handler assumes the interrupt
handler has completed the command and returns SUCCESS, causing the request
for the scsi_cmnd to be re-queued.

But the interrupt handler may not have finished the command yet. After it
drops the spinlock protecting CMD_SP, it does memory cleanup before finally
calling scsi_done() to complete the scsi_cmnd. If the call to scsi_done
occurs after the abort handler finishes and re-queues the request, the
completion of the scsi_cmnd will advance and try to double complete a
request already queued for retry.

This patch fixes the issue by moving scsi_done() and any other use of
scsi_cmnd to before the spinlock is released by the interrupt handler.

Link: https://lore.kernel.org/r/20220311184359.2345319-1-djeffery@redhat.com
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 88c549f257db..40a52feb315d 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -986,8 +986,6 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	CMD_SP(sc) = NULL;
 	CMD_FLAGS(sc) |= FNIC_IO_DONE;
 
-	spin_unlock_irqrestore(io_lock, flags);
-
 	if (hdr_status != FCPIO_SUCCESS) {
 		atomic64_inc(&fnic_stats->io_stats.io_failures);
 		shost_printk(KERN_ERR, fnic->lport->host, "hdr status = %s\n",
@@ -996,8 +994,6 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 
 	fnic_release_ioreq_buf(fnic, io_req, sc);
 
-	mempool_free(io_req, fnic->io_req_pool);
-
 	cmd_trace = ((u64)hdr_status << 56) |
 		  (u64)icmnd_cmpl->scsi_status << 48 |
 		  (u64)icmnd_cmpl->flags << 40 | (u64)sc->cmnd[0] << 32 |
@@ -1021,6 +1017,12 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	} else
 		fnic->lport->host_stats.fcp_control_requests++;
 
+	/* Call SCSI completion function to complete the IO */
+	scsi_done(sc);
+	spin_unlock_irqrestore(io_lock, flags);
+
+	mempool_free(io_req, fnic->io_req_pool);
+
 	atomic64_dec(&fnic_stats->io_stats.active_ios);
 	if (atomic64_read(&fnic->io_cmpl_skip))
 		atomic64_dec(&fnic->io_cmpl_skip);
@@ -1049,9 +1051,6 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 		if(io_duration_time > atomic64_read(&fnic_stats->io_stats.current_max_io_time))
 			atomic64_set(&fnic_stats->io_stats.current_max_io_time, io_duration_time);
 	}
-
-	/* Call SCSI completion function to complete the IO */
-	scsi_done(sc);
 }
 
 /* fnic_fcpio_itmf_cmpl_handler
-- 
2.34.1



