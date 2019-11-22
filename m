Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E706410611E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfKVFyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:54:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727613AbfKVFxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:53:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80D5B2072D;
        Fri, 22 Nov 2019 05:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401991;
        bh=Br6czqm7QHjAlEQVygEZv/kGKjVi2PDAWm0cepnf6qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cszmBtxUWx8xZQv3TPhQ65jCFksBXTZAqi1FnhoyUNt45Abl1G/pa0RvsLJE8aiyB
         wNH1UfZuNBefdL9sRE7Dxh7ZtaWQoSsaNB5/Z2/y6HK+0OEKrtt7XIEojwU/vJ/LeV
         EFEZaiwSVjwRBA+TB+XuNE2ENDCXVRBIOH7JEwT4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 209/219] scsi: hisi_sas: shutdown axi bus to avoid exception CQ returned
Date:   Fri, 22 Nov 2019 00:49:00 -0500
Message-Id: <20191122054911.1750-201-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 3922b17e2ea39..675768ee648e7 100644
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

