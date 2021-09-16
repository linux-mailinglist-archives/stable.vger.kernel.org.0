Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC1040E75A
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347175AbhIPRbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353029AbhIPR3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:29:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2943E61C32;
        Thu, 16 Sep 2021 16:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810770;
        bh=sEkLBe290KaPKtHxIDfF8Sql3ipPQQpbu8xLZAvL+0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2nEBZlvSUnIFbhRHXXaJ1mKMBiIBqcsQr22wzJ9VJbaa0cUrAJGBmMyS89Vf0JJiC
         RzKQjCueVD2NIJYDr26eOuom6izpPQjpw3UcUW+p/Ri6bjAYmIVbUv973e0QI3IX1c
         9Ncf6pdbSf9TT2vkDULsNB4l6Ejt0sUkce0d2fR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jordy Zomer <jordy@pwning.systems>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 234/432] vt: keyboard.c: make console an unsigned int
Date:   Thu, 16 Sep 2021 17:59:43 +0200
Message-Id: <20210916155818.776317618@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 3df15d6f37246d2f12f53d915c41d806289d3d46 ]

The console variable is used everywhere in some fun pointer path and
array indexes and for some reason isn't always declared as unsigned.
This plays havoc with some static analysis tools so mark the variable as
unsigned so we "know" we can not wrap the arrays backwards here.

Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Jordy Zomer <jordy@pwning.systems>
Link: https://lore.kernel.org/r/20210726134322.2274919-2-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/keyboard.c | 30 +++++++++++++++---------------
 include/linux/vt_kern.h   | 30 +++++++++++++++---------------
 2 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 4b0d69042ceb..bf6efebeb4bd 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1171,7 +1171,7 @@ static inline unsigned char getleds(void)
  *
  *	Check the status of a keyboard led flag and report it back
  */
