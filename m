Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E88BD1574C8
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgBJMfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:35:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728151AbgBJMfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:53 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48FB420863;
        Mon, 10 Feb 2020 12:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338152;
        bh=Ltz2oaLXq2xBQOHBKtR5CK4Djns+UnmIlRNTfkRE6U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xj6ZJecdDt4vXtoKiyTCtwHTNe+RQkh7vFBaUlIhLp7lQjOHzPnjptUKSET1oXL28
         b7DwPnCldYY2FPCXYcOi//LdlyZfomZ4y1c9tPKm1S1QaPfi/aeEarZ9ijieq8FPOA
         Lqm/wZNxPse2mlotYgxNPb/Y0+BIt3ABIEITCDvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick French <nickfrench@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 116/195] media: rc: ensure lirc is initialized before registering input device
Date:   Mon, 10 Feb 2020 04:32:54 -0800
Message-Id: <20200210122316.748790034@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 080d89f522e2baddb4fbbd1af4b67b5f92537ef8 upstream.

Once rc_open is called on the input device, lirc events can be delivered.
Ensure lirc is ready to do so else we might get this:

Registered IR keymap rc-hauppauge
rc rc0: Hauppauge WinTV PVR-350 as
/devices/pci0000:00/0000:00:1e.0/0000:04:00.0/i2c-0/0-0018/rc/rc0
input: Hauppauge WinTV PVR-350 as
/devices/pci0000:00/0000:00:1e.0/0000:04:00.0/i2c-0/0-0018/rc/rc0/input9
BUG: kernel NULL pointer dereference, address: 0000000000000038
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
CPU: 1 PID: 17 Comm: kworker/1:0 Not tainted 5.3.11-300.fc31.x86_64 #1
Hardware name:  /DG43NB, BIOS NBG4310H.86A.0096.2009.0903.1845 09/03/2009
Workqueue: events ir_work [ir_kbd_i2c]
RIP: 0010:ir_lirc_scancode_event+0x3d/0xb0
Code: a6 b4 07 00 00 49 81 c6 b8 07 00 00 55 53 e8 ba a7 9d ff 4c 89
e7 49 89 45 00 e8 5e 7a 25 00 49 8b 1e 48 89 c5 4c 39 f3 74 58 <8b> 43
38 8b 53 40 89 c1 2b 4b 3c 39 ca 72 41 21 d0 49 8b 7d 00 49
RSP: 0018:ffffaae2000b3d88 EFLAGS: 00010017
RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000019
RDX: 0000000000000001 RSI: 006e801b1f26ce6a RDI: ffff9e39797c37b4
RBP: 0000000000000002 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: ffff9e39797c37b4
R13: ffffaae2000b3db8 R14: ffff9e39797c37b8 R15: ffff9e39797c33d8
FS:  0000000000000000(0000) GS:ffff9e397b680000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000038 CR3: 0000000035844000 CR4: 00000000000006e0
Call Trace:
ir_do_keydown+0x8e/0x2b0
rc_keydown+0x52/0xc0
ir_work+0xb8/0x130 [ir_kbd_i2c]
process_one_work+0x19d/0x340
worker_thread+0x50/0x3b0
kthread+0xfb/0x130
? process_one_work+0x340/0x340
? kthread_park+0x80/0x80
ret_from_fork+0x35/0x40
Modules linked in: rc_hauppauge tuner msp3400 saa7127 saa7115 ivtv(+)
tveeprom cx2341x v4l2_common videodev mc i2c_algo_bit ir_kbd_i2c
ip_tables firewire_ohci e1000e serio_raw firewire_core ata_generic
crc_itu_t pata_acpi pata_jmicron fuse
CR2: 0000000000000038
---[ end trace c67c2697a99fa74b ]---
RIP: 0010:ir_lirc_scancode_event+0x3d/0xb0
Code: a6 b4 07 00 00 49 81 c6 b8 07 00 00 55 53 e8 ba a7 9d ff 4c 89
e7 49 89 45 00 e8 5e 7a 25 00 49 8b 1e 48 89 c5 4c 39 f3 74 58 <8b> 43
38 8b 53 40 89 c1 2b 4b 3c 39 ca 72 41 21 d0 49 8b 7d 00 49
RSP: 0018:ffffaae2000b3d88 EFLAGS: 00010017
RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000019
RDX: 0000000000000001 RSI: 006e801b1f26ce6a RDI: ffff9e39797c37b4
RBP: 0000000000000002 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: ffff9e39797c37b4
R13: ffffaae2000b3db8 R14: ffff9e39797c37b8 R15: ffff9e39797c33d8
FS:  0000000000000000(0000) GS:ffff9e397b680000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000038 CR3: 0000000035844000 CR4: 00000000000006e0
rc rc0: lirc_dev: driver ir_kbd_i2c registered at minor = 0, scancode
receiver, no transmitter
tuner-simple 0-0061: creating new instance
tuner-simple 0-0061: type set to 2 (Philips NTSC (FI1236,FM1236 and
compatibles))
ivtv0: Registered device video0 for encoder MPG (4096 kB)
ivtv0: Registered device video32 for encoder YUV (2048 kB)
ivtv0: Registered device vbi0 for encoder VBI (1024 kB)
ivtv0: Registered device video24 for encoder PCM (320 kB)
ivtv0: Registered device radio0 for encoder radio
ivtv0: Registered device video16 for decoder MPG (1024 kB)
ivtv0: Registered device vbi8 for decoder VBI (64 kB)
ivtv0: Registered device vbi16 for decoder VOUT
ivtv0: Registered device video48 for decoder YUV (1024 kB)

Cc: stable@vger.kernel.org
Tested-by: Nick French <nickfrench@gmail.com>
Reported-by: Nick French <nickfrench@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/rc-main.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1874,23 +1874,28 @@ int rc_register_device(struct rc_dev *de
 
 	dev->registered = true;
 
-	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
-		rc = rc_setup_rx_device(dev);
-		if (rc)
-			goto out_dev;
-	}
-
-	/* Ensure that the lirc kfifo is setup before we start the thread */
+	/*
+	 * once the the input device is registered in rc_setup_rx_device,
+	 * userspace can open the input device and rc_open() will be called
+	 * as a result. This results in driver code being allowed to submit
+	 * keycodes with rc_keydown, so lirc must be registered first.
+	 */
 	if (dev->allowed_protocols != RC_PROTO_BIT_CEC) {
 		rc = ir_lirc_register(dev);
 		if (rc < 0)
-			goto out_rx;
+			goto out_dev;
+	}
+
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
+		rc = rc_setup_rx_device(dev);
+		if (rc)
+			goto out_lirc;
 	}
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW) {
 		rc = ir_raw_event_register(dev);
 		if (rc < 0)
-			goto out_lirc;
+			goto out_rx;
 	}
 
 	dev_dbg(&dev->dev, "Registered rc%u (driver: %s)\n", dev->minor,
@@ -1898,11 +1903,11 @@ int rc_register_device(struct rc_dev *de
 
 	return 0;
 
+out_rx:
+	rc_free_rx_device(dev);
 out_lirc:
 	if (dev->allowed_protocols != RC_PROTO_BIT_CEC)
 		ir_lirc_unregister(dev);
-out_rx:
-	rc_free_rx_device(dev);
 out_dev:
 	device_del(&dev->dev);
 out_rx_free:


