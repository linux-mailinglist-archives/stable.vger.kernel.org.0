Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AA213A60C
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbgANKIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:08:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729416AbgANKIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:08:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65AF7207FF;
        Tue, 14 Jan 2020 10:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996500;
        bh=Zkne0qlY6NJIT3bKQZGPcYYlFRgfrwxG1in28LCITt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UG4FDY5eeU4TQTFWEu9Ii1E/2lPuDJSikkEgzMWaFEpWTymYo99xQ5jzRjuk8G06B
         NiDv8eDWjMm383/psVMGNlrLQC9g4B3/LV/varVunP7Bx0n67ctI717+NK/WwQA+/Y
         lScQXAJUZvAl8AHnLV51YEzk7mSohD1qHHhOgdUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c769968809f9359b07aa@syzkaller.appspotmail.com,
        syzbot+76f3a30e88d256644c78@syzkaller.appspotmail.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 14/46] Input: add safety guards to input_set_keycode()
Date:   Tue, 14 Jan 2020 11:01:31 +0100
Message-Id: <20200114094343.435861738@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094339.608068818@linuxfoundation.org>
References: <20200114094339.608068818@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit cb222aed03d798fc074be55e59d9a112338ee784 upstream.

If we happen to have a garbage in input device's keycode table with values
too big we'll end up doing clear_bit() with offset way outside of our
bitmaps, damaging other objects within an input device or even outside of
it. Let's add sanity checks to the returned old keycodes.

Reported-by: syzbot+c769968809f9359b07aa@syzkaller.appspotmail.com
Reported-by: syzbot+76f3a30e88d256644c78@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20191207212757.GA245964@dtor-ws
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/input.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -858,16 +858,18 @@ static int input_default_setkeycode(stru
 		}
 	}
 
-	__clear_bit(*old_keycode, dev->keybit);
-	__set_bit(ke->keycode, dev->keybit);
-
-	for (i = 0; i < dev->keycodemax; i++) {
-		if (input_fetch_keycode(dev, i) == *old_keycode) {
-			__set_bit(*old_keycode, dev->keybit);
-			break; /* Setting the bit twice is useless, so break */
+	if (*old_keycode <= KEY_MAX) {
+		__clear_bit(*old_keycode, dev->keybit);
+		for (i = 0; i < dev->keycodemax; i++) {
+			if (input_fetch_keycode(dev, i) == *old_keycode) {
+				__set_bit(*old_keycode, dev->keybit);
+				/* Setting the bit twice is useless, so break */
+				break;
+			}
 		}
 	}
 
+	__set_bit(ke->keycode, dev->keybit);
 	return 0;
 }
 
@@ -923,9 +925,13 @@ int input_set_keycode(struct input_dev *
 	 * Simulate keyup event if keycode is not present
 	 * in the keymap anymore
 	 */
-	if (test_bit(EV_KEY, dev->evbit) &&
-	    !is_event_supported(old_keycode, dev->keybit, KEY_MAX) &&
-	    __test_and_clear_bit(old_keycode, dev->key)) {
+	if (old_keycode > KEY_MAX) {
+		dev_warn(dev->dev.parent ?: &dev->dev,
+			 "%s: got too big old keycode %#x\n",
+			 __func__, old_keycode);
+	} else if (test_bit(EV_KEY, dev->evbit) &&
+		   !is_event_supported(old_keycode, dev->keybit, KEY_MAX) &&
+		   __test_and_clear_bit(old_keycode, dev->key)) {
 		struct input_value vals[] =  {
 			{ EV_KEY, old_keycode, 0 },
 			input_value_sync


