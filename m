Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FA01FEDFA
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 10:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgFRInX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 04:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728320AbgFRInW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 04:43:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBBAD214DB;
        Thu, 18 Jun 2020 08:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592469800;
        bh=aO8x8BAQf4bA0x3ukEckdZ4vCdDQ4nyGgn7G6wLhtV8=;
        h=Subject:To:From:Date:From;
        b=fjKnVEg2cA7lGtSvbc4SE2onpSqeZ4XmSinpDzSqD2sUIOH6k0gh8eJ4zK3pxQ8j9
         9zvjcdmeyQy2l4upSkpVZMqCJ+h7q7WhvqR/PbMBEho/JTRjDRLi1uS4frxOxskNgO
         4dY7f/sFr2kni5JtGIgB30iIa5l7WPNwoI6otNK0=
Subject: patch "USB: ehci: reopen solution for Synopsys HC bug" added to usb-linus
To:     liulongfang@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 10:43:08 +0200
Message-ID: <15924697884065@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: ehci: reopen solution for Synopsys HC bug

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1ddcb71a3edf0e1682b6e056158e4c4b00325f66 Mon Sep 17 00:00:00 2001
From: Longfang Liu <liulongfang@huawei.com>
Date: Mon, 8 Jun 2020 11:46:59 +0800
Subject: USB: ehci: reopen solution for Synopsys HC bug
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A Synopsys USB2.0 core used in Huawei Kunpeng920 SoC has a bug which
might cause the host controller not issuing ping.

Bug description:
After indicating an Interrupt on Async Advance, the software uses the
doorbell mechanism to delete the Next Link queue head of the last
executed queue head. At this time, the host controller still references
the removed queue head(the queue head is NULL). NULL reference causes
the host controller to lose the USB device.

Solution:
After deleting the Next Link queue head, when has_synopsys_hc_bug set
to 1，the software can write one of the valid queue head addresses to
the ASYNCLISTADDR register to allow the host controller to get
the valid queue head. in order to solve that problem, this patch set
the flag for Huawei Kunpeng920

There are detailed instructions and solutions in this patch:
commit 2f7ac6c19997 ("USB: ehci: add workaround for Synopsys HC bug")

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/1591588019-44284-1-git-send-email-liulongfang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-pci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 3c3820ad9092..af3c1b9b38b2 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -216,6 +216,13 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 		ehci_info(ehci, "applying MosChip frame-index workaround\n");
 		ehci->frame_index_bug = 1;
 		break;
+	case PCI_VENDOR_ID_HUAWEI:
+		/* Synopsys HC bug */
+		if (pdev->device == 0xa239) {
+			ehci_info(ehci, "applying Synopsys HC workaround\n");
+			ehci->has_synopsys_hc_bug = 1;
+		}
+		break;
 	}
 
 	/* optional debug port, normally in the first BAR */
-- 
2.27.0


