Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C93147AD92
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbhLTOxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:53:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42476 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbhLTOvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:51:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F94C611D0;
        Mon, 20 Dec 2021 14:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BEDC36AE7;
        Mon, 20 Dec 2021 14:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011861;
        bh=ODWJTRXKy8xSS4+g6COkmOYMLdb0LQomb8Z3YB/r018=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKO0r3ZjBIhLOYXJEzVyKIq1AiSYQHf+3+6JAkZCZ7Wis+z+ZrankuLjQnAScP0uk
         muklrsT6LgKMJMpoYTwaULof9f5y+Qih70b0/l701l/dnFuWeOP14GFCgviHEloqen
         76P3MvQcFifWY6t0Z4htxUtpHdxc1cWhkd8h1+eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        syzbot+5ca0bf339f13c4243001@syzkaller.appspotmail.com
Subject: [PATCH 5.10 86/99] media: mxl111sf: change mutex_init() location
Date:   Mon, 20 Dec 2021 15:34:59 +0100
Message-Id: <20211220143032.289591032@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 44870a9e7a3c24acbb3f888b2a7cc22c9bdf7e7f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -931,8 +931,6 @@ static int mxl111sf_init(struct dvb_usb_
 		  .len = sizeof(eeprom), .buf = eeprom },
 	};
 
-	mutex_init(&state->msg_lock);
-
 	ret = get_chip_info(state);
 	if (mxl_fail(ret))
 		pr_err("failed to get chip info during probe");
@@ -1074,6 +1072,14 @@ static int mxl111sf_get_stream_config_dv
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
@@ -1083,6 +1089,7 @@ static struct dvb_usb_device_properties
 	.generic_bulk_ctrl_endpoint = 0x02,
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
+	.probe             = mxl111sf_probe,
 	.i2c_algo          = &mxl111sf_i2c_algo,
 	.frontend_attach   = mxl111sf_frontend_attach_dvbt,
 	.tuner_attach      = mxl111sf_attach_tuner,
@@ -1124,6 +1131,7 @@ static struct dvb_usb_device_properties
 	.generic_bulk_ctrl_endpoint = 0x02,
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
+	.probe             = mxl111sf_probe,
 	.i2c_algo          = &mxl111sf_i2c_algo,
 	.frontend_attach   = mxl111sf_frontend_attach_atsc,
 	.tuner_attach      = mxl111sf_attach_tuner,
@@ -1165,6 +1173,7 @@ static struct dvb_usb_device_properties
 	.generic_bulk_ctrl_endpoint = 0x02,
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
+	.probe             = mxl111sf_probe,
 	.i2c_algo          = &mxl111sf_i2c_algo,
 	.frontend_attach   = mxl111sf_frontend_attach_mh,
 	.tuner_attach      = mxl111sf_attach_tuner,
@@ -1233,6 +1242,7 @@ static struct dvb_usb_device_properties
 	.generic_bulk_ctrl_endpoint = 0x02,
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
+	.probe             = mxl111sf_probe,
 	.i2c_algo          = &mxl111sf_i2c_algo,
 	.frontend_attach   = mxl111sf_frontend_attach_atsc_mh,
 	.tuner_attach      = mxl111sf_attach_tuner,
@@ -1311,6 +1321,7 @@ static struct dvb_usb_device_properties
 	.generic_bulk_ctrl_endpoint = 0x02,
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
+	.probe             = mxl111sf_probe,
 	.i2c_algo          = &mxl111sf_i2c_algo,
 	.frontend_attach   = mxl111sf_frontend_attach_mercury,
 	.tuner_attach      = mxl111sf_attach_tuner,
@@ -1381,6 +1392,7 @@ static struct dvb_usb_device_properties
 	.generic_bulk_ctrl_endpoint = 0x02,
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
+	.probe             = mxl111sf_probe,
 	.i2c_algo          = &mxl111sf_i2c_algo,
 	.frontend_attach   = mxl111sf_frontend_attach_mercury_mh,
 	.tuner_attach      = mxl111sf_attach_tuner,


