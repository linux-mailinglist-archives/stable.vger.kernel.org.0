Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E117826B507
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgIOXfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726927AbgIOOgC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:36:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6990722273;
        Tue, 15 Sep 2020 14:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179972;
        bh=KE+dOjeAtydUuI0m1GnJa28CJwiJjqKAACeN7sV+qfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vIj2yHGj/Rsii0dSSEvVIi42twAhKgZh5xqeTwnVn71WI6s208YqNA6FJ6yn0C4na
         l8J7ps9CpLkBpF/NJklfIFx+OTGhRmxi7b2kFCkBazBpPtHH5tTz21GvV6WSoReGnR
         /M2GcCPJD0xCEWb5eGniGalTfxsaKFyyAFTTDhdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 028/177] scsi: libsas: Set data_dir as DMA_NONE if libata marks qc as NODATA
Date:   Tue, 15 Sep 2020 16:11:39 +0200
Message-Id: <20200915140654.985100982@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

[ Upstream commit 53de092f47ff40e8d4d78d590d95819d391bf2e0 ]

It was discovered that sdparm will fail when attempting to disable write
cache on a SATA disk connected via libsas.

In the ATA command set the write cache state is controlled through the SET
FEATURES operation. This is roughly corresponds to MODE SELECT in SCSI and
the latter command is what is used in the SCSI-ATA translation layer. A
subtle difference is that a MODE SELECT carries data whereas SET FEATURES
is defined as a non-data command in ATA.

Set the DMA data direction to DMA_NONE if the requested ATA command is
identified as non-data.

[mkp: commit desc]

Fixes: fa1c1e8f1ece ("[SCSI] Add SATA support to libsas")
Link: https://lore.kernel.org/r/1598426666-54544-1-git-send-email-luojiaxing@huawei.com
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_ata.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 5d716d3887071..6de4bc77fd55c 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -209,7 +209,10 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		task->num_scatter = si;
 	}
 
-	task->data_dir = qc->dma_dir;
+	if (qc->tf.protocol == ATA_PROT_NODATA)
+		task->data_dir = DMA_NONE;
+	else
+		task->data_dir = qc->dma_dir;
 	task->scatter = qc->sg;
 	task->ata_task.retry_count = 1;
 	task->task_state_flags = SAS_TASK_STATE_PENDING;
-- 
2.25.1



