Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18BF2CA6E1
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 16:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390203AbgLAPVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 10:21:18 -0500
Received: from www.linuxtv.org ([130.149.80.248]:51766 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387678AbgLAPVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 10:21:17 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1kk7SE-000kjE-0x; Tue, 01 Dec 2020 15:20:34 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 01 Dec 2020 15:19:07 +0000
Subject: [git:media_tree/fixes] media: pulse8-cec: fix duplicate free at disconnect or probe error
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Maxime Ripard <mripard@kernel.org>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1kk7SE-000kjE-0x@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: pulse8-cec: fix duplicate free at disconnect or probe error
Author:  Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:    Fri Nov 27 10:36:32 2020 +0100

Commit 601282d65b96 ("media: pulse8-cec: use adap_free callback") used
the adap_free callback to clean up on disconnect. What I forgot was that
in the probe it will call cec_delete_adapter() followed by kfree(pulse8)
if an error occurs. But by using the adap_free callback,
cec_delete_adapter() is already freeing the pulse8 struct.

This wasn't noticed since normally the probe works fine, but Pulse-Eight
published a new firmware version that caused a probe error, so now it
hits this bug. This affects firmware version 12, but probably any
version >= 10.

Commit aa9eda76129c ("media: pulse8-cec: close serio in disconnect, not
adap_free") made this worse by adding the line 'pulse8->serio = NULL'
right after the call to cec_unregister_adapter in the disconnect()
function. Unfortunately, cec_unregister_adapter will typically call
cec_delete_adapter (unless a filehandle to the cec device is still
open), which frees the pulse8 struct. So now it will also crash on a
simple unplug of the Pulse-Eight device.

With this fix both the unplug issue and a probe() error situation are
handled correctly again.

It will still fail to probe() with a v12 firmware, that's something
to look at separately.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Maxime Ripard <mripard@kernel.org>
Tested-by: Maxime Ripard <mripard@kernel.org>
Fixes: aa9eda76129c ("media: pulse8-cec: close serio in disconnect, not adap_free")
Fixes: 601282d65b96 ("media: pulse8-cec: use adap_free callback")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/cec/usb/pulse8/pulse8-cec.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

---

diff --git a/drivers/media/cec/usb/pulse8/pulse8-cec.c b/drivers/media/cec/usb/pulse8/pulse8-cec.c
index e4d8446b87da..5d3a3f775bc8 100644
--- a/drivers/media/cec/usb/pulse8/pulse8-cec.c
+++ b/drivers/media/cec/usb/pulse8/pulse8-cec.c
@@ -650,7 +650,6 @@ static void pulse8_disconnect(struct serio *serio)
 	struct pulse8 *pulse8 = serio_get_drvdata(serio);
 
 	cec_unregister_adapter(pulse8->adap);
-	pulse8->serio = NULL;
 	serio_set_drvdata(serio, NULL);
 	serio_close(serio);
 }
@@ -830,8 +829,10 @@ static int pulse8_connect(struct serio *serio, struct serio_driver *drv)
 	pulse8->adap = cec_allocate_adapter(&pulse8_cec_adap_ops, pulse8,
 					    dev_name(&serio->dev), caps, 1);
 	err = PTR_ERR_OR_ZERO(pulse8->adap);
-	if (err < 0)
-		goto free_device;
+	if (err < 0) {
+		kfree(pulse8);
+		return err;
+	}
 
 	pulse8->dev = &serio->dev;
 	serio_set_drvdata(serio, pulse8);
@@ -874,8 +875,6 @@ close_serio:
 	serio_close(serio);
 delete_adap:
 	cec_delete_adapter(pulse8->adap);
-free_device:
-	kfree(pulse8);
 	return err;
 }
 
