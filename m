Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76CC2013AB
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390466AbgFSQCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392178AbgFSPMy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:12:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95B5720776;
        Fri, 19 Jun 2020 15:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579574;
        bh=XyxooGzy8AMblJssvPD5OPR+1XIsIJH6f3B0ES9u9eY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWz3niSPS/WEwWcUC3i7/CGNTdNX0x+Dlss3V/3zUk+A3AzGaiUJ02//1FCVES79q
         pqnPz+oAZvEv4+y4raCnG6LXBDSabT/cHCNoTooU1M0JWtC6ejOB38b0psHxW5huco
         90pGrtwUUSOj71iTMREcYp4lO0P3RAkvx8/K5zsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcos Scriven <marcos@scriven.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 185/261] PCI: Avoid FLR for AMD Matisse HD Audio & USB 3.0
Date:   Fri, 19 Jun 2020 16:33:16 +0200
Message-Id: <20200619141658.779836675@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcos Scriven <marcos@scriven.org>

[ Upstream commit 0d14f06cd6657ba3446a5eb780672da487b068e7 ]

The AMD Matisse HD Audio & USB 3.0 devices advertise Function Level Reset
support, but hang when an FLR is triggered.

To reproduce the problem, attach the device to a VM, then detach and try to
attach again.

Rename the existing quirk_intel_no_flr(), which was not Intel-specific, to
quirk_no_flr(), and apply it to prevent the use of FLR on these AMD
devices.

Link: https://lore.kernel.org/r/CAAri2DpkcuQZYbT6XsALhx2e6vRqPHwtbjHYeiH7MNp4zmt1RA@mail.gmail.com
Signed-off-by: Marcos Scriven <marcos@scriven.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 2e50eec41dc4..ba3b114dcfa9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5130,13 +5130,23 @@ static void quirk_intel_qat_vf_cap(struct pci_dev *pdev)
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x443, quirk_intel_qat_vf_cap);
 
-/* FLR may cause some 82579 devices to hang */
-static void quirk_intel_no_flr(struct pci_dev *dev)
+/*
+ * FLR may cause the following to devices to hang:
+ *
+ * AMD Starship/Matisse HD Audio Controller 0x1487
+ * AMD Matisse USB 3.0 Host Controller 0x149c
+ * Intel 82579LM Gigabit Ethernet Controller 0x1502
+ * Intel 82579V Gigabit Ethernet Controller 0x1503
+ *
+ */
+static void quirk_no_flr(struct pci_dev *dev)
 {
 	dev->dev_flags |= PCI_DEV_FLAGS_NO_FLR_RESET;
 }
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_intel_no_flr);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_intel_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1487, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
 
 static void quirk_no_ext_tags(struct pci_dev *pdev)
 {
-- 
2.25.1



