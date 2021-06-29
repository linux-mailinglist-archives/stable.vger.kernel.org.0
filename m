Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF4A3B7463
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 16:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbhF2OgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 10:36:22 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57310 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234285AbhF2OgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 10:36:21 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 81DA9226CB;
        Tue, 29 Jun 2021 14:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624977233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=l27yWpUOt7K6JE8GkAbI88JtQoiyZZfThwFoqr+iDA4=;
        b=U4QMH2o29Jz5J6WBl+WVh97CQszudPV29Q6xctPTJ7Ttob9J3hjuprMtUCwAf7h6nDuz/g
        jhdMxb4IJVR/NFmJmMnDCDHOakR/5FQ0Hmkg1B+tZ01pPj9sgGwVxDoq+W8f3rUCSYVBZG
        UqwI21drNzvRTP/YvoHtE+zzQK2CBIM=
Received: from alley.suse.cz (unknown [10.100.216.66])
        by relay2.suse.de (Postfix) with ESMTP id 2A645A3B85;
        Tue, 29 Jun 2021 14:33:53 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     John Ogness <john.ogness@linutronix.de>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        stable@vger.kernel.org
Subject: [PATCH] printk/console: Check consistent sequence number when handling race in console_unlock()
Date:   Tue, 29 Jun 2021 16:33:41 +0200
Message-Id: <20210629143341.19284-1-pmladek@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The standard printk() tries to flush the message to the console
immediately. It tries to take the console lock. If the lock is
already taken then the current owner is responsible for flushing
even the new message.

There is a small race window between checking whether a new message is
available and releasing the console lock. It is solved by re-checking
the state after releasing the console lock. If the check is positive
then console_unlock() tries to take the lock again and process the new
message as well.

The commit 996e966640ddea7b535c ("printk: remove logbuf_lock") causes that
console_seq is not longer read atomically. As a result, the re-check might
be done with an inconsistent 64-bit index.

Solve it by using the last sequence number that has been checked under
the console lock. In the worst case, it will take the lock again only
to realized that the new message has already been proceed. But it
was possible even before.

Fixes: commit 996e966640ddea7b535c ("printk: remove logbuf_lock")
Cc: stable@vger.kernel.org # 5.13
Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/printk/printk.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 142a58d124d9..87411084075e 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2545,6 +2545,7 @@ void console_unlock(void)
 	bool do_cond_resched, retry;
 	struct printk_info info;
 	struct printk_record r;
+	u64 next_seq;
 
 	if (console_suspended) {
 		up_console_sem();
@@ -2654,8 +2655,10 @@ void console_unlock(void)
 			cond_resched();
 	}
 
-	console_locked = 0;
+	/* Get consistent value of the next-to-be-used sequence number. */
+	next_seq = console_seq;
 
+	console_locked = 0;
 	up_console_sem();
 
 	/*
@@ -2664,7 +2667,7 @@ void console_unlock(void)
 	 * there's a new owner and the console_unlock() from them will do the
 	 * flush, no worries.
 	 */
-	retry = prb_read_valid(prb, console_seq, NULL);
+	retry = prb_read_valid(prb, next_seq, NULL);
 	printk_safe_exit_irqrestore(flags);
 
 	if (retry && console_trylock())
-- 
2.26.2

