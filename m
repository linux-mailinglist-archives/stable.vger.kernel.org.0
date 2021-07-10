Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E263C2DFF
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhGJCZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhGJCZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:25:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CE67613E8;
        Sat, 10 Jul 2021 02:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883763;
        bh=sCeIkDHHckfR4D+RnhHTSkVjSEPu2eJfdUuxc5HFrfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXTgc1Cg1IOe1zMoil5T7COVrzpQmhGvX/4GLnsjtDwQI3RTwVd+VwSz6BqENhrwN
         aCwV5Ia47EI8DL2Ulo1pU4imwJwutlS7ApKDJwtKv5hNu7SzMi/A/RJCfmxT9p8TdN
         3XbJR7gaJ0IR4w8hC75UuijkgKQD9Iqk+PakPzwcsQMY60hyZ9FwlHKgdNmnj0BIgA
         oPWKSkVW0dBW0wHivehGn0C1zKzXqAty6OHDOpCnWKUuTI/pIDsdY/bEYMvgq+dJGG
         KZA4c/ugV1soP6Hq1wJT9hp5IRBlb0wP2JMKibi4/OSQbT21F3kJCfGFealmPoeC4L
         FWCQAj2+2XlOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 036/104] scsi: megaraid_sas: Fix resource leak in case of probe failure
Date:   Fri,  9 Jul 2021 22:20:48 -0400
Message-Id: <20210710022156.3168825-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
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
index 63a4f48bdc75..7ab741f03b84 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7478,11 +7478,16 @@ static int megasas_probe_one(struct pci_dev *pdev,
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
 
@@ -7490,8 +7495,16 @@ static int megasas_probe_one(struct pci_dev *pdev,
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
index 38fc9467c625..f83bfc459fa1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -5195,6 +5195,7 @@ megasas_alloc_fusion_context(struct megasas_instance *instance)
 		if (!fusion->log_to_span) {
 			dev_err(&instance->pdev->dev, "Failed from %s %d\n",
 				__func__, __LINE__);
+			kfree(instance->ctrl_context);
 			return -ENOMEM;
 		}
 	}
-- 
2.30.2

