Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DBE6165B
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbfGGTiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:38:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57200 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727541AbfGGTiH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:07 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz5-0006gb-2o; Sun, 07 Jul 2019 20:38:03 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz3-0005aE-EH; Sun, 07 Jul 2019 20:38:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Chiranjeevi Rapolu" <chiranjeevi.rapolu@intel.com>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Sakari Ailus" <sakari.ailus@linux.intel.com>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.774638704@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 049/129] media: uvcvideo: Avoid NULL pointer
 dereference at the end of streaming
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 9dd0627d8d62a7ddb001a75f63942d92b5336561 upstream.

The UVC video driver converts the timestamp from hardware specific unit
to one known by the kernel at the time when the buffer is dequeued. This
is fine in general, but the streamoff operation consists of the
following steps (among other things):

1. uvc_video_clock_cleanup --- the hardware clock sample array is
   released and the pointer to the array is set to NULL,

2. buffers in active state are returned to the user and

3. buf_finish callback is called on buffers that are prepared.
   buf_finish includes calling uvc_video_clock_update that accesses the
   hardware clock sample array.

The above is serialised by a queue specific mutex. Address the problem
by skipping the clock conversion if the hardware clock sample array is
already released.

Fixes: 9c0863b1cc48 ("[media] vb2: call buf_finish from __queue_cancel")

Reported-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Tested-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/usb/uvc/uvc_video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -627,6 +627,14 @@ void uvc_video_clock_update(struct uvc_s
 	u32 rem;
 	u64 y;
 
+	/*
+	 * We will get called from __vb2_queue_cancel() if there are buffers
+	 * done but not dequeued by the user, but the sample array has already
+	 * been released at that time. Just bail out in that case.
+	 */
+	if (!clock->samples)
+		return;
+
 	spin_lock_irqsave(&clock->lock, flags);
 
 	if (clock->count < clock->size)

