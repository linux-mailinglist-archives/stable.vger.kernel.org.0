Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2903C2FB5
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhGJCcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233718AbhGJCau (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:30:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB97461402;
        Sat, 10 Jul 2021 02:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884054;
        bh=jE/24Gsr/1ffoSTCYFF78xcO3eeVz62z3tCPcZk8ME0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQKukCVvyF7L1rlE6OgCEFhcoCen4L4Ps+sPHdnxb6KAQUjvt1d6jSH8L8yquhx67
         fy4j9YIJtdO6tp73xb+DUQgCWgVV2hnmgedcVEEPt7/9AlBYbNn+tCFbb/o3pKDzME
         GkbJgNtpKP2CxSy3xOBGGAG2mVHjejjpvFKFsvfMog3RFjzO4g8TL1HqCpAnv5qHzP
         J1zRT+p5urmQnl+dWX0bAs5CfZsm/iKN5rrox+SKX5O8W3o7yLCRtIS+FISWQh4LZb
         Qf56a+oreYUcRP+8pfomXlWRy41XUhaWVta/7mlo/eGC8z2eWMaUqaQg6BMnEnKCTR
         qfZSu7CagPnWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/63] scsi: megaraid_sas: Fix resource leak in case of probe failure
Date:   Fri,  9 Jul 2021 22:26:26 -0400
Message-Id: <20210710022709.3170675-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit b5438f48fdd8e1c3f130d32637511efd32038152 ]

The driver doesn't clean up all the allocated resources properly when
scsi_add_host(), megasas_start_aen() function fails during the PCI device
probe.

Clean up all those resources.

Link: https://lore.kernel.org/r/20210528131307.25683-3-chandrakanth.patil@broadcom.com
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 13 +++++++++++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b9c1f722f1de..418178c2b548 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7415,11 +7415,16 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	return 0;
 
 fail_start_aen:
+	instance->unload = 1;
+	scsi_remove_host(instance->host);
 fail_io_attach:
 	megasas_mgmt_info.count--;
 	megasas_mgmt_info.max_index--;
 	megasas_mgmt_info.instance[megasas_mgmt_info.max_index] = NULL;
 
+	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
+		del_timer_sync(&instance->sriov_heartbeat_timer);
+
 	instance->instancet->disable_intr(instance);
 	megasas_destroy_irqs(instance);
 
@@ -7427,8 +7432,16 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		megasas_release_fusion(instance);
 	else
 		megasas_release_mfi(instance);
+
 	if (instance->msix_vectors)
 		pci_free_irq_vectors(instance->pdev);
+	instance->msix_vectors = 0;
+
+	if (instance->fw_crash_state != UNAVAILABLE)
+		megasas_free_host_crash_buffer(instance);
+
+	if (instance->adapter_type != MFI_SERIES)
+		megasas_fusion_stop_watchdog(instance);
 fail_init_mfi:
 	scsi_host_put(host);
 fail_alloc_instance:
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 5dcd7b9b72ce..ae7a3e154bb2 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -5177,6 +5177,7 @@ megasas_alloc_fusion_context(struct megasas_instance *instance)
 		if (!fusion->log_to_span) {
 			dev_err(&instance->pdev->dev, "Failed from %s %d\n",
 				__func__, __LINE__);
+			kfree(instance->ctrl_context);
 			return -ENOMEM;
 		}
 	}
-- 
2.30.2

