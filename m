Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9861D2A5258
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731694AbgKCUtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:49:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:39022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731401AbgKCUsA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:48:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A38220719;
        Tue,  3 Nov 2020 20:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436480;
        bh=UUZhJu7PlHJEOTeScATk6/XWUhsNVq7I6xnmh+OhpVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ar2zxCfrAW/3pMDIcjvchfrXr/XuFfsbbt2xWrrPFU5r5i7UDXuUEH5BySP0ehWAx
         Ex0c2Ox7MLJT4izf5OlRrhYUjU8OI3d9bsx9lvHV48j5ztuO6eDeRV+A1svyOmTy7X
         059NW8PLZ2f/4GlUteqCnaAENPExwqq42B1Prwlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gaurav Kohli <gkohli@codeaurora.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.9 261/391] tracing: Fix race in trace_open and buffer resize call
Date:   Tue,  3 Nov 2020 21:35:12 +0100
Message-Id: <20201103203404.635910328@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaurav Kohli <gkohli@codeaurora.org>

commit bbeb97464eefc65f506084fd9f18f21653e01137 upstream.

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

This race can cause data abort or some times infinte loop in
rb_remove_pages and rb_insert_pages while checking pages
for sanity.

Take buffer lock to fix this.

Link: https://lkml.kernel.org/r/1601976833-24377-1-git-send-email-gkohli@codeaurora.org

Cc: stable@vger.kernel.org
Fixes: b23d7a5f4a07a ("ring-buffer: speed up buffer resets by avoiding synchronize_rcu for each CPU")
Signed-off-by: Gaurav Kohli <gkohli@codeaurora.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ring_buffer.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4866,6 +4866,9 @@ void ring_buffer_reset_cpu(struct trace_
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
 
+	/* prevent another thread from changing buffer sizes */
+	mutex_lock(&buffer->mutex);
+
 	atomic_inc(&cpu_buffer->resize_disabled);
 	atomic_inc(&cpu_buffer->record_disabled);
 
@@ -4876,6 +4879,8 @@ void ring_buffer_reset_cpu(struct trace_
 
 	atomic_dec(&cpu_buffer->record_disabled);
 	atomic_dec(&cpu_buffer->resize_disabled);
+
+	mutex_unlock(&buffer->mutex);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
 
@@ -4889,6 +4894,9 @@ void ring_buffer_reset_online_cpus(struc
 	struct ring_buffer_per_cpu *cpu_buffer;
 	int cpu;
 
+	/* prevent another thread from changing buffer sizes */
+	mutex_lock(&buffer->mutex);
+
 	for_each_online_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
 
@@ -4907,6 +4915,8 @@ void ring_buffer_reset_online_cpus(struc
 		atomic_dec(&cpu_buffer->record_disabled);
 		atomic_dec(&cpu_buffer->resize_disabled);
 	}
+
+	mutex_unlock(&buffer->mutex);
 }
 
 /**


