Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78DB42691D
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240375AbhJHLeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240449AbhJHLcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:32:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 928356121F;
        Fri,  8 Oct 2021 11:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692639;
        bh=Qlnfsy33Fa5GLT82aBUq02M+g7d+tQhUIXd/wlt7r+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07D1hPlJhRgE6Grp+obrJfDw4ZIXmKcLU+LmJ8769cs3jnge4jocQd6uvXj06nZCt
         dYIw6HG3xbC7J3RDrT2dfcPRN1+M+1uLMgPgTll6kAgMLP2raLAvJlINvSoKiLK0Vh
         oBvhG0FwfCmWSllUnZijpRE1hob2iszdFpW/xPs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Wen Xiong <wenxiong@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/16] scsi: ses: Retry failed Send/Receive Diagnostic commands
Date:   Fri,  8 Oct 2021 13:28:00 +0200
Message-Id: <20211008112715.803347541@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112715.444305067@linuxfoundation.org>
References: <20211008112715.444305067@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Xiong <wenxiong@linux.ibm.com>

[ Upstream commit fbdac19e642899455b4e64c63aafe2325df7aafa ]

Setting SCSI logging level with error=3, we saw some errors from enclosues:

[108017.360833] ses 0:0:9:0: tag#641 Done: NEEDS_RETRY Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[108017.360838] ses 0:0:9:0: tag#641 CDB: Receive Diagnostic 1c 01 01 00 20 00
[108017.427778] ses 0:0:9:0: Power-on or device reset occurred
[108017.427784] ses 0:0:9:0: tag#641 Done: SUCCESS Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[108017.427788] ses 0:0:9:0: tag#641 CDB: Receive Diagnostic 1c 01 01 00 20 00
[108017.427791] ses 0:0:9:0: tag#641 Sense Key : Unit Attention [current]
[108017.427793] ses 0:0:9:0: tag#641 Add. Sense: Bus device reset function occurred
[108017.427801] ses 0:0:9:0: Failed to get diagnostic page 0x1
[108017.427804] ses 0:0:9:0: Failed to bind enclosure -19
[108017.427895] ses 0:0:10:0: Attached Enclosure device
[108017.427942] ses 0:0:10:0: Attached scsi generic sg18 type 13

Retry if the Send/Receive Diagnostic commands complete with a transient
error status (NOT_READY or UNIT_ATTENTION with ASC 0x29).

Link: https://lore.kernel.org/r/1631849061-10210-2-git-send-email-wenxiong@linux.ibm.com
Reviewed-by: Brian King <brking@linux.ibm.com>
Reviewed-by: James Bottomley <jejb@linux.ibm.com>
Signed-off-by: Wen Xiong <wenxiong@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ses.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c2afba2a5414..43e682297fd5 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,9 +87,16 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
+	unsigned int retries = SES_RETRIES;
+	struct scsi_sense_hdr sshdr;
+
+	do {
+		ret = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
+				       &sshdr, SES_TIMEOUT, 1, NULL);
+	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
+		 (sshdr.sense_key == NOT_READY ||
+		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
 
-	ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				NULL, SES_TIMEOUT, SES_RETRIES, NULL);
 	if (unlikely(ret))
 		return ret;
 
@@ -121,9 +128,16 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
+	struct scsi_sense_hdr sshdr;
+	unsigned int retries = SES_RETRIES;
+
+	do {
+		result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
+					  &sshdr, SES_TIMEOUT, 1, NULL);
+	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
+		 (sshdr.sense_key == NOT_READY ||
+		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
 
-	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-				  NULL, SES_TIMEOUT, SES_RETRIES, NULL);
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
-- 
2.33.0



