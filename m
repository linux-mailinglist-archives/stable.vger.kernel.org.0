Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F17F2B6332
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732513AbgKQNfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:35:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732012AbgKQNfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:35:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C2A8207BC;
        Tue, 17 Nov 2020 13:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620148;
        bh=KjlZzjSxSYVKd8YaHzTmcETwGpcoLRp3HLiGKbHylBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgYqVRq1gqI14GkfQGmlt9JoVuE20FraLMN1WT1PXi4Ga0zGpF4NbvgWqUAaWpyQo
         WfFqvRm00GM1UmDCbDq/ioTLcu4vAUpvULQpJ6Z2RjpzvHcJe4IgAIplCGBXPCkKNo
         RtAwHQ2WM9PfhqldozWNDHgJTkTKadYvvxVQr2Z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Don Brace <don.brace@microchip.com>,
        Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 092/255] scsi: hpsa: Fix memory leak in hpsa_init_one()
Date:   Tue, 17 Nov 2020 14:03:52 +0100
Message-Id: <20201117122143.438268628@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 48d5da59262b4..aed59ec20ad9e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8854,7 +8854,7 @@ reinit_after_soft_reset:
 	/* hook into SCSI subsystem */
 	rc = hpsa_scsi_add_host(h);
 	if (rc)
-		goto clean7; /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
+		goto clean8; /* lastlogicals, perf, sg, cmd, irq, shost, pci, lu, aer/h */
 
 	/* Monitor the controller for firmware lockups */
 	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
@@ -8869,6 +8869,8 @@ reinit_after_soft_reset:
 				HPSA_EVENT_MONITOR_INTERVAL);
 	return 0;
 
+clean8: /* lastlogicals, perf, sg, cmd, irq, shost, pci, lu, aer/h */
+	kfree(h->lastlogicals);
 clean7: /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
 	hpsa_free_performant_mode(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-- 
2.27.0



