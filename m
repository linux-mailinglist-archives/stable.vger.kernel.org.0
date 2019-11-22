Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9A3106EE8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfKVLMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:12:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728618AbfKVK6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:58:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63FA420718;
        Fri, 22 Nov 2019 10:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420291;
        bh=fAL4fjcaPMxzF3yBKiRd6D+DTiReBP5DKKTY84t6nDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSj1kSSunqG4xFnh4xVwedFQVQuAfcy1v/DO/FmWmu/qC6fMShUnHsCq02/DuQPIr
         eZqgkm5HkR088byPm46jEf2b5I4G1wg76Ht/9fwwmjgMp7Sn7ebOEfqvKyUBxZkmSq
         oHZHGSUXwG5gGhQt3H+56bJkPUU3UUdEMBmepMfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 056/220] printk: CON_PRINTBUFFER console registration is a bit racy
Date:   Fri, 22 Nov 2019 11:27:01 +0100
Message-Id: <20191122100916.176222949@linuxfoundation.org>
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

From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>

[ Upstream commit 884e370ea88c109a3b982f4eb9ecd82510a3a1fe ]

CON_PRINTBUFFER console registration requires us to do several
preparation steps:
- Rollback console_seq to replay logbuf messages which were already
  seen on other consoles;
- Set exclusive_console flag so console_unlock() will ->write() logbuf
  messages only to the exclusive_console driver.

The way we do it, however, is a bit racy

	logbuf_lock_irqsave(flags);
	console_seq = syslog_seq;
	console_idx = syslog_idx;
	logbuf_unlock_irqrestore(flags);
						<< preemption enabled
						<< irqs enabled
	exclusive_console = newcon;
	console_unlock();

We rollback console_seq under logbuf_lock with IRQs disabled, but
we set exclusive_console with local IRQs enabled and logbuf unlocked.
If the system oops-es or panic-s before we set exclusive_console - and
given that we have IRQs and preemption enabled there is such a
possibility - we will re-play all logbuf messages to every registered
console, which may be a bit annoying and time consuming.

Move exclusive_console assignment to the same IRQs-disabled and
logbuf_lock-protected section where we rollback console_seq.

Link: http://lkml.kernel.org/r/20180928095304.9972-1-sergey.senozhatsky@gmail.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index b627954061bb6..11d70fd15e706 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2708,14 +2708,18 @@ void register_console(struct console *newcon)
 		logbuf_lock_irqsave(flags);
 		console_seq = syslog_seq;
 		console_idx = syslog_idx;
-		logbuf_unlock_irqrestore(flags);
 		/*
 		 * We're about to replay the log buffer.  Only do this to the
 		 * just-registered console to avoid excessive message spam to
 		 * the already-registered consoles.
+		 *
+		 * Set exclusive_console with disabled interrupts to reduce
+		 * race window with eventual console_flush_on_panic() that
+		 * ignores console_lock.
 		 */
 		exclusive_console = newcon;
 		exclusive_console_stop_seq = console_seq;
+		logbuf_unlock_irqrestore(flags);
 	}
 	console_unlock();
 	console_sysfs_notify();
-- 
2.20.1



