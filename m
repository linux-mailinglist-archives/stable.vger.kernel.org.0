Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6CCCBA7D
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 14:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbfJDMdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 08:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729034AbfJDMdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 08:33:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 853F72133F;
        Fri,  4 Oct 2019 12:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570192393;
        bh=zGK5+qpT2dUbtlCFPjePhhPrvUHZDOfoCESoTCavHfs=;
        h=Subject:To:From:Date:From;
        b=fK9f5TlgLiS6hGWi1ZFqGFDEhnvgZPYd1/yROpVC0LIerbJ42hip+WXwgTwuihgYW
         6U8HhKfNp1SPuxwN0leqbo56l0OW0tUhEKS2u/XFgc9U4tEjW8S/Og9BHuQBR7/ubM
         dPX7qAcci7WGcbKAjHLG7/8fBERpFkYYTNKOmnI4=
Subject: patch "xhci: Prevent device initiated U1/U2 link pm if exit latency is too" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        jan@centricular.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 14:33:05 +0200
Message-ID: <157019238571103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Prevent device initiated U1/U2 link pm if exit latency is too

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From cd9d9491e835a845c1a98b8471f88d26285e0bb9 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Fri, 4 Oct 2019 14:59:27 +0300
Subject: xhci: Prevent device initiated U1/U2 link pm if exit latency is too
 long

If host/hub initiated link pm is prevented by a driver flag we still must
ensure that periodic endpoints have longer service intervals than link pm
exit latency before allowing device initiated link pm.

Fix this by continue walking and checking endpoint service interval if
xhci_get_timeout_no_hub_lpm() returns anything else than USB3_LPM_DISABLED

While at it fix the split line error message

Tested-by: Jan Schmidt <jan@centricular.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1570190373-30684-3-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 500865975687..aed5a65f25bd 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4790,10 +4790,12 @@ static u16 xhci_calculate_lpm_timeout(struct usb_hcd *hcd,
 		if (intf->dev.driver) {
 			driver = to_usb_driver(intf->dev.driver);
 			if (driver && driver->disable_hub_initiated_lpm) {
-				dev_dbg(&udev->dev, "Hub-initiated %s disabled "
-						"at request of driver %s\n",
-						state_name, driver->name);
-				return xhci_get_timeout_no_hub_lpm(udev, state);
+				dev_dbg(&udev->dev, "Hub-initiated %s disabled at request of driver %s\n",
+					state_name, driver->name);
+				timeout = xhci_get_timeout_no_hub_lpm(udev,
+								      state);
+				if (timeout == USB3_LPM_DISABLED)
+					return timeout;
 			}
 		}
 
-- 
2.23.0


