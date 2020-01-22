Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3B114502F
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387857AbgAVJoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:44:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387848AbgAVJo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:44:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C69024689;
        Wed, 22 Jan 2020 09:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686266;
        bh=Cug0z3RmEwOajik43RCt+J88axKfzDQMKeBDhYVqr4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JrFamKofme5MVK/NjBsnBjU6IlN5UVYubc202WcmPalcvfRE2AJs8ZYSg0Zuc2AEZ
         A6+2Ktkonq5XGOdVlqaK2G5S2MidS11ocyNSj1cw6EMZ/UhlcyXir80XbfMawX++5V
         Ba+oqm33N28SS+nHbBD301Crg5x7B342SP4InTuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Hernandez <michael.hernandez@cavium.com>,
        Huacai Chen <chenhc@lemote.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 097/103] scsi: qla2xxx: Fix qla2x00_request_irqs() for MSI
Date:   Wed, 22 Jan 2020 10:29:53 +0100
Message-Id: <20200122092816.364184440@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

commit 45dc8f2d9c94ed74a5e31e63e9136a19a7e16081 upstream.

Commit 4fa183455988 ("scsi: qla2xxx: Utilize pci_alloc_irq_vectors/
pci_free_irq_vectors calls.") use pci_alloc_irq_vectors() to replace
pci_enable_msi() but it didn't handle the return value correctly. This bug
make qla2x00 always fail to setup MSI if MSI-X fail, so fix it.

BTW, improve the log message of return value in qla2x00_request_irqs() to
avoid confusion.

Fixes: 4fa183455988 ("scsi: qla2xxx: Utilize pci_alloc_irq_vectors/pci_free_irq_vectors calls.")
Cc: Michael Hernandez <michael.hernandez@cavium.com>
Link: https://lore.kernel.org/r/1574314847-14280-1-git-send-email-chenhc@lemote.com
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_isr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3573,7 +3573,7 @@ qla2x00_request_irqs(struct qla_hw_data
 skip_msix:
 
 	ql_log(ql_log_info, vha, 0x0037,
-	    "Falling back-to MSI mode -%d.\n", ret);
+	    "Falling back-to MSI mode -- ret=%d.\n", ret);
 
 	if (!IS_QLA24XX(ha) && !IS_QLA2532(ha) && !IS_QLA8432(ha) &&
 	    !IS_QLA8001(ha) && !IS_P3P_TYPE(ha) && !IS_QLAFX00(ha) &&
@@ -3581,13 +3581,13 @@ skip_msix:
 		goto skip_msi;
 
 	ret = pci_alloc_irq_vectors(ha->pdev, 1, 1, PCI_IRQ_MSI);
-	if (!ret) {
+	if (ret > 0) {
 		ql_dbg(ql_dbg_init, vha, 0x0038,
 		    "MSI: Enabled.\n");
 		ha->flags.msi_enabled = 1;
 	} else
 		ql_log(ql_log_warn, vha, 0x0039,
-		    "Falling back-to INTa mode -- %d.\n", ret);
+		    "Falling back-to INTa mode -- ret=%d.\n", ret);
 skip_msi:
 
 	/* Skip INTx on ISP82xx. */


