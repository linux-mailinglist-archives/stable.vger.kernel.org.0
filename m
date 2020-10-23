Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A45129712D
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 16:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750420AbgJWOSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 10:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750307AbgJWOSC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Oct 2020 10:18:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A43921527;
        Fri, 23 Oct 2020 14:18:01 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kVxtH-004deC-Ut; Fri, 23 Oct 2020 10:17:59 -0400
Message-ID: <20201023141759.821185545@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 23 Oct 2020 10:16:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Qiujun Huang <hqjagain@gmail.com>, stable@vger.kernel.org
Subject: [for-linus][PATCH 1/2] ring-buffer: Return 0 on success from ring_buffer_resize()
References: <20201023141609.430954343@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

We don't need to check the new buffer size, and the return value
had confused resize_buffer_duplicate_size().
...
	ret = ring_buffer_resize(trace_buf->buffer,
		per_cpu_ptr(size_buf->data,cpu_id)->entries, cpu_id);
	if (ret == 0)
		per_cpu_ptr(trace_buf->data, cpu_id)->entries =
			per_cpu_ptr(size_buf->data, cpu_id)->entries;
...

Link: https://lkml.kernel.org/r/20201019142242.11560-1-hqjagain@gmail.com

Cc: stable@vger.kernel.org
Fixes: d60da506cbeb3 ("tracing: Add a resize function to make one buffer equivalent to another buffer")
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 15bf28b13e50..5c6a9c6a058f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1952,18 +1952,18 @@ int ring_buffer_resize(struct trace_buffer *buffer, unsigned long size,
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long nr_pages;
-	int cpu, err = 0;
+	int cpu, err;
 
 	/*
 	 * Always succeed at resizing a non-existent buffer:
 	 */
 	if (!buffer)
-		return size;
+		return 0;
 
 	/* Make sure the requested buffer exists */
 	if (cpu_id != RING_BUFFER_ALL_CPUS &&
 	    !cpumask_test_cpu(cpu_id, buffer->cpumask))
-		return size;
+		return 0;
 
 	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 
@@ -2119,7 +2119,7 @@ int ring_buffer_resize(struct trace_buffer *buffer, unsigned long size,
 	}
 
 	mutex_unlock(&buffer->mutex);
-	return size;
+	return 0;
 
  out_err:
 	for_each_buffer_cpu(buffer, cpu) {
-- 
2.28.0


