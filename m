Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DE3278B43
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 16:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgIYOxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 10:53:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728575AbgIYOxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 10:53:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 962A22074B;
        Fri, 25 Sep 2020 14:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601045580;
        bh=cUPODzvUiUjahqtIJ41uubHTx+wH4D3YM6TkLGBl0AE=;
        h=Subject:To:From:Date:From;
        b=BbrCML38gS3EtlCKrWMsRzsWmaluLX+0MKp76NCQKk0Fhkx/JS1uwmHumJZ2z2R/0
         90NokB75qncbK76zj9MkddIMX72qiwsUSNzrd+mHYtFvO6uv9GgumvhFFmxlrLOx9O
         3R8byyQkP0AWSJ78KzDynHhDolh1JH2QXmPYXAgI=
Subject: patch "Revert "usbip: Implement a match function to fix usbip"" added to usb-linus
To:     m.v.b@runbox.com, andreyknvl@google.com,
        gregkh@linuxfoundation.org, hadess@hadess.net, shuah@kernel.org,
        skhan@linuxfoundation.org, stable@vger.kernel.org,
        stern@rowland.harvard.edu, syzkaller@googlegroups.com,
        valentina.manea.m@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Sep 2020 16:53:14 +0200
Message-ID: <160104559416073@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "usbip: Implement a match function to fix usbip"

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d6407613c1e2ef90213dee388aa16b6e1bd08cbc Mon Sep 17 00:00:00 2001
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
Date: Tue, 22 Sep 2020 14:07:00 +0300
Subject: Revert "usbip: Implement a match function to fix usbip"

This commit reverts commit 7a2f2974f265 ("usbip: Implement a match
function to fix usbip").

In summary, commit d5643d2249b2 ("USB: Fix device driver race")
inadvertently broke usbip functionality, which I resolved in an incorrect
manner by introducing a match function to usbip, usbip_match(), that
unconditionally returns true.

However, the usbip_match function, as is, causes usbip to take over
virtual devices used by syzkaller for USB fuzzing, which is a regression
reported by Andrey Konovalov.

Furthermore, in conjunction with the fix of another bug, handled by another
patch titled "usbcore/driver: Fix specific driver selection" in this patch
set, the usbip_match function causes unexpected USB subsystem behaviour
when the usbip_host driver is loaded. The unexpected behaviour can be
qualified as follows:
- If commit 41160802ab8e ("USB: Simplify USB ID table match") is included
  in the kernel, then all USB devices are bound to the usbip_host
  driver, which appears to the user as if all USB devices were
  disconnected.
- If the same commit (41160802ab8e) is not in the kernel (as is the case
  with v5.8.10) then all USB devices are re-probed and re-bound to their
  original device drivers, which appears to the user as a disconnection
  and re-connection of USB devices.

Please note that this commit will make usbip non-operational again,
until yet another patch in this patch set is merged, titled
"usbcore/driver: Accommodate usbip".

Cc: <stable@vger.kernel.org> # 5.8: 41160802ab8e: USB: Simplify USB ID table match
Cc: <stable@vger.kernel.org> # 5.8
Cc: Bastien Nocera <hadess@hadess.net>
Cc: Valentina Manea <valentina.manea.m@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: <syzkaller@googlegroups.com>
Reported-by: Andrey Konovalov <andreyknvl@google.com>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
Link: https://lore.kernel.org/r/20200922110703.720960-2-m.v.b@runbox.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/stub_dev.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
index 9d7d642022d1..2305d425e6c9 100644
--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -461,11 +461,6 @@ static void stub_disconnect(struct usb_device *udev)
 	return;
 }
 
-static bool usbip_match(struct usb_device *udev)
-{
-	return true;
-}
-
 #ifdef CONFIG_PM
 
 /* These functions need usb_port_suspend and usb_port_resume,
@@ -491,7 +486,6 @@ struct usb_device_driver stub_driver = {
 	.name		= "usbip-host",
 	.probe		= stub_probe,
 	.disconnect	= stub_disconnect,
-	.match		= usbip_match,
 #ifdef CONFIG_PM
 	.suspend	= stub_suspend,
 	.resume		= stub_resume,
-- 
2.28.0


