Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEE7412521
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381619AbhITSlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381491AbhITSi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:38:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6649C6331F;
        Mon, 20 Sep 2021 17:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159002;
        bh=kVKORygI7uG9FgVjbDwDHcU6s5KToObH9EXzb7DmW7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2gfB/h5NzKzrzbVrr3cgPxF7h4VNmZdvqajQ4NCcoYZx/qlkUitB0AiR5Kjco0pu
         GjWWDhSbWus8nCQnL98WR3KC9vOlO4jL1C+OJuP5mEG+s2P0gnjn1UJdxT5zbWGCaL
         jnU0yYXN4+QYm8oQ3UaC8fu2zii5m6xxyZAwHpmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.14 009/168] PCI: Add AMD GPU multi-function power dependencies
Date:   Mon, 20 Sep 2021 18:42:27 +0200
Message-Id: <20210920163921.963519692@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit 60b78ed088ebe1a872ee1320b6c5ad6ee2c4bd9a upstream.

Some AMD GPUs have built-in USB xHCI and USB Type-C UCSI controllers with
power dependencies between the GPU and the other functions as in
6d2e369f0d4c ("PCI: Add NVIDIA GPU multi-function power dependencies").

Add device link support for the AMD integrated USB xHCI and USB Type-C UCSI
controllers.

Without this, runtime power management, including GPU resume and temp and
fan sensors don't work correctly.

Reported-at: https://gitlab.freedesktop.org/drm/amd/-/issues/1704
Link: https://lore.kernel.org/r/20210903063311.3606226-1-evan.quan@amd.com
Signed-off-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5350,7 +5350,7 @@ DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR
 			      PCI_CLASS_MULTIMEDIA_HD_AUDIO, 8, quirk_gpu_hda);
 
 /*
- * Create device link for NVIDIA GPU with integrated USB xHCI Host
+ * Create device link for GPUs with integrated USB xHCI Host
  * controller to VGA.
  */
 static void quirk_gpu_usb(struct pci_dev *usb)
@@ -5359,9 +5359,11 @@ static void quirk_gpu_usb(struct pci_dev
 }
 DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
 			      PCI_CLASS_SERIAL_USB, 8, quirk_gpu_usb);
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
+			      PCI_CLASS_SERIAL_USB, 8, quirk_gpu_usb);
 
 /*
- * Create device link for NVIDIA GPU with integrated Type-C UCSI controller
+ * Create device link for GPUs with integrated Type-C UCSI controller
  * to VGA. Currently there is no class code defined for UCSI device over PCI
  * so using UNKNOWN class for now and it will be updated when UCSI
  * over PCI gets a class code.
@@ -5374,6 +5376,9 @@ static void quirk_gpu_usb_typec_ucsi(str
 DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
 			      PCI_CLASS_SERIAL_UNKNOWN, 8,
 			      quirk_gpu_usb_typec_ucsi);
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
+			      PCI_CLASS_SERIAL_UNKNOWN, 8,
+			      quirk_gpu_usb_typec_ucsi);
 
 /*
  * Enable the NVIDIA GPU integrated HDA controller if the BIOS left it


