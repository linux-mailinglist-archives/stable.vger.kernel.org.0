Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2309E14B925
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387416AbgA1O1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:27:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387410AbgA1O1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:27:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0282E21739;
        Tue, 28 Jan 2020 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221665;
        bh=g0Z9QBGkkZWKLyDFFMC1v28NDBuTXl2GWQrE5zeB+2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3kVDMJNmg/kfOouWTDC07r67NwyoffWpZqss0jJfQ08JgggDumGv2n9bWmCq7nYt
         NAwATsEHZfP9n3ouyrK3nbOjLwfntthY6pWBZdOUfPSlJifRAoeUQN/58/R8lX7Rul
         MHtymlO79PtIIa+KVpykQEfgnxG9oYYTdxH1DsrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.19 25/92] PCI: Mark AMD Navi14 GPU rev 0xc5 ATS as broken
Date:   Tue, 28 Jan 2020 15:07:53 +0100
Message-Id: <20200128135812.295361279@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 5e89cd303e3a4505752952259b9f1ba036632544 upstream.

To account for parts of the chip that are "harvested" (disabled) due to
silicon flaws, caches on some AMD GPUs must be initialized before ATS is
enabled.

ATS is normally enabled by the IOMMU driver before the GPU driver loads, so
this cache initialization would have to be done in a quirk, but that's too
complex to be practical.

For Navi14 (device ID 0x7340), this initialization is done by the VBIOS,
but apparently some boards went to production with an older VBIOS that
doesn't do it.  Disable ATS for those boards.

Link: https://lore.kernel.org/r/20200114205523.1054271-3-alexander.deucher@amd.com
Bug: https://gitlab.freedesktop.org/drm/amd/issues/1015
See-also: d28ca864c493 ("PCI: Mark AMD Stoney Radeon R7 GPU ATS as broken")
See-also: 9b44b0b09dec ("PCI: Mark AMD Stoney GPU ATS as broken")
[bhelgaas: squash into one patch, simplify slightly, commit log]
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4891,18 +4891,25 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SE
 
 #ifdef CONFIG_PCI_ATS
 /*
- * Some devices have a broken ATS implementation causing IOMMU stalls.
- * Don't use ATS for those devices.
+ * Some devices require additional driver setup to enable ATS.  Don't use
+ * ATS for those devices as ATS will be enabled before the driver has had a
+ * chance to load and configure the device.
  */
-static void quirk_no_ats(struct pci_dev *pdev)
+static void quirk_amd_harvest_no_ats(struct pci_dev *pdev)
 {
-	pci_info(pdev, "disabling ATS (broken on this device)\n");
+	if (pdev->device == 0x7340 && pdev->revision != 0xc5)
+		return;
+
+	pci_info(pdev, "disabling ATS\n");
 	pdev->ats_cap = 0;
 }
 
 /* AMD Stoney platform GPU */
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x98e4, quirk_no_ats);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x6900, quirk_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x98e4, quirk_amd_harvest_no_ats);
+/* AMD Iceland dGPU */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x6900, quirk_amd_harvest_no_ats);
+/* AMD Navi14 dGPU */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7340, quirk_amd_harvest_no_ats);
 #endif /* CONFIG_PCI_ATS */
 
 /* Freescale PCIe doesn't support MSI in RC mode */


