Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BD5274064
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 13:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgIVLHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 07:07:35 -0400
Received: from aibo.runbox.com ([91.220.196.211]:51628 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgIVLHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 07:07:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
        :Message-Id:Date:Subject:Cc:To:From;
        bh=psqE07dXlcAdf8xwU1osA4X0VG70gu6FTObLRO7oA7Y=; b=ZMQwj+445i4FxUocxpvqWlXVw3
        BEqiV3gKbzDiSMSGPvNX+5HwDGeF+LTd9ReJRv2pwLNETTiC/PXg6l5IPoaPrmGdJIv/R7MHw/Pl2
        ggBPhn+o8KSX6qPJ4zl0++G+tgulw8W/nzvj3W+czioT4XJ/s+6Ews1KRUdiPUJuhUgqe1ag4CxhA
        hGHaPQpeTJssU7gAle9SOwfqqD9M38ZJxY8h4Kywm4drc121YK9X6kUAOUjoF2esbbdOYfK8nc/Tn
        o1Q/Ri4G0K0KoxXZxB0MMQUo1GrrGdAeVtpaKM3Q4Asd6BijmByveExGSg0+3IsyxzHzjrAH5RRLo
        ar2nmPDQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kKg8z-0005vk-Ce; Tue, 22 Sep 2020 13:07:33 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kKg8k-0000Pn-3h; Tue, 22 Sep 2020 13:07:18 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     linux-usb@vger.kernel.org
Cc:     "M. Vefa Bicakci" <m.v.b@runbox.com>, stable@vger.kernel.org,
        Bastien Nocera <hadess@hadess.net>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com
Subject: [PATCH v3 1/4] Revert "usbip: Implement a match function to fix usbip"
Date:   Tue, 22 Sep 2020 14:07:00 +0300
Message-Id: <20200922110703.720960-2-m.v.b@runbox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922110703.720960-1-m.v.b@runbox.com>
References: <20200922110703.720960-1-m.v.b@runbox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Reported-by: Andrey Konovalov <andreyknvl@google.com>
Link: https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/
Cc: <stable@vger.kernel.org> # 5.8: 41160802ab8e: USB: Simplify USB ID table match
Cc: <stable@vger.kernel.org> # 5.8
Cc: Bastien Nocera <hadess@hadess.net>
Cc: Valentina Manea <valentina.manea.m@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: <syzkaller@googlegroups.com>
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>

---
v3: New patch in the patch set.

    Note for stable tree maintainers: I have marked the following commit
    as a dependency of this patch, because that commit resolves a bug that
    the next commit in this patch set uncovers, where if a driver does
    not have an id_table, then its match function is not considered for
    execution at all.
      commit 41160802ab8e ("USB: Simplify USB ID table match")
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
2.26.2

