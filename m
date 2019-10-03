Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C923CCA6B4
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392917AbfJCQqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730157AbfJCQqd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:46:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A77D20830;
        Thu,  3 Oct 2019 16:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121192;
        bh=zV48jgoYMfQjfPPSYmYYK+1BTHruirrsZy0aq79/d4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTEQhxAu9c5Mw6aY9H5uAtaAYUvemRapaoPJdvO4+3kcVXEsZnjVGZvKrch8tHyqp
         DCiIikOQVd6ypJWUPB19VBXw2NwtjH1pq7Mncuw8XUdlLLDFAy60lteYH2ELY/pEOB
         BkOg5wjV12n1ZIqTFXIQJZLhpVIGc2snt2Wk1L0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8a8f48672560c8ca59dd@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 141/344] media: dvb-frontends: use ida for pll number
Date:   Thu,  3 Oct 2019 17:51:46 +0200
Message-Id: <20191003154554.158863980@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

[ Upstream commit c268e7adea52be0093de1164c425f3c8d8927770 ]

KASAN: global-out-of-bounds Read in dvb_pll_attach

Syzbot reported global-out-of-bounds Read in dvb_pll_attach, while
accessing id[dvb_pll_devcount], because dvb_pll_devcount was 65,
that is more than size of 'id' which is DVB_PLL_MAX(64).

Rather than increasing dvb_pll_devcount every time, use ida so that
numbers are allocated correctly. This does mean that no more than
64 devices can be attached at the same time, but this is more than
sufficient.

usb 1-1: dvb_usb_v2: will pass the complete MPEG2 transport stream to the
software demuxer
dvbdev: DVB: registering new adapter (774 Friio White ISDB-T USB2.0)
usb 1-1: media controller created
dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
tc90522 0-0018: Toshiba TC90522 attached.
usb 1-1: DVB: registering adapter 0 frontend 0 (Toshiba TC90522 ISDB-T
module)...
dvbdev: dvb_create_media_entity: media entity 'Toshiba TC90522 ISDB-T
module' registered.
==================================================================
BUG: KASAN: global-out-of-bounds in dvb_pll_attach+0x6c5/0x830
drivers/media/dvb-frontends/dvb-pll.c:798
Read of size 4 at addr ffffffff89c9e5e0 by task kworker/0:1/12

CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.2.0-rc6+ #13
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xca/0x13e lib/dump_stack.c:113
  print_address_description+0x67/0x231 mm/kasan/report.c:188
  __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:317
  kasan_report+0xe/0x20 mm/kasan/common.c:614
  dvb_pll_attach+0x6c5/0x830 drivers/media/dvb-frontends/dvb-pll.c:798
  dvb_pll_probe+0xfe/0x174 drivers/media/dvb-frontends/dvb-pll.c:877
  i2c_device_probe+0x790/0xaa0 drivers/i2c/i2c-core-base.c:389
  really_probe+0x281/0x660 drivers/base/dd.c:509
  driver_probe_device+0x104/0x210 drivers/base/dd.c:670
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:777
  bus_for_each_drv+0x15c/0x1e0 drivers/base/bus.c:454
  __device_attach+0x217/0x360 drivers/base/dd.c:843
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
  device_add+0xae6/0x16f0 drivers/base/core.c:2111
  i2c_new_client_device+0x5b3/0xc40 drivers/i2c/i2c-core-base.c:778
  i2c_new_device+0x19/0x50 drivers/i2c/i2c-core-base.c:821
  dvb_module_probe+0xf9/0x220 drivers/media/dvb-core/dvbdev.c:985
  friio_tuner_attach+0x125/0x1d0 drivers/media/usb/dvb-usb-v2/gl861.c:536
  dvb_usbv2_adapter_frontend_init
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:675 [inline]
  dvb_usbv2_adapter_init drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:804
[inline]
  dvb_usbv2_init drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:865 [inline]
  dvb_usbv2_probe.cold+0x24dc/0x255d
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:980
  usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
  really_probe+0x281/0x660 drivers/base/dd.c:509
  driver_probe_device+0x104/0x210 drivers/base/dd.c:670
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:777
  bus_for_each_drv+0x15c/0x1e0 drivers/base/bus.c:454
  __device_attach+0x217/0x360 drivers/base/dd.c:843
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
  device_add+0xae6/0x16f0 drivers/base/core.c:2111
  usb_set_configuration+0xdf6/0x1670 drivers/usb/core/message.c:2023
  generic_probe+0x9d/0xd5 drivers/usb/core/generic.c:210
  usb_probe_device+0x99/0x100 drivers/usb/core/driver.c:266
  really_probe+0x281/0x660 drivers/base/dd.c:509
  driver_probe_device+0x104/0x210 drivers/base/dd.c:670
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:777
  bus_for_each_drv+0x15c/0x1e0 drivers/base/bus.c:454
  __device_attach+0x217/0x360 drivers/base/dd.c:843
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
  device_add+0xae6/0x16f0 drivers/base/core.c:2111
  usb_new_device.cold+0x8c1/0x1016 drivers/usb/core/hub.c:2534
  hub_port_connect drivers/usb/core/hub.c:5089 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
  port_event drivers/usb/core/hub.c:5350 [inline]
  hub_event+0x1ada/0x3590 drivers/usb/core/hub.c:5432
  process_one_work+0x905/0x1570 kernel/workqueue.c:2269
  process_scheduled_works kernel/workqueue.c:2331 [inline]
  worker_thread+0x7ab/0xe20 kernel/workqueue.c:2417
  kthread+0x30b/0x410 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the variable:
  id+0x100/0x120

