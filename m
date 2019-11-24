Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D187108267
	for <lists+stable@lfdr.de>; Sun, 24 Nov 2019 07:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbfKXG7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Nov 2019 01:59:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbfKXG7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Nov 2019 01:59:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 879722068F;
        Sun, 24 Nov 2019 06:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574578752;
        bh=hxkNenwRCrOjag6h7R3CP5ZTXVk7ROBIYj/FuvNvqfU=;
        h=Subject:To:From:Date:From;
        b=pDX+qycDZi0XCOHhONf8NssiIVuWPd7katggEwqZvM2AlwrcnvDBdbh6lAhi4BYuS
         EuWzUPo9aK9CDfYnoro/Y8jx3mXhRCgoF3ZLSvxOoq1QuihiNRw2BJ9qVfE0IxDD9g
         DA8AlXu16oDFpp3c0KMiNmyDOV2ZZkSYcrWlV5gY=
Subject: patch "tty: vt: keyboard: reject invalid keycodes" added to tty-next
To:     dmitry.torokhov@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Nov 2019 07:59:08 +0100
Message-ID: <1574578748145123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: vt: keyboard: reject invalid keycodes

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From b2b2dd71e0859436d4e05b2f61f86140250ed3f8 Mon Sep 17 00:00:00 2001
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Fri, 22 Nov 2019 12:42:20 -0800
Subject: tty: vt: keyboard: reject invalid keycodes

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
 drivers/tty/vt/keyboard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 515fc095e3b4..15d33fa0c925 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1491,7 +1491,7 @@ static void kbd_event(struct input_handle *handle, unsigned int event_type,
 
 	if (event_type == EV_MSC && event_code == MSC_RAW && HW_RAW(handle->dev))
 		kbd_rawcode(value);
-	if (event_type == EV_KEY)
+	if (event_type == EV_KEY && event_code <= KEY_MAX)
 		kbd_keycode(event_code, value, HW_RAW(handle->dev));
 
 	spin_unlock(&kbd_event_lock);
-- 
2.24.0


