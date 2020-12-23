Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4B12E1707
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgLWDFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:05:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728537AbgLWCTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C691C2333F;
        Wed, 23 Dec 2020 02:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689911;
        bh=g9l/AVySqwUOgWXIZKwBBCsFwLsc0+LsVZFHye0PciE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKj3aOBUJfs9Wr5kmzbySkToutv/qNQKM1gzr3mozg0pM3FWsw3DXAl4pCUrTMQ48
         wsyXsaumHdqdJRoFHVGm2fHzASmHshhrmkhlOr3E/CpkdxrbSSo1ZaE/nVLQZCLUcv
         wZCKXLZ9k3rVTcKSW3NKEu8Z5myDPWvWBvMO4HMm/le30EBRU639ZgOqJ8vx61h6QT
         uLgd/Kk7IbMKt3L7diEEYjqZuWENmLPffi+ukL+Cys42MzrbRjNFnnpiMpe2xzWojy
         t0vV1oUuAxKkA77D8yV1/F34yMRRxFpoxsCfiQEFGUKQptBIbOpxQ7u+wl4URWWDbT
         9kY+avh4aeW8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yuuzheng <yuuzheng@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Radha Ramachandran <radha@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 013/130] scsi: pm80xx: Fix pm8001_mpi_get_nvmd_resp() race condition
Date:   Tue, 22 Dec 2020 21:16:16 -0500
Message-Id: <20201223021813.2791612-13-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index f8e11f672d1e2..f6d4a7578c80f 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3232,10 +3232,15 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
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

