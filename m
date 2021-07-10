Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFC53C2D1C
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhGJCVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232145AbhGJCV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EE28613ED;
        Sat, 10 Jul 2021 02:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883523;
        bh=h91LIh+KeYUJMz/NOXSP/4Z8BHP3chzFmzGKxgxR+f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EX80IJaGdRExezrpzThuS0iD0+ui5tJbbEnWkulIhZ5zwVbMBwQLSTd29du5UaxRz
         YAwTPwFEpzYSQjCKS15LU28QvHZFPXC7fZqpUWS3mktOfSBYsFJ7uSx+FuMUhAqSHg
         lkvR2ialnkbedpkj/Sz10XVxcXzZ/0JB3CTUT8JzhkWAOXhnkx1L/K1wBTsE9kiOdp
         PpUEkCDINzLUGiFYQz+0/BRQ9g2MLGmPavoOuAMHO9MQc5wRSKD4eFj3x9SJzIpv5q
         0JnRPs3xs3elMs/yDBr4WHRFB4zLIkEmzApPaoD3X5rzG38gJnFq3yvozZktSziqjZ
         aZsSjB+DhmYxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 040/114] scsi: megaraid_sas: Fix resource leak in case of probe failure
Date:   Fri,  9 Jul 2021 22:16:34 -0400
Message-Id: <20210710021748.3167666-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
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
index 4d4e9dbe5193..e4004d3353b8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7545,11 +7545,16 @@ static int megasas_probe_one(struct pci_dev *pdev,
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
 
@@ -7557,8 +7562,16 @@ static int megasas_probe_one(struct pci_dev *pdev,
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
index 2221175ae051..8bf7db921758 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -5266,6 +5266,7 @@ megasas_alloc_fusion_context(struct megasas_instance *instance)
 		if (!fusion->log_to_span) {
 			dev_err(&instance->pdev->dev, "Failed from %s %d\n",
 				__func__, __LINE__);
+			kfree(instance->ctrl_context);
 			return -ENOMEM;
 		}
 	}
-- 
2.30.2

