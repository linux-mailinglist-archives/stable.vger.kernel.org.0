Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E254937F948
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 16:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbhEMOCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 10:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234281AbhEMOBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 10:01:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D495F6127A;
        Thu, 13 May 2021 14:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620914435;
        bh=YMiOzHMPTEMU9Drs+XBRdKH2AEmTrzri3Nrrv8TkdV8=;
        h=Subject:To:From:Date:From;
        b=z8snoDux/qmed2UEYE8rckfh8cJHuOjXksfga/Uqgz4TB8XbBLVpDLjOz+QIg1ixO
         z7hIwxv5EYEQbFR5tY8KkGRfOL2E301pEwLE+CQRo/kYnGpMVaFoJz8cw2F32foBvR
         6kCr7hnuOyqpcYp/BBG2Zn6wIyqjDHjUBlWY+9M8=
Subject: patch "usb: core: hub: fix race condition about TRSMRCY of resume" added to usb-linus
To:     chunfeng.yun@mediatek.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu,
        tianping.fang@mediatek.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 16:00:33 +0200
Message-ID: <162091443319189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: core: hub: fix race condition about TRSMRCY of resume

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 975f94c7d6c306b833628baa9aec3f79db1eb3a1 Mon Sep 17 00:00:00 2001
From: Chunfeng Yun <chunfeng.yun@mediatek.com>
Date: Wed, 12 May 2021 10:07:38 +0800
Subject: usb: core: hub: fix race condition about TRSMRCY of resume

This may happen if the port becomes resume status exactly
when usb_port_resume() gets port status, it still need provide
a TRSMCRY time before access the device.

CC: <stable@vger.kernel.org>
Reported-by: Tianping Fang <tianping.fang@mediatek.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20210512020738.52961-1-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index b2bc4b7c4289..fc7d6cdacf16 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3642,9 +3642,6 @@ int usb_port_resume(struct usb_device *udev, pm_message_t msg)
 		 * sequence.
 		 */
 		status = hub_port_status(hub, port1, &portstatus, &portchange);
-
-		/* TRSMRCY = 10 msec */
-		msleep(10);
 	}
 
  SuspendCleared:
@@ -3659,6 +3656,9 @@ int usb_port_resume(struct usb_device *udev, pm_message_t msg)
 				usb_clear_port_feature(hub->hdev, port1,
 						USB_PORT_FEAT_C_SUSPEND);
 		}
+
+		/* TRSMRCY = 10 msec */
+		msleep(10);
 	}
 
 	if (udev->persist_enabled)
-- 
2.31.1


