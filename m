Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912C53CDFC7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345493AbhGSPLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344695AbhGSPIE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:08:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E39261351;
        Mon, 19 Jul 2021 15:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709693;
        bh=TLnzebTb9MmGCEw9e7SnEQlxLGwSIHh9/HCpE8FFGjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izFmtmIGHqVVoK+8bkAqjCc6PRaVSYz9VYTiiMqokSoe2VNrGP8T+LDbR+SQ62NfQ
         8oKzFVe/ZBVU7jKZ92EJ5CBkOHh8EHLl9i55Qf3GsHmYw9k6nlEXCJrw0ljKCcZiVT
         hkGf5zbJkbOi9Q9miq4gFZj3DXwOtzioOHGqah2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/149] scsi: megaraid_sas: Fix resource leak in case of probe failure
Date:   Mon, 19 Jul 2021 16:52:15 +0200
Message-Id: <20210719144907.967077289@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 
@@ -7427,8 +7432,16 @@ fail_io_attach:
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



