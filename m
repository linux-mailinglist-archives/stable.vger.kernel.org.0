Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31E12B608F
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgKQNKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:10:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729462AbgKQNKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:10:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82B612468F;
        Tue, 17 Nov 2020 13:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618621;
        bh=ftB/Lvk/JniQNtrB4zj8xCl/hMjsiHhtAZQ+3ZmknXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVmB8b0e+OBqCIEt0RsxIOx0xEwgLK+mNB6o2LA3MphVKGsI8LeLs9Boo5Ey/nf1G
         /eVwL/0pwX3ugHmuIVZHaNlFQfwdEDX6UOUTFMQcXTDwkK/pCGWj6K2o4ypNqwzCld
         L+ncGFqxgs+DAdyOhRsQmPs3vGY4agbx4CEpHwos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Don Brace <don.brace@microchip.com>,
        Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 29/78] scsi: hpsa: Fix memory leak in hpsa_init_one()
Date:   Tue, 17 Nov 2020 14:04:55 +0100
Message-Id: <20201117122110.522025121@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
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
index b82df8cdf9626..7f1d6d52d48bd 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8937,7 +8937,7 @@ reinit_after_soft_reset:
 	/* hook into SCSI subsystem */
 	rc = hpsa_scsi_add_host(h);
 	if (rc)
-		goto clean7; /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
+		goto clean8; /* lastlogicals, perf, sg, cmd, irq, shost, pci, lu, aer/h */
 
 	/* Monitor the controller for firmware lockups */
 	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
@@ -8949,6 +8949,8 @@ reinit_after_soft_reset:
 				h->heartbeat_sample_interval);
 	return 0;
 
+clean8: /* lastlogicals, perf, sg, cmd, irq, shost, pci, lu, aer/h */
+	kfree(h->lastlogicals);
 clean7: /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
 	hpsa_free_performant_mode(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-- 
2.27.0



