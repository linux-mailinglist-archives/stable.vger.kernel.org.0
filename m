Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5248F33B846
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbhCOOCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232750AbhCOOAR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED94464F71;
        Mon, 15 Mar 2021 13:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816790;
        bh=gKlWR5OD6YJnYAWwJMrB2fhx4cWpWEb+H0/hePFAhBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnrLZYoYaVlQR20hdgOq6p/mCYP5QIuIP/yOgx1dJc/LjuBw+GT4Ew7QIJF+amuzi
         0XR54OHAEGKDJMvEN1H/gutI7X7xPoNX21Yy7Lu9+l8nMT2OekXABy7nWDxTPiu6pL
         ymxWwWZBv06NRNmmfmhk/+4Ht3EWJym6DwVi1a9U=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        akshatzen <akshatzen@google.com>,
        Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Radha Ramachandran <radha@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 126/306] scsi: pm80xx: Fix missing tag_free in NVMD DATA req
Date:   Mon, 15 Mar 2021 14:53:09 +0100
Message-Id: <20210315135511.924863168@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
index dd15246d5b03..ea43dff40a85 100644
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



