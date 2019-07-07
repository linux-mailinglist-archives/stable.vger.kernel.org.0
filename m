Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBEEB61694
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfGGTkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:40:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58022 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727667AbfGGTiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:17 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzG-0006je-45; Sun, 07 Jul 2019 20:38:14 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0005gX-Kp; Sun, 07 Jul 2019 20:38:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        "Alistair Strachan" <astrachan@google.com>,
        "syzbot" <syzkaller@googlegroups.com>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.148922416@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 125/129] media: uvcvideo: Fix 'type' check leading to
 overflow
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alistair Strachan <astrachan@google.com>

commit 47bb117911b051bbc90764a8bff96543cbd2005f upstream.

When initially testing the Camera Terminal Descriptor wTerminalType
field (buffer[4]), no mask is used. Later in the function, the MSB is
overloaded to store the descriptor subtype, and so a mask of 0x7fff
is used to check the type.

If a descriptor is specially crafted to set this overloaded bit in the
original wTerminalType field, the initial type check will fail (falling
through, without adjusting the buffer size), but the later type checks
will pass, assuming the buffer has been made suitably large, causing an
overflow.

Avoid this problem by checking for the MSB in the wTerminalType field.
If the bit is set, assume the descriptor is bad, and abort parsing it.

Originally reported here:
https://groups.google.com/forum/#!topic/syzkaller/Ot1fOE6v1d8
A similar (non-compiling) patch was provided at that time.

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Alistair Strachan <astrachan@google.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/usb/uvc/uvc_driver.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -977,11 +977,19 @@ static int uvc_parse_standard_control(st
 			return -EINVAL;
 		}
 
-		/* Make sure the terminal type MSB is not null, otherwise it
-		 * could be confused with a unit.
+		/*
+		 * Reject invalid terminal types that would cause issues:
+		 *
+		 * - The high byte must be non-zero, otherwise it would be
+		 *   confused with a unit.
+		 *
+		 * - Bit 15 must be 0, as we use it internally as a terminal
+		 *   direction flag.
+		 *
+		 * Other unknown types are accepted.
 		 */
 		type = get_unaligned_le16(&buffer[4]);
-		if ((type & 0xff00) == 0) {
+		if ((type & 0x7f00) == 0 || (type & 0x8000) != 0) {
 			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
 				"interface %d INPUT_TERMINAL %d has invalid "
 				"type 0x%04x, skipping\n", udev->devnum,

