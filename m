Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3D3157C41
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgBJNgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:36:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727790AbgBJMfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:14 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51BFE21739;
        Mon, 10 Feb 2020 12:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338114;
        bh=gAS0gDgR2zNNC2Unq2owu7uFgsqm7TRSY3xbV5/aEcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PArG8zCGon3XmgTofzrJziA1Tt/WkTbT0Hy5T77TacMel5XkxQNx7Q7zZkAhcCDNX
         wP2ko26jLk2KaNlVrqzd051NgaqG9AZArOwGCkpxFa5RvgBxdSFe3lL91thiMbmZNV
         OPTqNPA2HrbXLdTlMXLHx6gIW1RBNIoVAd9zUmPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 008/195] printk: fix exclusive_console replaying
Date:   Mon, 10 Feb 2020 04:31:06 -0800
Message-Id: <20200210122306.568937255@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
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
index 845efadaf7ecf..7a2fdc097c8cb 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2717,8 +2717,6 @@ void register_console(struct console *newcon)
 		 * for us.
 		 */
 		logbuf_lock_irqsave(flags);
-		console_seq = syslog_seq;
-		console_idx = syslog_idx;
 		/*
 		 * We're about to replay the log buffer.  Only do this to the
 		 * just-registered console to avoid excessive message spam to
@@ -2730,6 +2728,8 @@ void register_console(struct console *newcon)
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



