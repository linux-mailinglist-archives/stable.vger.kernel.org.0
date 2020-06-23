Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED8B205DB9
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388441AbgFWUQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:16:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388901AbgFWUP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:15:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF31C20702;
        Tue, 23 Jun 2020 20:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943359;
        bh=CoUWkoNza6UN9/1kLJu/JmxiUJyTQiCu0L4g1FUCvCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZwiUJpKJzEOCQjxMr5216/ElI6mmX31CLkmYfcYRsJXMrWLzgvIH02yQpGKj5omL
         MqNTEJotuZgh9NKVyAngEFoZHRy+5aAqG/ivDh87rmTUcVxv1N9aDuFYaNrOC4ik4F
         Skv56ZjaRb9iHZ2degz1eusH18L2lmD20K6rAuNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 361/477] tracing/probe: Fix bpf_task_fd_query() for kprobes and uprobes
Date:   Tue, 23 Jun 2020 21:55:58 +0200
Message-Id: <20200623195424.595608159@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

[ Upstream commit 22d5bd6867364b41576a712755271a7d6161abd6 ]

Commit 60d53e2c3b75 ("tracing/probe: Split trace_event related data from
trace_probe") removed the trace_[ku]probe structure from the
trace_event_call->data pointer. As bpf_get_[ku]probe_info() were
forgotten in that change, fix them now. These functions are currently
only used by the bpf_task_fd_query() syscall handler to collect
information about a perf event.

Fixes: 60d53e2c3b75 ("tracing/probe: Split trace_event related data from trace_probe")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lore.kernel.org/bpf/20200608124531.819838-1-jean-philippe@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c | 2 +-
 kernel/trace/trace_uprobe.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 35989383ae113..8eeb95e04bf52 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1629,7 +1629,7 @@ int bpf_get_kprobe_info(const struct perf_event *event, u32 *fd_type,
 	if (perf_type_tracepoint)
 		tk = find_trace_kprobe(pevent, group);
 	else
-		tk = event->tp_event->data;
+		tk = trace_kprobe_primary_from_call(event->tp_event);
 	if (!tk)
 		return -EINVAL;
 
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 2a8e8e9c1c754..fdd47f99b18fd 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1412,7 +1412,7 @@ int bpf_get_uprobe_info(const struct perf_event *event, u32 *fd_type,
 	if (perf_type_tracepoint)
 		tu = find_probe_event(pevent, group);
 	else
-		tu = event->tp_event->data;
+		tu = trace_uprobe_primary_from_call(event->tp_event);
 	if (!tu)
 		return -EINVAL;
 
-- 
2.25.1



