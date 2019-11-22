Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A27FB106ECF
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbfKVK6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:58:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730079AbfKVK6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:58:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AC972075B;
        Fri, 22 Nov 2019 10:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420285;
        bh=Er1C0v6WOPG9MdMVv1ytWpIZtgZTMmVtrfz1ICT1oRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhBvFC3EqXdQVHKUdbuNZz4S6vYQupVumcwBIFMPV8lY22jp4e4N/bOrLSyy/t1me
         fUiRMaXw8S9ElPcfF/V9xN7dc3W/2eUfv1+Nz5ZvNTEobNktRj3GyyiXydjLe2TW0O
         Rarsb8Clo0tsQF2OxRQeC2Of0D1Omaf9j4mqSG/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 055/220] printk: Do not miss new messages when replaying the log
Date:   Fri, 22 Nov 2019 11:27:00 +0100
Message-Id: <20191122100916.121259277@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit f92b070f2dc89a8ff1a0cc8b608e20abef894c7d ]

The variable "exclusive_console" is used to reply all existing messages
on a newly registered console. It is cleared when all messages are out.

The problem is that new messages might appear in the meantime. These
are then visible only on the exclusive console.

The obvious solution is to clear "exclusive_console" after we replay
all messages that were already proceed before we started the reply.

Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Link: http://lkml.kernel.org/r/20180913123406.14378-1-pmladek@suse.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: linux-kernel@vger.kernel.org
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index d0d03223b45b1..b627954061bb6 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -423,6 +423,7 @@ static u32 log_next_idx;
 /* the next printk record to write to the console */
 static u64 console_seq;
 static u32 console_idx;
+static u64 exclusive_console_stop_seq;
 
 /* the next printk record to read after the last 'clear' command */
 static u64 clear_seq;
@@ -2014,6 +2015,7 @@ static u64 syslog_seq;
 static u32 syslog_idx;
 static u64 console_seq;
 static u32 console_idx;
+static u64 exclusive_console_stop_seq;
 static u64 log_first_seq;
 static u32 log_first_idx;
 static u64 log_next_seq;
@@ -2381,6 +2383,12 @@ void console_unlock(void)
 			goto skip;
 		}
 
+		/* Output to all consoles once old messages replayed. */
+		if (unlikely(exclusive_console &&
+			     console_seq >= exclusive_console_stop_seq)) {
+			exclusive_console = NULL;
+		}
+
 		len += msg_print_text(msg,
 				console_msg_format & MSG_FORMAT_SYSLOG,
 				text + len,
@@ -2423,10 +2431,6 @@ void console_unlock(void)
 
 	console_locked = 0;
 
-	/* Release the exclusive_console once it is used */
-	if (unlikely(exclusive_console))
-		exclusive_console = NULL;
-
 	raw_spin_unlock(&logbuf_lock);
 
 	up_console_sem();
@@ -2711,6 +2715,7 @@ void register_console(struct console *newcon)
 		 * the already-registered consoles.
 		 */
 		exclusive_console = newcon;
+		exclusive_console_stop_seq = console_seq;
 	}
 	console_unlock();
 	console_sysfs_notify();
-- 
2.20.1



