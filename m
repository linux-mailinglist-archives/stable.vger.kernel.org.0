Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977632E1575
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbgLWCVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:21:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727093AbgLWCVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 227F523383;
        Wed, 23 Dec 2020 02:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690072;
        bh=n+dHf+9iipnLMbP70h2Xd3pDrJjVCPzFWRSVingdC/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYScbjwo3VX3YB5DMs2gmgyT6fah5YzsK9LoENYD/QdI79pbzd5D0pOmNMAh6VffN
         EqpiMAzjiA5aRhkxohvUTCJy6AnD/CRX9M8xgwjXUciRgbmcfiKp0l5I1XeEojdRMn
         VIUH5whLocrLhTRrbpgmuqx1aULZeILRy6jOtiklwuIUPIJ+fjToepJQvB061ujnYx
         SFscfOS2AMWhlI8Z+Yjs0y/Ow+mCsQmy4lnuCQStF367Q9tcd47jNYi8nLZAwhIfW6
         9PZgpx+P9Dvu6fHvPNFzwVYSkYUsKx0CcOEQ1lPXtN4AVdqeTWXWqGLyHCFwmRI84T
         4F97kXOMM+oeg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yuuzheng <yuuzheng@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Radha Ramachandran <radha@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/87] scsi: pm80xx: Fix pm8001_mpi_get_nvmd_resp() race condition
Date:   Tue, 22 Dec 2020 21:19:42 -0500
Message-Id: <20201223022103.2792705-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yuuzheng <yuuzheng@google.com>

[ Upstream commit 1f889b58716a5f5e3e4fe0e6742c1a4472f29ac1 ]

A use-after-free or null-pointer error occurs when the 251-byte response
data is copied from IOMB buffer to response message buffer in function
pm8001_mpi_get_nvmd_resp().

After sending the command get_nvmd_data(), the caller begins to sleep by
calling wait_for_complete() and waits for the wake-up from calling
complete() in pm8001_mpi_get_nvmd_resp(). Due to unexpected events (e.g.,
interrupt), if response buffer gets freed before memcpy(), a use-after-free
error will occur. To fix this, the complete() should be called after
memcpy().

Link: https://lore.kernel.org/r/20201102165528.26510-5-Viswas.G@microchip.com.com
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: yuuzheng <yuuzheng@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 3e814c0469fbd..026bf39e3892d 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3196,10 +3196,15 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		pm8001_ha->memoryMap.region[NVMD].virt_ptr,
 		fw_control_context->len);
 	kfree(ccb->fw_control_context);
+	/* To avoid race condition, complete should be
+	 * called after the message is copied to
+	 * fw_control_context->usrAddr
+	 */
+	complete(pm8001_ha->nvmd_completion);
+	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("Set nvm data complete!\n"));
 	ccb->task = NULL;
 	ccb->ccb_tag = 0xFFFFFFFF;
 	pm8001_tag_free(pm8001_ha, tag);
-	complete(pm8001_ha->nvmd_completion);
 }
 
 int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *piomb)
-- 
2.27.0