-int vt_get_leds(int console, int flag)
+int vt_get_leds(unsigned int console, int flag)
 {
 	struct kbd_struct *kb = kbd_table + console;
 	int ret;
@@ -1193,7 +1193,7 @@ EXPORT_SYMBOL_GPL(vt_get_leds);
  *	Set the LEDs on a console. This is a wrapper for the VT layer
  *	so that we can keep kbd knowledge internal
  */
-void vt_set_led_state(int console, int leds)
+void vt_set_led_state(unsigned int console, int leds)
 {
 	struct kbd_struct *kb = kbd_table + console;
 	setledstate(kb, leds);
@@ -1212,7 +1212,7 @@ void vt_set_led_state(int console, int leds)
  *	don't hold the lock. We probably need to split out an LED lock
  *	but not during an -rc release!
  */
-void vt_kbd_con_start(int console)
+void vt_kbd_con_start(unsigned int console)
 {
 	struct kbd_struct *kb = kbd_table + console;
 	unsigned long flags;
@@ -1229,7 +1229,7 @@ void vt_kbd_con_start(int console)
  *	Handle console stop. This is a wrapper for the VT layer
  *	so that we can keep kbd knowledge internal
  */
-void vt_kbd_con_stop(int console)
+void vt_kbd_con_stop(unsigned int console)
 {
 	struct kbd_struct *kb = kbd_table + console;
 	unsigned long flags;
@@ -1825,7 +1825,7 @@ int vt_do_diacrit(unsigned int cmd, void __user *udp, int perm)
  *	Update the keyboard mode bits while holding the correct locks.
  *	Return 0 for success or an error code.
  */
-int vt_do_kdskbmode(int console, unsigned int arg)
+int vt_do_kdskbmode(unsigned int console, unsigned int arg)
 {
 	struct kbd_struct *kb = kbd_table + console;
 	int ret = 0;
@@ -1865,7 +1865,7 @@ int vt_do_kdskbmode(int console, unsigned int arg)
  *	Update the keyboard meta bits while holding the correct locks.
  *	Return 0 for success or an error code.
  */
-int vt_do_kdskbmeta(int console, unsigned int arg)
+int vt_do_kdskbmeta(unsigned int console, unsigned int arg)
 {
 	struct kbd_struct *kb = kbd_table + console;
 	int ret = 0;
@@ -2008,7 +2008,7 @@ static int vt_kdskbent(unsigned char kbdmode, unsigned char idx,
 }
 
 int vt_do_kdsk_ioctl(int cmd, struct kbentry __user *user_kbe, int perm,
-						int console)
+						unsigned int console)
 {
 	struct kbd_struct *kb = kbd_table + console;
 	struct kbentry kbe;
@@ -2097,7 +2097,7 @@ int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb, int perm)
 	return ret;
 }
 
-int vt_do_kdskled(int console, int cmd, unsigned long arg, int perm)
+int vt_do_kdskled(unsigned int console, int cmd, unsigned long arg, int perm)
 {
 	struct kbd_struct *kb = kbd_table + console;
         unsigned long flags;
@@ -2139,7 +2139,7 @@ int vt_do_kdskled(int console, int cmd, unsigned long arg, int perm)
         return -ENOIOCTLCMD;
 }
 
-int vt_do_kdgkbmode(int console)
+int vt_do_kdgkbmode(unsigned int console)
 {
 	struct kbd_struct *kb = kbd_table + console;
 	/* This is a spot read so needs no locking */
@@ -2163,7 +2163,7 @@ int vt_do_kdgkbmode(int console)
  *
  *	Report the meta flag status of this console
  */
-int vt_do_kdgkbmeta(int console)
+int vt_do_kdgkbmeta(unsigned int console)
 {
 	struct kbd_struct *kb = kbd_table + console;
         /* Again a spot read so no locking */
@@ -2176,7 +2176,7 @@ int vt_do_kdgkbmeta(int console)
  *
  *	Restore the unicode console state to its default
  */
-void vt_reset_unicode(int console)
+void vt_reset_unicode(unsigned int console)
 {
 	unsigned long flags;
 
@@ -2204,7 +2204,7 @@ int vt_get_shift_state(void)
  *	Reset the keyboard bits for a console as part of a general console
  *	reset event
  */
-void vt_reset_keyboard(int console)
+void vt_reset_keyboard(unsigned int console)
 {
 	struct kbd_struct *kb = kbd_table + console;
 	unsigned long flags;
@@ -2234,7 +2234,7 @@ void vt_reset_keyboard(int console)
  *	caller must be sure that there are no synchronization needs
  */
 
-int vt_get_kbd_mode_bit(int console, int bit)
+int vt_get_kbd_mode_bit(unsigned int console, int bit)
 {
 	struct kbd_struct *kb = kbd_table + console;
 	return vc_kbd_mode(kb, bit);
@@ -2249,7 +2249,7 @@ int vt_get_kbd_mode_bit(int console, int bit)
  *	caller must be sure that there are no synchronization needs
  */
 
-void vt_set_kbd_mode_bit(int console, int bit)
+void vt_set_kbd_mode_bit(unsigned int console, int bit)
 {
 	struct kbd_struct *kb = kbd_table + console;
 	unsigned long flags;
@@ -2268,7 +2268,7 @@ void vt_set_kbd_mode_bit(int console, int bit)
  *	caller must be sure that there are no synchronization needs
  */
 
-void vt_clr_kbd_mode_bit(int console, int bit)
+void vt_clr_kbd_mode_bit(unsigned int console, int bit)
 {
 	struct kbd_struct *kb = kbd_table + console;
 	unsigned long flags;
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 0da94a6dee15..b5ab452fca5b 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -148,26 +148,26 @@ void hide_boot_cursor(bool hide);
 
 /* keyboard  provided interfaces */
 int vt_do_diacrit(unsigned int cmd, void __user *up, int eperm);
-int vt_do_kdskbmode(int console, unsigned int arg);
-int vt_do_kdskbmeta(int console, unsigned int arg);
+int vt_do_kdskbmode(unsigned int console, unsigned int arg);
+int vt_do_kdskbmeta(unsigned int console, unsigned int arg);
 int vt_do_kbkeycode_ioctl(int cmd, struct kbkeycode __user *user_kbkc,
 			  int perm);
 int vt_do_kdsk_ioctl(int cmd, struct kbentry __user *user_kbe, int perm,
-		     int console);
+		     unsigned int console);
 int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb, int perm);
-int vt_do_kdskled(int console, int cmd, unsigned long arg, int perm);
-int vt_do_kdgkbmode(int console);
-int vt_do_kdgkbmeta(int console);
-void vt_reset_unicode(int console);
+int vt_do_kdskled(unsigned int console, int cmd, unsigned long arg, int perm);
+int vt_do_kdgkbmode(unsigned int console);
+int vt_do_kdgkbmeta(unsigned int console);
+void vt_reset_unicode(unsigned int console);
 int vt_get_shift_state(void);
-void vt_reset_keyboard(int console);
-int vt_get_leds(int console, int flag);
-int vt_get_kbd_mode_bit(int console, int bit);
-void vt_set_kbd_mode_bit(int console, int bit);
-void vt_clr_kbd_mode_bit(int console, int bit);
-void vt_set_led_state(int console, int leds);
-void vt_kbd_con_start(int console);
-void vt_kbd_con_stop(int console);
+void vt_reset_keyboard(unsigned int console);
+int vt_get_leds(unsigned int console, int flag);
+int vt_get_kbd_mode_bit(unsigned int console, int bit);
+void vt_set_kbd_mode_bit(unsigned int console, int bit);
+void vt_clr_kbd_mode_bit(unsigned int console, int bit);
+void vt_set_led_state(unsigned int console, int leds);
+void vt_kbd_con_start(unsigned int console);
+void vt_kbd_con_stop(unsigned int console);
 
 void vc_scrolldelta_helper(struct vc_data *c, int lines,
 		unsigned int rolled_over, void *_base, unsigned int size);
-- 
2.30.2



