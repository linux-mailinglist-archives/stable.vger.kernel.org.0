Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC9E4122D5
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349493AbhITSST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376384AbhITSQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:16:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E63D663292;
        Mon, 20 Sep 2021 17:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158525;
        bh=v/tayfpX1bOz7k2xErtAMSvzzuqhs/FPU1R4fo7tjMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ymvf4Y839WPtkczEbAEuQn1PrG0K3AzHrxnmbkN943xthhMBOSm36U1+7cO9jvuP0
         nK+mCTbVcJqLgD0YxrrUVlF5LOFBLvR2Fpn1XZxVqzk/EIGOXVUbKlQqKwbom3dXnS
         3OggPY8GpqNrP4kb2aJS/JmXOTADNzObiW+soF/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 197/260] PCI: Add AMD GPU multi-function power dependencies
Date:   Mon, 20 Sep 2021 18:43:35 +0200
Message-Id: <20210920163937.804777673@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
@@ -5394,7 +5394,7 @@ DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR
 			      PCI_CLASS_MULTIMEDIA_HD_AUDIO, 8, quirk_gpu_hda);
 
 /*
- * Create device link for NVIDIA GPU with integrated USB xHCI Host
+ * Create device link for GPUs with integrated USB xHCI Host
  * controller to VGA.
  */
 static void quirk_gpu_usb(struct pci_dev *usb)
@@ -5403,9 +5403,11 @@ static void quirk_gpu_usb(struct pci_dev
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
@@ -5418,6 +5420,9 @@ static void quirk_gpu_usb_typec_ucsi(str
 DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
 			      PCI_CLASS_SERIAL_UNKNOWN, 8,
 			      quirk_gpu_usb_typec_ucsi);
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
+			      PCI_CLASS_SERIAL_UNKNOWN, 8,
+			      quirk_gpu_usb_typec_ucsi);
 
 /*
  * Enable the NVIDIA GPU integrated HDA controller if the BIOS left it


