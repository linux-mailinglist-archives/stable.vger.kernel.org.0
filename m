Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4803CA178
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 17:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhGOPcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 11:32:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40948 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbhGOPcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 11:32:25 -0400
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1626362971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=35CXobfY8CFmqTt4Bwc24NZBVuf8jY71PYlcrs1aoUA=;
        b=IPlGbN2quQJzuVV69+X+jmjMFNyPW9sCjB0dJNENhIXKmmHqeJrcDTcLvQrWG9sdmb6Ngl
        Z0ylHL+qNKLQwiqUIEMejKEQRKKjvduqLB+LSgL/J6YnLnZ+pH4RDxxAe5h8l+aRb8T9f6
        NhefWjvXh14KKD9K/sARGN+xlQXtzPbidc/B9YsKHhCsBpYGWozYlsUcNoSpAmDfEYxfON
        b+uGech+YRQpymDx24abNQpaMmjHy06kzV+pWD8deg9wBuKHvbw7R+zJp0xr3gpTPNbjjF
        QqX0c8otmlhFWn/nFfB3oUpMzu7VC1biujL79WojNgm65EZxa2+/cAiO3wUPtg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1626362971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=35CXobfY8CFmqTt4Bwc24NZBVuf8jY71PYlcrs1aoUA=;
        b=oyKYgh4Sh9edL3MjsTq1m9hK2hxbHfTtE2GOeBTQeF2ZYwCXNsHzsChZO7+v/dr7/4RPcw
        12s6IdDoZxJpy1AA==
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Petr Mladek <pmladek@suse.com>, kernel test robot <lkp@intel.com>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH tglx/in-place v1 03/21] printk/console: Check consistent sequence number when handling race in console_unlock()
Date:   Thu, 15 Jul 2021 17:35:12 +0206
Message-Id: <20210715152930.22959-4-john.ogness@linutronix.de>
In-Reply-To: <20210715152930.22959-1-john.ogness@linutronix.de>
References: <20210715152930.22959-1-john.ogness@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

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

The variable next_seq is marked as __maybe_unused to call down compiler
warning when CONFIG_PRINTK is not defined.

Fixes: commit 996e966640ddea7b535c ("printk: remove logbuf_lock")
Reported-by: kernel test robot <lkp@intel.com>  # unused next_seq warning
Cc: stable@vger.kernel.org # 5.13
Signed-off-by: Petr Mladek <pmladek@suse.com>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Link: https://lore.kernel.org/r/20210702150657.26760-1-pmladek@suse.com
---
 kernel/printk/printk.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 142a58d124d9..6dad7da8f383 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2545,6 +2545,7 @@ void console_unlock(void)
 	bool do_cond_resched, retry;
 	struct printk_info info;
 	struct printk_record r;
+	u64 __maybe_unused next_seq;
 
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
2.20.1

