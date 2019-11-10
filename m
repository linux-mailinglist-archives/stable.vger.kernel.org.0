Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55353F63D7
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbfKJCuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:50:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729572AbfKJCuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:50:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C41422581;
        Sun, 10 Nov 2019 02:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354216;
        bh=pdvAvsejs+m9ghYz4ndlfv1HwItb8YLYK5+SNO/7GAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tm+nWBQXp0B3oftZRz4Vtt/6RBi1yKcivmfn0An//gtAOkwrpf4PtpwscfyyTbJej
         hwvk6if8GwgoGo/CE2xhOdEuTFjJcqlAKPNAO8rzdHYd1zgpk+v85WjItiDdmAA7g8
         aTCPwxsEacRNHIGzukqNd4wPgHGdxo8nEy1rCg0s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Ondrey Zary <linux@rainbow-software.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 55/66] scsi: NCR5380: Clear all unissued commands on host reset
Date:   Sat,  9 Nov 2019 21:48:34 -0500
Message-Id: <20191110024846.32598-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024846.32598-1-sashal@kernel.org>
References: <20191110024846.32598-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

[ Upstream commit 1aeeeed7f03c576f096eede7b0384f99a98f588c ]

When doing a host reset we should be clearing all outstanding commands, not
just the command triggering the reset.

[mkp: adjusted Hannes' SoB address]

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Ondrey Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 3cfab8868c989..ba7b3aef3ef0b 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2392,7 +2392,7 @@ static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
 	spin_lock_irqsave(&hostdata->lock, flags);
 
 #if (NDEBUG & NDEBUG_ANY)
-	scmd_printk(KERN_INFO, cmd, __func__);
+	shost_printk(KERN_INFO, instance, __func__);
 #endif
 	NCR5380_dprint(NDEBUG_ANY, instance);
 	NCR5380_dprint_phase(NDEBUG_ANY, instance);
@@ -2410,10 +2410,13 @@ static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
 	 * commands!
 	 */
 
-	if (list_del_cmd(&hostdata->unissued, cmd)) {
+	list_for_each_entry(ncmd, &hostdata->unissued, list) {
+		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
+
 		cmd->result = DID_RESET << 16;
 		cmd->scsi_done(cmd);
 	}
+	INIT_LIST_HEAD(&hostdata->unissued);
 
 	if (hostdata->selecting) {
 		hostdata->selecting->result = DID_RESET << 16;
-- 
2.20.1

