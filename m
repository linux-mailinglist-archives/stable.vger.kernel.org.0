Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F971212CA
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfLPRzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:55:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728099AbfLPRzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:55:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DDDE21582;
        Mon, 16 Dec 2019 17:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518949;
        bh=bOEKlkM0Bu6aFMQUWVJmuPimpJcF6y2YbSZcnZpYxnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5CQahxj5rKT+gRt8xL7Fm23KznkplBT1SthDbUghrd1SnrfwmsxfZmi/t68+8RK5
         Ona5G5/nzrP9pUEam+gyeSnOKFwL25apPfJJ7BjcFJszspQIjx0D1f2UuZTe7L1lSC
         t5mbHh/ITm3jSMZi+26BqSotswXPypOKX3I81LQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.14 132/267] x86/PCI: Avoid AMD FCH XHCI USB PME# from D0 defect
Date:   Mon, 16 Dec 2019 18:47:38 +0100
Message-Id: <20191216174907.382680758@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 7e8ce0e2b036dbc6617184317983aea4f2c52099 upstream.

The AMD FCH USB XHCI Controller advertises support for generating PME#
while in D0.  When in D0, it does signal PME# for USB 3.0 connect events,
but not for USB 2.0 or USB 1.1 connect events, which means the controller
doesn't wake correctly for those events.

  00:10.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH USB XHCI Controller [1022:7914] (rev 20) (prog-if 30 [XHCI])
        Subsystem: Dell FCH USB XHCI Controller [1028:087e]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Clear PCI_PM_CAP_PME_D0 in dev->pme_support to indicate the device will not
assert PME# from D0 so we don't rely on it.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203673
Link: https://lore.kernel.org/r/20190902145252.32111-1-kai.heng.feng@canonical.com
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/pci/fixup.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -589,6 +589,17 @@ static void pci_fixup_amd_ehci_pme(struc
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x7808, pci_fixup_amd_ehci_pme);
 
 /*
+ * Device [1022:7914]
+ * When in D0, PME# doesn't get asserted when plugging USB 2.0 device.
+ */
+static void pci_fixup_amd_fch_xhci_pme(struct pci_dev *dev)
+{
+	dev_info(&dev->dev, "PME# does not work under D0, disabling it\n");
+	dev->pme_support &= ~(PCI_PM_CAP_PME_D0 >> PCI_PM_CAP_PME_SHIFT);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x7914, pci_fixup_amd_fch_xhci_pme);
+
+/*
  * Apple MacBook Pro: Avoid [mem 0x7fa00000-0x7fbfffff]
  *
  * Using the [mem 0x7fa00000-0x7fbfffff] region, e.g., by assigning it to


