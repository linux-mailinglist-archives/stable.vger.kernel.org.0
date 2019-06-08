Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAB039E1E
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfFHLqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:46:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbfFHLmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:42:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C47C214C6;
        Sat,  8 Jun 2019 11:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994139;
        bh=5bcOOhnBzrcExyet8C5wXfJJjzJCXhhTYw5WMcEjTIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0P/j6PKcac11r0+/FEBXjDcrLljo4Pt+PY1U+UYi5j2Xxu/fMJEmQv3Zw9lGSnOn
         U8tICRgwAeZKLCXcd7Rsdwt2yoy1TyQjPyF7tcn++0x8xNx28HTLiGxSbwjZBjDp8s
         7+8I1G8Tj0k7yJvJdwK0XE5DFwt90flvFXQoajzI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lianbo Jiang <lijiang@redhat.com>,
        Don Brace <don.brace@microsemi.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, esc.storagedev@microsemi.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 66/70] scsi: smartpqi: properly set both the DMA mask and the coherent DMA mask
Date:   Sat,  8 Jun 2019 07:39:45 -0400
Message-Id: <20190608113950.8033-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lianbo Jiang <lijiang@redhat.com>

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
index 75ec43aa8df3..531824afba5f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7285,7 +7285,7 @@ static int pqi_pci_init(struct pqi_ctrl_info *ctrl_info)
 	else
 		mask = DMA_BIT_MASK(32);
 
-	rc = dma_set_mask(&ctrl_info->pci_dev->dev, mask);
+	rc = dma_set_mask_and_coherent(&ctrl_info->pci_dev->dev, mask);
 	if (rc) {
 		dev_err(&ctrl_info->pci_dev->dev, "failed to set DMA mask\n");
 		goto disable_device;
-- 
2.20.1

