Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5FC4691D6
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 09:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239822AbhLFI7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 03:59:09 -0500
Received: from www.linuxtv.org ([130.149.80.248]:46926 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231253AbhLFI7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Dec 2021 03:59:09 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1mu9md-008jWY-Or; Mon, 06 Dec 2021 08:55:39 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Mon, 06 Dec 2021 08:54:12 +0000
Subject: [git:media_stage/master] media: uvcvideo: fix division by zero at stream start
To:     linuxtv-commits@linuxtv.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        stable@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Johan Hovold <johan@kernel.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1mu9md-008jWY-Or@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: uvcvideo: fix division by zero at stream start
Author:  Johan Hovold <johan@kernel.org>
Date:    Tue Oct 26 11:55:11 2021 +0200

Add the missing bulk-endpoint max-packet sanity check to
uvc_video_start_transfer() to avoid division by zero in
uvc_alloc_urb_buffers() in case a malicious device has broken
descriptors (or when doing descriptor fuzz testing).

Note that USB core will reject URBs submitted for endpoints with zero
wMaxPacketSize but that drivers doing packet-size calculations still
need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
endpoint descriptors with maxpacket=0")).

Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
Cc: stable@vger.kernel.org      # 2.6.26
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/uvc/uvc_video.c | 4 ++++
 1 file changed, 4 insertions(+)

---

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 9f37eaf28ce7..1b4cc934109e 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1963,6 +1963,10 @@ static int uvc_video_start_transfer(struct uvc_streaming *stream,
 		if (ep == NULL)
 			return -EIO;
 
+		/* Reject broken descriptors. */
+		if (usb_endpoint_maxp(&ep->desc) == 0)
+			return -EIO;
+
 		ret = uvc_init_video_bulk(stream, ep, gfp_flags);
 	}
 
