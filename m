Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F271DB62B
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgETOWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:22:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33132 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727050AbgETOW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbx-00037U-VX; Wed, 20 May 2020 15:22:22 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbw-007DU0-75; Wed, 20 May 2020 15:22:20 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Will Deacon" <will@kernel.org>,
        "Andrey Konovalov" <andreyknvl@google.com>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>
Date:   Wed, 20 May 2020 15:14:33 +0100
Message-ID: <lsq.1589984008.375168790@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 65/99] media: uvcvideo: Avoid cyclic entity chains
 due to malformed USB descriptors
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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

Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
Reported-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/usb/uvc/uvc_driver.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1369,6 +1369,11 @@ static int uvc_scan_chain_forward(struct
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
@@ -1450,6 +1455,13 @@ static int uvc_scan_chain_backward(struc
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
 				printk(" %d", term->id);
 

