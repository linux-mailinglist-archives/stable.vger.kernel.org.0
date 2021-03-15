Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB1033B9B3
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhCOOGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233394AbhCOOBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF54764FC9;
        Mon, 15 Mar 2021 14:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816870;
        bh=Hc2RNgYQ9816tG0LFu3KtMs6m4KsiJybRjF36L5Dmm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7E+wgaAQo6DP1PPpL/gML9t5O6jMpBb2R+ojXZxv/gyaEzTgXso2fgRMaqRlwuta
         Ruu59LmyeYUdGn2lUOT1zIKVJai7drTT8h7lnpxRE+ibHWWJJh0J9wshf+n9aLtnIF
         Dr3dJRB7sDkvak5iITM52ElDjPxY3aQ/Ffipr16s=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+719da9b149a931f5143f@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 174/306] ALSA: usb-audio: fix NULL ptr dereference in usb_audio_probe
Date:   Mon, 15 Mar 2021 14:53:57 +0100
Message-Id: <20210315135513.500495383@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Pavel Skripkin <paskripkin@gmail.com>

commit 30dea07180de3aa0ad613af88431ef4e34b5ef68 upstream.

syzbot reported null pointer dereference in usb_audio_probe.
The problem was in case, when quirk == NULL. It's not an
error condition, so quirk must be checked before dereferencing.

Call Trace:
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 really_probe+0x291/0xe60 drivers/base/dd.c:554
 driver_probe_device+0x26b/0x3d0 drivers/base/dd.c:740
 __device_attach_driver+0x1d1/0x290 drivers/base/dd.c:846
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4a0 drivers/base/dd.c:914
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbdb/0x1db0 drivers/base/core.c:3242
 usb_set_configuration+0x113f/0x1910 drivers/usb/core/message.c:2164
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
 really_probe+0x291/0xe60 drivers/base/dd.c:554
 driver_probe_device+0x26b/0x3d0 drivers/base/dd.c:740
 __device_attach_driver+0x1d1/0x290 drivers/base/dd.c:846
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4a0 drivers/base/dd.c:914
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbdb/0x1db0 drivers/base/core.c:3242
 usb_new_device.cold+0x721/0x1058 drivers/usb/core/hub.c:2555
 hub_port_connect drivers/usb/core/hub.c:5223 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5363 [inline]
 port_event drivers/usb/core/hub.c:5509 [inline]
 hub_event+0x2357/0x4320 drivers/usb/core/hub.c:5591
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Reported-by: syzbot+719da9b149a931f5143f@syzkaller.appspotmail.com
Fixes: 9799110825db ("ALSA: usb-audio: Disable USB autosuspend properly in setup_disable_autosuspend()")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/f1ebad6e721412843bd1b12584444c0a63c6b2fb.1615242183.git.paskripkin@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/card.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -831,7 +831,8 @@ static int usb_audio_probe(struct usb_in
 		snd_media_device_create(chip, intf);
 	}
 
-	chip->quirk_type = quirk->type;
+	if (quirk)
+		chip->quirk_type = quirk->type;
 
 	usb_chip[chip->index] = chip;
 	chip->intf[chip->num_interfaces] = intf;


