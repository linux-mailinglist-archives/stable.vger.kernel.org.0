Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D6D47ADE1
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237849AbhLTO4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:56:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45688 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236429AbhLTOyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:54:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40FE1611BB;
        Mon, 20 Dec 2021 14:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2241FC36AF9;
        Mon, 20 Dec 2021 14:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012061;
        bh=ETh9eYwVsyPUcNkbf1gHX8x76+ti/iFzdziC9KkE+o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LswGJLc6tPrB1Nezi1jFgBzauHMoxurtG7ZXkBg1UYR4DsrXgj70zY7qzSM1Dlwby
         uVp4FItJ1mQMydt79x0DWxBg22L8wvjKW2x+BpasPNnwaQXqjAql031freM9CqFych
         XLqHNl7lmjxSjfhU8ZSxh7y/leg5VfinsytS14S8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 034/177] scsi: ufs: core: Retry START_STOP on UNIT_ATTENTION
Date:   Mon, 20 Dec 2021 15:33:04 +0100
Message-Id: <20211220143041.241708326@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit af21c3fd5b3ec540a97b367a70b26616ff7e0c55 upstream.

Commit 57d104c153d3 ("ufs: add UFS power management support") made the UFS
driver submit a REQUEST SENSE command before submitting a power management
command to a WLUN to clear the POWER ON unit attention. Instead of
submitting a REQUEST SENSE command before submitting a power management
command, retry the power management command until it succeeds.

This is the preparation to get rid of all UNIT ATTENTION code which should
be handled by users.

Link: https://lore.kernel.org/r/20211001182015.1347587-2-jaegeuk@kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufshcd.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8477,7 +8477,7 @@ static int ufshcd_set_dev_pwr_mode(struc
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
-	int ret;
+	int ret, retries;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->sdev_ufs_device;
@@ -8510,8 +8510,14 @@ static int ufshcd_set_dev_pwr_mode(struc
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
+	for (retries = 3; retries > 0; --retries) {
+		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
+		if (!scsi_status_is_check_condition(ret) ||
+				!scsi_sense_valid(&sshdr) ||
+				sshdr.sense_key != UNIT_ATTENTION)
+			break;
+	}
 	if (ret) {
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",


