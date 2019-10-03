Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 136A7CAC0D
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbfJCQEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:04:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731470AbfJCQEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:04:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D02FD21D81;
        Thu,  3 Oct 2019 16:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118686;
        bh=glujSVm4D3IbVgjgNJ3C3K+loQmkHW7DbSS/kWksBPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qf0oObjSTZ+14urFO8q+oY+Gznqg1cU5e/IQH1mIP0AOnz4WASeUjsZD+YmBmLuYu
         U211xh8r/+z7ES5k7SFRfYScQcCAMvxIp0iANsFPAUX7AqZKkBkfxZ3pxYfL0iV6rS
         HY5waA9ozJQSdvQrEqzcjhsrA4tzUHBCnqno6i54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 101/129] printk: remove games with previous record flags
Date:   Thu,  3 Oct 2019 17:53:44 +0200
Message-Id: <20191003154405.507944331@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 5aa068ea4082b39eafc356c27c9ecd155b0895f6 ]

The record logging code looks at the previous record flags in various
ways, and they are all wrong.

You can't use the previous record flags to determine anything about the
next record, because they may simply not be related.  In particular, the
reason the previous record was a continuation record may well be exactly
_because_ the new record was printed by a different process, which is
why the previous record was flushed.

So all those games are simply wrong, and make the code hard to
understand (because the code fundamentally cdoes not make sense).

So remove it.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 109 +++++++++--------------------------------
 1 file changed, 24 insertions(+), 85 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 27adaaab96ba5..df348d4eeb265 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -356,7 +356,6 @@ DECLARE_WAIT_QUEUE_HEAD(log_wait);
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
 static u64 syslog_seq;
 static u32 syslog_idx;
-static enum log_flags syslog_prev;
 static size_t syslog_partial;
 
 /* index and sequence number of the first record stored in the buffer */
@@ -370,7 +369,6 @@ static u32 log_next_idx;
 /* the next printk record to write to the console */
 static u64 console_seq;
 static u32 console_idx;
-static enum log_flags console_prev;
 
 /* the next printk record to read after the last 'clear' command */
 static u64 clear_seq;
