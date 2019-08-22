Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6756E99B93
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404499AbfHVRZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:25:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391871AbfHVRZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:44 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 642CF2341A;
        Thu, 22 Aug 2019 17:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494743;
        bh=kFGKgC0gvPqD7KF3DhCZfPMKpv8ou032LeWM4nQGtDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wDeDtjl8MGecr05hziyKXw8dHPNb3s4BYmtEkosxJVmykzd0IbkXrMOc75rSsBkKX
         wTm7y5FHE2hawyHt79Jlz3EG0blEGADt/P4wHdCsbNx1b+g0g5JPpWHPNfFShcPl0u
         pGSwspDszLA0JOt6wVwmmmwvbBkzGSyWrKNRqPbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bader Ali - Saleh <bader.alisaleh@microsemi.com>,
        Scott Teel <scott.teel@microsemi.com>,
        Scott Benesh <scott.benesh@microsemi.com>,
        Kevin Barnett <kevin.barnett@microsemi.com>,
        Don Brace <don.brace@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 37/85] scsi: hpsa: correct scsi command status issue after reset
Date:   Thu, 22 Aug 2019 10:19:10 -0700
Message-Id: <20190822171732.932719199@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit eeebce1862970653cdf5c01e98bc669edd8f529a ]

Reviewed-by: Bader Ali - Saleh <bader.alisaleh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c43eccdea65d2..f570b8c5d857c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2320,6 +2320,8 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 	case IOACCEL2_SERV_RESPONSE_COMPLETE:
 		switch (c2->error_data.status) {
 		case IOACCEL2_STATUS_SR_TASK_COMP_GOOD:
+			if (cmd)
+				cmd->result = 0;
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_CHK_COND:
 			cmd->result |= SAM_STAT_CHECK_CONDITION;
@@ -2479,8 +2481,10 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 
 	/* check for good status */
 	if (likely(c2->error_data.serv_response == 0 &&
-			c2->error_data.status == 0))
+			c2->error_data.status == 0)) {
+		cmd->result = 0;
 		return hpsa_cmd_free_and_done(h, c, cmd);
+	}
 
 	/*
 	 * Any RAID offload error results in retry which will use
@@ -5617,6 +5621,12 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	}
 	c = cmd_tagged_alloc(h, cmd);
 
+	/*
+	 * This is necessary because the SML doesn't zero out this field during
+	 * error recovery.
+	 */
+	cmd->result = 0;
+
 	/*
 	 * Call alternate submit routine for I/O accelerated commands.
 	 * Retries always go down the normal I/O path.
-- 
2.20.1



