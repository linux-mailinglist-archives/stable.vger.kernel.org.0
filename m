Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4EC34424D
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhCVMkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231657AbhCVMil (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:38:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A79B761931;
        Mon, 22 Mar 2021 12:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416671;
        bh=JocfG6KJGfFGtY9reXX4CgCm+UnePnSPZ75dnzv8H/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d980WvHmg+/mRa4ES6zSSk9IJ3mt6GEiSVJwfH53Sk8Pk2jmareVeqS+JteBuresV
         HLQ6D91LxNUvJ0F+hV0IUrFs+dOaMWIglkTiqP5+7FBE+TQ3RD4zOJj0od9+930lad
         jyfYEAoTrowv8BfGcI/5Twb7BCleaj8rLQDdEfTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        yuuzheng <yuuzheng@google.com>,
        Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Radha Ramachandran <radha@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/157] scsi: pm80xx: Fix pm8001_mpi_get_nvmd_resp() race condition
Date:   Mon, 22 Mar 2021 13:27:14 +0100
Message-Id: <20210322121936.207738576@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9e9a546da959..2054c2b03d92 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3279,10 +3279,15 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
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
2.30.1



