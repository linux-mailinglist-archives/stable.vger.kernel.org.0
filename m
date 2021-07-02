Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB3B3BA284
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 17:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhGBPJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 11:09:38 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:38794 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbhGBPJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Jul 2021 11:09:38 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4B10B22887;
        Fri,  2 Jul 2021 15:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625238425; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=51SpbJbiB6BamLErDhJvHKnX/gRj55FDO2A1qH6QAPo=;
        b=eLybhm4nl7puN3IE9hwaXvG1WvWAFq+Z826wnW9/du/9WmyaZKrS/4ZBXYrDxFoQ2p6I7O
        6VDzG1d9+bHh+PjpeXLzRZPAJia9oSAlDlxPoP2UNq+ua5QJHySnHP+tWXdSHS8OyMFsKW
        E/H/vHedBOpTkjMOdGKLIZMI9ta4yQA=
Received: from alley.suse.cz (unknown [10.100.216.66])
        by relay2.suse.de (Postfix) with ESMTP id B5A5FA3B94;
        Fri,  2 Jul 2021 15:07:04 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     John Ogness <john.ogness@linutronix.de>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: [PATCH v2] printk/console: Check consistent sequence number when handling race in console_unlock()
Date:   Fri,  2 Jul 2021 17:06:57 +0200
Message-Id: <20210702150657.26760-1-pmladek@suse.com>
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

The variable next_seq is marked as __maybe_unused to call down compiler
warning when CONFIG_PRINTK is not defined.

Fixes: commit 996e966640ddea7b535c ("printk: remove logbuf_lock")
Reported-by: kernel test robot <lkp@intel.com>  # unused next_seq warning
Cc: stable@vger.kernel.org # 5.13
Signed-off-by: Petr Mladek <pmladek@suse.com>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
Changes in v2:

  - fixed warning about unused next_seq variable reported by kernel test robot

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
2.26.2