@@ -639,27 +637,15 @@ static void append_char(char **pp, char *e, char c)
 }
 
 static ssize_t msg_print_ext_header(char *buf, size_t size,
-				    struct printk_log *msg, u64 seq,
-				    enum log_flags prev_flags)
+				    struct printk_log *msg, u64 seq)
 {
 	u64 ts_usec = msg->ts_nsec;
-	char cont = '-';
 
 	do_div(ts_usec, 1000);
 
-	/*
-	 * If we couldn't merge continuation line fragments during the print,
-	 * export the stored flags to allow an optional external merge of the
-	 * records. Merging the records isn't always neccessarily correct, like
-	 * when we hit a race during printing. In most cases though, it produces
-	 * better readable output. 'c' in the record flags mark the first
-	 * fragment of a line, '+' the following.
-	 */
-	if (msg->flags & LOG_CONT)
-		cont = (prev_flags & LOG_CONT) ? '+' : 'c';
-
 	return scnprintf(buf, size, "%u,%llu,%llu,%c;",
-		       (msg->facility << 3) | msg->level, seq, ts_usec, cont);
+		       (msg->facility << 3) | msg->level, seq, ts_usec,
+		       msg->flags & LOG_CONT ? 'c' : '-');
 }
 
 static ssize_t msg_print_ext_body(char *buf, size_t size,
@@ -714,7 +700,6 @@ static ssize_t msg_print_ext_body(char *buf, size_t size,
 struct devkmsg_user {
 	u64 seq;
 	u32 idx;
-	enum log_flags prev;
 	struct ratelimit_state rs;
 	struct mutex lock;
 	char buf[CONSOLE_EXT_LOG_MAX];
@@ -824,12 +809,11 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 
 	msg = log_from_idx(user->idx);
 	len = msg_print_ext_header(user->buf, sizeof(user->buf),
-				   msg, user->seq, user->prev);
+				   msg, user->seq);
 	len += msg_print_ext_body(user->buf + len, sizeof(user->buf) - len,
 				  log_dict(msg), msg->dict_len,
 				  log_text(msg), msg->text_len);
 
-	user->prev = msg->flags;
 	user->idx = log_next(user->idx);
 	user->seq++;
 	raw_spin_unlock_irq(&logbuf_lock);
@@ -1215,26 +1199,12 @@ static size_t print_prefix(const struct printk_log *msg, bool syslog, char *buf)
 	return len;
 }
 
-static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
-			     bool syslog, char *buf, size_t size)
+static size_t msg_print_text(const struct printk_log *msg, bool syslog, char *buf, size_t size)
 {
 	const char *text = log_text(msg);
 	size_t text_size = msg->text_len;
-	bool prefix = true;
-	bool newline = true;
 	size_t len = 0;
 
-	if ((prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
-		prefix = false;
-
-	if (msg->flags & LOG_CONT) {
-		if ((prev & LOG_CONT) && !(prev & LOG_NEWLINE))
-			prefix = false;
-
-		if (!(msg->flags & LOG_NEWLINE))
-			newline = false;
-	}
-
 	do {
 		const char *next = memchr(text, '\n', text_size);
 		size_t text_len;
@@ -1252,22 +1222,17 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 			    text_len + 1 >= size - len)
 				break;
 
-			if (prefix)
-				len += print_prefix(msg, syslog, buf + len);
+			len += print_prefix(msg, syslog, buf + len);
 			memcpy(buf + len, text, text_len);
 			len += text_len;
-			if (next || newline)
-				buf[len++] = '\n';
+			buf[len++] = '\n';
 		} else {
 			/* SYSLOG_ACTION_* buffer size only calculation */
-			if (prefix)
-				len += print_prefix(msg, syslog, NULL);
+			len += print_prefix(msg, syslog, NULL);
 			len += text_len;
-			if (next || newline)
-				len++;
+			len++;
 		}
 
-		prefix = true;
 		text = next;
 	} while (text);
 
@@ -1293,7 +1258,6 @@ static int syslog_print(char __user *buf, int size)
 			/* messages are gone, move to first one */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
-			syslog_prev = 0;
 			syslog_partial = 0;
 		}
 		if (syslog_seq == log_next_seq) {
@@ -1303,13 +1267,11 @@ static int syslog_print(char __user *buf, int size)
 
 		skip = syslog_partial;
 		msg = log_from_idx(syslog_idx);
-		n = msg_print_text(msg, syslog_prev, true, text,
-				   LOG_LINE_MAX + PREFIX_MAX);
+		n = msg_print_text(msg, true, text, LOG_LINE_MAX + PREFIX_MAX);
 		if (n - syslog_partial <= size) {
 			/* message fits into buffer, move forward */
 			syslog_idx = log_next(syslog_idx);
 			syslog_seq++;
-			syslog_prev = msg->flags;
 			n -= syslog_partial;
 			syslog_partial = 0;
 		} else if (!len){
@@ -1352,7 +1314,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		u64 next_seq;
 		u64 seq;
 		u32 idx;
-		enum log_flags prev;
 
 		/*
 		 * Find first record that fits, including all following records,
@@ -1360,12 +1321,10 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		 */
 		seq = clear_seq;
 		idx = clear_idx;
-		prev = 0;
 		while (seq < log_next_seq) {
 			struct printk_log *msg = log_from_idx(idx);
 
-			len += msg_print_text(msg, prev, true, NULL, 0);
-			prev = msg->flags;
+			len += msg_print_text(msg, true, NULL, 0);
 			idx = log_next(idx);
 			seq++;
 		}
@@ -1373,12 +1332,10 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		/* move first record forward until length fits into the buffer */
 		seq = clear_seq;
 		idx = clear_idx;
-		prev = 0;
 		while (len > size && seq < log_next_seq) {
 			struct printk_log *msg = log_from_idx(idx);
 
-			len -= msg_print_text(msg, prev, true, NULL, 0);
-			prev = msg->flags;
+			len -= msg_print_text(msg, true, NULL, 0);
 			idx = log_next(idx);
 			seq++;
 		}
@@ -1391,7 +1348,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 			struct printk_log *msg = log_from_idx(idx);
 			int textlen;
 
-			textlen = msg_print_text(msg, prev, true, text,
+			textlen = msg_print_text(msg, true, text,
 						 LOG_LINE_MAX + PREFIX_MAX);
 			if (textlen < 0) {
 				len = textlen;
@@ -1399,7 +1356,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 			}
 			idx = log_next(idx);
 			seq++;
-			prev = msg->flags;
 
 			raw_spin_unlock_irq(&logbuf_lock);
 			if (copy_to_user(buf + len, text, textlen))
@@ -1412,7 +1368,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 				/* messages are gone, move to next one */
 				seq = log_first_seq;
 				idx = log_first_idx;
-				prev = 0;
 			}
 		}
 	}
@@ -1513,7 +1468,6 @@ int do_syslog(int type, char __user *buf, int len, int source)
 			/* messages are gone, move to first one */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
-			syslog_prev = 0;
 			syslog_partial = 0;
 		}
 		if (source == SYSLOG_FROM_PROC) {
@@ -1526,16 +1480,14 @@ int do_syslog(int type, char __user *buf, int len, int source)
 		} else {
 			u64 seq = syslog_seq;
 			u32 idx = syslog_idx;
-			enum log_flags prev = syslog_prev;
 
 			error = 0;
 			while (seq < log_next_seq) {
 				struct printk_log *msg = log_from_idx(idx);
 
-				error += msg_print_text(msg, prev, true, NULL, 0);
+				error += msg_print_text(msg, true, NULL, 0);
 				idx = log_next(idx);
 				seq++;
-				prev = msg->flags;
 			}
 			error -= syslog_partial;
 		}
@@ -1717,7 +1669,7 @@ static size_t cont_print_text(char *text, size_t size)
 	size_t textlen = 0;
 	size_t len;
 
