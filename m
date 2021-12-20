Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D181447A8A6
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 12:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhLTL1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 06:27:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53700 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhLTL1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 06:27:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9881760BA7
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 11:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16189C36AE8;
        Mon, 20 Dec 2021 11:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639999637;
        bh=RJmTlFkZ/u6wJDlqp7uKUBTz8gjrX8lelEmo/XpTwbU=;
        h=Subject:To:Cc:From:Date:From;
        b=UtwVSjf6GqjI8qI5wGRCFGr65jYu2IXE0PMQJtHWjHfrmc9l5lbomSvzGnJWNqNKb
         8UaQExKkD6uZaoN4Ud7LUPdOFvR0gxsxHSu9vJ5jSbVm+7nNs/y/XgNNQX0W5zu8nk
         UJnFRxRgdhhp1QMuWVk4po1It+LoKFplplolUoEk=
Subject: FAILED: patch "[PATCH] media: mxl111sf: change mutex_init() location" failed to apply to 4.9-stable tree
To:     paskripkin@gmail.com, mchehab+huawei@kernel.org, sean@mess.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Dec 2021 12:27:14 +0100
Message-ID: <163999963428224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 44870a9e7a3c24acbb3f888b2a7cc22c9bdf7e7f Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Thu, 19 Aug 2021 12:42:21 +0200
Subject: [PATCH] media: mxl111sf: change mutex_init() location

Syzbot reported, that mxl111sf_ctrl_msg() uses uninitialized
mutex. The problem was in wrong mutex_init() location.

Previous mutex_init(&state->msg_lock) call was in ->init() function, but
dvb_usbv2_init() has this order of calls:

	dvb_usbv2_init()
	  dvb_usbv2_adapter_init()
	    dvb_usbv2_adapter_frontend_init()
	      props->frontend_attach()

	  props->init()

Since mxl111sf_* devices call mxl111sf_ctrl_msg() in ->frontend_attach()
internally we need to initialize state->msg_lock before
frontend_attach(). To achieve it, ->probe() call added to all mxl111sf_*
devices, which will simply initiaize mutex.

Reported-and-tested-by: syzbot+5ca0bf339f13c4243001@syzkaller.appspotmail.com

Fixes: 8572211842af ("[media] mxl111sf: convert to new DVB USB")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index 7865fa0a8295..cd5861a30b6f 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -931,8 +931,6 @@ static int mxl111sf_init(struct dvb_usb_device *d)
 		  .len = sizeof(eeprom), .buf = eeprom },
 	};
 
-	mutex_init(&state->msg_lock);
-
 	ret = get_chip_info(state);
 	if (mxl_fail(ret))
 		pr_err("failed to get chip info during probe");
@@ -1074,6 +1072,14 @@ static int mxl111sf_get_stream_config_dvbt(struct dvb_frontend *fe,
 	return 0;
 }
 
+static int mxl111sf_probe(struct dvb_usb_device *dev)
+{
+	struct mxl111sf_state *state = d_to_priv(dev);
+
+	mutex_init(&state->msg_lock);
+	return 0;
+}
+
 static struct dvb_usb_device_properties mxl111sf_props_dvbt = {
 	.driver_name = KBUILD_MODNAME,
 	.owner = THIS_MODULE,
@@ -1083,6 +1089,7 @@ static struct dvb_usb_device_properties mxl111sf_props_dvbt = {
 	.generic_bulk_ctrl_endpoint = 0x02,
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
+	.probe             = mxl111sf_probe,
 	.i2c_algo          = &mxl111sf_i2c_algo,
 	.frontend_attach   = mxl111sf_frontend_attach_dvbt,
 	.tuner_attach      = mxl111sf_attach_tuner,
@@ -1124,6 +1131,7 @@ static struct dvb_usb_device_properties mxl111sf_props_atsc = {
 	.generic_bulk_ctrl_endpoint = 0x02,
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
+	.probe             = mxl111sf_probe,
 	.i2c_algo          = &mxl111sf_i2c_algo,
 	.frontend_attach   = mxl111sf_frontend_attach_atsc,
 	.tuner_attach      = mxl111sf_attach_tuner,
@@ -1165,6 +1173,7 @@ static struct dvb_usb_device_properties mxl111sf_props_mh = {
 	.generic_bulk_ctrl_endpoint = 0x02,
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
+	.probe             = mxl111sf_probe,
 	.i2c_algo          = &mxl111sf_i2c_algo,
 	.frontend_attach   = mxl111sf_frontend_attach_mh,
 	.tuner_attach      = mxl111sf_attach_tuner,
@@ -1233,6 +1242,7 @@ static struct dvb_usb_device_properties mxl111sf_props_atsc_mh = {
 	.generic_bulk_ctrl_endpoint = 0x02,
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
+	.probe             = mxl111sf_probe,
 	.i2c_algo          = &mxl111sf_i2c_algo,
 	.frontend_attach   = mxl111sf_frontend_attach_atsc_mh,
 	.tuner_attach      = mxl111sf_attach_tuner,
@@ -1311,6 +1321,7 @@ static struct dvb_usb_device_properties mxl111sf_props_mercury = {
 	.generic_bulk_ctrl_endpoint = 0x02,
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
+	.probe             = mxl111sf_probe,
 	.i2c_algo          = &mxl111sf_i2c_algo,
 	.frontend_attach   = mxl111sf_frontend_attach_mercury,
 	.tuner_attach      = mxl111sf_attach_tuner,
@@ -1381,6 +1392,7 @@ static struct dvb_usb_device_properties mxl111sf_props_mercury_mh = {
 	.generic_bulk_ctrl_endpoint = 0x02,
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
+	.probe             = mxl111sf_probe,
 	.i2c_algo          = &mxl111sf_i2c_algo,
 	.frontend_attach   = mxl111sf_frontend_attach_mercury_mh,
 	.tuner_attach      = mxl111sf_attach_tuner,

