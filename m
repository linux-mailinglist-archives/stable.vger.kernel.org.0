Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048BE27732C
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 15:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgIXNzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 09:55:23 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:46521 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbgIXNzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Sep 2020 09:55:22 -0400
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 24 Sep 2020 06:55:21 -0700
Received: from ironmsg02-blr.qualcomm.com ([10.86.208.131])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/AES256-SHA; 24 Sep 2020 06:55:19 -0700
Received: from gkohli-linux.qualcomm.com ([10.204.78.26])
  by ironmsg02-blr.qualcomm.com with ESMTP; 24 Sep 2020 19:25:07 +0530
Received: by gkohli-linux.qualcomm.com (Postfix, from userid 427023)
        id 7FBC621323; Thu, 24 Sep 2020 19:25:06 +0530 (IST)
From:   Gaurav Kohli <gkohli@codeaurora.org>
To:     rostedt@goodmis.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Gaurav Kohli <gkohli@codeaurora.org>, stable@vger.kernel.org
Subject: [PATCH v1] trace: Fix race in trace_open and buffer resize call
Date:   Thu, 24 Sep 2020 19:25:05 +0530
Message-Id: <1600955705-27382-1-git-send-email-gkohli@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Signed-off-by: Gaurav Kohli <gkohli@codeaurora.org>
Cc: stable@vger.kernel.org
---
Changes since v0:
  -Addressed Steven's review comments.

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 93ef0ab..15bf28b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4866,6 +4866,9 @@ void ring_buffer_reset_cpu(struct trace_buffer *buffer, int cpu)
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
 
+	/* prevent another thread from changing buffer sizes */
+	mutex_lock(&buffer->mutex);
+
 	atomic_inc(&cpu_buffer->resize_disabled);
 	atomic_inc(&cpu_buffer->record_disabled);
 
@@ -4876,6 +4879,8 @@ void ring_buffer_reset_cpu(struct trace_buffer *buffer, int cpu)
 
 	atomic_dec(&cpu_buffer->record_disabled);
 	atomic_dec(&cpu_buffer->resize_disabled);
+
+	mutex_unlock(&buffer->mutex);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
 
@@ -4889,6 +4894,9 @@ void ring_buffer_reset_online_cpus(struct trace_buffer *buffer)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	int cpu;
 
+	/* prevent another thread from changing buffer sizes */
+	mutex_lock(&buffer->mutex);
+
 	for_each_online_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
 
@@ -4907,6 +4915,8 @@ void ring_buffer_reset_online_cpus(struct trace_buffer *buffer)
 		atomic_dec(&cpu_buffer->record_disabled);
 		atomic_dec(&cpu_buffer->resize_disabled);
 	}
+
+	mutex_unlock(&buffer->mutex);
 }
 
 /**
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center,
Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