-	if (cont.cons == 0 && (console_prev & LOG_NEWLINE)) {
+	if (cont.cons == 0) {
 		textlen += print_time(cont.ts_nsec, text);
 		size -= textlen;
 	}
@@ -1985,11 +1937,9 @@ static u64 syslog_seq;
 static u32 syslog_idx;
 static u64 console_seq;
 static u32 console_idx;
-static enum log_flags syslog_prev;
 static u64 log_first_seq;
 static u32 log_first_idx;
 static u64 log_next_seq;
-static enum log_flags console_prev;
 static struct cont {
 	size_t len;
 	size_t cons;
@@ -2001,15 +1951,15 @@ static char *log_dict(const struct printk_log *msg) { return NULL; }
 static struct printk_log *log_from_idx(u32 idx) { return NULL; }
 static u32 log_next(u32 idx) { return 0; }
 static ssize_t msg_print_ext_header(char *buf, size_t size,
-				    struct printk_log *msg, u64 seq,
-				    enum log_flags prev_flags) { return 0; }
+				    struct printk_log *msg,
+				    u64 seq) { return 0; }
 static ssize_t msg_print_ext_body(char *buf, size_t size,
 				  char *dict, size_t dict_len,
 				  char *text, size_t text_len) { return 0; }
 static void call_console_drivers(int level,
 				 const char *ext_text, size_t ext_len,
 				 const char *text, size_t len) {}
-static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
+static size_t msg_print_text(const struct printk_log *msg,
 			     bool syslog, char *buf, size_t size) { return 0; }
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 static bool suppress_message_printing(int level) { return false; }
@@ -2397,7 +2347,6 @@ void console_unlock(void)
 			/* messages are gone, move to first one */
 			console_seq = log_first_seq;
 			console_idx = log_first_idx;
-			console_prev = 0;
 		} else {
 			len = 0;
 		}
@@ -2422,16 +2371,14 @@ void console_unlock(void)
 			 * will properly dump everything later.
 			 */
 			msg->flags &= ~LOG_NOCONS;
-			console_prev = msg->flags;
 			goto skip;
 		}
 
-		len += msg_print_text(msg, console_prev, false,
-				      text + len, sizeof(text) - len);
+		len += msg_print_text(msg, false, text + len, sizeof(text) - len);
 		if (nr_ext_console_drivers) {
 			ext_len = msg_print_ext_header(ext_text,
 						sizeof(ext_text),
-						msg, console_seq, console_prev);
+						msg, console_seq);
 			ext_len += msg_print_ext_body(ext_text + ext_len,
 						sizeof(ext_text) - ext_len,
 						log_dict(msg), msg->dict_len,
@@ -2439,7 +2386,6 @@ void console_unlock(void)
 		}
 		console_idx = log_next(console_idx);
 		console_seq++;
-		console_prev = msg->flags;
 		raw_spin_unlock(&logbuf_lock);
 
 		stop_critical_timings();	/* don't trace print latency */
@@ -2734,7 +2680,6 @@ void register_console(struct console *newcon)
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		console_seq = syslog_seq;
 		console_idx = syslog_idx;
-		console_prev = syslog_prev;
 		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 		/*
 		 * We're about to replay the log buffer.  Only do this to the
@@ -3084,7 +3029,7 @@ bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
 		goto out;
 
 	msg = log_from_idx(dumper->cur_idx);
-	l = msg_print_text(msg, 0, syslog, line, size);
+	l = msg_print_text(msg, syslog, line, size);
 
 	dumper->cur_idx = log_next(dumper->cur_idx);
 	dumper->cur_seq++;
@@ -3153,7 +3098,6 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	u32 idx;
 	u64 next_seq;
 	u32 next_idx;
-	enum log_flags prev;
 	size_t l = 0;
 	bool ret = false;
 
@@ -3176,27 +3120,23 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	/* calculate length of entire buffer */
 	seq = dumper->cur_seq;
 	idx = dumper->cur_idx;
-	prev = 0;
 	while (seq < dumper->next_seq) {
 		struct printk_log *msg = log_from_idx(idx);
 
-		l += msg_print_text(msg, prev, true, NULL, 0);
+		l += msg_print_text(msg, true, NULL, 0);
 		idx = log_next(idx);
 		seq++;
-		prev = msg->flags;
 	}
 
 	/* move first record forward until length fits into the buffer */
 	seq = dumper->cur_seq;
 	idx = dumper->cur_idx;
-	prev = 0;
 	while (l > size && seq < dumper->next_seq) {
 		struct printk_log *msg = log_from_idx(idx);
 
-		l -= msg_print_text(msg, prev, true, NULL, 0);
+		l -= msg_print_text(msg, true, NULL, 0);
 		idx = log_next(idx);
 		seq++;
-		prev = msg->flags;
 	}
 
 	/* last message in next interation */
@@ -3207,10 +3147,9 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	while (seq < dumper->next_seq) {
 		struct printk_log *msg = log_from_idx(idx);
 
-		l += msg_print_text(msg, prev, syslog, buf + l, size - l);
+		l += msg_print_text(msg, syslog, buf + l, size - l);
 		idx = log_next(idx);
 		seq++;
-		prev = msg->flags;
 	}
 
 	dumper->next_seq = next_seq;
-- 
2.20.1



