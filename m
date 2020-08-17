Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC198246AF4
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387737AbgHQPpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387732AbgHQPpw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:45:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CAA32053B;
        Mon, 17 Aug 2020 15:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679151;
        bh=D5k2ndZ09RSu27YbTeDuJAYP77MmDjoMsYm5JQfcbV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQWDTkJdEBaTTppiNhwKne2IahnQ4K591VF54Tg64v8anDsT2KgoHeA5z3dQo/CKG
         sh53NBvFaCc0BA7psPKNv5XSUVMV9KEf3saagmMKVxw6ctFLmyzC9fIMlDo1PGayVn
         PDKIA2nxUZv8AFrTQn7m7cey0k5SLzNizFtVG1wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, jbaron@akamai.com,
        Jim Cromie <jim.cromie@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 113/393] dyndbg: fix a BUG_ON in ddebug_describe_flags
Date:   Mon, 17 Aug 2020 17:12:43 +0200
Message-Id: <20200817143825.096967498@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8f199f403ab50..e3755d1f74bd2 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -87,22 +87,22 @@ static struct { unsigned flag:8; char opt_char; } opt_array[] = {
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
@@ -144,7 +144,7 @@ static int ddebug_change(const struct ddebug_query *query,
 	struct ddebug_table *dt;
 	unsigned int newflags;
 	unsigned int nfound = 0;
-	char flagbuf[10];
+	struct flagsbuf fbuf;
 
 	/* search for matching ddebugs */
 	mutex_lock(&ddebug_lock);
@@ -201,8 +201,7 @@ static int ddebug_change(const struct ddebug_query *query,
 			vpr_info("changed %s:%d [%s]%s =%s\n",
 				 trim_prefix(dp->filename), dp->lineno,
 				 dt->mod_name, dp->function,
-				 ddebug_describe_flags(dp, flagbuf,
-						       sizeof(flagbuf)));
+				 ddebug_describe_flags(dp->flags, &fbuf));
 		}
 	}
 	mutex_unlock(&ddebug_lock);
@@ -816,7 +815,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 {
 	struct ddebug_iter *iter = m->private;
 	struct _ddebug *dp = p;
-	char flagsbuf[10];
+	struct flagsbuf flags;
 
 	vpr_info("called m=%p p=%p\n", m, p);
 
@@ -829,7 +828,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 	seq_printf(m, "%s:%u [%s]%s =%s \"",
 		   trim_prefix(dp->filename), dp->lineno,
 		   iter->table->mod_name, dp->function,
-		   ddebug_describe_flags(dp, flagsbuf, sizeof(flagsbuf)));
+		   ddebug_describe_flags(dp->flags, &flags));
 	seq_escape(m, dp->format, "\t\r\n\"");
 	seq_puts(m, "\"\n");
 
-- 
2.25.1



