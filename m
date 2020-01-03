Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEED12F6DC
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 11:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgACKsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 05:48:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727220AbgACKsw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 05:48:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A2DD24649;
        Fri,  3 Jan 2020 10:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578048532;
        bh=5JU9Pu08IH+Q3Wk9frn3aCNMmaWfFvt0dtoeOdCFf2Q=;
        h=Subject:To:From:Date:From;
        b=OIsB5frXqwCPuySIy4EkQEK1zlZ5C0SQ4QpP/0Bxe9+UpJTiz1pBBP5E6bhfLPD7C
         wLfCWDH+h/GmK6JYV4Kkbzre7XBX64eCRg6NRnnrVsjuwW7mB86pYlNiiaQDxFlkp+
         JRA5xR0IwuDZ2U/cI0plW5kjwYqdt0Njo69Pvr3w=
Subject: patch "staging: vt6656: set usb_set_intfdata on driver fail." added to staging-linus
To:     tvboxspy@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jan 2020 11:48:38 +0100
Message-ID: <15780485185370@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: vt6656: set usb_set_intfdata on driver fail.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c0bcf9f3f5b661d4ace2a64a79ef661edd2a4dc8 Mon Sep 17 00:00:00 2001
From: Malcolm Priestley <tvboxspy@gmail.com>
Date: Fri, 20 Dec 2019 21:15:59 +0000
Subject: staging: vt6656: set usb_set_intfdata on driver fail.

intfdata will contain stale pointer when the device is detached after
failed initialization when referenced in vt6656_disconnect

Provide driver access to it here and NULL it.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/6de448d7-d833-ef2e-dd7b-3ef9992fee0e@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vt6656/device.h   | 1 +
 drivers/staging/vt6656/main_usb.c | 1 +
 drivers/staging/vt6656/wcmd.c     | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 6074ceda78bf..50e1c8918040 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -259,6 +259,7 @@ struct vnt_private {
 	u8 mac_hw;
 	/* netdev */
 	struct usb_device *usb;
+	struct usb_interface *intf;
 
 	u64 tsf_time;
 	u8 rx_rate;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 4a5d741f94f5..9cb924c54571 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -992,6 +992,7 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	priv = hw->priv;
 	priv->hw = hw;
 	priv->usb = udev;
+	priv->intf = intf;
 
 	vnt_set_options(priv);
 
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 3eb2f11a5de1..2c5250ca2801 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -99,6 +99,7 @@ void vnt_run_command(struct work_struct *work)
 		if (vnt_init(priv)) {
 			/* If fail all ends TODO retry */
 			dev_err(&priv->usb->dev, "failed to start\n");
+			usb_set_intfdata(priv->intf, NULL);
 			ieee80211_free_hw(priv->hw);
 			return;
 		}
-- 
2.24.1


