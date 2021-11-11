Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E807144CEBE
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 02:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbhKKB0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 20:26:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232725AbhKKB0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 20:26:04 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B34E61361;
        Thu, 11 Nov 2021 01:23:16 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1mkyo6-000AfC-Nj;
        Wed, 10 Nov 2021 20:23:14 -0500
Message-ID: <20211111012314.565064820@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 10 Nov 2021 20:22:55 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [for-linus][PATCH 1/2] ring-buffer: Protect ring_buffer_reset() from reentrancy
References: <20211111012254.044048524@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The resetting of the entire ring buffer use to simply go through and reset
each individual CPU buffer that had its own protection and synchronization.
But this was very slow, due to performing a synchronization for each CPU.
The code was reshuffled to do one disabling of all CPU buffers, followed
by a single RCU synchronization, and then the resetting of each of the CPU
buffers. But unfortunately, the mutex that prevented multiple occurrences
of resetting the buffer was not moved to the upper function, and there is
nothing to protect from it.

Take the ring buffer mutex around the global reset.

Cc: stable@vger.kernel.org
Fixes: b23d7a5f4a07a ("ring-buffer: speed up buffer resets by avoiding synchronize_rcu for each CPU")
Reported-by: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f6520d0a4c8c..2699e9e562b1 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5228,6 +5228,9 @@ void ring_buffer_reset(struct trace_buffer *buffer)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	int cpu;
 
+	/* prevent another thread from changing buffer sizes */
+	mutex_lock(&buffer->mutex);
+
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
 
@@ -5246,6 +5249,8 @@ void ring_buffer_reset(struct trace_buffer *buffer)
 		atomic_dec(&cpu_buffer->record_disabled);
 		atomic_dec(&cpu_buffer->resize_disabled);
 	}
+
+	mutex_unlock(&buffer->mutex);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset);
 
-- 
2.33.0
