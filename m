Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE65532E7CF
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhCEMV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:21:29 -0500
Received: from www.linuxtv.org ([130.149.80.248]:34270 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229797AbhCEMVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:21:14 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1lI9SD-002Se0-1h; Fri, 05 Mar 2021 12:21:13 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 05 Mar 2021 12:17:57 +0000
Subject: [git:media_tree/master] media: dvb-usb: Fix memory leak at error in dvb_usb_device_init()
To:     linuxtv-commits@linuxtv.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sean Young <sean@mess.org>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1lI9SD-002Se0-1h@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: dvb-usb: Fix memory leak at error in dvb_usb_device_init()
Author:  Takashi Iwai <tiwai@suse.de>
Date:    Mon Feb 1 09:32:46 2021 +0100

dvb_usb_device_init() allocates a dvb_usb_device object, but it
doesn't release the object by itself even at errors.  The object is
released in the callee side (dvb_usb_init()) in some error cases via
dvb_usb_exit() call, but it also missed the object free in other error
paths.  And, the caller (it's only dvb_usb_device_init()) doesn't seem
caring the resource management as well, hence those memories are
leaked.

This patch assures releasing the memory at the error path in
dvb_usb_device_init().  Now dvb_usb_init() frees the resources it
allocated but leaves the passed dvb_usb_device object intact.  In
turn, the dvb_usb_device object is released in dvb_usb_device_init()
instead.
We could use dvb_usb_exit() function for releasing everything in the
callee (as it was used for some error cases in the original code), but
releasing the passed object in the callee is non-intuitive and
error-prone.  So I took this approach (which is more standard in Linus
kernel code) although it ended with a bit more open codes.

Along with the change, the patch makes sure that USB intfdata is reset
and don't return the bogus pointer to the caller of
dvb_usb_device_init() at the error path, too.

Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/dvb-usb/dvb-usb-init.c | 47 +++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 16 deletions(-)

---

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
index c1a7634e27b4..c78158d12540 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -158,22 +158,20 @@ static int dvb_usb_init(struct dvb_usb_device *d, short *adapter_nums)
 
 		if (d->props.priv_init != NULL) {
 			ret = d->props.priv_init(d);
-			if (ret != 0) {
-				kfree(d->priv);
-				d->priv = NULL;
-				return ret;
-			}
+			if (ret != 0)
+				goto err_priv_init;
 		}
 	}
 
 	/* check the capabilities and set appropriate variables */
 	dvb_usb_device_power_ctrl(d, 1);
 
-	if ((ret = dvb_usb_i2c_init(d)) ||
-		(ret = dvb_usb_adapter_init(d, adapter_nums))) {
-		dvb_usb_exit(d);
-		return ret;
-	}
+	ret = dvb_usb_i2c_init(d);
+	if (ret)
+		goto err_i2c_init;
+	ret = dvb_usb_adapter_init(d, adapter_nums);
+	if (ret)
+		goto err_adapter_init;
 
 	if ((ret = dvb_usb_remote_init(d)))
 		err("could not initialize remote control.");
@@ -181,6 +179,17 @@ static int dvb_usb_init(struct dvb_usb_device *d, short *adapter_nums)
 	dvb_usb_device_power_ctrl(d, 0);
 
 	return 0;
+
+err_adapter_init:
+	dvb_usb_adapter_exit(d);
+err_i2c_init:
+	dvb_usb_i2c_exit(d);
+	if (d->priv && d->props.priv_destroy)
+		d->props.priv_destroy(d);
+err_priv_init:
+	kfree(d->priv);
+	d->priv = NULL;
+	return ret;
 }
 
 /* determine the name and the state of the just found USB device */
@@ -281,15 +290,21 @@ int dvb_usb_device_init(struct usb_interface *intf,
 
 	usb_set_intfdata(intf, d);
 
-	if (du != NULL)
+	ret = dvb_usb_init(d, adapter_nums);
+	if (ret) {
+		info("%s error while loading driver (%d)", desc->name, ret);
+		goto error;
+	}
+
+	if (du)
 		*du = d;
 
-	ret = dvb_usb_init(d, adapter_nums);
+	info("%s successfully initialized and connected.", desc->name);
+	return 0;
 
-	if (ret == 0)
-		info("%s successfully initialized and connected.", desc->name);
-	else
-		info("%s error while loading driver (%d)", desc->name, ret);
+ error:
+	usb_set_intfdata(intf, NULL);
+	kfree(d);
 	return ret;
 }
 EXPORT_SYMBOL(dvb_usb_device_init);
