Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA46224B418
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbgHTJ5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730335AbgHTJ5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:57:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69F90207FB;
        Thu, 20 Aug 2020 09:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917458;
        bh=r9w4WXp9/e7/WqILGWIDl0giQdfpbmYMY9CwCYFkm6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aerKHIFzZUi0i0cup1a8pyeKjYz8rM3GX64EPqnAvI2u5BUGyO+YgKLe2c0gNSm5i
         uU4sdNtARYuVEh2q86mW2yOvA+mTr20uxEpohAlAAjKDjP0QxTE9JHuoJI1Oc3kiq/
         qZ1OT0l8MmcKXNCz+epcwGc0qqz0WLY6PQJNScjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.9 009/212] PCI/ASPM: Disable ASPM on ASMedia ASM1083/1085 PCIe-to-PCI bridge
Date:   Thu, 20 Aug 2020 11:19:42 +0200
Message-Id: <20200820091602.794106606@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <hancockrwd@gmail.com>

commit b361663c5a40c8bc758b7f7f2239f7a192180e7c upstream.

Recently ASPM handling was changed to allow ASPM on PCIe-to-PCI/PCI-X
bridges.  Unfortunately the ASMedia ASM1083/1085 PCIe to PCI bridge device
doesn't seem to function properly with ASPM enabled.  On an Asus PRIME
H270-PRO motherboard, it causes errors like these:

  pcieport 0000:00:1c.0: AER: PCIe Bus Error: severity=Corrected, type=Data Link Layer, (Transmitter ID)
  pcieport 0000:00:1c.0: AER:   device [8086:a292] error status/mask=00003000/00002000
  pcieport 0000:00:1c.0: AER:    [12] Timeout
  pcieport 0000:00:1c.0: AER: Corrected error received: 0000:00:1c.0
  pcieport 0000:00:1c.0: AER: can't find device of ID00e0

In addition to flooding the kernel log, this also causes the machine to
wake up immediately after suspend is initiated.

The device advertises ASPM L0s and L1 support in the Link Capabilities
register, but the ASMedia web page for ASM1083 [1] claims "No PCIe ASPM
support".

Windows 10 (build 2004) enables L0s, but it also logs correctable PCIe
errors.

Add a quirk to disable ASPM for this device.

[1] https://www.asmedia.com.tw/eng/e_show_products.php?cate_index=169&item=114

[bhelgaas: commit log]
Fixes: 66ff14e59e8a ("PCI/ASPM: Allow ASPM on links to PCIe-to-PCI/PCI-X Bridges")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=208667
Link: https://lore.kernel.org/r/20200722021803.17958-1-hancockrwd@gmail.com
Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2046,6 +2046,19 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10f4, quirk_disable_aspm_l0s);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1508, quirk_disable_aspm_l0s);
 
+static void quirk_disable_aspm_l0s_l1(struct pci_dev *dev)
+{
+	pci_info(dev, "Disabling ASPM L0s/L1\n");
+	pci_disable_link_state(dev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
+}
+
+/*
+ * ASM1083/1085 PCIe-PCI bridge devices cause AER timeout errors on the
+ * upstream PCIe root port when ASPM is enabled. At least L0s mode is affected;
+ * disable both L0s and L1 for now to be safe.
+ */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ASMEDIA, 0x1080, quirk_disable_aspm_l0s_l1);
+
 /*
  * Some Pericom PCIe-to-PCI bridges in reverse mode need the PCIe Retrain
  * Link bit cleared after starting the link retrain process to allow this


