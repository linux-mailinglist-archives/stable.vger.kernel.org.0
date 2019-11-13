Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB328FA5FA
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbfKMBvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:51:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727795AbfKMBvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:51:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEA3F22468;
        Wed, 13 Nov 2019 01:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609882;
        bh=fAL4fjcaPMxzF3yBKiRd6D+DTiReBP5DKKTY84t6nDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJiG75x0x1dhs07O8e8gQmuQdF6VzldPy3jgLvlDdEjxZD53nshB4HkSHdz0/y2Zf
         mQCJT0uKm8P7Ayk0jdONR6JOXkb+5Yp37ijgErkaMkklk1EGlt6x5JTWLWiV4nZ40H
         EJKP3wOQtmZ01op3pV3drqshzXF8QbMRsVJtc9Gg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 044/209] printk: CON_PRINTBUFFER console registration is a bit racy
Date:   Tue, 12 Nov 2019 20:47:40 -0500
Message-Id: <20191113015025.9685-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

