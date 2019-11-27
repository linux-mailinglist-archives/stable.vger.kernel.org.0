Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1605710B97F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbfK0Uxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:53:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728353AbfK0Uxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:53:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 844CA21882;
        Wed, 27 Nov 2019 20:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888021;
        bh=zeMmqN91T1U6t+tXj7rn0j1WvBUUfrtvQg+SMNngmbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2tvASS1X+R1N+U67BLkWrhOaGns410dV78HKDfOL4Gd9i3M01Bx41KFxzDSVACFM
         JqOaRWgAKhKRUPyNj5WDRDDTGGsi+mpdN+p4tggUlZZXMCMOuYlX/Wt3xdRWjVlxh/
         mr6h5fE1Utu08ftOGUeaQKztJe57jD0UY17/IfoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 144/211] scsi: megaraid_sas: Fix goto labels in error handling
Date:   Wed, 27 Nov 2019 21:31:17 +0100
Message-Id: <20191127203107.612529069@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



