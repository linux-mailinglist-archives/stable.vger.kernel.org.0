Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9890014F75
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfEFOeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbfEFOeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:34:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7ADD204EC;
        Mon,  6 May 2019 14:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153243;
        bh=JjMQHWf7en1JnPMl25Brc/ONJrEvJ0JAbONFCKfVaBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrjwHLyeqwIJRXPLLuKgd5U7OW8jP8mEQOG3+btqwsMf4bKmqNsJjRru9sYFGuLSD
         tCRRY7d9GPLB18Oqsj2Y+Zvn96FM82Gg4vpr13o8TLFnm8T8U6u3/qDE/JU5vnkd4F
         M1ZNVzTQHVOQZZUCvvr7VtBs/CEMhghs98GIWYlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+d919b0f29d7b5a4994b9@syzkaller.appspotmail.com
Subject: [PATCH 5.0 016/122] USB: dummy-hcd: Fix failure to give back unlinked URBs
Date:   Mon,  6 May 2019 16:31:14 +0200
Message-Id: <20190506143056.202398219@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit fc834e607ae3d18e1a20bca3f9a2d7f52ea7a2be upstream.

The syzkaller USB fuzzer identified a failure mode in which dummy-hcd
would never give back an unlinked URB.  This causes usb_kill_urb() to
hang, leading to WARNINGs and unkillable threads.

In dummy-hcd, all URBs are given back by the dummy_timer() routine as
it scans through the list of pending URBS.  Failure to give back URBs
can be caused by failure to start or early exit from the scanning
loop.  The code currently has two such pathways: One is triggered when
an unsupported bus transfer speed is encountered, and the other by
exhausting the simulated bandwidth for USB transfers during a frame.

This patch removes those two paths, thereby allowing all unlinked URBs
to be given back in a timely manner.  It adds a check for the bus
speed when the gadget first starts running, so that dummy_timer() will
never thereafter encounter an unsupported speed.  And it prevents the
loop from exiting as soon as the total bandwidth has been used up (the
scanning loop continues, giving back unlinked URBs as they are found,
but not transferring any more data).

Thanks to Andrey Konovalov for manually running the syzkaller fuzzer
to help track down the source of the bug.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+d919b0f29d7b5a4994b9@syzkaller.appspotmail.com
CC: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/dummy_hcd.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -979,8 +979,18 @@ static int dummy_udc_start(struct usb_ga
 	struct dummy_hcd	*dum_hcd = gadget_to_dummy_hcd(g);
 	struct dummy		*dum = dum_hcd->dum;
 
-	if (driver->max_speed == USB_SPEED_UNKNOWN)
+	switch (g->speed) {
+	/* All the speeds we support */
+	case USB_SPEED_LOW:
+	case USB_SPEED_FULL:
+	case USB_SPEED_HIGH:
+	case USB_SPEED_SUPER:
+		break;
+	default:
+		dev_err(dummy_dev(dum_hcd), "Unsupported driver max speed %d\n",
+				driver->max_speed);
 		return -EINVAL;
+	}
 
 	/*
 	 * SLAVE side init ... the layer above hardware, which
@@ -1784,9 +1794,10 @@ static void dummy_timer(struct timer_lis
 		/* Bus speed is 500000 bytes/ms, so use a little less */
 		total = 490000;
 		break;
-	default:
+	default:	/* Can't happen */
 		dev_err(dummy_dev(dum_hcd), "bogus device speed\n");
-		return;
+		total = 0;
+		break;
 	}
 
 	/* FIXME if HZ != 1000 this will probably misbehave ... */
@@ -1828,7 +1839,7 @@ restart:
 
 		/* Used up this frame's bandwidth? */
 		if (total <= 0)
-			break;
+			continue;
 
 		/* find the gadget's ep for this request (if configured) */
 		address = usb_pipeendpoint (urb->pipe);


