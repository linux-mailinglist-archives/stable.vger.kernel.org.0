Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3B12063DD
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403835AbgFWVMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391220AbgFWUbh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:31:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE3B220702;
        Tue, 23 Jun 2020 20:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944297;
        bh=DEbBMIJn1vOMYDyhp9S3fXJXMBYm9t2z9zO+SaS04aQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfxjkdLfR+BdbfeVARJRKTm9Vdj9HrMKMpglwAp4RLiuikJ7GBDLB3PgqZUVhve/l
         Nb6SXLwdlzcDTybE8a+0YQ5FSCkkag2aAoybXw0f8VH5wvhePm4SIsa2DEt1Gx+ajx
         TFUcJFE6ft9mF8Z5azUWcM7ecGpRN5+Dtbtf97ZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 249/314] tracing/probe: Fix bpf_task_fd_query() for kprobes and uprobes
Date:   Tue, 23 Jun 2020 21:57:24 +0200
Message-Id: <20200623195350.825256873@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
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
index fba4b48451f6c..26de9c6549566 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1464,7 +1464,7 @@ int bpf_get_kprobe_info(const struct perf_event *event, u32 *fd_type,
 	if (perf_type_tracepoint)
 		tk = find_trace_kprobe(pevent, group);
 	else
-		tk = event->tp_event->data;
+		tk = trace_kprobe_primary_from_call(event->tp_event);
 	if (!tk)
 		return -EINVAL;
 
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 2619bc5ed520c..5294843de6efd 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1405,7 +1405,7 @@ int bpf_get_uprobe_info(const struct perf_event *event, u32 *fd_type,
 	if (perf_type_tracepoint)
 		tu = find_probe_event(pevent, group);
 	else
-		tu = event->tp_event->data;
+		tu = trace_uprobe_primary_from_call(event->tp_event);
 	if (!tu)
 		return -EINVAL;
 
-- 
2.25.1



