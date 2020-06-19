Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBB120150F
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404033AbgFSQRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390483AbgFSPCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:02:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D890F20734;
        Fri, 19 Jun 2020 15:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578944;
        bh=7w10rXu2sVvzKN7TaS3j1o+cBwIhXDiwMwU0dEUW7Jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkjED8wHXhJUEXltBCR8V9K8d4j0SCMwfiR0/wvYugIPN2HOXMSwfLqsUvWOYN9Gs
         qF+iH1l/qFkJ7a3oENl3+9EUWbJRr8vhdmB6u7XF10sB+8XV/uUSM3TYJYjzaJsOEo
         JDGY60tHTRtPYKjkhIosKtO044ZAO8Y1/dLjeDLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Daniel Drake <drake@endlessm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Aaron Plattner <aplattner@nvidia.com>,
        Peter Wu <peter@lekensteyn.nl>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Karol Herbst <kherbst@redhat.com>,
        Maik Freudenberg <hhfeuer@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 215/267] PCI: Enable NVIDIA HDA controllers
Date:   Fri, 19 Jun 2020 16:33:20 +0200
Message-Id: <20200619141659.038588653@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit b516ea586d717472178e6ef1c152e85608b0ce32 ]

Many NVIDIA GPUs can be configured as either a single-function video device
or a multi-function device with video at function 0 and an HDA audio
controller at function 1.  The HDA controller can be enabled or disabled by
a bit in the function 0 config space.

Some BIOSes leave the HDA disabled, which means the HDMI connector from the
NVIDIA GPU may not work.  Sometimes the BIOS enables the HDA if an HDMI
cable is connected at boot time, but that doesn't handle hotplug cases.

Enable the HDA controller on device enumeration and resume and re-read the
header type, which tells us whether the GPU is a multi-function device.

This quirk is limited to NVIDIA PCI devices with the VGA Controller device
class.  This is expected to correspond to product configurations where the
NVIDIA GPU has connectors attached.  Other products where the device class
is 3D Controller are expected to correspond to configurations where the
NVIDIA GPU is dedicated (dGPU) and has no connectors.  See original post
(URL below) for more details.

This commit takes inspiration from an earlier patch by Daniel Drake.

Link: https://lore.kernel.org/r/20190708051744.24039-1-drake@endlessm.com v2
Link: https://lore.kernel.org/r/20190613063514.15317-1-drake@endlessm.com v1
Link: https://devtalk.nvidia.com/default/topic/1024022
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=75985
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Daniel Drake <drake@endlessm.com>
[bhelgaas: commit log, log message, return early if already enabled]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Aaron Plattner <aplattner@nvidia.com>
Cc: Peter Wu <peter@lekensteyn.nl>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Maik Freudenberg <hhfeuer@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c    | 30 ++++++++++++++++++++++++++++++
 include/linux/pci_ids.h |  1 +
 2 files changed, 31 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 8ac2d5a4a224..502dca568d6c 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5120,6 +5120,36 @@ DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
 			      PCI_CLASS_SERIAL_UNKNOWN, 8,
 			      quirk_gpu_usb_typec_ucsi);
 
+/*
+ * Enable the NVIDIA GPU integrated HDA controller if the BIOS left it
+ * disabled.  https://devtalk.nvidia.com/default/topic/1024022
+ */
+static void quirk_nvidia_hda(struct pci_dev *gpu)
+{
+	u8 hdr_type;
+	u32 val;
+
+	/* There was no integrated HDA controller before MCP89 */
+	if (gpu->device < PCI_DEVICE_ID_NVIDIA_GEFORCE_320M)
+		return;
+
+	/* Bit 25 at offset 0x488 enables the HDA controller */
+	pci_read_config_dword(gpu, 0x488, &val);
+	if (val & BIT(25))
+		return;
+
+	pci_info(gpu, "Enabling HDA controller\n");
+	pci_write_config_dword(gpu, 0x488, val | BIT(25));
+
+	/* The GPU becomes a multi-function device when the HDA is enabled */
+	pci_read_config_byte(gpu, PCI_HEADER_TYPE, &hdr_type);
+	gpu->multifunction = !!(hdr_type & 0x80);
+}
+DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+			       PCI_BASE_CLASS_DISPLAY, 16, quirk_nvidia_hda);
+DECLARE_PCI_FIXUP_CLASS_RESUME_EARLY(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+			       PCI_BASE_CLASS_DISPLAY, 16, quirk_nvidia_hda);
+
 /*
  * Some IDT switches incorrectly flag an ACS Source Validation error on
  * completions for config read requests even though PCIe r4.0, sec
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 47833d8f8928..b952f1557f5d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1336,6 +1336,7 @@
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP78S_SMBUS    0x0752
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE       0x0759
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_SMBUS     0x07D8
+#define PCI_DEVICE_ID_NVIDIA_GEFORCE_320M           0x08A0
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP79_SMBUS     0x0AA2
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP89_SATA	    0x0D85
 
-- 
2.25.1



