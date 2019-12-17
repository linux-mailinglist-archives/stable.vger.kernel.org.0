Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34691122102
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfLQA7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:59:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34684 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726692AbfLQAvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:35 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15G-0003Jx-Hx; Tue, 17 Dec 2019 00:51:30 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15F-0005Sp-Oy; Tue, 17 Dec 2019 00:51:29 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Tomoki Sekiyama" <tomoki.sekiyama@gmail.com>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Tue, 17 Dec 2019 00:45:54 +0000
Message-ID: <lsq.1576543535.478659069@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 020/136] USB: yurex: Don't retry on unexpected errors
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 32a0721c6620b77504916dac0cea8ad497c4878a upstream.

According to Greg KH, it has been generally agreed that when a USB
driver encounters an unknown error (or one it can't handle directly),
it should just give up instead of going into a potentially infinite
retry loop.

The three codes -EPROTO, -EILSEQ, and -ETIME fall into this category.
They can be caused by bus errors such as packet loss or corruption,
attempting to communicate with a disconnected device, or by malicious
firmware.  Nowadays the extent of packet loss or corruption is
negligible, so it should be safe for a driver to give up whenever one
of these errors occurs.

Although the yurex driver handles -EILSEQ errors in this way, it
doesn't do the same for -EPROTO (as discovered by the syzbot fuzzer)
or other unrecognized errors.  This patch adjusts the driver so that
it doesn't log an error message for -EPROTO or -ETIME, and it doesn't
retry after any errors.

Reported-and-tested-by: syzbot+b24d736f18a1541ad550@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>

Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.1909171245410.1590-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/misc/yurex.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -136,6 +136,7 @@ static void yurex_interrupt(struct urb *
 	switch (status) {
 	case 0: /*success*/
 		break;
+	/* The device is terminated or messed up, give up */
 	case -EOVERFLOW:
 		dev_err(&dev->interface->dev,
 			"%s - overflow with length %d, actual length is %d\n",
@@ -144,12 +145,13 @@ static void yurex_interrupt(struct urb *
 	case -ENOENT:
 	case -ESHUTDOWN:
 	case -EILSEQ:
-		/* The device is terminated, clean up */
+	case -EPROTO:
+	case -ETIME:
 		return;
 	default:
 		dev_err(&dev->interface->dev,
 			"%s - unknown status received: %d\n", __func__, status);
-		goto exit;
+		return;
 	}
 
 	/* handle received message */
@@ -181,7 +183,6 @@ static void yurex_interrupt(struct urb *
 		break;
 	}
 
-exit:
 	retval = usb_submit_urb(dev->urb, GFP_ATOMIC);
 	if (retval) {
 		dev_err(&dev->interface->dev, "%s - usb_submit_urb failed: %d\n",

