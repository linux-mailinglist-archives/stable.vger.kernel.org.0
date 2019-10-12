Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89BFCD4BA3
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 03:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbfJLA7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 20:59:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727345AbfJLA7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 20:59:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4A20218AC;
        Sat, 12 Oct 2019 00:59:21 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1iJ5kf-0004ES-1m; Fri, 11 Oct 2019 20:59:21 -0400
Message-Id: <20191012005920.942012497@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 11 Oct 2019 20:57:50 -0400
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
Subject: [PATCH 3/7 v2] tracing: Get trace_array reference for available_tracers files
References: <20191012005747.210722465@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As instances may have different tracers available, we need to look at the
trace_array descriptor that shows lists the available tracers for the
instance. But there's a race between opening the file and the admin from
deleting the instance. The trace_array_get() needs to be called before
accessing the trace_array.

Cc: stable@vger.kernel.org
Fixes: 607e2ea167e56 ("tracing: Set up infrastructure to allow tracers for instances")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 252f79c435f8..fa7d813b04c6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4355,9 +4355,14 @@ static int show_traces_open(struct inode *inode, struct file *file)
 	if (tracing_disabled)
 		return -ENODEV;
 
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	ret = seq_open(file, &show_traces_seq_ops);
-	if (ret)
+	if (ret) {
+		trace_array_put(tr);
 		return ret;
+	}
 
 	m = file->private_data;
 	m->private = tr;
@@ -4365,6 +4370,14 @@ static int show_traces_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int show_traces_release(struct inode *inode, struct file *file)
+{
+	struct trace_array *tr = inode->i_private;
+
+	trace_array_put(tr);
+	return seq_release(inode, file);
+}
+
 static ssize_t
 tracing_write_stub(struct file *filp, const char __user *ubuf,
 		   size_t count, loff_t *ppos)
@@ -4395,8 +4408,8 @@ static const struct file_operations tracing_fops = {
 static const struct file_operations show_traces_fops = {
 	.open		= show_traces_open,
 	.read		= seq_read,
-	.release	= seq_release,
 	.llseek		= seq_lseek,
+	.release	= show_traces_release,
 };
 
 static ssize_t
-- 
2.23.0


