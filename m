Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E76621218DD
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbfLPRz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:55:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728117AbfLPRz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:55:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 545BE206B7;
        Mon, 16 Dec 2019 17:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518956;
        bh=U4z2sRDYdJKHX1PNo+xR3U0qZN1owb1vJ9hDYEmbJF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GW1xW6RoZRG8C9xFexuB/f56U/eXZuosXkwcz88oI/90u8G6G24J6MlOWVKMgpqac
         nZdpG3Z63GU4my+kh109VZZuMmzbP+Std+pkua6btN0Z79d2hcI4J2Sv0uEc1kBMiA
         27VNdsjkQJA7IwD8T0+ASNLKrmEfX9SEoudxXGEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+19340dff067c2d3835c0@syzkaller.appspotmail.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 135/267] tty: vt: keyboard: reject invalid keycodes
Date:   Mon, 16 Dec 2019 18:47:41 +0100
Message-Id: <20191216174908.123251878@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit b2b2dd71e0859436d4e05b2f61f86140250ed3f8 upstream.

Do not try to handle keycodes that are too big, otherwise we risk doing
out-of-bounds writes:

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

In this case we were dealing with a fuzzed HID device that declared over
12K buttons, and while HID layer should not be reporting to us such big
keycodes, we should also be defensive and reject invalid data ourselves as
well.

Reported-by: syzbot+19340dff067c2d3835c0@syzkaller.appspotmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191122204220.GA129459@dtor-ws
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/keyboard.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1460,7 +1460,7 @@ static void kbd_event(struct input_handl
 
 	if (event_type == EV_MSC && event_code == MSC_RAW && HW_RAW(handle->dev))
 		kbd_rawcode(value);
-	if (event_type == EV_KEY)
+	if (event_type == EV_KEY && event_code <= KEY_MAX)
 		kbd_keycode(event_code, value, HW_RAW(handle->dev));
 
 	spin_unlock(&kbd_event_lock);


