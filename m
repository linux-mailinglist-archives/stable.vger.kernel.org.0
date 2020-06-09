Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9651F43E4
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387520AbgFIR6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733252AbgFIRzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:55:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C87E220774;
        Tue,  9 Jun 2020 17:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725332;
        bh=Nchi5rPksxeSgTW7vOly43VUU3E5jE2NOk7Oj9wAaIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fn8fgO88PiFprwP5uFHgFvWbfkQvCYb+4TwxavDNsRzdkNIuOfxN56y8WsAGxC6rg
         +xMCkz0Rl4SOarKquKlVinD2k0y7Q/8B1JOprQ1nFoTUX4sT0u/KtisnGOyyg9i5NQ
         Qyg7H/tk0d7REZ9PzrpGQ8+chS8QMd0bEWWL+TgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyungtae Kim <kt0755@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.7 14/24] vt: keyboard: avoid signed integer overflow in k_ascii
Date:   Tue,  9 Jun 2020 19:45:45 +0200
Message-Id: <20200609174150.492778027@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174149.255223112@linuxfoundation.org>
References: <20200609174149.255223112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit b86dab054059b970111b5516ae548efaae5b3aae upstream.

When k_ascii is invoked several times in a row there is a potential for
signed integer overflow:

UBSAN: Undefined behaviour in drivers/tty/vt/keyboard.c:888:19 signed integer overflow:
10 * 1111111111 cannot be represented in type 'int'
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.11 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xce/0x128 lib/dump_stack.c:118
 ubsan_epilogue+0xe/0x30 lib/ubsan.c:154
 handle_overflow+0xdc/0xf0 lib/ubsan.c:184
 __ubsan_handle_mul_overflow+0x2a/0x40 lib/ubsan.c:205
 k_ascii+0xbf/0xd0 drivers/tty/vt/keyboard.c:888
 kbd_keycode drivers/tty/vt/keyboard.c:1477 [inline]
 kbd_event+0x888/0x3be0 drivers/tty/vt/keyboard.c:1495

While it can be worked around by using check_mul_overflow()/
check_add_overflow(), it is better to introduce a separate flag to
signal that number pad is being used to compose a symbol, and
change type of the accumulator from signed to unsigned, thus
avoiding undefined behavior when it overflows.

Reported-by: Kyungtae Kim <kt0755@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200525232740.GA262061@dtor-ws
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/keyboard.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -127,7 +127,11 @@ static DEFINE_SPINLOCK(func_buf_lock); /
 static unsigned long key_down[BITS_TO_LONGS(KEY_CNT)];	/* keyboard key bitmap */
 static unsigned char shift_down[NR_SHIFT];		/* shift state counters.. */
 static bool dead_key_next;
-static int npadch = -1;					/* -1 or number assembled on pad */
+
+/* Handles a number being assembled on the number pad */
+static bool npadch_active;
+static unsigned int npadch_value;
+
 static unsigned int diacr;
 static char rep;					/* flag telling character repeat */
 
@@ -845,12 +849,12 @@ static void k_shift(struct vc_data *vc,
 		shift_state &= ~(1 << value);
 
 	/* kludge */
-	if (up_flag && shift_state != old_state && npadch != -1) {
+	if (up_flag && shift_state != old_state && npadch_active) {
 		if (kbd->kbdmode == VC_UNICODE)
-			to_utf8(vc, npadch);
+			to_utf8(vc, npadch_value);
 		else
-			put_queue(vc, npadch & 0xff);
-		npadch = -1;
+			put_queue(vc, npadch_value & 0xff);
+		npadch_active = false;
 	}
 }
 
@@ -868,7 +872,7 @@ static void k_meta(struct vc_data *vc, u
 
 static void k_ascii(struct vc_data *vc, unsigned char value, char up_flag)
 {
-	int base;
+	unsigned int base;
 
 	if (up_flag)
 		return;
@@ -882,10 +886,12 @@ static void k_ascii(struct vc_data *vc,
 		base = 16;
 	}
 
-	if (npadch == -1)
-		npadch = value;
-	else
-		npadch = npadch * base + value;
+	if (!npadch_active) {
+		npadch_value = 0;
+		npadch_active = true;
+	}
+
+	npadch_value = npadch_value * base + value;
 }
 
 static void k_lock(struct vc_data *vc, unsigned char value, char up_flag)


