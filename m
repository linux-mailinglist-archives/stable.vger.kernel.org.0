Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1FDF2EFEF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731468AbfE3DSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728513AbfE3DSM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:12 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFC8524787;
        Thu, 30 May 2019 03:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186291;
        bh=2YrukC3cEquubOCbw1IuRKiQl5aoHpT/7i1Fh9AHkO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0VYm0W5o+6gLXUQ6JojJmsEFsDtGLStJHFwGQw9mRKtArZhiBNyubMm6kWzTYYaq8
         D+3R4qsb+jnyETv/9/GWP0znanyG1NNNzRn5Daoo69c8fCQ4gUS/hNBWR+IwsAqSgA
         BKkmA2uTT3UCAuH6hKDT0xouJk+mHP/0wORvXfVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 250/276] media: dvbsky: Avoid leaking dvb frontend
Date:   Wed, 29 May 2019 20:06:48 -0700
Message-Id: <20190530030540.774952700@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fdfa59cd63b184e1e96d51ff170fcac739bc6f6f ]

Commit 14f4eaeddabc ("media: dvbsky: fix driver unregister logic") fixed
a use-after-free by removing the reference to the frontend after deleting
the backing i2c device.

This has the unfortunate side effect the frontend device is never freed
in the dvb core leaving a dangling device, leading to errors when the
dvb core tries to register the frontend after e.g. a replug as reported
here: https://www.spinics.net/lists/linux-media/msg138181.html

media: dvbsky: issues with DVBSky T680CI

===
[  561.119145] sp2 8-0040: CIMaX SP2 successfully attached
[  561.119161] usb 2-3: DVB: registering adapter 0 frontend 0 (Silicon Labs
Si2168)...
[  561.119174] sysfs: cannot create duplicate filename '/class/dvb/
dvb0.frontend0'
===

The use after free happened as dvb_usbv2_disconnect calls in this order:
- dvb_usb_device::props->exit(...)
- dvb_usbv2_adapter_frontend_exit(...)
  + if (fe) dvb_unregister_frontend(fe)
  + dvb_usb_device::props->frontend_detach(...)

Moving the release of the i2c device from exit() to frontend_detach()
avoids the dangling pointer access and allows the core to unregister
the frontend.

This was originally reported for a DVBSky T680CI, but it also affects
the MyGica T230C. As all supported devices structure the registration/
unregistration identically, apply the change for all device types.

Signed-off-by: Stefan Brüns <stefan.bruens@rwth-aachen.de>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index e28bd8836751e..ae0814dd202a6 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -615,16 +615,18 @@ static int dvbsky_init(struct dvb_usb_device *d)
 	return 0;
 }
 
-static void dvbsky_exit(struct dvb_usb_device *d)
+static int dvbsky_frontend_detach(struct dvb_usb_adapter *adap)
 {
+	struct dvb_usb_device *d = adap_to_d(adap);
 	struct dvbsky_state *state = d_to_priv(d);
-	struct dvb_usb_adapter *adap = &d->adapter[0];
+
+	dev_dbg(&d->udev->dev, "%s: adap=%d\n", __func__, adap->id);
 
 	dvb_module_release(state->i2c_client_tuner);
 	dvb_module_release(state->i2c_client_demod);
 	dvb_module_release(state->i2c_client_ci);
 
-	adap->fe[0] = NULL;
+	return 0;
 }
 
 /* DVB USB Driver stuff */
@@ -640,11 +642,11 @@ static struct dvb_usb_device_properties dvbsky_s960_props = {
 
 	.i2c_algo         = &dvbsky_i2c_algo,
 	.frontend_attach  = dvbsky_s960_attach,
+	.frontend_detach  = dvbsky_frontend_detach,
 	.init             = dvbsky_init,
 	.get_rc_config    = dvbsky_get_rc_config,
 	.streaming_ctrl   = dvbsky_streaming_ctrl,
 	.identify_state	  = dvbsky_identify_state,
-	.exit             = dvbsky_exit,
 	.read_mac_address = dvbsky_read_mac_addr,
 
 	.num_adapters = 1,
@@ -667,11 +669,11 @@ static struct dvb_usb_device_properties dvbsky_s960c_props = {
 
 	.i2c_algo         = &dvbsky_i2c_algo,
 	.frontend_attach  = dvbsky_s960c_attach,
+	.frontend_detach  = dvbsky_frontend_detach,
 	.init             = dvbsky_init,
 	.get_rc_config    = dvbsky_get_rc_config,
 	.streaming_ctrl   = dvbsky_streaming_ctrl,
 	.identify_state	  = dvbsky_identify_state,
-	.exit             = dvbsky_exit,
 	.read_mac_address = dvbsky_read_mac_addr,
 
 	.num_adapters = 1,
@@ -694,11 +696,11 @@ static struct dvb_usb_device_properties dvbsky_t680c_props = {
 
 	.i2c_algo         = &dvbsky_i2c_algo,
 	.frontend_attach  = dvbsky_t680c_attach,
+	.frontend_detach  = dvbsky_frontend_detach,
 	.init             = dvbsky_init,
 	.get_rc_config    = dvbsky_get_rc_config,
 	.streaming_ctrl   = dvbsky_streaming_ctrl,
 	.identify_state	  = dvbsky_identify_state,
-	.exit             = dvbsky_exit,
 	.read_mac_address = dvbsky_read_mac_addr,
 
 	.num_adapters = 1,
@@ -721,11 +723,11 @@ static struct dvb_usb_device_properties dvbsky_t330_props = {
 
 	.i2c_algo         = &dvbsky_i2c_algo,
 	.frontend_attach  = dvbsky_t330_attach,
+	.frontend_detach  = dvbsky_frontend_detach,
 	.init             = dvbsky_init,
 	.get_rc_config    = dvbsky_get_rc_config,
 	.streaming_ctrl   = dvbsky_streaming_ctrl,
 	.identify_state	  = dvbsky_identify_state,
-	.exit             = dvbsky_exit,
 	.read_mac_address = dvbsky_read_mac_addr,
 
 	.num_adapters = 1,
@@ -748,11 +750,11 @@ static struct dvb_usb_device_properties mygica_t230c_props = {
 
 	.i2c_algo         = &dvbsky_i2c_algo,
 	.frontend_attach  = dvbsky_mygica_t230c_attach,
+	.frontend_detach  = dvbsky_frontend_detach,
 	.init             = dvbsky_init,
 	.get_rc_config    = dvbsky_get_rc_config,
 	.streaming_ctrl   = dvbsky_streaming_ctrl,
 	.identify_state	  = dvbsky_identify_state,
-	.exit             = dvbsky_exit,
 
 	.num_adapters = 1,
 	.adapter = {
-- 
2.20.1



