Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0923D0A0B
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 09:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbhGUHKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 03:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235839AbhGUHJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 03:09:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BF92600D1;
        Wed, 21 Jul 2021 07:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626853768;
        bh=TvAIj0siXlZAAhFY4IOaU+YZqsjrkHCmWRXentu+bqo=;
        h=Subject:To:From:Date:From;
        b=VHBldk9wy5XiCmN0KuBFWceavGDAzljoU4VuKn+GAx1cbIxgFhItN5wKaoiwMxqUs
         c0/0OY37lo10SaBG2JbeIZLx3fEbu0uNkPrMUY+xY/4azljMCh/n3TNN8mBgyj0nk5
         V0x28QSIVafNC2LuTVDaukU1X9sMOOEnQ6asiFHA=
Subject: patch "usb: xhci: avoid renesas_usb_fw.mem when it's unusable" added to usb-linus
To:     gthelen@google.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 09:49:16 +0200
Message-ID: <1626853756241118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: avoid renesas_usb_fw.mem when it's unusable

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0665e387318607d8269bfdea60723c627c8bae43 Mon Sep 17 00:00:00 2001
From: Greg Thelen <gthelen@google.com>
Date: Fri, 2 Jul 2021 00:12:24 -0700
Subject: usb: xhci: avoid renesas_usb_fw.mem when it's unusable

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
 drivers/usb/host/xhci-pci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 18c2bbddf080..1c9a7957c45c 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -636,7 +636,14 @@ static const struct pci_device_id pci_ids[] = {
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
-- 
2.32.0


