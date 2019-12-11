Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3266711B2CC
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388482AbfLKPip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:38:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:49346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388230AbfLKPio (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:38:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA0AC2464B;
        Wed, 11 Dec 2019 15:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078723;
        bh=hem3ebfjLNtne7dQ8qxpZB4aD9lv/NFaA3OZLHfUMIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uq1GNHCDKY738d9llwp3no4jw87fT604gqQcga5P6n7/t7PfUp34BrCkb3QxgsfgR
         TYp9S5TZT48/lu8djdWvtKA0+65ZlHc6BN9nG5H4cQnWDftHaJ7m+Z3daOygs45O2b
         HlDh+MZxo9Ze6S5STcVAGDFlrZYnUDLgxgNMscuc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     peter chang <dpf@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Deepak Ukey <deepak.ukey@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, pmchba@pmcs.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 28/37] scsi: pm80xx: Fix for SATA device discovery
Date:   Wed, 11 Dec 2019 10:38:04 -0500
Message-Id: <20191211153813.24126-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153813.24126-1-sashal@kernel.org>
References: <20191211153813.24126-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: peter chang <dpf@google.com>

[ Upstream commit ce21c63ee995b7a8b7b81245f2cee521f8c3c220 ]

Driver was missing complete() call in mpi_sata_completion which result in
SATA abort error handling timing out. That causes the device to be left in
the in_recovery state so subsequent commands sent to the device fail and
the OS removes access to it.

Link: https://lore.kernel.org/r/20191114100910.6153-2-deepak.ukey@microchip.com
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: peter chang <dpf@google.com>
Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 9edd61c063a1a..df5f0bc295875 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2368,6 +2368,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk("task 0x%p done with io_status 0x%x"
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			t, status, ts->resp, ts->stat));
+		if (t->slow_task)
+			complete(&t->slow_task->completion);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-- 
2.20.1

