Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501D2167097
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgBUHqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:46:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728126AbgBUHq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:46:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6379D207FD;
        Fri, 21 Feb 2020 07:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271188;
        bh=T7uWfjRYwYIvMGHvSLHzXsYWS5MRR42vOXJsYdLx2RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEY+7dzGPSOP3vLkiPhfP001uRy6E7zj5K/vpzxPiQeaAYYPu5R+CKOzYjHzQuLp7
         PyImtUU/LiAOVkeUvUf8XG/4q8G7xlzvgQeebVUt77o7RmCGzqCsa5o8kcRhwpO3bG
         eG3z6ZsXw6clPmA6we/cEsXbs6oqi3u6qdh6r/Do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 035/399] printk: fix exclusive_console replaying
Date:   Fri, 21 Feb 2020 08:36:00 +0100
Message-Id: <20200221072405.779898046@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit def97da136515cb289a14729292c193e0a93bc64 ]

Commit f92b070f2dc8 ("printk: Do not miss new messages when replaying
the log") introduced a new variable @exclusive_console_stop_seq to
store when an exclusive console should stop printing. It should be
set to the @console_seq value at registration. However, @console_seq
is previously set to @syslog_seq so that the exclusive console knows
where to begin. This results in the exclusive console immediately
reactivating all the other consoles and thus repeating the messages
for those consoles.

Set @console_seq after @exclusive_console_stop_seq has stored the
current @console_seq value.

Fixes: f92b070f2dc8 ("printk: Do not miss new messages when replaying the log")
Link: http://lkml.kernel.org/r/20191219115322.31160-1-john.ogness@linutronix.de
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 1ef6f75d92f1f..fada22dc4ab6c 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2770,8 +2770,6 @@ void register_console(struct console *newcon)
 		 * for us.
 		 */
 		logbuf_lock_irqsave(flags);
-		console_seq = syslog_seq;
-		console_idx = syslog_idx;
 		/*
 		 * We're about to replay the log buffer.  Only do this to the
 		 * just-registered console to avoid excessive message spam to
@@ -2783,6 +2781,8 @@ void register_console(struct console *newcon)
 		 */
 		exclusive_console = newcon;
 		exclusive_console_stop_seq = console_seq;
+		console_seq = syslog_seq;
+		console_idx = syslog_idx;
 		logbuf_unlock_irqrestore(flags);
 	}
 	console_unlock();
-- 
2.20.1



