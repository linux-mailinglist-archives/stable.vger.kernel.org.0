Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C38E126949
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfLSSgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:36:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727505AbfLSSgO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:36:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89B0224679;
        Thu, 19 Dec 2019 18:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780574;
        bh=w3yhLTO+m3owtSpnXd91u23gP/yH1TzFv6KaobX7H+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JS8FDxHydg5Cfz14hnVvt/HVre8bm0IiOWWL6IVqRhI0Jfs/9v69a7PCyX107btbV
         VRv2zujR2aWzgVPYv4qQ192ia2vAbTCG0o/h1BW3/lobTK94QAM5a/4v8K13x8YjMC
         sxcgLjkTmu2OQe2UYyl2paRGzI3ueCjTiCAeJjq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.4 004/162] x86/PCI: Avoid AMD FCH XHCI USB PME# from D0 defect
Date:   Thu, 19 Dec 2019 19:31:52 +0100
Message-Id: <20191219183157.527365032@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
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
@@ -542,6 +542,17 @@ static void twinhead_reserve_killing_zon
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x27B9, twinhead_reserve_killing_zone);
 
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
  * Broadwell EP Home Agent BARs erroneously return non-zero values when read.
  *
  * See http://www.intel.com/content/www/us/en/processors/xeon/xeon-e5-v4-spec-update.html


