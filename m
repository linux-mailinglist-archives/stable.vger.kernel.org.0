Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AFF313C41
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbhBHSD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:03:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235257AbhBHSAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:00:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68E3964EA6;
        Mon,  8 Feb 2021 17:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807110;
        bh=H6plJyXO27aiqIwdd5XSrW9dkGwIyHBmlxIkRT8gcMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhbJbjk7f+dEOEKt5GL/nMS/iLmMzeMt+kCt9CE6KTJVOdrXPqczNU72uP7NiwdFw
         Q3qnybxkqq7wyvNe72XQIdktosxLbF5bpcpxfGttt2S2rLfwKGbv+CblcY6l5AdXcC
         Y6gy/aIAUtTFGn/f3LymdfRuLrJMySuFzP7X7toS+Zwtjw7soc9Lvos6wVeUHImWm4
         BNfWsE0TR1/1NwJy8pEP4xpKi9UqMvpsTqbSJ5zJpwbG2eH4cCEFDwJ2PVjSasL7uU
         iwTluXCI4jsVvNT2xJgrOfYQ7etvII5LwvsldGWhoN0xpPSHpUodQViaY1+VHJFCwQ
         9NFfMdh0OFohw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/36] scsi: lpfc: Fix EEH encountering oops with NVMe traffic
Date:   Mon,  8 Feb 2021 12:57:47 -0500
Message-Id: <20210208175806.2091668-17-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 8c65830ae1629b03e5d65e9aafae7e2cf5f8b743 ]

In testing, in a configuration with Redfish and native NVMe multipath when
an EEH is injected, a kernel oops is being encountered:

(unreliable)
lpfc_nvme_ls_req+0x328/0x720 [lpfc]
__nvme_fc_send_ls_req.constprop.13+0x1d8/0x3d0 [nvme_fc]
nvme_fc_create_association+0x224/0xd10 [nvme_fc]
nvme_fc_reset_ctrl_work+0x110/0x154 [nvme_fc]
process_one_work+0x304/0x5d

the NBMe transport is issuing a Disconnect LS request, which the driver
receives and tries to post but the work queue used by the driver is already
being torn down by the eeh.

Fix by validating the validity of the work queue before proceeding with the
LS transmit.

Link: https://lore.kernel.org/r/20210127221601.84878-1-jsmart2021@gmail.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 69f1a0457f51e..03c81cec6bc98 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -714,6 +714,9 @@ __lpfc_nvme_ls_req(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		return -ENODEV;
 	}
 
+	if (!vport->phba->sli4_hba.nvmels_wq)
+		return -ENOMEM;
+
 	/*
 	 * there are two dma buf in the request, actually there is one and
 	 * the second one is just the start address + cmd size.
-- 
2.27.0

