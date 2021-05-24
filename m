Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF94138EBDD
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbhEXPHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234846AbhEXPFL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:05:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 452A761624;
        Mon, 24 May 2021 14:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867859;
        bh=pon5fKdHLxi+NILGNc50lSkTJKYRyySy5hnikaHr58Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJDlrXJkg8oUbnrCu5zi/0XyKvK9pVDsvtpB0HcGbpMbpDirScqgefTppYUix4ZRA
         itOjGLdJl5n6EAIogAdu9lj4UQHkk/iIKQpSMGhZsXE2WWJsQRhK9bakfam35EDXU5
         ZdkMl8ZSJ7ubYolk6y1WgFvCnSrnw/aIBUkpvmBSbKI1KJpx4HPD+uj2q39zV1/+uj
         OWEPkr7wfz3c+4RsQnxQ3yNNF3gj2aVUY8w9ZK487XwPpb5iHw1TJfwDD46Qu2/Wrk
         NG6+gISYgRqpbCIZKqJVVChHn/Dh+bAYKBNbFrAXc353yE45NZlgh+5+hJHbjdTs7i
         vJDymf/7aK/kQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matt Wang <wwentao@vmware.com>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 15/21] scsi: BusLogic: Fix 64-bit system enumeration error for Buslogic
Date:   Mon, 24 May 2021 10:50:34 -0400
Message-Id: <20210524145040.2499322-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145040.2499322-1-sashal@kernel.org>
References: <20210524145040.2499322-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Wang <wwentao@vmware.com>

[ Upstream commit 56f396146af278135c0ff958c79b5ee1bd22453d ]

Commit 391e2f25601e ("[SCSI] BusLogic: Port driver to 64-bit")
introduced a serious issue for 64-bit systems.  With this commit,
64-bit kernel will enumerate 8*15 non-existing disks.  This is caused
by the broken CCB structure.  The change from u32 data to void *data
increased CCB length on 64-bit system, which introduced an extra 4
byte offset of the CDB.  This leads to incorrect response to INQUIRY
commands during enumeration.

Fix disk enumeration failure by reverting the portion of the commit
above which switched the data pointer from u32 to void.

Link: https://lore.kernel.org/r/C325637F-1166-4340-8F0F-3BCCD59D4D54@vmware.com
Acked-by: Khalid Aziz <khalid@gonehiking.org>
Signed-off-by: Matt Wang <wwentao@vmware.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/BusLogic.c | 6 +++---
 drivers/scsi/BusLogic.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 35380a58d3f0..48c1b590415d 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3081,11 +3081,11 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 		ccb->opcode = BLOGIC_INITIATOR_CCB_SG;
 		ccb->datalen = count * sizeof(struct blogic_sg_seg);
 		if (blogic_multimaster_type(adapter))
-			ccb->data = (void *)((unsigned int) ccb->dma_handle +
+			ccb->data = (unsigned int) ccb->dma_handle +
 					((unsigned long) &ccb->sglist -
-					(unsigned long) ccb));
+					(unsigned long) ccb);
 		else
-			ccb->data = ccb->sglist;
+			ccb->data = virt_to_32bit_virt(ccb->sglist);
 
 		scsi_for_each_sg(command, sg, count, i) {
 			ccb->sglist[i].segbytes = sg_dma_len(sg);
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index 8d47e2c88d24..1a33a4b28d45 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -821,7 +821,7 @@ struct blogic_ccb {
 	unsigned char cdblen;				/* Byte 2 */
 	unsigned char sense_datalen;			/* Byte 3 */
 	u32 datalen;					/* Bytes 4-7 */
-	void *data;					/* Bytes 8-11 */
+	u32 data;					/* Bytes 8-11 */
 	unsigned char:8;				/* Byte 12 */
 	unsigned char:8;				/* Byte 13 */
 	enum blogic_adapter_status adapter_status;	/* Byte 14 */
-- 
2.30.2

