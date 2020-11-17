Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C732B640D
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732945AbgKQNky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:40:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732912AbgKQNkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:40:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23BB22465E;
        Tue, 17 Nov 2020 13:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620451;
        bh=DIjBjeDq1ZYRW5cBKZFmzvPfZeig4cQX54M4VKEqhAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrDl6DonN7S1DNPgJHu/mZAqoWXT6KsoxVXvHUK4+6I7TwOWxXrCsXxiwXF6Xbp0l
         ZFHS/u9UAfTFIf4Mp4M7JBS4JI3+R8zi6CaDnE+BlyIdQQ5yIMjlsgAciHImDPnVFC
         6sPVTcr270WpIW5srwO1eYUOBS5hNXp2XY0Fwd20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jookia <contact@jookia.org>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 5.9 194/255] speakup: Fix clearing selection in safe context
Date:   Tue, 17 Nov 2020 14:05:34 +0100
Message-Id: <20201117122148.372918687@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit 640969a69ca4dd2ac025fe873c6bf25eba8f11b3 upstream.

speakup_cut() calls speakup_clear_selection() which calls console_lock.
Problem is: speakup_cut() is called from a keyboard interrupt
context. This would hang if speakup_cut is pressed while the console
lock is unfortunately already held.

We can however as well just defer calling clear_selection() until the
already-deferred set_selection_kernel() call.

This was spotted by the lock hardener:

 Possible unsafe locking scenario:\x0a
       CPU0
       ----
  lock(console_lock);
  <Interrupt>
    lock(console_lock);
\x0a *** DEADLOCK ***\x0a
[...]
Call Trace:
 <IRQ>
 dump_stack+0xc2/0x11a
 print_usage_bug.cold+0x3e0/0x4b1
 mark_lock+0xd95/0x1390
 ? print_irq_inversion_bug+0xa0/0xa0
 __lock_acquire+0x21eb/0x5730
 ? __kasan_check_read+0x11/0x20
 ? check_chain_key+0x215/0x5e0
 ? register_lock_class+0x1580/0x1580
 ? lock_downgrade+0x7a0/0x7a0
 ? __rwlock_init+0x140/0x140
 lock_acquire+0x13f/0x370
 ? speakup_clear_selection+0xe/0x20 [speakup]
 console_lock+0x33/0x50
 ? speakup_clear_selection+0xe/0x20 [speakup]
 speakup_clear_selection+0xe/0x20 [speakup]
 speakup_cut+0x19e/0x4b0 [speakup]
 keyboard_notifier_call+0x1f04/0x4a40 [speakup]
 ? read_all_doc+0x240/0x240 [speakup]
 notifier_call_chain+0xbf/0x130
 __atomic_notifier_call_chain+0x80/0x130
 atomic_notifier_call_chain+0x16/0x20
 kbd_event+0x7d7/0x3b20
 ? k_pad+0x850/0x850
 ? sysrq_filter+0x450/0xd40
 input_to_handler+0x362/0x4b0
 ? rcu_read_lock_sched_held+0xe0/0xe0
 input_pass_values+0x408/0x5a0
 ? __rwlock_init+0x140/0x140
 ? lock_acquire+0x13f/0x370
 input_handle_event+0x70e/0x1380
 input_event+0x67/0x90
 atkbd_interrupt+0xe62/0x1d4e [atkbd]
 ? __kasan_check_write+0x14/0x20
 ? atkbd_event_work+0x130/0x130 [atkbd]
 ? _raw_spin_lock_irqsave+0x26/0x70
 serio_interrupt+0x93/0x120 [serio]
 i8042_interrupt+0x232/0x510 [i8042]
 ? rcu_read_lock_bh_held+0xd0/0xd0
 ? handle_irq_event+0xa5/0x13a
 ? i8042_remove+0x1f0/0x1f0 [i8042]
 __handle_irq_event_percpu+0xe6/0x6c0
 handle_irq_event_percpu+0x71/0x150
 ? __handle_irq_event_percpu+0x6c0/0x6c0
 ? __kasan_check_read+0x11/0x20
 ? do_raw_spin_unlock+0x5c/0x240
 handle_irq_event+0xad/0x13a
 handle_edge_irq+0x233/0xa90
 do_IRQ+0x10b/0x310
 common_interrupt+0xf/0xf
 </IRQ>

Cc: stable@vger.kernel.org
Reported-by: Jookia <contact@jookia.org>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Link: https://lore.kernel.org/r/20201107233310.7iisvaozpiqj3yvy@function
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/accessibility/speakup/main.c      |    1 -
 drivers/accessibility/speakup/selection.c |   11 ++++-------
 drivers/accessibility/speakup/speakup.h   |    1 -
 3 files changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/accessibility/speakup/main.c
+++ b/drivers/accessibility/speakup/main.c
@@ -357,7 +357,6 @@ static void speakup_cut(struct vc_data *
 	mark_cut_flag = 0;
 	synth_printf("%s\n", spk_msg_get(MSG_CUT));
 
-	speakup_clear_selection();
 	ret = speakup_set_selection(tty);
 
 	switch (ret) {
--- a/drivers/accessibility/speakup/selection.c
+++ b/drivers/accessibility/speakup/selection.c
@@ -22,13 +22,6 @@ struct speakup_selection_work {
 	struct tty_struct *tty;
 };
 
-void speakup_clear_selection(void)
-{
-	console_lock();
-	clear_selection();
-	console_unlock();
-}
-
 static void __speakup_set_selection(struct work_struct *work)
 {
 	struct speakup_selection_work *ssw =
@@ -51,6 +44,10 @@ static void __speakup_set_selection(stru
 		goto unref;
 	}
 
+	console_lock();
+	clear_selection();
+	console_unlock();
+
 	set_selection_kernel(&sel, tty);
 
 unref:
--- a/drivers/accessibility/speakup/speakup.h
+++ b/drivers/accessibility/speakup/speakup.h
@@ -70,7 +70,6 @@ void spk_do_flush(void);
 void speakup_start_ttys(void);
 void synth_buffer_add(u16 ch);
 void synth_buffer_clear(void);
-void speakup_clear_selection(void);
 int speakup_set_selection(struct tty_struct *tty);
 void speakup_cancel_selection(void);
 int speakup_paste_selection(struct tty_struct *tty);


