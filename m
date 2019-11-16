Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F72FF0B2
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbfKPPuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:50:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:58718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729125AbfKPPue (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:50:34 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22EAC2182A;
        Sat, 16 Nov 2019 15:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919433;
        bh=zeMmqN91T1U6t+tXj7rn0j1WvBUUfrtvQg+SMNngmbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBrO+m/zxFbVZFEx750BD5VW7e1l4QEjcWafz2O3E19WaK4on0AMAURtb42hf3bfv
         ABuZ/nGGUE2jFfeGbHFS5wWLkJx25SuDA55kW4cRyrPKdiGAeMvwd5RxeNvZitbH9B
         VPk4/+ceokReaaMJcWGBo6JTP3hBqFd+rulZqJRY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 131/150] scsi: megaraid_sas: Fix goto labels in error handling
Date:   Sat, 16 Nov 2019 10:47:09 -0500
Message-Id: <20191116154729.9573-131-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

[ Upstream commit 8a25fa17b6ed6e6c8101e9c68a10ae68a9025f2c ]

During init, if pci_alloc_irq_vectors() fails, the driver has not yet setup
the IRQs. Fix the goto labels and error handling for this case.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 23a9f0777fa62..577513649afbe 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5324,7 +5324,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (!instance->msix_vectors) {
 		i = pci_alloc_irq_vectors(instance->pdev, 1, 1, PCI_IRQ_LEGACY);
 		if (i < 0)
-			goto fail_setup_irqs;
+			goto fail_init_adapter;
 	}
 
 	megasas_setup_reply_map(instance);
@@ -5541,9 +5541,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 fail_get_ld_pd_list:
 	instance->instancet->disable_intr(instance);
-fail_init_adapter:
 	megasas_destroy_irqs(instance);
-fail_setup_irqs:
+fail_init_adapter:
 	if (instance->msix_vectors)
 		pci_free_irq_vectors(instance->pdev);
 	instance->msix_vectors = 0;
-- 
2.20.1

