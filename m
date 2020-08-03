Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC12223A6FF
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgHCM5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgHCMVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:21:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E04F20738;
        Mon,  3 Aug 2020 12:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457304;
        bh=rRQsBuWultFzeA0SwrZlU9xbZ20iKD/hOXZx30bdjho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0Q8dgNb0b8QGI5JwDQY4jDyf6nPtFbMIstuxc5kOcMl6nmriZ3tpKQyzJNJwdI2d
         yGneSo7mSWaWa/3ANcycmbV5PxP/Eps6sKXbk6Gx4Ao1VUzbtjhL53Cba6evmf0YtI
         EXoImPcXE6TrRAsM7xaNIpfX11Yq4aqE5eNkVXHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.7 002/120] PCI/ASPM: Disable ASPM on ASMedia ASM1083/1085 PCIe-to-PCI bridge
Date:   Mon,  3 Aug 2020 14:17:40 +0200
Message-Id: <20200803121902.984796307@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
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
@@ -2330,6 +2330,19 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
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


