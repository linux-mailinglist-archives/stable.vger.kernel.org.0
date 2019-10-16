Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F849DA07C
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391459AbfJPWL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391390AbfJPV4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:56:36 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A58321A4C;
        Wed, 16 Oct 2019 21:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262995;
        bh=sEtzKRnmJWXm1i7t+fTOk3/ruudXpNOfhncm3fa4dOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ZDKWiFSQBwBicPwbXW+pEFgPFghgFYX1jpiWm6F11Y0XV4mg29A1FFTHUo3oue/Z
         eeKsSirLrLqckftLYAo56u7+B6MzKc9rt4nXk7Hz7dU2hvQKu5mA/PieGDmB5QV912
         KY7RO6oXvFLTKFNCgWOUbHiotlvCQFodAXMnHycI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 63/65] tracing: Get trace_array reference for available_tracers files
Date:   Wed, 16 Oct 2019 14:51:17 -0700
Message-Id: <20191016214840.268456520@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
References: <20191016214756.457746573@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 194c2c74f5532e62c218adeb8e2b683119503907 upstream.

As instances may have different tracers available, we need to look at the
trace_array descriptor that shows the list of the available tracers for the
instance. But there's a race between opening the file and an admin
deleting the instance. The trace_array_get() needs to be called before
accessing the trace_array.

Cc: stable@vger.kernel.org
Fixes: 607e2ea167e56 ("tracing: Set up infrastructure to allow tracers for instances")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4152,9 +4152,14 @@ static int show_traces_open(struct inode
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
@@ -4162,6 +4167,14 @@ static int show_traces_open(struct inode
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
@@ -4192,8 +4205,8 @@ static const struct file_operations trac
 static const struct file_operations show_traces_fops = {
 	.open		= show_traces_open,
 	.read		= seq_read,
-	.release	= seq_release,
 	.llseek		= seq_lseek,
+	.release	= show_traces_release,
 };
 
 static ssize_t


