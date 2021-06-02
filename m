Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B14739B279
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 08:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhFDGWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 02:22:06 -0400
Received: from www.linuxtv.org ([130.149.80.248]:43580 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229844AbhFDGWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 02:22:05 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1lp3Bq-001NVk-KC; Fri, 04 Jun 2021 06:20:18 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Wed, 02 Jun 2021 12:10:25 +0000
Subject: [git:media_tree/master] media: gspca/sq905: fix control-request direction
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Johan Hovold <johan@kernel.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1lp3Bq-001NVk-KC@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: gspca/sq905: fix control-request direction
Author:  Johan Hovold <johan@kernel.org>
Date:    Fri May 21 15:28:39 2021 +0200

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the USB_REQ_SYNCH_FRAME request which erroneously used
usb_sndctrlpipe().

Fixes: 27d35fc3fb06 ("V4L/DVB (10639): gspca - sq905: New subdriver.")
Cc: stable@vger.kernel.org      # 2.6.30
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/gspca/sq905.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/drivers/media/usb/gspca/sq905.c b/drivers/media/usb/gspca/sq905.c
index 949111070971..32504ebcfd4d 100644
--- a/drivers/media/usb/gspca/sq905.c
+++ b/drivers/media/usb/gspca/sq905.c
@@ -116,7 +116,7 @@ static int sq905_command(struct gspca_dev *gspca_dev, u16 index)
 	}
 
 	ret = usb_control_msg(gspca_dev->dev,
-			      usb_sndctrlpipe(gspca_dev->dev, 0),
+			      usb_rcvctrlpipe(gspca_dev->dev, 0),
 			      USB_REQ_SYNCH_FRAME,                /* request */
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      SQ905_PING, 0, gspca_dev->usb_buf, 1,
