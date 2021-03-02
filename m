Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FFA32AF02
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhCCAON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:14:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383604AbhCBL4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 06:56:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81C3A64F0D;
        Tue,  2 Mar 2021 11:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686141;
        bh=Z44VBan+ciMPBEAO8gcJLdPEjd8Og8yZJ1Bf26BE4Ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMXAIALzbzyRHqiPwBMNodjscDpCa+hFwyoYmQSlicc72KeW5TEwuk+4IdrjKHWnB
         6GpFxh1YDcmDHhDzn9xj5FYptS1njRBwL71C4CtwTFVt2YGC0BlU8PCRxIcnr0tguX
         rpvNtEd5RZobfnJ0v+SNBZkWy6dEM7XpwEtpwhyGVH2Hh5FSyj4hQAYq6tp864FYSw
         MHOgwM+IDwhqr0j1wpfF+AKzRBa1Ofy9mXRsV1vQQGqOllK8iHKUZs7ESp/0DjB+nZ
         9MsDffVz6kSYexdmvNgPN8Hz96A4lyyXJkzLHAVmg9Zt0cnrnTkAb6KQUIn4dukfen
         Eu+lUE56zNYxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     akshatzen <akshatzen@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Radha Ramachandran <radha@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, pmchba@pmcs.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 04/52] scsi: pm80xx: Fix missing tag_free in NVMD DATA req
Date:   Tue,  2 Mar 2021 06:54:45 -0500
Message-Id: <20210302115534.61800-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: akshatzen <akshatzen@google.com>

[ Upstream commit 5d28026891c7041deec08cc5ddd8f3abd90195e1 ]

Tag was not freed in NVMD get/set data request failure scenario. This
caused a tag leak each time a request failed.

Link: https://lore.kernel.org/r/20210109123849.17098-5-Viswas.G@microchip.com
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: akshatzen <akshatzen@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index c8d4d87c5473..fc721d616f43 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3038,8 +3038,8 @@ void pm8001_mpi_set_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	complete(pm8001_ha->nvmd_completion);
 	pm8001_dbg(pm8001_ha, MSG, "Set nvm data complete!\n");
 	if ((dlen_status & NVMD_STAT) != 0) {
-		pm8001_dbg(pm8001_ha, FAIL, "Set nvm data error!\n");
-		return;
+		pm8001_dbg(pm8001_ha, FAIL, "Set nvm data error %x\n",
+				dlen_status);
 	}
 	ccb->task = NULL;
 	ccb->ccb_tag = 0xFFFFFFFF;
@@ -3062,11 +3062,17 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 
 	pm8001_dbg(pm8001_ha, MSG, "Get nvm data complete!\n");
 	if ((dlen_status & NVMD_STAT) != 0) {
-		pm8001_dbg(pm8001_ha, FAIL, "Get nvm data error!\n");
+		pm8001_dbg(pm8001_ha, FAIL, "Get nvm data error %x\n",
+				dlen_status);
 		complete(pm8001_ha->nvmd_completion);
+		/* We should free tag during failure also, the tag is not being
+		 * freed by requesting path anywhere.
+		 */
+		ccb->task = NULL;
+		ccb->ccb_tag = 0xFFFFFFFF;
+		pm8001_tag_free(pm8001_ha, tag);
 		return;
 	}
-
 	if (ir_tds_bn_dps_das_nvm & IPMode) {
 		/* indirect mode - IR bit set */
 		pm8001_dbg(pm8001_ha, MSG, "Get NVMD success, IR=1\n");
-- 
2.30.1

