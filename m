Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E28304A66
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731399AbhAZFFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731716AbhAYTWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 14:22:10 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E129020E65;
        Mon, 25 Jan 2021 19:21:27 +0000 (UTC)
Date:   Mon, 25 Jan 2021 14:21:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Denis Efremov <efremov@linux.com>,
        Gaurav Kohli <gkohli@codeaurora.org>
Subject: [PATCH v5.4 and earlier] trace: Fix race in trace_open and buffer
 resize call
Message-ID: <20210125142126.70d6a33c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaurav Kohli <gkohli@codeaurora.org>

[ upstream commit bbeb97464eefc65f506084fd9f18f21653e01137 ]

Below race can come, if trace_open and resize of
cpu buffer is running parallely on different cpus
CPUX                                CPUY
				    ring_buffer_resize
				    atomic_read(&buffer->resize_disabled)
tracing_open
tracing_reset_online_cpus
ring_buffer_reset_cpu
rb_reset_cpu
				    rb_update_pages
				    remove/insert pages
resetting pointer

This race can cause data abort or some times infinite loop in
rb_remove_pages and rb_insert_pages while checking pages
for sanity.

Take buffer lock to fix this.

Link: https://lkml.kernel.org/r/1601976833-24377-1-git-send-email-gkohli@codeaurora.org

Cc: stable@vger.kernel.org
Fixes: 83f40318dab00 ("ring-buffer: Make removal of ring buffer pages atomic")
Reported-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Gaurav Kohli <gkohli@codeaurora.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---

I updated the "Fixes:" tag with the proper commit it fixes.
-- Steve

 kernel/trace/ring_buffer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 077877ed54f7..728374166653 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4448,6 +4448,8 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
+	/* prevent another thread from changing buffer sizes */
+	mutex_lock(&buffer->mutex);
 
 	atomic_inc(&buffer->resize_disabled);
 	atomic_inc(&cpu_buffer->record_disabled);
@@ -4471,6 +4473,8 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 
 	atomic_dec(&cpu_buffer->record_disabled);
 	atomic_dec(&buffer->resize_disabled);
+
+	mutex_unlock(&buffer->mutex);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
 
-- 
2.25.4

