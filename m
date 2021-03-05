Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8EC32E7CE
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhCEMV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:21:29 -0500
Received: from www.linuxtv.org ([130.149.80.248]:34348 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhCEMVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:21:15 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1lI9SC-002Sdg-Vh; Fri, 05 Mar 2021 12:21:12 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 05 Mar 2021 12:18:40 +0000
Subject: [git:media_tree/master] media: dvb-usb: Fix use-after-free access
To:     linuxtv-commits@linuxtv.org
Cc:     Takashi Iwai <tiwai@suse.de>, Robert Foss <robert.foss@linaro.org>,
        Sean Young <sean@mess.org>,
        Stefan Seyfried <seife+kernel@b1-systems.com>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1lI9SC-002Sdg-Vh@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: dvb-usb: Fix use-after-free access
Author:  Takashi Iwai <tiwai@suse.de>
Date:    Mon Feb 1 09:32:47 2021 +0100

dvb_usb_device_init() copies the properties to the own data, so that
the callers can release the original properties later (as done in the
commit 299c7007e936 ("media: dw2102: Fix memleak on sequence of
probes")).  However, it also stores dev->desc pointer that is a
reference to the original properties data.  Since dev->desc is
referred later, it may result in use-after-free, in the worst case,
leading to a kernel Oops as reported.

This patch addresses the problem by allocating and copying the
properties at first, then get the desc from the copied properties.

Reported-and-tested-by: Stefan Seyfried <seife+kernel@b1-systems.com>
BugLink: http://bugzilla.opensuse.org/show_bug.cgi?id=1181104

Reviewed-by: Robert Foss <robert.foss@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/dvb-usb/dvb-usb-init.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

---

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
index c78158d12540..6c9e3290af56 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -264,27 +264,30 @@ int dvb_usb_device_init(struct usb_interface *intf,
 	if (du != NULL)
 		*du = NULL;
 
-	if ((desc = dvb_usb_find_device(udev, props, &cold)) == NULL) {
+	d = kzalloc(sizeof(*d), GFP_KERNEL);
+	if (!d) {
+		err("no memory for 'struct dvb_usb_device'");
+		return -ENOMEM;
+	}
+
+	memcpy(&d->props, props, sizeof(struct dvb_usb_device_properties));
+
+	desc = dvb_usb_find_device(udev, &d->props, &cold);
+	if (!desc) {
 		deb_err("something went very wrong, device was not found in current device list - let's see what comes next.\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto error;
 	}
 
 	if (cold) {
 		info("found a '%s' in cold state, will try to load a firmware", desc->name);
 		ret = dvb_usb_download_firmware(udev, props);
 		if (!props->no_reconnect || ret != 0)
-			return ret;
+			goto error;
 	}
 
 	info("found a '%s' in warm state.", desc->name);
-	d = kzalloc(sizeof(struct dvb_usb_device), GFP_KERNEL);
-	if (d == NULL) {
-		err("no memory for 'struct dvb_usb_device'");
-		return -ENOMEM;
-	}
-
 	d->udev = udev;
-	memcpy(&d->props, props, sizeof(struct dvb_usb_device_properties));
 	d->desc = desc;
 	d->owner = owner;
 
