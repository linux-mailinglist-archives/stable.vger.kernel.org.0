Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC3BD9F30
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437387AbfJPVxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437296AbfJPVxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:11 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A20321A49;
        Wed, 16 Oct 2019 21:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262790;
        bh=fruldeb33iN9zTBskPGOhUUlHhwi0U+9Kdn0xTmWzyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0DKV/4h75bzXClcfzb9JzslpOG511LFnhrlTWkfw6Of7oWI1uMBxW9IBewc+LXGy
         zke3dbttj0neGkucQKnleZhx01mYYAZBLLtloKZEkfRYv7bDHHqk8IC81AIBQ5Dsb8
         5pGrSD1nbj2o7T8zjOtnoJuUaMC1cgf+V1n9XiZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Tomoki Sekiyama <tomoki.sekiyama@gmail.com>,
        syzbot+b24d736f18a1541ad550@syzkaller.appspotmail.com
Subject: [PATCH 4.4 30/79] USB: yurex: Dont retry on unexpected errors
Date:   Wed, 16 Oct 2019 14:50:05 -0700
Message-Id: <20191016214755.997785491@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
CC: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.1909171245410.1590-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/yurex.c |    7 ++++---
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


