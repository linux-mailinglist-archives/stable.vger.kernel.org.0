Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0283A31BCE2
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhBOPhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:37:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230425AbhBOPfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:35:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E54F64DCF;
        Mon, 15 Feb 2021 15:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403102;
        bh=H6plJyXO27aiqIwdd5XSrW9dkGwIyHBmlxIkRT8gcMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KF9szHFC2n+S2JVfXJUX+NgMX/O8tZIMUBy98hh9YmjQsqmw+c7Smhi3Al8J0WcZR
         kuD83niOb3Bt6g7PoH4pNyXsqRbQ84NYYVqgRboPn0x3691dAH4U/net2gH85SSMmv
         PyjHQ+nSswD2LeNbwUkAmJdiRy4bAM2qqEJt7A8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/104] scsi: lpfc: Fix EEH encountering oops with NVMe traffic
Date:   Mon, 15 Feb 2021 16:26:41 +0100
Message-Id: <20210215152720.386890600@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



