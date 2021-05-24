Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5B138EAA7
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbhEXO5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234192AbhEXOyf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:54:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA59561432;
        Mon, 24 May 2021 14:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867721;
        bh=BCFSwPzx2HxKv/p9u44M95JwdRo+S1eHf49eYFKdEJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hB4FPbwoE7cWFvSUqfE+Rv7Lnkt91LikKBWuEcnmCFS41t03y9Kez3YWJmvIPVUn7
         T+sTK3+4skyM/H8zxi2h42ZCvBUW7zk+9OQaRtA1taqm/AneWDQaVA4yofmhtxvRey
         5e2yXNE4p16HOFV4WIYD6LBm4L4KSYMEItwZw1XkkOwzfsBHDpo9SCV+6HvQks7OMF
         Bnbp4VWzEFguyXpJ43hZLItFzRg+RCmKK66+OhyZF9YzwrOQ9NLnaRoyQGc0UgDiyg
         47xiZNQqcYQGtz8sUM5EZ7bajc+sKbPi+BMISqUgpUndVZiaFqguUqZUSsXsvrz/yZ
         f+rI0wt345UmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matt Wang <wwentao@vmware.com>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 46/62] scsi: BusLogic: Fix 64-bit system enumeration error for Buslogic
Date:   Mon, 24 May 2021 10:47:27 -0400
Message-Id: <20210524144744.2497894-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
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
index ccb061ab0a0a..7231de2767a9 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3078,11 +3078,11 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
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

