Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6AF03D6210
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbhGZPeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233473AbhGZPdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:33:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE96B60C40;
        Mon, 26 Jul 2021 16:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316017;
        bh=Pbmmhl+SwCyA5a0AenO4yVayqqeIWk0Bb6ZsKHmPnUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzLLzhEIDPxmPegD0PM9JLi9By4xQ4c4SG64+BOybi5/fwVoJSSckCyihHWWD0p/1
         CEHRWyoVrFNvq58n8zhzyBLVp7x/iTpMBIV6WmTQJIvo+Nu2QVrgaxKt0zorM4Tc6u
         11aT8jpxRiTjwT+6/swOwO1NC4PaiyiIECr8DIoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH 5.13 156/223] usb: xhci: avoid renesas_usb_fw.mem when its unusable
Date:   Mon, 26 Jul 2021 17:39:08 +0200
Message-Id: <20210726153851.324980843@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Thelen <gthelen@google.com>

commit 0665e387318607d8269bfdea60723c627c8bae43 upstream.

Commit a66d21d7dba8 ("usb: xhci: Add support for Renesas controller with
memory") added renesas_usb_fw.mem firmware reference to xhci-pci.  Thus
modinfo indicates xhci-pci.ko has "firmware: renesas_usb_fw.mem".  But
the firmware is only actually used with CONFIG_USB_XHCI_PCI_RENESAS.  An
unusable firmware reference can trigger safety checkers which look for
drivers with unmet firmware dependencies.

Avoid referring to renesas_usb_fw.mem in circumstances when it cannot be
loaded (when CONFIG_USB_XHCI_PCI_RENESAS isn't set).

Fixes: a66d21d7dba8 ("usb: xhci: Add support for Renesas controller with memory")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Thelen <gthelen@google.com>
Link: https://lore.kernel.org/r/20210702071224.3673568-1-gthelen@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -636,7 +636,14 @@ static const struct pci_device_id pci_id
 	{ /* end: all zeroes */ }
 };
 MODULE_DEVICE_TABLE(pci, pci_ids);
+
+/*
+ * Without CONFIG_USB_XHCI_PCI_RENESAS renesas_xhci_check_request_fw() won't
+ * load firmware, so don't encumber the xhci-pci driver with it.
+ */
+#if IS_ENABLED(CONFIG_USB_XHCI_PCI_RENESAS)
 MODULE_FIRMWARE("renesas_usb_fw.mem");
+#endif
 
 /* pci driver glue; this is a "new style" PCI driver module */
 static struct pci_driver xhci_pci_driver = {


