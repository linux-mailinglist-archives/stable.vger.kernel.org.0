Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7980D284966
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 11:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgJFJeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 05:34:06 -0400
Received: from z5.mailgun.us ([104.130.96.5]:35937 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbgJFJeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Oct 2020 05:34:06 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601976846; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=ckUBDn3d6qNMOJfUzQnYHA2hJd9PVhr0vQBnUyhLSrY=; b=csmL9xZNOttC3br4e6NJj2f8X9uL2hw198+PiIjuZckzHSDSf0mO8v1hb9VmAgbpU2xEd9V2
 k0Pt358HFz3TNejFi478yMh+PligBeC4h4/vPFs39YScytCTbA8TynQcxA0Kzz7Imj2eCoYa
 H9DExPPNPPSrxmCRTY8Hr3FsY0k=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f7c3a0dd63768e57bde3954 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 06 Oct 2020 09:34:05
 GMT
Sender: gkohli=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CC6D1C43382; Tue,  6 Oct 2020 09:34:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from localhost (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: gkohli)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 44737C433C8;
        Tue,  6 Oct 2020 09:34:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 44737C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=gkohli@codeaurora.org
From:   Gaurav Kohli <gkohli@codeaurora.org>
To:     rostedt@goodmis.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Gaurav Kohli <gkohli@codeaurora.org>, stable@vger.kernel.org
Subject: [PATCH v1] trace: Fix race in trace_open and buffer resize call
Date:   Tue,  6 Oct 2020 15:03:53 +0530
Message-Id: <1601976833-24377-1-git-send-email-gkohli@codeaurora.org>
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

Take buffer lock to fix this.

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

