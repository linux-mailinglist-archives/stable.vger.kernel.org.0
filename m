Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0481516AA27
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 16:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgBXPdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 10:33:19 -0500
Received: from www.linuxtv.org ([130.149.80.248]:43884 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbgBXPdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Feb 2020 10:33:19 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1j6Fhm-008yAf-KK; Mon, 24 Feb 2020 15:31:34 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Mon, 24 Feb 2020 15:24:21 +0000
Subject: [git:media_tree/master] media: dib0700: fix rc endpoint lookup
To:     linuxtv-commits@linuxtv.org
Cc:     stable <stable@vger.kernel.org>, Sean Young <sean@mess.org>,
        Johan Hovold <johan@kernel.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1j6Fhm-008yAf-KK@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: dib0700: fix rc endpoint lookup
Author:  Johan Hovold <johan@kernel.org>
Date:    Fri Jan 3 17:35:12 2020 +0100

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid submitting an URB to an invalid endpoint.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: c4018fa2e4c0 ("[media] dib0700: fix RC support on Hauppauge Nova-TD")
Cc: stable <stable@vger.kernel.org>     # 3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/dvb-usb/dib0700_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index e53c58ab6488..ef62dd6c5ae4 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -818,7 +818,7 @@ int dib0700_rc_setup(struct dvb_usb_device *d, struct usb_interface *intf)
 
 	/* Starting in firmware 1.20, the RC info is provided on a bulk pipe */
 
-	if (intf->altsetting[0].desc.bNumEndpoints < rc_ep + 1)
+	if (intf->cur_altsetting->desc.bNumEndpoints < rc_ep + 1)
 		return -ENODEV;
 
 	purb = usb_alloc_urb(0, GFP_KERNEL);
@@ -838,7 +838,7 @@ int dib0700_rc_setup(struct dvb_usb_device *d, struct usb_interface *intf)
 	 * Some devices like the Hauppauge NovaTD model 52009 use an interrupt
 	 * endpoint, while others use a bulk one.
 	 */
-	e = &intf->altsetting[0].endpoint[rc_ep].desc;
+	e = &intf->cur_altsetting->endpoint[rc_ep].desc;
 	if (usb_endpoint_dir_in(e)) {
 		if (usb_endpoint_xfer_bulk(e)) {
 			pipe = usb_rcvbulkpipe(d->udev, rc_ep);
