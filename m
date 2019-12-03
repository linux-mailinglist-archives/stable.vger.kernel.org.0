Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B81111DEB
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbfLCW6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:58:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:54550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730629AbfLCW6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:58:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCB6420656;
        Tue,  3 Dec 2019 22:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413894;
        bh=Hg7/XqMKWSjexJGTuiwjWqUsEomk2ejWFfAGBHr0WEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LccXEoa5fdA/cHkxO5FHcLNPJ+4H8D1U4NxyzrwJYscfzDmV3i3osAX740XvFZJmn
         oxOUk7SIxvYKDC4VTC+42HVakdWlJ2wmPEnwzyfy8vT+7l765P8j05KRVy2D4MKBFO
         fWNS5r4pPUaqDFzOAWTQsQDsSAdgQxASy0AZArLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 253/321] scsi: hisi_sas: shutdown axi bus to avoid exception CQ returned
Date:   Tue,  3 Dec 2019 23:35:19 +0100
Message-Id: <20191203223440.298152074@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 5c31b0c677531c2b8b4e29b3cfb923df663f39b7 ]

When injecting 2 bit ECC error, it will cause fatal AXI interrupts. Before
the recovery of SAS controller reset, the internal of SAS controller is in
error. If CQ interrupts return at the time, actually it is exception CQ
interrupt, and it may cause resource release in disorder.

To avoid the exception situation, shutdown AXI bus after fatal AXI
interrupt. In SAS controller reset, it will restart AXI bus. For later
version of v3 hw, hardware will shutdown AXI bus for this situation, so
just fix current ver of v3 hw.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index fb2a5969181b5..a7407d5376ba2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1520,6 +1520,7 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
 	u32 irq_value, irq_msk;
 	struct hisi_hba *hisi_hba = p;
 	struct device *dev = hisi_hba->dev;
+	struct pci_dev *pdev = hisi_hba->pci_dev;
 	int i;
 
 	irq_msk = hisi_sas_read32(hisi_hba, ENT_INT_SRC_MSK3);
@@ -1551,6 +1552,17 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
 				error->msg, irq_value);
 			queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 		}
+
+		if (pdev->revision < 0x21) {
+			u32 reg_val;
+
+			reg_val = hisi_sas_read32(hisi_hba,
+						  AXI_MASTER_CFG_BASE +
+						  AM_CTRL_GLOBAL);
+			reg_val |= AM_CTRL_SHUTDOWN_REQ_MSK;
+			hisi_sas_write32(hisi_hba, AXI_MASTER_CFG_BASE +
+					 AM_CTRL_GLOBAL, reg_val);
+		}
 	}
 
 	if (irq_value & BIT(ENT_INT_SRC3_ITC_INT_OFF)) {
-- 
2.20.1



