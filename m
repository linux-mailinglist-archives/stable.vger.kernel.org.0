Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A61D4B98
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 03:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbfJLA7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 20:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbfJLA7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 20:59:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B462421835;
        Sat, 12 Oct 2019 00:59:21 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1iJ5ke-0004Dy-T1; Fri, 11 Oct 2019 20:59:20 -0400
Message-Id: <20191012005920.780394471@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 11 Oct 2019 20:57:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <matthewgarrett@google.com>,
        James Morris James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: [PATCH 2/7 v2] ftrace: Get a reference counter for the trace_array on filter files
References: <20191012005747.210722465@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The ftrace set_ftrace_filter and set_ftrace_notrace files are specific for
an instance now. They need to take a reference to the instance otherwise
there could be a race between accessing the files and deleting the instance.

It wasn't until the :mod: caching where these file operations stated
referencing the trace_arry directly.

Cc: stable@vger.kernel.org
Fixes: 673feb9d76ab3 ("ftrace: Add :mod: caching infrastructure to trace_array")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 62a50bf399d6..32c2eb167de0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3540,21 +3540,22 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 	struct ftrace_hash *hash;
 	struct list_head *mod_head;
 	struct trace_array *tr = ops->private;
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	ftrace_ops_init(ops);
 
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
+	if (tr && trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter)
-		return -ENOMEM;
+		goto out;
 
-	if (trace_parser_get_init(&iter->parser, FTRACE_BUFF_MAX)) {
-		kfree(iter);
-		return -ENOMEM;
-	}
+	if (trace_parser_get_init(&iter->parser, FTRACE_BUFF_MAX))
+		goto out;
 
 	iter->ops = ops;
 	iter->flags = flag;
@@ -3584,13 +3585,13 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 
 		if (!iter->hash) {
 			trace_parser_put(&iter->parser);
-			kfree(iter);
-			ret = -ENOMEM;
 			goto out_unlock;
 		}
 	} else
 		iter->hash = hash;
 
+	ret = 0;
+
 	if (file->f_mode & FMODE_READ) {
 		iter->pg = ftrace_pages_start;
 
@@ -3602,7 +3603,6 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 			/* Failed */
 			free_ftrace_hash(iter->hash);
 			trace_parser_put(&iter->parser);
-			kfree(iter);
 		}
 	} else
 		file->private_data = iter;
@@ -3610,6 +3610,13 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
  out_unlock:
 	mutex_unlock(&ops->func_hash->regex_lock);
 
+ out:
+	if (ret) {
+		kfree(iter);
+		if (tr)
+			trace_array_put(tr);
+	}
+
 	return ret;
 }
 
@@ -5037,6 +5044,8 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 
 	mutex_unlock(&iter->ops->func_hash->regex_lock);
 	free_ftrace_hash(iter->hash);
+	if (iter->tr)
+		trace_array_put(iter->tr);
 	kfree(iter);
 
 	return 0;
-- 
2.23.0


