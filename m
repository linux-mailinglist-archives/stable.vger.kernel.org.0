Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F82FF229
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbfKPPqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:46:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729505AbfKPPqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:47 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1929208C0;
        Sat, 16 Nov 2019 15:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919207;
        bh=Fi8OaMcX8gTmZH11iXnGBBrdgRkl0FBxFfRS9Yc16JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h5JHENdLgJVXN6jM4RI/bgAMK2o8ezS75aTfRHli4aUQIfyEFtQOplZX07WaIZSN7
         oJJ90WFgi+fOs3s+ag9gonqSx8jIYQR0iyACptCqTGzY+14Jkh6sCUT4NydFUoLgX6
         96Gsn6UE/Ao5jQVnU3P2UgIlcDGgCFR/P5aF/xmk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 211/237] scsi: megaraid_sas: Fix goto labels in error handling
Date:   Sat, 16 Nov 2019 10:40:46 -0500
Message-Id: <20191116154113.7417-211-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
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
index 2f94ab9c23540..2f31d266339f8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5410,7 +5410,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (!instance->msix_vectors) {
 		i = pci_alloc_irq_vectors(instance->pdev, 1, 1, PCI_IRQ_LEGACY);
 		if (i < 0)
-			goto fail_setup_irqs;
+			goto fail_init_adapter;
 	}
 
 	megasas_setup_reply_map(instance);
@@ -5619,9 +5619,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
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

