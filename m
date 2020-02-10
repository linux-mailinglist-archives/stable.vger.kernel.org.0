Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52CBA1574E4
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgBJMgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:36:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:56722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbgBJMgp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:45 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 275F620838;
        Mon, 10 Feb 2020 12:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338204;
        bh=mybJf9H4zwQSbbA4ifMmeLxgNPhjekDf/AYhWwnpOQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCIcdixByHhumBVwNTV3EUKgcA6RJmpNRW/XTsGZM6TyWfwYrgSZrewCyFqTJ497E
         JYtsNpwV1Fg2ObDl5GRd6CILIQ4+BRPbNZ8VYzuOgdyJlwHt5wNapSIgObqYlu0x0Q
         zQZVG9GPfu638f50cT9O2KuKBu2LknZs0xqoFzgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>,
        Will Deacon <will@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 022/309] media: uvcvideo: Avoid cyclic entity chains due to malformed USB descriptors
Date:   Mon, 10 Feb 2020 04:29:38 -0800
Message-Id: <20200210122408.118957083@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 68035c80e129c4cfec659aac4180354530b26527 upstream.

Way back in 2017, fuzzing the 4.14-rc2 USB stack with syzkaller kicked
up the following WARNING from the UVC chain scanning code:

  | list_add double add: new=ffff880069084010, prev=ffff880069084010,
  | next=ffff880067d22298.
  | ------------[ cut here ]------------
  | WARNING: CPU: 1 PID: 1846 at lib/list_debug.c:31 __list_add_valid+0xbd/0xf0
  | Modules linked in:
  | CPU: 1 PID: 1846 Comm: kworker/1:2 Not tainted
  | 4.14.0-rc2-42613-g1488251d1a98 #238
  | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
  | Workqueue: usb_hub_wq hub_event
  | task: ffff88006b01ca40 task.stack: ffff880064358000
  | RIP: 0010:__list_add_valid+0xbd/0xf0 lib/list_debug.c:29
  | RSP: 0018:ffff88006435ddd0 EFLAGS: 00010286
  | RAX: 0000000000000058 RBX: ffff880067d22298 RCX: 0000000000000000
  | RDX: 0000000000000058 RSI: ffffffff85a58800 RDI: ffffed000c86bbac
  | RBP: ffff88006435dde8 R08: 1ffff1000c86ba52 R09: 0000000000000000
  | R10: 0000000000000002 R11: 0000000000000000 R12: ffff880069084010
  | R13: ffff880067d22298 R14: ffff880069084010 R15: ffff880067d222a0
  | FS:  0000000000000000(0000) GS:ffff88006c900000(0000) knlGS:0000000000000000
  | CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  | CR2: 0000000020004ff2 CR3: 000000006b447000 CR4: 00000000000006e0
  | Call Trace:
  |  __list_add ./include/linux/list.h:59
  |  list_add_tail+0x8c/0x1b0 ./include/linux/list.h:92
  |  uvc_scan_chain_forward.isra.8+0x373/0x416
  | drivers/media/usb/uvc/uvc_driver.c:1471
  |  uvc_scan_chain drivers/media/usb/uvc/uvc_driver.c:1585
  |  uvc_scan_device drivers/media/usb/uvc/uvc_driver.c:1769
  |  uvc_probe+0x77f2/0x8f00 drivers/media/usb/uvc/uvc_driver.c:2104

Looking into the output from usbmon, the interesting part is the
following data packet:

  ffff880069c63e00 30710169 C Ci:1:002:0 0 143 = 09028f00 01030080
  00090403 00000e01 00000924 03000103 7c003328 010204db

If we drop the lead configuration and interface descriptors, we're left
with an output terminal descriptor describing a generic display:

  /* Output terminal descriptor */
  buf[0]	09
  buf[1]	24
  buf[2]	03	/* UVC_VC_OUTPUT_TERMINAL */
  buf[3]	00	/* ID */
  buf[4]	01	/* type == 0x0301 (UVC_OTT_DISPLAY) */
  buf[5]	03
  buf[6]	7c
  buf[7]	00	/* source ID refers to self! */
  buf[8]	33

The problem with this descriptor is that it is self-referential: the
source ID of 0 matches itself! This causes the 'struct uvc_entity'
representing the display to be added to its chain list twice during
'uvc_scan_chain()': once via 'uvc_scan_chain_entity()' when it is
processed directly from the 'dev->entities' list and then again
immediately afterwards when trying to follow the source ID in
'uvc_scan_chain_forward()'

Add a check before adding an entity to a chain list to ensure that the
entity is not already part of a chain.

Link: https://lore.kernel.org/linux-media/CAAeHK+z+Si69jUR+N-SjN9q4O+o5KFiNManqEa-PjUta7EOb7A@mail.gmail.com/

Cc: <stable@vger.kernel.org>
Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
Reported-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/uvc/uvc_driver.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1493,6 +1493,11 @@ static int uvc_scan_chain_forward(struct
 			break;
 		if (forward == prev)
 			continue;
+		if (forward->chain.next || forward->chain.prev) {
+			uvc_trace(UVC_TRACE_DESCR, "Found reference to "
+				"entity %d already in chain.\n", forward->id);
+			return -EINVAL;
+		}
 
 		switch (UVC_ENTITY_TYPE(forward)) {
 		case UVC_VC_EXTENSION_UNIT:
@@ -1574,6 +1579,13 @@ static int uvc_scan_chain_backward(struc
 				return -1;
 			}
 
+			if (term->chain.next || term->chain.prev) {
+				uvc_trace(UVC_TRACE_DESCR, "Found reference to "
+					"entity %d already in chain.\n",
+					term->id);
+				return -EINVAL;
+			}
+
 			if (uvc_trace_param & UVC_TRACE_PROBE)
 				printk(KERN_CONT " %d", term->id);
 


