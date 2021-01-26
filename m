Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71377303FF6
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 15:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392134AbhAZOQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 09:16:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392667AbhAZOQi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 09:16:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12783206CA;
        Tue, 26 Jan 2021 14:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611670557;
        bh=ta2LJeQ35NJjiWDOdPasolz3iOXygMQW0EWIxBnJ4uA=;
        h=Subject:To:From:Date:From;
        b=idfBLJStUAu54DM2r9OegEQ6du47aXSrLje5Dn4ENMxL2cXfoHJRqXdTHNBBhbfJk
         WD2T3BgdeDpPe6I08VBldDI7mX0mtxqO0NfM+CEr0ms0Yunyug4Kq78JUgmPgPCLlN
         fCIPJvt0qjzRMFsm/2UVE6L2HJxAewJvMkpBTDV8=
Subject: patch "USB: usblp: don't call usb_set_interface if there's a single alt" added to usb-linus
To:     kernel@jeremyfiggins.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, zaitcev@redhat.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 26 Jan 2021 15:15:55 +0100
Message-ID: <1611670555227110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: usblp: don't call usb_set_interface if there's a single alt

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d8c6edfa3f4ee0d45d7ce5ef18d1245b78774b9d Mon Sep 17 00:00:00 2001
From: Jeremy Figgins <kernel@jeremyfiggins.com>
Date: Sat, 23 Jan 2021 18:21:36 -0600
Subject: USB: usblp: don't call usb_set_interface if there's a single alt

Some devices, such as the Winbond Electronics Corp. Virtual Com Port
(Vendor=0416, ProdId=5011), lockup when usb_set_interface() or
usb_clear_halt() are called. This device has only a single
altsetting, so it should not be necessary to call usb_set_interface().

Acked-by: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Jeremy Figgins <kernel@jeremyfiggins.com>
Link: https://lore.kernel.org/r/YAy9kJhM/rG8EQXC@watson
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usblp.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index 134dc2005ce9..c9f6e9758288 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -1329,14 +1329,17 @@ static int usblp_set_protocol(struct usblp *usblp, int protocol)
 	if (protocol < USBLP_FIRST_PROTOCOL || protocol > USBLP_LAST_PROTOCOL)
 		return -EINVAL;
 
-	alts = usblp->protocol[protocol].alt_setting;
-	if (alts < 0)
-		return -EINVAL;
-	r = usb_set_interface(usblp->dev, usblp->ifnum, alts);
-	if (r < 0) {
-		printk(KERN_ERR "usblp: can't set desired altsetting %d on interface %d\n",
-			alts, usblp->ifnum);
-		return r;
+	/* Don't unnecessarily set the interface if there's a single alt. */
+	if (usblp->intf->num_altsetting > 1) {
+		alts = usblp->protocol[protocol].alt_setting;
+		if (alts < 0)
+			return -EINVAL;
+		r = usb_set_interface(usblp->dev, usblp->ifnum, alts);
+		if (r < 0) {
+			printk(KERN_ERR "usblp: can't set desired altsetting %d on interface %d\n",
+				alts, usblp->ifnum);
+			return r;
+		}
 	}
 
 	usblp->bidir = (usblp->protocol[protocol].epread != NULL);
-- 
2.30.0


