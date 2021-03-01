Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFC7328D77
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbhCATLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:11:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240785AbhCATGf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:06:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C379C651F7;
        Mon,  1 Mar 2021 17:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619205;
        bh=dgK4SJKskwrHlITS8R6DyDUSdy/Sk3XZTC5aDWFvg3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFtKEEB3j9RH7W/Pe9pbfrl6nc0RtJwcObMLugTwNsv2igVwbPAtvSx9YtLutEoa9
         vIK5srhPXscI1epmLbxR2C9dCoNFbSCA2ZymzmQxpOJ6rqwhtOnLWCzDFwxfKABC1S
         WQ5kmQEO/ABnEFl+F2PQHK9Jyxj4PB0wsGWJzZVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        "J. Avila" <elavila@google.com>,
        John Ogness <john.ogness@linutronix.de>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 371/663] printk: avoid prb_first_valid_seq() where possible
Date:   Mon,  1 Mar 2021 17:10:19 +0100
Message-Id: <20210301161200.205329570@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 13791c80b0cdf54d92fc54221cdf490683b109de ]

If message sizes average larger than expected (more than 32
characters), the data_ring will wrap before the desc_ring. Once the
data_ring wraps, it will start invalidating descriptors. These
invalid descriptors hang around until they are eventually recycled
when the desc_ring wraps. Readers do not care about invalid
descriptors, but they still need to iterate past them. If the
average message size is much larger than 32 characters, then there
will be many invalid descriptors preceding the valid descriptors.

The function prb_first_valid_seq() always begins at the oldest
descriptor and searches for the first valid descriptor. This can
be rather expensive for the above scenario. And, in fact, because
of its heavy usage in /dev/kmsg, there have been reports of long
delays and even RCU stalls.

For code that does not need to search from the oldest record,
replace prb_first_valid_seq() usage with prb_read_valid_*()
functions, which provide a start sequence number to search from.

Fixes: 896fbe20b4e2333fb55 ("printk: use the lockless ringbuffer")
Reported-by: kernel test robot <oliver.sang@intel.com>
Reported-by: J. Avila <elavila@google.com>
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20210211173152.1629-1-john.ogness@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index aafec8cb8637d..d0df95346ab3f 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -782,9 +782,9 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 		logbuf_lock_irq();
 	}
 
-	if (user->seq < prb_first_valid_seq(prb)) {
+	if (r->info->seq != user->seq) {
 		/* our last seen message is gone, return error and reset */
-		user->seq = prb_first_valid_seq(prb);
+		user->seq = r->info->seq;
 		ret = -EPIPE;
 		logbuf_unlock_irq();
 		goto out;
@@ -859,6 +859,7 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 static __poll_t devkmsg_poll(struct file *file, poll_table *wait)
 {
 	struct devkmsg_user *user = file->private_data;
+	struct printk_info info;
 	__poll_t ret = 0;
 
 	if (!user)
@@ -867,9 +868,9 @@ static __poll_t devkmsg_poll(struct file *file, poll_table *wait)
 	poll_wait(file, &log_wait, wait);
 
 	logbuf_lock_irq();
-	if (prb_read_valid(prb, user->seq, NULL)) {
+	if (prb_read_valid_info(prb, user->seq, &info, NULL)) {
 		/* return error when data has vanished underneath us */
-		if (user->seq < prb_first_valid_seq(prb))
+		if (info.seq != user->seq)
 			ret = EPOLLIN|EPOLLRDNORM|EPOLLERR|EPOLLPRI;
 		else
 			ret = EPOLLIN|EPOLLRDNORM;
@@ -1606,6 +1607,7 @@ static void syslog_clear(void)
 
 int do_syslog(int type, char __user *buf, int len, int source)
 {
+	struct printk_info info;
 	bool clear = false;
 	static int saved_console_loglevel = LOGLEVEL_DEFAULT;
 	int error;
@@ -1676,9 +1678,14 @@ int do_syslog(int type, char __user *buf, int len, int source)
 	/* Number of chars in the log buffer */
 	case SYSLOG_ACTION_SIZE_UNREAD:
 		logbuf_lock_irq();
-		if (syslog_seq < prb_first_valid_seq(prb)) {
+		if (!prb_read_valid_info(prb, syslog_seq, &info, NULL)) {
+			/* No unread messages. */
+			logbuf_unlock_irq();
+			return 0;
+		}
+		if (info.seq != syslog_seq) {
 			/* messages are gone, move to first one */
-			syslog_seq = prb_first_valid_seq(prb);
+			syslog_seq = info.seq;
 			syslog_partial = 0;
 		}
 		if (source == SYSLOG_FROM_PROC) {
@@ -1690,7 +1697,6 @@ int do_syslog(int type, char __user *buf, int len, int source)
 			error = prb_next_seq(prb) - syslog_seq;
 		} else {
 			bool time = syslog_partial ? syslog_time : printk_time;
-			struct printk_info info;
 			unsigned int line_count;
 			u64 seq;
 
@@ -3378,9 +3384,11 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 		goto out;
 
 	logbuf_lock_irqsave(flags);
-	if (dumper->cur_seq < prb_first_valid_seq(prb)) {
-		/* messages are gone, move to first available one */
-		dumper->cur_seq = prb_first_valid_seq(prb);
+	if (prb_read_valid_info(prb, dumper->cur_seq, &info, NULL)) {
+		if (info.seq != dumper->cur_seq) {
+			/* messages are gone, move to first available one */
+			dumper->cur_seq = info.seq;
+		}
 	}
 
 	/* last entry */
-- 
2.27.0



