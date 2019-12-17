Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 116631230AE
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 16:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfLQPl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 10:41:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbfLQPl3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 10:41:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3462A2465E;
        Tue, 17 Dec 2019 15:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576597288;
        bh=14fxz1g93eJrGWAl22AH5K143t43QwrxjnddQxfnLBY=;
        h=Subject:To:From:Date:From;
        b=XK0uVedqgIuqqjJVjuFzsfXqGFbfQ6tW1Yzkiho+n/UCarnT26oQ48/zPaB0KUX7b
         Ji16VBp1w+0keEeUJtkI7T8N33tlNVfAU/aklVnsIDrr3UyfEFHuHjrM478BVqQ8Ht
         bX4xMvOyR2/q2p8UoiqKU1xn6HKEg2O9TK+6kTYg=
Subject: patch "usbip: Fix error path of vhci_recv_ret_submit()" added to usb-linus
To:     suwan.kim027@gmail.com, gregkh@linuxfoundation.org,
        marmarek@invisiblethingslab.com, skhan@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Dec 2019 16:41:18 +0100
Message-ID: <15765972787371@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usbip: Fix error path of vhci_recv_ret_submit()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From aabb5b833872524eaf28f52187e5987984982264 Mon Sep 17 00:00:00 2001
From: Suwan Kim <suwan.kim027@gmail.com>
Date: Fri, 13 Dec 2019 11:30:55 +0900
Subject: usbip: Fix error path of vhci_recv_ret_submit()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If a transaction error happens in vhci_recv_ret_submit(), event
handler closes connection and changes port status to kick hub_event.
Then hub tries to flush the endpoint URBs, but that causes infinite
loop between usb_hub_flush_endpoint() and vhci_urb_dequeue() because
"vhci_priv" in vhci_urb_dequeue() was already released by
vhci_recv_ret_submit() before a transmission error occurred. Thus,
vhci_urb_dequeue() terminates early and usb_hub_flush_endpoint()
continuously calls vhci_urb_dequeue().

The root cause of this issue is that vhci_recv_ret_submit()
terminates early without giving back URB when transaction error
occurs in vhci_recv_ret_submit(). That causes the error URB to still
be linked at endpoint list without “vhci_priv".

So, in the case of transaction error in vhci_recv_ret_submit(),
unlink URB from the endpoint, insert proper error code in
urb->status and give back URB.

Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20191213023055.19933-3-suwan.kim027@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/vhci_rx.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/usbip/vhci_rx.c b/drivers/usb/usbip/vhci_rx.c
index 33f8972ba842..00fc98741c5d 100644
--- a/drivers/usb/usbip/vhci_rx.c
+++ b/drivers/usb/usbip/vhci_rx.c
@@ -77,16 +77,21 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
 	usbip_pack_pdu(pdu, urb, USBIP_RET_SUBMIT, 0);
 
 	/* recv transfer buffer */
-	if (usbip_recv_xbuff(ud, urb) < 0)
-		return;
+	if (usbip_recv_xbuff(ud, urb) < 0) {
+		urb->status = -EPROTO;
+		goto error;
+	}
 
 	/* recv iso_packet_descriptor */
-	if (usbip_recv_iso(ud, urb) < 0)
-		return;
+	if (usbip_recv_iso(ud, urb) < 0) {
+		urb->status = -EPROTO;
+		goto error;
+	}
 
 	/* restore the padding in iso packets */
 	usbip_pad_iso(ud, urb);
 
+error:
 	if (usbip_dbg_flag_vhci_rx)
 		usbip_dump_urb(urb);
 
-- 
2.24.1


