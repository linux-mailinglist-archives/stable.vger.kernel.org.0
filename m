Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BADF138090
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbgAKKb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:31:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728901AbgAKKbZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:31:25 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 111A120880;
        Sat, 11 Jan 2020 10:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738684;
        bh=6P3mEpt+EZtfaqkH6sYTaUltr3yxoCaUdwy0Fm+ZyJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YIgT2qq84T+7QhZB2nqKzXhetqrK8aVe7Zft5gh00akKOxIBqMmbo8Dcv5XI53Z+7
         4Er4xmugeGEJ9CUIUO0rP3mK7rm7p0lRLkX2cqRZfyvcKH2lAEui7t2SwBxexV0G9g
         0y/m+0Co0I2gOsfhWx8FvwOsEzdC3KInDBl5n8KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Garrett <mjg59@google.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 137/165] tracing: Do not create directories if lockdown is in affect
Date:   Sat, 11 Jan 2020 10:50:56 +0100
Message-Id: <20200111094937.426468077@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit a356646a56857c2e5ad875beec734d7145ecd49a upstream.

If lockdown is disabling tracing on boot up, it prevents the tracing files
from even bering created. But when that happens, there's several places that
will give a warning that the files were not created as that is usually a
sign of a bug.

Add in strategic locations where a check is made to see if tracing is
disabled by lockdown, and if it is, do not go further, and fail silently
(but print that tracing is disabled by lockdown, without doing a WARN_ON()).

Cc: Matthew Garrett <mjg59@google.com>
Fixes: 17911ff38aa5 ("tracing: Add locked_down checks to the open calls of files created for tracefs")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ring_buffer.c |    6 ++++++
 kernel/trace/trace.c       |   17 +++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -11,6 +11,7 @@
 #include <linux/trace_seq.h>
 #include <linux/spinlock.h>
 #include <linux/irq_work.h>
+#include <linux/security.h>
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
 #include <linux/kthread.h>	/* for self test */
@@ -5068,6 +5069,11 @@ static __init int test_ringbuffer(void)
 	int cpu;
 	int ret = 0;
 
+	if (security_locked_down(LOCKDOWN_TRACEFS)) {
+		pr_warning("Lockdown is enabled, skipping ring buffer tests\n");
+		return 0;
+	}
+
 	pr_info("Running ring buffer tests...\n");
 
 	buffer = ring_buffer_alloc(RB_TEST_BUFFER_SIZE, RB_FL_OVERWRITE);
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1804,6 +1804,12 @@ int __init register_tracer(struct tracer
 		return -1;
 	}
 
+	if (security_locked_down(LOCKDOWN_TRACEFS)) {
+		pr_warning("Can not register tracer %s due to lockdown\n",
+			   type->name);
+		return -EPERM;
+	}
+
 	mutex_lock(&trace_types_lock);
 
 	tracing_selftest_running = true;
@@ -8647,6 +8653,11 @@ struct dentry *tracing_init_dentry(void)
 {
 	struct trace_array *tr = &global_trace;
 
+	if (security_locked_down(LOCKDOWN_TRACEFS)) {
+		pr_warning("Tracing disabled due to lockdown\n");
+		return ERR_PTR(-EPERM);
+	}
+
 	/* The top level trace array uses  NULL as parent */
 	if (tr->dir)
 		return NULL;
@@ -9089,6 +9100,12 @@ __init static int tracer_alloc_buffers(v
 	int ring_buf_size;
 	int ret = -ENOMEM;
 
+
+	if (security_locked_down(LOCKDOWN_TRACEFS)) {
+		pr_warning("Tracing disabled due to lockdown\n");
+		return -EPERM;
+	}
+
 	/*
 	 * Make sure we don't accidently add more trace options
 	 * than we have bits for.


