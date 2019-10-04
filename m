Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975E3CBA7F
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 14:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730606AbfJDMdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 08:33:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729034AbfJDMdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 08:33:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF4AD215EA;
        Fri,  4 Oct 2019 12:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570192398;
        bh=wz9aJFKe+f2G30k8N2WxHRQAiExuNySk9X5RiM12uAQ=;
        h=Subject:To:From:Date:From;
        b=NbTB6tkgsaa5V8UmHaL8ZCQK+ISbO6dJ/H4gFi7uh1BM6aqc4RQypTg8fp5xlmImR
         lDZNWDa2PbkD8OlSy7iSiX52a3JRb2QfcxmxkXLNyS2dBHNojdr2gZng0+jQ2rAz8r
         51vXqXgurSRyu5FkWCTbBo0x8YR6u1ixKW5FNs7A=
Subject: patch "xhci: Fix USB 3.1 capability detection on early xHCI 1.1 spec based" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        loic.yhuel@gmail.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 14:33:06 +0200
Message-ID: <1570192386211241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Fix USB 3.1 capability detection on early xHCI 1.1 spec based

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 47f50d61076523e1a0d5a070062c2311320eeca8 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Fri, 4 Oct 2019 14:59:29 +0300
Subject: xhci: Fix USB 3.1 capability detection on early xHCI 1.1 spec based
 hosts
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Early xHCI 1.1 spec did not mention USB 3.1 capable hosts should set
sbrn to 0x31, or that the minor revision is a two digit BCD
containing minor and sub-minor numbers.
This was later clarified in xHCI 1.2.

Some USB 3.1 capable hosts therefore have sbrn set to 0x30, or minor
revision set to 0x1 instead of 0x10.

Detect the USB 3.1 capability correctly for these hosts as well

Fixes: ddd57980a0fd ("xhci: detect USB 3.2 capable host controllers correctly")
Cc: <stable@vger.kernel.org> # v4.18+
Cc: Loïc Yhuel <loic.yhuel@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1570190373-30684-5-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a5ba5ace3d00..aec69d294973 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5079,11 +5079,18 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 		hcd->has_tt = 1;
 	} else {
 		/*
-		 * Some 3.1 hosts return sbrn 0x30, use xhci supported protocol
-		 * minor revision instead of sbrn. Minor revision is a two digit
-		 * BCD containing minor and sub-minor numbers, only show minor.
+		 * Early xHCI 1.1 spec did not mention USB 3.1 capable hosts
+		 * should return 0x31 for sbrn, or that the minor revision
+		 * is a two digit BCD containig minor and sub-minor numbers.
+		 * This was later clarified in xHCI 1.2.
+		 *
+		 * Some USB 3.1 capable hosts therefore have sbrn 0x30, and
+		 * minor revision set to 0x1 instead of 0x10.
 		 */
-		minor_rev = xhci->usb3_rhub.min_rev / 0x10;
+		if (xhci->usb3_rhub.min_rev == 0x1)
+			minor_rev = 1;
+		else
+			minor_rev = xhci->usb3_rhub.min_rev / 0x10;
 
 		switch (minor_rev) {
 		case 2:
-- 
2.23.0


