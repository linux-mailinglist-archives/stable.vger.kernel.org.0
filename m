Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF3940E4F0
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349592AbhIPRGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349180AbhIPRDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:03:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83A9461B06;
        Thu, 16 Sep 2021 16:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810074;
        bh=6G4IsplKoyeetAmOlTy7tdSl++/n/23XqHH2qpFwkFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhfT5/vg9j9Wk2vjhnJsiF+r2V+e+wsYbMAnXeCQOrsrvR+utr6JV65VyNDiIQhmP
         mOjUmJztAVezyLz48CgmwixhQVhupjBJ6OgZUgj7FAovpB11c1q/6sJO338gMGtypF
         2fem7LDfnPW5qk5hFOzfKln6qYupyHVP7Ziu2H0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        John Ogness <john.ogness@linutronix.de>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.13 348/380] printk/console: Check consistent sequence number when handling race in console_unlock()
Date:   Thu, 16 Sep 2021 18:01:45 +0200
Message-Id: <20210916155815.886427268@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

commit 11e4b63abbe23872b45f325a7c6c8b7f9ff42cad upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/printk/printk.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2545,6 +2545,7 @@ void console_unlock(void)
 	bool do_cond_resched, retry;
 	struct printk_info info;
 	struct printk_record r;
+	u64 __maybe_unused next_seq;
 
 	if (console_suspended) {
 		up_console_sem();
@@ -2654,8 +2655,10 @@ skip:
 			cond_resched();
 	}
 
-	console_locked = 0;
+	/* Get consistent value of the next-to-be-used sequence number. */
+	next_seq = console_seq;
 
+	console_locked = 0;
 	up_console_sem();
 
 	/*
@@ -2664,7 +2667,7 @@ skip:
 	 * there's a new owner and the console_unlock() from them will do the
 	 * flush, no worries.
 	 */
-	retry = prb_read_valid(prb, console_seq, NULL);
+	retry = prb_read_valid(prb, next_seq, NULL);
 	printk_safe_exit_irqrestore(flags);
 
 	if (retry && console_trylock())


