Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960D44A44E7
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiAaLez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379127AbiAaL3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:29:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361E4C0617A9;
        Mon, 31 Jan 2022 03:19:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EACF1B82A65;
        Mon, 31 Jan 2022 11:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF5AC340E8;
        Mon, 31 Jan 2022 11:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627995;
        bh=OSuO5PnMFjxxILHxYCzqxQ8mNf+RJzHno0hjReRUrB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6Fin3bQ2YpYkH2QkMqg23GPiyl7Gi/nMoD2zNDUew/TFj+pCbMgBvvjWo3bQMItb
         TT5NxxWkEye/YzJ6bPUht+EiTSLfAc6DUe+pcSPQshAQ0LFvpEnx1Mh5Fox83fzHjC
         j0Ni+oRITgziXnpIFEKtNLR0jWnh5XG+e40f0NcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>
Subject: [PATCH 5.16 090/200] PCI/sysfs: Find shadow ROM before static attribute initialization
Date:   Mon, 31 Jan 2022 11:55:53 +0100
Message-Id: <20220131105236.635467164@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

commit 66d28b21fe6b3da8d1e9f0a7ba38bc61b6c547e1 upstream.

Ville reported that the sysfs "rom" file for VGA devices disappeared after
527139d738d7 ("PCI/sysfs: Convert "rom" to static attribute").

Prior to 527139d738d7, FINAL fixups, including pci_fixup_video() where we
find shadow ROMs, were run before pci_create_sysfs_dev_files() created the
sysfs "rom" file.

After 527139d738d7, "rom" is a static attribute and is created before FINAL
fixups are run, so we didn't create "rom" files for shadow ROMs:

  acpi_pci_root_add
    ...
      pci_scan_single_device
        pci_device_add
          pci_fixup_video                    # <-- new HEADER fixup
          device_add
            ...
              if (grp->is_visible())
                pci_dev_rom_attr_is_visible  # after 527139d738d7
    pci_bus_add_devices
      pci_bus_add_device
        pci_fixup_device(pci_fixup_final)
          pci_fixup_video                    # <-- previous FINAL fixup
        pci_create_sysfs_dev_files
          if (pci_resource_len(pdev, PCI_ROM_RESOURCE))
            sysfs_create_bin_file("rom")     # before 527139d738d7

Change pci_fixup_video() to be a HEADER fixup so it runs before sysfs
static attributes are initialized.

Rename the Loongson pci_fixup_radeon() to pci_fixup_video() and make its
dmesg logging identical to the others since it is doing the same job.

Link: https://lore.kernel.org/r/YbxqIyrkv3GhZVxx@intel.com
Fixes: 527139d738d7 ("PCI/sysfs: Convert "rom" to static attribute")
Link: https://lore.kernel.org/r/20220126154001.16895-1-helgaas@kernel.org
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org			# v5.13+
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Krzysztof Wilczyński <kw@linux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/pci/fixup.c              |    4 ++--
 arch/mips/loongson64/vbios_quirk.c |    9 ++++-----
 arch/x86/pci/fixup.c               |    4 ++--
 3 files changed, 8 insertions(+), 9 deletions(-)

--- a/arch/ia64/pci/fixup.c
+++ b/arch/ia64/pci/fixup.c
@@ -76,5 +76,5 @@ static void pci_fixup_video(struct pci_d
 		}
 	}
 }
-DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
-				PCI_CLASS_DISPLAY_VGA, 8, pci_fixup_video);
+DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_ANY_ID, PCI_ANY_ID,
+			       PCI_CLASS_DISPLAY_VGA, 8, pci_fixup_video);
--- a/arch/mips/loongson64/vbios_quirk.c
+++ b/arch/mips/loongson64/vbios_quirk.c
@@ -3,7 +3,7 @@
 #include <linux/pci.h>
 #include <loongson.h>
 
-static void pci_fixup_radeon(struct pci_dev *pdev)
+static void pci_fixup_video(struct pci_dev *pdev)
 {
 	struct resource *res = &pdev->resource[PCI_ROM_RESOURCE];
 
@@ -22,8 +22,7 @@ static void pci_fixup_radeon(struct pci_
 	res->flags = IORESOURCE_MEM | IORESOURCE_ROM_SHADOW |
 		     IORESOURCE_PCI_FIXED;
 
-	dev_info(&pdev->dev, "BAR %d: assigned %pR for Radeon ROM\n",
-		 PCI_ROM_RESOURCE, res);
+	dev_info(&pdev->dev, "Video device with shadowed ROM at %pR\n", res);
 }
-DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_ATI, 0x9615,
-				PCI_CLASS_DISPLAY_VGA, 8, pci_fixup_radeon);
+DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_VENDOR_ID_ATI, 0x9615,
+			       PCI_CLASS_DISPLAY_VGA, 8, pci_fixup_video);
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -353,8 +353,8 @@ static void pci_fixup_video(struct pci_d
 		}
 	}
 }
-DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
-				PCI_CLASS_DISPLAY_VGA, 8, pci_fixup_video);
+DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_ANY_ID, PCI_ANY_ID,
+			       PCI_CLASS_DISPLAY_VGA, 8, pci_fixup_video);
 
 
 static const struct dmi_system_id msi_k8t_dmi_table[] = {


