Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04AE4FF34C
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbfKPQYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:24:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727812AbfKPPmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:21 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A424C2075E;
        Sat, 16 Nov 2019 15:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918941;
        bh=qsqvoLnvkm9r6o6e3Zo90Z9m4WCmoNPo7yyWUXtRSf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iO0Fiazwy0Hg8GGtY/N6W60KGmr12j1KUKuGyL/IMkP+P7ZKzOksYajZT45VrE1SD
         QuJqVYg9WVMp8Y9Gt/2rONnkHYiIgtrx6lXE6sTj83NKqO8KyRs8UoI7RHOJPem3gR
         YpVq1G8a4BrJmzOGbF/jnYmlHb/qXCd+ByVWjxcs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, dc395x@twibble.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 063/237] scsi: dc395x: fix dma API usage in srb_done
Date:   Sat, 16 Nov 2019 10:38:18 -0500
Message-Id: <20191116154113.7417-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3a5bd7021184dec2946f2a4d7a8943f8a5713e52 ]

We can't just transfer ownership to the CPU and then unmap, as this will
break with swiotlb.

Instead unmap the command and sense buffer a little earlier in the I/O
completion handler and get rid of the pci_dma_sync_sg_for_cpu call
entirely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/dc395x.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 1ed2cd82129d2..08161df64ead5 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3447,14 +3447,12 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		}
 	}
 
-	if (dir != PCI_DMA_NONE && scsi_sg_count(cmd))
-		pci_dma_sync_sg_for_cpu(acb->dev, scsi_sglist(cmd),
-					scsi_sg_count(cmd), dir);
-
 	ckc_only = 0;
 /* Check Error Conditions */
       ckc_e:
 
+	pci_unmap_srb(acb, srb);
+
 	if (cmd->cmnd[0] == INQUIRY) {
 		unsigned char *base = NULL;
 		struct ScsiInqData *ptr;
@@ -3507,7 +3505,6 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 			cmd, cmd->result);
 		srb_free_insert(acb, srb);
 	}
-	pci_unmap_srb(acb, srb);
 
 	cmd->scsi_done(cmd);
 	waiting_process_next(acb);
-- 
2.20.1

