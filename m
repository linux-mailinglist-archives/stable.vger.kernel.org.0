Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0955510B9F3
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfK0U61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:58:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731319AbfK0U61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:58:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37E3421582;
        Wed, 27 Nov 2019 20:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888305;
        bh=qsqvoLnvkm9r6o6e3Zo90Z9m4WCmoNPo7yyWUXtRSf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3XJGZRJtsUfSmTOZznEFI/PNwGlQaQqwbrqSPRSvDvmYrK7CwIQyjROA6ZAyEfjI
         jPHiOGKEZ0CHF50T7EAQd8hD9MP6UkySxqsueMF2NPbGktxK9ucadEQIECcf8ZOaM1
         9TYAnbMDdx1XdkKTFFeq2Nml2EqAWzNgPZejUMQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 082/306] scsi: dc395x: fix dma API usage in srb_done
Date:   Wed, 27 Nov 2019 21:28:52 +0100
Message-Id: <20191127203120.921093907@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



