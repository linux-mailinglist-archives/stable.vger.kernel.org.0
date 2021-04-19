Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B521A36443F
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241402AbhDSN0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242024AbhDSNZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:25:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4B6D61279;
        Mon, 19 Apr 2021 13:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838408;
        bh=tmk9auTV9c2q/Tm4db4keAyjyEwvAwB+TKa5nIyAZNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPlZFYed2wBAB2lchcGSM3cmZ2SbTWjkzMlOcoKz6oPANIfhcPUqk9EfKKFEJe1ob
         xuIiOv+Bn74bTn8A208JlI/L4NKfYUTbQFlfvfyN1DvlpnjZJSxUgOTewzDyZQSfGg
         WgKEwg3ZXbZqF7WzSHEszrPoMMO5ziKOp1xvhJB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Jolly Shah <jollys@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 49/73] scsi: libsas: Reset num_scatter if libata marks qc as NODATA
Date:   Mon, 19 Apr 2021 15:06:40 +0200
Message-Id: <20210419130525.414284176@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jolly Shah <jollys@google.com>

commit 176ddd89171ddcf661862d90c5d257877f7326d6 upstream.

When the cache_type for the SCSI device is changed, the SCSI layer issues a
MODE_SELECT command. The caching mode details are communicated via a
request buffer associated with the SCSI command with data direction set as
DMA_TO_DEVICE (scsi_mode_select()). When this command reaches the libata
layer, as a part of generic initial setup, libata layer sets up the
scatterlist for the command using the SCSI command (ata_scsi_qc_new()).
This command is then translated by the libata layer into
ATA_CMD_SET_FEATURES (ata_scsi_mode_select_xlat()). The libata layer treats
this as a non-data command (ata_mselect_caching()), since it only needs an
ATA taskfile to pass the caching on/off information to the device. It does
not need the scatterlist that has been setup, so it does not perform
dma_map_sg() on the scatterlist (ata_qc_issue()). Unfortunately, when this
command reaches the libsas layer (sas_ata_qc_issue()), libsas layer sees it
as a non-data command with a scatterlist. It cannot extract the correct DMA
length since the scatterlist has not been mapped with dma_map_sg() for a
DMA operation. When this partially constructed SAS task reaches pm80xx
LLDD, it results in the following warning:

"pm80xx_chip_sata_req 6058: The sg list address
start_addr=0x0000000000000000 data_len=0x0end_addr_high=0xffffffff
end_addr_low=0xffffffff has crossed 4G boundary"

Update libsas to handle ATA non-data commands separately so num_scatter and
total_xfer_len remain 0.

Link: https://lore.kernel.org/r/20210318225632.2481291-1-jollys@google.com
Fixes: 53de092f47ff ("scsi: libsas: Set data_dir as DMA_NONE if libata marks qc as NODATA")
Tested-by: Luo Jiaxing <luojiaxing@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Jolly Shah <jollys@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/libsas/sas_ata.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -200,18 +200,17 @@ static unsigned int sas_ata_qc_issue(str
 		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
 		task->total_xfer_len = qc->nbytes;
 		task->num_scatter = qc->n_elem;
+		task->data_dir = qc->dma_dir;
+	} else if (qc->tf.protocol == ATA_PROT_NODATA) {
+		task->data_dir = DMA_NONE;
 	} else {
 		for_each_sg(qc->sg, sg, qc->n_elem, si)
 			xfer += sg_dma_len(sg);
 
 		task->total_xfer_len = xfer;
 		task->num_scatter = si;
-	}
-
-	if (qc->tf.protocol == ATA_PROT_NODATA)
-		task->data_dir = DMA_NONE;
-	else
 		task->data_dir = qc->dma_dir;
+	}
 	task->scatter = qc->sg;
 	task->ata_task.retry_count = 1;
 	task->task_state_flags = SAS_TASK_STATE_PENDING;


