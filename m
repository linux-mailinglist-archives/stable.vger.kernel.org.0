Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE18013A688
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731514AbgANKMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:12:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732861AbgANKMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:12:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A02F207FF;
        Tue, 14 Jan 2020 10:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996720;
        bh=4nAkv6T/KHbSo6vgUYZW7o+FzmQgtTO6S3jvFzs7md0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6t+bdawmmsoVSUd9/5vWvX4xbsSj9uwc3FQ90ZJ5VniK/LWvrjET0bFN1ine8azv
         uvQIxjEhgI2lAmq4CTi70Z1lXfmGbe6FUHh33i6PdjF6IG+V/s3ZaF0aUMn1IxRu7b
         AgQ46VftNbi40WfRyuBVrp+zE9mpTsEuqv9PKov0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+19340dff067c2d3835c0@syzkaller.appspotmail.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.9 10/31] HID: hid-input: clear unmapped usages
Date:   Tue, 14 Jan 2020 11:02:02 +0100
Message-Id: <20200114094341.617526687@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094334.725604663@linuxfoundation.org>
References: <20200114094334.725604663@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 4f3882177240a1f55e45a3d241d3121341bead78 upstream.

We should not be leaving half-mapped usages with potentially invalid
keycodes, as that may confuse hidinput_find_key() when the key is located
by index, which may end up feeding way too large keycode into the VT
keyboard handler and cause OOB write there:

BUG: KASAN: global-out-of-bounds in clear_bit include/asm-generic/bitops-instrumented.h:56 [inline]
BUG: KASAN: global-out-of-bounds in kbd_keycode drivers/tty/vt/keyboard.c:1411 [inline]
BUG: KASAN: global-out-of-bounds in kbd_event+0xe6b/0x3790 drivers/tty/vt/keyboard.c:1495
Write of size 8 at addr ffffffff89a1b2d8 by task syz-executor108/1722
...
 kbd_keycode drivers/tty/vt/keyboard.c:1411 [inline]
 kbd_event+0xe6b/0x3790 drivers/tty/vt/keyboard.c:1495
 input_to_handler+0x3b6/0x4c0 drivers/input/input.c:118
 input_pass_values.part.0+0x2e3/0x720 drivers/input/input.c:145
 input_pass_values drivers/input/input.c:949 [inline]
 input_set_keycode+0x290/0x320 drivers/input/input.c:954
 evdev_handle_set_keycode_v2+0xc4/0x120 drivers/input/evdev.c:882
 evdev_do_ioctl drivers/input/evdev.c:1150 [inline]

Cc: stable@vger.kernel.org
Reported-by: syzbot+19340dff067c2d3835c0@syzkaller.appspotmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Tested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-input.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1026,9 +1026,15 @@ static void hidinput_configure_usage(str
 	}
 
 mapped:
-	if (device->driver->input_mapped && device->driver->input_mapped(device,
-				hidinput, field, usage, &bit, &max) < 0)
-		goto ignore;
+	if (device->driver->input_mapped &&
+	    device->driver->input_mapped(device, hidinput, field, usage,
+					 &bit, &max) < 0) {
+		/*
+		 * The driver indicated that no further generic handling
+		 * of the usage is desired.
+		 */
+		return;
+	}
 
 	set_bit(usage->type, input->evbit);
 
@@ -1087,9 +1093,11 @@ mapped:
 		set_bit(MSC_SCAN, input->mscbit);
 	}
 
-ignore:
 	return;
 
+ignore:
+	usage->type = 0;
+	usage->code = 0;
 }
 
 void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct hid_usage *usage, __s32 value)


