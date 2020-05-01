Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE2E1C14CB
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731574AbgEANnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:43:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731573AbgEANm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:42:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD6B9205C9;
        Fri,  1 May 2020 13:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340578;
        bh=94mw8uZEgOKrafDgEM6Tke72tytpPCo+cZotPk36k4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8d6ouF8vAcawMKb6jXYWb5FGcgxB5bH4uPQhMytbyUXVml+PdXVGiDRmwGFZ8pc4
         5tKysqFrQfcW7QtTgb+myxFe639EHimFVqSqfbQq9Ql4cK3CPq7rmWnHE1X2quNd4l
         CmJxvC1eDQ1HYpze0a0irH1q03/0mVF061w1yXIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.6 043/106] PCI: Avoid ASMedia XHCI USB PME# from D0 defect
Date:   Fri,  1 May 2020 15:23:16 +0200
Message-Id: <20200501131548.880771212@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 2880325bda8d53566dcb9725abc929eec871608e upstream.

The ASMedia USB XHCI Controller claims to support generating PME# while
in D0:

  01:00.0 USB controller: ASMedia Technology Inc. Device 2142 (prog-if 30 [XHCI])
    Subsystem: SUNIX Co., Ltd. Device 312b
    Capabilities: [78] Power Management version 3
      Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot-,D3cold-)
      Status: D0 NoSoftRst+ PME-Enable+ DSel=0 DScale=0 PME-

However PME# only gets asserted when plugging USB 2.0 or USB 1.1 devices,
but not for USB 3.0 devices.

Remove PCI_PM_CAP_PME_D0 to avoid using PME under D0.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=205919
Link: https://lore.kernel.org/r/20191219192006.16270-1-kai.heng.feng@canonical.com
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5527,3 +5527,14 @@ out_disable:
 DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, 0x13b1,
 			      PCI_CLASS_DISPLAY_VGA, 8,
 			      quirk_reset_lenovo_thinkpad_p50_nvgpu);
+
+/*
+ * Device [1b21:2142]
+ * When in D0, PME# doesn't get asserted when plugging USB 3.0 device.
+ */
+static void pci_fixup_no_d0_pme(struct pci_dev *dev)
+{
+	pci_info(dev, "PME# does not work under D0, disabling it\n");
+	dev->pme_support &= ~(PCI_PM_CAP_PME_D0 >> PCI_PM_CAP_PME_SHIFT);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ASMEDIA, 0x2142, pci_fixup_no_d0_pme);