Memory state around the buggy address:
  ffffffff89c9e480: fa fa fa fa 00 00 fa fa fa fa fa fa 00 00 00 00
  ffffffff89c9e500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ffffffff89c9e580: 00 00 00 00 00 00 00 00 00 00 00 00 fa fa fa fa
                                                        ^
  ffffffff89c9e600: 04 fa fa fa fa fa fa fa 04 fa fa fa fa fa fa fa
  ffffffff89c9e680: 04 fa fa fa fa fa fa fa 04 fa fa fa fa fa fa fa
==================================================================

Reported-by: syzbot+8a8f48672560c8ca59dd@syzkaller.appspotmail.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/dvb-pll.c | 40 ++++++++++++++++-----------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index ba0c49107bd28..d45b4ddc8f912 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -9,6 +9,7 @@
 
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/idr.h>
 #include <linux/dvb/frontend.h>
 #include <asm/types.h>
 
@@ -34,8 +35,7 @@ struct dvb_pll_priv {
 };
 
 #define DVB_PLL_MAX 64
-
-static unsigned int dvb_pll_devcount;
+static DEFINE_IDA(pll_ida);
 
 static int debug;
 module_param(debug, int, 0644);
@@ -787,6 +787,7 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
 	struct dvb_pll_priv *priv = NULL;
 	int ret;
 	const struct dvb_pll_desc *desc;
+	int nr;
 
 	b1 = kmalloc(1, GFP_KERNEL);
 	if (!b1)
@@ -795,9 +796,14 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
 	b1[0] = 0;
 	msg.buf = b1;
 
-	if ((id[dvb_pll_devcount] > DVB_PLL_UNDEFINED) &&
-	    (id[dvb_pll_devcount] < ARRAY_SIZE(pll_list)))
-		pll_desc_id = id[dvb_pll_devcount];
+	nr = ida_simple_get(&pll_ida, 0, DVB_PLL_MAX, GFP_KERNEL);
+	if (nr < 0) {
+		kfree(b1);
+		return NULL;
+	}
+
+	if (id[nr] > DVB_PLL_UNDEFINED && id[nr] < ARRAY_SIZE(pll_list))
+		pll_desc_id = id[nr];
 
 	BUG_ON(pll_desc_id < 1 || pll_desc_id >= ARRAY_SIZE(pll_list));
 
@@ -808,24 +814,20 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
 			fe->ops.i2c_gate_ctrl(fe, 1);
 
 		ret = i2c_transfer (i2c, &msg, 1);
-		if (ret != 1) {
-			kfree(b1);
-			return NULL;
-		}
+		if (ret != 1)
+			goto out;
 		if (fe->ops.i2c_gate_ctrl)
 			     fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
 	priv = kzalloc(sizeof(struct dvb_pll_priv), GFP_KERNEL);
-	if (!priv) {
-		kfree(b1);
-		return NULL;
-	}
+	if (!priv)
+		goto out;
 
 	priv->pll_i2c_address = pll_addr;
 	priv->i2c = i2c;
 	priv->pll_desc = desc;
-	priv->nr = dvb_pll_devcount++;
+	priv->nr = nr;
 
 	memcpy(&fe->ops.tuner_ops, &dvb_pll_tuner_ops,
 	       sizeof(struct dvb_tuner_ops));
@@ -858,6 +860,11 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
 	kfree(b1);
 
 	return fe;
+out:
+	kfree(b1);
+	ida_simple_remove(&pll_ida, nr);
+
+	return NULL;
 }
 EXPORT_SYMBOL(dvb_pll_attach);
 
@@ -894,9 +901,10 @@ dvb_pll_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 static int dvb_pll_remove(struct i2c_client *client)
 {
-	struct dvb_frontend *fe;
+	struct dvb_frontend *fe = i2c_get_clientdata(client);
+	struct dvb_pll_priv *priv = fe->tuner_priv;
 
-	fe = i2c_get_clientdata(client);
+	ida_simple_remove(&pll_ida, priv->nr);
 	dvb_pll_release(fe);
 	return 0;
 }
-- 
2.20.1



