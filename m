Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965862ACD8C
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732959AbgKJDzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:55:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:56096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732941AbgKJDzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:55:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4108320E65;
        Tue, 10 Nov 2020 03:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980499;
        bh=M0KRGxqTCcvw0U8+MbflUq3anI/8OJASA/HynP2EIPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMS4WtmyDLW/cuNrqlViy2BrJ4RdLyeqStqck/mQR55XBmdwqV0SRovIs6eRPA+8g
         HIF82YT7aD4gbDu/Vj99nwV3pAX4GNPfCrITmmVTZ6QPw20Gg5U+x47zUIbs/pVaBJ
         P51/iC1M087ddyTEQuYu8IO7nujM3hEyXihWIpak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        Don Brace <don.brace@microchip.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, storagedev@microchip.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/42] scsi: hpsa: Fix memory leak in hpsa_init_one()
Date:   Mon,  9 Nov 2020 22:54:11 -0500
Message-Id: <20201110035440.424258-13-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035440.424258-1-sashal@kernel.org>
References: <20201110035440.424258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>

[ Upstream commit af61bc1e33d2c0ec22612b46050f5b58ac56a962 ]

When hpsa_scsi_add_host() fails, h->lastlogicals is leaked since it is
missing a free() in the error handler.

Fix this by adding free() when hpsa_scsi_add_host() fails.

Link: https://lore.kernel.org/r/20201027073125.14229-1-keitasuzuki.park@sslab.ics.keio.ac.jp
Tested-by: Don Brace <don.brace@microchip.com>
Acked-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e67cb4561aace..bac705990a961 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8854,7 +8854,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* hook into SCSI subsystem */
 	rc = hpsa_scsi_add_host(h);
 	if (rc)
-		goto clean7; /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
+		goto clean8; /* lastlogicals, perf, sg, cmd, irq, shost, pci, lu, aer/h */
 
 	/* Monitor the controller for firmware lockups */
 	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
@@ -8869,6 +8869,8 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				HPSA_EVENT_MONITOR_INTERVAL);
 	return 0;
 
+clean8: /* lastlogicals, perf, sg, cmd, irq, shost, pci, lu, aer/h */
+	kfree(h->lastlogicals);
 clean7: /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
 	hpsa_free_performant_mode(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-- 
2.27.0

