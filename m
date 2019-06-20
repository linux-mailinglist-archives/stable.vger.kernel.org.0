Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF5F4D7AF
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbfFTSJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728396AbfFTSJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:09:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29B512070B;
        Thu, 20 Jun 2019 18:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054150;
        bh=9V2N86cb4mxQbhVVZzJJ2pIIQZxb+CrxwkJdnJWXibM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nn//6LApx3ARVoKMG8I3B5z9r+28TY1aQekcuAgv69+2h/qgnt6QnSJHU4UxzV7LE
         InA1j1VHksu6fO4QPSuhDd/8Sm7gNxRAqmkPQeog26HxVxA2vOFCP6Tk6kIKQQdaAq
         cGHsoF7SP8CCPEkmuhkxhacWWrMi44YcQWIgNgwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lianbo Jiang <lijiang@redhat.com>,
        Don Brace <don.brace@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 36/45] scsi: smartpqi: properly set both the DMA mask and the coherent DMA mask
Date:   Thu, 20 Jun 2019 19:57:38 +0200
Message-Id: <20190620174339.915213134@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174328.608036501@linuxfoundation.org>
References: <20190620174328.608036501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1d94f06e7f5df4064ef336b7b710f50143b64a53 ]

When SME is enabled, the smartpqi driver won't work on the HP DL385 G10
machine, which causes the failure of kernel boot because it fails to
allocate pqi error buffer. Please refer to the kernel log:
....
[    9.431749] usbcore: registered new interface driver uas
[    9.441524] Microsemi PQI Driver (v1.1.4-130)
[    9.442956] i40e 0000:04:00.0: fw 6.70.48768 api 1.7 nvm 10.2.5
[    9.447237] smartpqi 0000:23:00.0: Microsemi Smart Family Controller found
         Starting dracut initqueue hook...
[  OK  ] Started Show Plymouth Boot Scre[    9.471654] Broadcom NetXtreme-C/E driver bnxt_en v1.9.1
en.
[  OK  ] Started Forward Password Requests to Plymouth Directory Watch.
[[0;[    9.487108] smartpqi 0000:23:00.0: failed to allocate PQI error buffer
....
[  139.050544] dracut-initqueue[949]: Warning: dracut-initqueue timeout - starting timeout scripts
[  139.589779] dracut-initqueue[949]: Warning: dracut-initqueue timeout - starting timeout scripts

Basically, the fact that the coherent DMA mask value wasn't set caused the
driver to fall back to SWIOTLB when SME is active.

For correct operation, lets call the dma_set_mask_and_coherent() to
properly set the mask for both streaming and coherent, in order to inform
the kernel about the devices DMA addressing capabilities.

Signed-off-by: Lianbo Jiang <lijiang@redhat.com>
Acked-by: Don Brace <don.brace@microsemi.com>
Tested-by: Don Brace <don.brace@microsemi.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 5ec2898d21cd..d34351c6b9af 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6392,7 +6392,7 @@ static int pqi_pci_init(struct pqi_ctrl_info *ctrl_info)
 	else
 		mask = DMA_BIT_MASK(32);
 
-	rc = dma_set_mask(&ctrl_info->pci_dev->dev, mask);
+	rc = dma_set_mask_and_coherent(&ctrl_info->pci_dev->dev, mask);
 	if (rc) {
 		dev_err(&ctrl_info->pci_dev->dev, "failed to set DMA mask\n");
 		goto disable_device;
-- 
2.20.1



