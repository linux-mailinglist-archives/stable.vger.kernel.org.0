Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5B9240EC2
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgHJTPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730151AbgHJTPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:15:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B14C622CBE;
        Mon, 10 Aug 2020 19:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086903;
        bh=Y8fek5Prvh23bZv4yQX0W0Su6L95AytBC8qnzyWtnb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PlN+50YvgwokdhKvigMSDHVImek1e2kJ3IVBuqK7CMsNbAfltfjxDU8E1OTlylKdW
         tD+Nt+lWeyfxh3C2VZ3xWa4FnlsM90dlasiZFfO3amXQK+CLQ92nfvQmAgbVWDACAb
         zAaDM844CBV/qjr5CYBSBb9f3ufpV2+E4UDH/lHA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jim Cromie <jim.cromie@gmail.com>, jbaron@akamai.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 13/16] dyndbg: fix a BUG_ON in ddebug_describe_flags
Date:   Mon, 10 Aug 2020 15:14:40 -0400
Message-Id: <20200810191443.3795581-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191443.3795581-1-sashal@kernel.org>
References: <20200810191443.3795581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

[ Upstream commit f678ce8cc3cb2ad29df75d8824c74f36398ba871 ]

ddebug_describe_flags() currently fills a caller provided string buffer,
after testing its size (also passed) in a BUG_ON.  Fix this by
replacing them with a known-big-enough string buffer wrapped in a
struct, and passing that instead.

Also simplify ddebug_describe_flags() flags parameter from a struct to
a member in that struct, and hoist the member deref up to the caller.
This makes the function reusable (soon) where flags are unpacked.

Acked-by: <jbaron@akamai.com>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Link: https://lore.kernel.org/r/20200719231058.1586423-8-jim.cromie@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/dynamic_debug.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index c6368ae93fe6e..f50d63f67899a 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -85,22 +85,22 @@ static struct { unsigned flag:8; char opt_char; } opt_array[] = {
 	{ _DPRINTK_FLAGS_NONE, '_' },
 };
 
+struct flagsbuf { char buf[ARRAY_SIZE(opt_array)+1]; };
+
 /* format a string into buf[] which describes the _ddebug's flags */
-static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
-				    size_t maxlen)
+static char *ddebug_describe_flags(unsigned int flags, struct flagsbuf *fb)
 {
-	char *p = buf;
+	char *p = fb->buf;
 	int i;
 
-	BUG_ON(maxlen < 6);
 	for (i = 0; i < ARRAY_SIZE(opt_array); ++i)
-		if (dp->flags & opt_array[i].flag)
+		if (flags & opt_array[i].flag)
 			*p++ = opt_array[i].opt_char;
-	if (p == buf)
+	if (p == fb->buf)
 		*p++ = '_';
 	*p = '\0';
 
-	return buf;
+	return fb->buf;
 }
 
 #define vpr_info(fmt, ...)					\
@@ -142,7 +142,7 @@ static int ddebug_change(const struct ddebug_query *query,
 	struct ddebug_table *dt;
 	unsigned int newflags;
 	unsigned int nfound = 0;
-	char flagbuf[10];
+	struct flagsbuf fbuf;
 
 	/* search for matching ddebugs */
 	mutex_lock(&ddebug_lock);
@@ -192,8 +192,7 @@ static int ddebug_change(const struct ddebug_query *query,
 			vpr_info("changed %s:%d [%s]%s =%s\n",
 				 trim_prefix(dp->filename), dp->lineno,
 				 dt->mod_name, dp->function,
-				 ddebug_describe_flags(dp, flagbuf,
-						       sizeof(flagbuf)));
+				 ddebug_describe_flags(dp->flags, &fbuf));
 		}
 	}
 	mutex_unlock(&ddebug_lock);
@@ -777,7 +776,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 {
 	struct ddebug_iter *iter = m->private;
 	struct _ddebug *dp = p;
-	char flagsbuf[10];
+	struct flagsbuf flags;
 
 	vpr_info("called m=%p p=%p\n", m, p);
 
@@ -790,7 +789,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	seq_printf(m, "%s:%u [%s]%s =%s \"",
 		   trim_prefix(dp->filename), dp->lineno,
 		   iter->table->mod_name, dp->function,
-		   ddebug_describe_flags(dp, flagsbuf, sizeof(flagsbuf)));
+		   ddebug_describe_flags(dp->flags, &flags));
 	seq_escape(m, dp->format, "\t\r\n\"");
 	seq_puts(m, "\"\n");
 
-- 
2.25.1

