Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4412A6F9F
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbfICQdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731068AbfICQ2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98AE62343A;
        Tue,  3 Sep 2019 16:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528094;
        bh=9hITkvwS7RUR+NOyuSsEcOigWPALmP3ru1eoSEaWVu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMdJoln4t0/ssmwLXtcysSY4uJyat4IGu3tSASucMvwMEPxLYfSn9ghU+BKVPLq8S
         xTklqDU3CqBQMBUZw76wCkf6qtcpTRLy6CGV6kaLpJpPowB1Px7fe5DhX+LsK6LtnS
         RA6zvstvN2uCTOVmW0rrMqjLI6IXIHHjyVpgU4DY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 103/167] PCI: Add macro for Switchtec quirk declarations
Date:   Tue,  3 Sep 2019 12:24:15 -0400
Message-Id: <20190903162519.7136-103-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 01d5d7fa8376c6b5acda86e16fcad22de6bba486 ]

Add SWITCHTEC_QUIRK() to reduce redundancy in declaring devices that use
quirk_switchtec_ntb_dma_alias().

By itself, this is no functional change, but a subsequent patch updates
SWITCHTEC_QUIRK() to fix ad281ecf1c7d ("PCI: Add DMA alias quirk for
Microsemi Switchtec NTB").

Fixes: ad281ecf1c7d ("PCI: Add DMA alias quirk for Microsemi Switchtec NTB")
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
[bhelgaas: split to separate patch]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 90 +++++++++++++++++---------------------------
 1 file changed, 34 insertions(+), 56 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 28c64f84bfe72..6cda8b7ecc821 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5082,59 +5082,37 @@ static void quirk_switchtec_ntb_dma_alias(struct pci_dev *pdev)
 	pci_iounmap(pdev, mmio);
 	pci_disable_device(pdev);
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8531,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8532,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8533,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8534,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8535,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8536,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8543,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8544,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8545,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8546,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8551,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8552,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8553,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8554,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8555,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8556,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8561,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8562,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8563,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8564,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8565,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8566,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8571,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8572,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8573,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8574,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8575,
-			quirk_switchtec_ntb_dma_alias);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, 0x8576,
-			quirk_switchtec_ntb_dma_alias);
+#define SWITCHTEC_QUIRK(vid) \
+	DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MICROSEMI, vid, \
+				quirk_switchtec_ntb_dma_alias)
+
+SWITCHTEC_QUIRK(0x8531);  /* PFX 24xG3 */
+SWITCHTEC_QUIRK(0x8532);  /* PFX 32xG3 */
+SWITCHTEC_QUIRK(0x8533);  /* PFX 48xG3 */
+SWITCHTEC_QUIRK(0x8534);  /* PFX 64xG3 */
+SWITCHTEC_QUIRK(0x8535);  /* PFX 80xG3 */
+SWITCHTEC_QUIRK(0x8536);  /* PFX 96xG3 */
+SWITCHTEC_QUIRK(0x8541);  /* PSX 24xG3 */
+SWITCHTEC_QUIRK(0x8542);  /* PSX 32xG3 */
+SWITCHTEC_QUIRK(0x8543);  /* PSX 48xG3 */
+SWITCHTEC_QUIRK(0x8544);  /* PSX 64xG3 */
+SWITCHTEC_QUIRK(0x8545);  /* PSX 80xG3 */
+SWITCHTEC_QUIRK(0x8546);  /* PSX 96xG3 */
+SWITCHTEC_QUIRK(0x8551);  /* PAX 24XG3 */
+SWITCHTEC_QUIRK(0x8552);  /* PAX 32XG3 */
+SWITCHTEC_QUIRK(0x8553);  /* PAX 48XG3 */
+SWITCHTEC_QUIRK(0x8554);  /* PAX 64XG3 */
+SWITCHTEC_QUIRK(0x8555);  /* PAX 80XG3 */
+SWITCHTEC_QUIRK(0x8556);  /* PAX 96XG3 */
+SWITCHTEC_QUIRK(0x8561);  /* PFXL 24XG3 */
+SWITCHTEC_QUIRK(0x8562);  /* PFXL 32XG3 */
+SWITCHTEC_QUIRK(0x8563);  /* PFXL 48XG3 */
+SWITCHTEC_QUIRK(0x8564);  /* PFXL 64XG3 */
+SWITCHTEC_QUIRK(0x8565);  /* PFXL 80XG3 */
+SWITCHTEC_QUIRK(0x8566);  /* PFXL 96XG3 */
+SWITCHTEC_QUIRK(0x8571);  /* PFXI 24XG3 */
+SWITCHTEC_QUIRK(0x8572);  /* PFXI 32XG3 */
+SWITCHTEC_QUIRK(0x8573);  /* PFXI 48XG3 */
+SWITCHTEC_QUIRK(0x8574);  /* PFXI 64XG3 */
+SWITCHTEC_QUIRK(0x8575);  /* PFXI 80XG3 */
+SWITCHTEC_QUIRK(0x8576);  /* PFXI 96XG3 */
-- 
2.20.1

