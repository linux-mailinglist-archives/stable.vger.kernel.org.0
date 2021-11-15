Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41B8452183
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244396AbhKPBFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:05:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245530AbhKOTUm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59B876326A;
        Mon, 15 Nov 2021 18:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001379;
        bh=NbQj6pqpOI1E9osxI37Pu//IRGmen8eUGenlQSectMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=taFffh+h662yr9/MJwsjjijM91/2Nm+olpA6bgnuxU1xWTXsrTk0TwzSr/mrBf20B
         N9BaSetFM5c24A/B6y0DFbiLZfdl6In0HWqx0qQQvmmTEfJo9gpvxpzaAp3auUc21p
         FsrSJ4daMz6BI0P8uzAyhMznKQK6OyxywY+sjkzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 134/917] ring-buffer: Protect ring_buffer_reset() from reentrancy
Date:   Mon, 15 Nov 2021 17:53:49 +0100
Message-Id: <20211115165433.317177945@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 51d157946666382e779f94c39891e8e9a020da78 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5233,6 +5233,9 @@ void ring_buffer_reset(struct trace_buff
 	struct ring_buffer_per_cpu *cpu_buffer;
 	int cpu;
 
+	/* prevent another thread from changing buffer sizes */
+	mutex_lock(&buffer->mutex);
+
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
 
@@ -5251,6 +5254,8 @@ void ring_buffer_reset(struct trace_buff
 		atomic_dec(&cpu_buffer->record_disabled);
 		atomic_dec(&cpu_buffer->resize_disabled);
 	}
+
+	mutex_unlock(&buffer->mutex);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset);
 


