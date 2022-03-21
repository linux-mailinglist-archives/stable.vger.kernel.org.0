Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA464E332D
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 23:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbiCUWz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 18:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiCUWzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 18:55:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18B24EF4B;
        Mon, 21 Mar 2022 15:37:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82EC4B81A53;
        Mon, 21 Mar 2022 21:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD535C340F3;
        Mon, 21 Mar 2022 21:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647899571;
        bh=tzu4ubjxmqozK98KomH+7/MS5yAMop4h8j39lIkn8Dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7Y24Dd8tYBtUvj8YvRPS/J/u7bubw8JPfDPMFQcw5S6qEl48mCXEPXVC3QNr9Keq
         3iOAbVv4fMOWDBBi3a/NLo6kCHcmA+CIOFdLabauNDUq1qtTG9rxE/7fDlmdMnkr2r
         vjZ7+9hlNZkQuZUxdx4tz1GWg+sdykzMB/b9R3PwbbF9X5bX0X9s3G+nlgHpUDH5Mk
         vuXIzEukOohx/2ravGUd3w2Ly9Mvu0QG3HfcpDzVYyxem6o1PSjjiQBK8/4LMwkWhT
         1UFFKoz3wXgB0HiETT+FMQvJy99nQWKWc5BNsFRJAqSUy6mPPa2K4GoGc7Zxps4RT3
         J9ryisWNXUTDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Jeffery <djeffery@redhat.com>,
        Laurence Oberman <loberman@redhat.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, satishkh@cisco.com,
        sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 5/6] scsi: fnic: Finish scsi_cmnd before dropping the spinlock
Date:   Mon, 21 Mar 2022 17:52:36 -0400
Message-Id: <20220321215240.490132-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220321215240.490132-1-sashal@kernel.org>
References: <20220321215240.490132-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

