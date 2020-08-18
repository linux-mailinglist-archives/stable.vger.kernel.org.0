Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E570248256
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 11:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgHRJza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 05:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbgHRJza (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 05:55:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBA1C206DA;
        Tue, 18 Aug 2020 09:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597744529;
        bh=zMcGqQP3zICssuRIxlJ2o4qVPJ72tZTYYzHQlmMHff0=;
        h=Subject:To:From:Date:From;
        b=Mf8WhTJGXrP4/Ax5OQa7IGOaHWbBMf5i97xknn+UWHaTrIz0w8vqqt39eNg6oOkvg
         z4396ytB9i/wlGi7628XuwgcOjxFDlQWBU04D+Zz2PtHwgJbymbiKPMZ2yiJUd55vV
         XPhEno0JnVjbdHiWZ7PPRulqnJRRUpc3eN0tSEtc=
Subject: patch "usbip: Implement a match function to fix usbip" added to usb-linus
To:     m.v.b@runbox.com, gregkh@linuxfoundation.org, hadess@hadess.net,
        skhan@linuxfoundation.org, stable@vger.kernel.org,
        stern@rowland.harvard.edu, valentina.manea.m@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 11:55:45 +0200
Message-ID: <1597744545567@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usbip: Implement a match function to fix usbip

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7a2f2974f26542b4e7b9b4321edb3cbbf3eeb91a Mon Sep 17 00:00:00 2001
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
Date: Mon, 10 Aug 2020 19:00:17 +0300
Subject: usbip: Implement a match function to fix usbip

Commit 88b7381a939d ("USB: Select better matching USB drivers when
available") introduced the use of a "match" function to select a
non-generic/better driver for a particular USB device. This
unfortunately breaks the operation of usbip in general, as reported in
the kernel bugzilla with bug 208267 (linked below).

Upon inspecting the aforementioned commit, one can observe that the
original code in the usb_device_match function used to return 1
unconditionally, but the aforementioned commit makes the usb_device_match
function use identifier tables and "match" virtual functions, if either of
them are available.

Hence, this commit implements a match function for usbip that
unconditionally returns true to ensure that usbip is functional again.

This change has been verified to restore usbip functionality, with a
v5.7.y kernel on an up-to-date version of Qubes OS 4.0, which uses
usbip to redirect USB devices between VMs.

Thanks to Jonathan Dieter for the effort in bisecting this issue down
to the aforementioned commit.

Fixes: 88b7381a939d ("USB: Select better matching USB drivers when available")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=208267
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1856443
Link: https://github.com/QubesOS/qubes-issues/issues/5905
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
Cc: <stable@vger.kernel.org> # 5.7
Cc: Valentina Manea <valentina.manea.m@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20200810160017.46002-1-m.v.b@runbox.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/stub_dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
index 2305d425e6c9..9d7d642022d1 100644
--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -461,6 +461,11 @@ static void stub_disconnect(struct usb_device *udev)
 	return;
 }
 
+static bool usbip_match(struct usb_device *udev)
+{
+	return true;
+}
+
 #ifdef CONFIG_PM
 
 /* These functions need usb_port_suspend and usb_port_resume,
@@ -486,6 +491,7 @@ struct usb_device_driver stub_driver = {
 	.name		= "usbip-host",
 	.probe		= stub_probe,
 	.disconnect	= stub_disconnect,
+	.match		= usbip_match,
 #ifdef CONFIG_PM
 	.suspend	= stub_suspend,
 	.resume		= stub_resume,
-- 
2.28.0


