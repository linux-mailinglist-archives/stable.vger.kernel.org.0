Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C0315F345
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392965AbgBNSKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:10:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730625AbgBNPxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:53:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2876E24673;
        Fri, 14 Feb 2020 15:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695626;
        bh=Nst9ebLRaE3NHXB6enkxe0pAhC967ktXa0/Y8kcJryM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STR/sTvcOG4aW1cJXdIS8++wLS/gUL1EZtiEjH6mywJUnKjPknhFazI0/BsKVlz6v
         hW0mLlN5Cy7cu3J8/KD++IoI4zBTgeBt5kqf9HZl2HgibtKaX0DY1/EZU/JmvKPUMu
         8eAaIra4I/4BLeKHyZ7QuQp1eCLxsZriSNZKyGLI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Sewart <jamessewart@arista.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 225/542] PCI: Add DMA alias quirk for PLX PEX NTB
Date:   Fri, 14 Feb 2020 10:43:37 -0500
Message-Id: <20200214154854.6746-225-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Sewart <jamessewart@arista.com>

[ Upstream commit 7b90dfc4873b87c468cc6046538f46a531c1d785 ]

The PLX PEX NTB forwards DMA transactions using Requester IDs that don't
exist as PCI devices.  The devfn for a transaction is used as an index into
a lookup table storing the origin of a transaction on the other side of the
bridge.

Alias all possible devfns to the NTB device so that any transaction coming
in is governed by the mappings for the NTB.

Signed-off-by: James Sewart <jamessewart@arista.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 9aa590eb712fe..83953752337c4 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5371,6 +5371,21 @@ SWITCHTEC_QUIRK(0x8574);  /* PFXI 64XG3 */
 SWITCHTEC_QUIRK(0x8575);  /* PFXI 80XG3 */
 SWITCHTEC_QUIRK(0x8576);  /* PFXI 96XG3 */
 
+/*
+ * The PLX NTB uses devfn proxy IDs to move TLPs between NT endpoints.
+ * These IDs are used to forward responses to the originator on the other
+ * side of the NTB.  Alias all possible IDs to the NTB to permit access when
+ * the IOMMU is turned on.
+ */
+static void quirk_plx_ntb_dma_alias(struct pci_dev *pdev)
+{
+	pci_info(pdev, "Setting PLX NTB proxy ID aliases\n");
+	/* PLX NTB may use all 256 devfns */
+	pci_add_dma_alias(pdev, 0, 256);
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_PLX, 0x87b0, quirk_plx_ntb_dma_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_PLX, 0x87b1, quirk_plx_ntb_dma_alias);
+
 /*
  * On Lenovo Thinkpad P50 SKUs with a Nvidia Quadro M1000M, the BIOS does
  * not always reset the secondary Nvidia GPU between reboots if the system
-- 
2.20.1

