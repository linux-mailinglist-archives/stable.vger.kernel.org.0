Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7283E18A1
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 17:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242381AbhHEPtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 11:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242199AbhHEPtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 11:49:51 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDEC660F35;
        Thu,  5 Aug 2021 15:49:36 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mBfcl-0037vr-NR; Thu, 05 Aug 2021 11:49:35 -0400
Message-ID: <20210805154935.553422403@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 05 Aug 2021 11:43:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Kamal Agrawal <kamaagra@codeaurora.org>
Subject: [for-linus][PATCH 1/6] tracing: Fix NULL pointer dereference in start_creating
References: <20210805154336.208362117@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Agrawal <kamaagra@codeaurora.org>

The event_trace_add_tracer() can fail. In this case, it leads to a crash
in start_creating with below call stack. Handle the error scenario
properly in trace_array_create_dir.

Call trace:
down_write+0x7c/0x204
start_creating.25017+0x6c/0x194
tracefs_create_file+0xc4/0x2b4
init_tracer_tracefs+0x5c/0x940
trace_array_create_dir+0x58/0xb4
trace_array_create+0x1bc/0x2b8
trace_array_get_by_name+0xdc/0x18c

Link: https://lkml.kernel.org/r/1627651386-21315-1-git-send-email-kamaagra@codeaurora.org

Cc: stable@vger.kernel.org
Fixes: 4114fbfd02f1 ("tracing: Enable creating new instance early boot")
Signed-off-by: Kamal Agrawal <kamaagra@codeaurora.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c59dd35a6da5..33899a71fdc1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9135,8 +9135,10 @@ static int trace_array_create_dir(struct trace_array *tr)
 		return -EINVAL;
 
 	ret = event_trace_add_tracer(tr->dir, tr);
-	if (ret)
+	if (ret) {
 		tracefs_remove(tr->dir);
+		return ret;
+	}
 
 	init_tracer_tracefs(tr, tr->dir);
 	__update_tracer_options(tr);
-- 
2.30.2
