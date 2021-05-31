Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3883139608D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhEaO2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232752AbhEaO0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:26:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88B2061C1B;
        Mon, 31 May 2021 13:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468821;
        bh=qpeWGXYbfBBTCp7GnN16Kw1/b0uQPW98VaTjozobj54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QS19l/KuK2T1wrCp5NIjZQwmZq8t9F3HUOGZPEJ3lYp8XcAg56OmpD484IpWczunL
         qkcl/zYwL6psdjiIwVHhq9FDpSKnPl/VTu6OxbXyCHZBb5YkFFgKPT4zTgCJ3IjgP4
         IikNTPH2dsZBf3xht1V4EV65gJd5t7tjAU4Ruu3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khalid Aziz <khalid@gonehiking.org>,
        Matt Wang <wwentao@vmware.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 124/177] scsi: BusLogic: Fix 64-bit system enumeration error for Buslogic
Date:   Mon, 31 May 2021 15:14:41 +0200
Message-Id: <20210531130652.207518522@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c25e8a54e869..6e988233fb81 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3077,11 +3077,11 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
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
index 6182cc8a0344..e081ad47d1cf 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -814,7 +814,7 @@ struct blogic_ccb {
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



