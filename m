Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C5323C120
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 22:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgHDU7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 16:59:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728061AbgHDU6Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Aug 2020 16:58:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBC3522BED;
        Tue,  4 Aug 2020 20:58:13 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1k340i-006HBO-OO; Tue, 04 Aug 2020 16:58:12 -0400
Message-ID: <20200804205812.638727187@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 04 Aug 2020 16:57:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>
Subject: [for-linus][PATCH 05/17] ftrace: Setup correct FTRACE_FL_REGS flags for module
References: <20200804205743.419135730@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengming Zhou <zhouchengming@bytedance.com>

When module loaded and enabled, we will use __ftrace_replace_code
for module if any ftrace_ops referenced it found. But we will get
wrong ftrace_addr for module rec in ftrace_get_addr_new, because
rec->flags has not been setup correctly. It can cause the callback
function of a ftrace_ops has FTRACE_OPS_FL_SAVE_REGS to be called
with pt_regs set to NULL.
So setup correct FTRACE_FL_REGS flags for rec when we call
referenced_filters to find ftrace_ops references it.

Link: https://lkml.kernel.org/r/20200728180554.65203-1-zhouchengming@bytedance.com

Cc: stable@vger.kernel.org
Fixes: 8c4f3c3fa9681 ("ftrace: Check module functions being traced on reload")
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c141d347f71a..d052f856f1cf 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6198,8 +6198,11 @@ static int referenced_filters(struct dyn_ftrace *rec)
 	int cnt = 0;
 
 	for (ops = ftrace_ops_list; ops != &ftrace_list_end; ops = ops->next) {
-		if (ops_references_rec(ops, rec))
-		    cnt++;
+		if (ops_references_rec(ops, rec)) {
+			cnt++;
+			if (ops->flags & FTRACE_OPS_FL_SAVE_REGS)
+				rec->flags |= FTRACE_FL_REGS;
+		}
 	}
 
 	return cnt;
@@ -6378,8 +6381,8 @@ void ftrace_module_enable(struct module *mod)
 		if (ftrace_start_up)
 			cnt += referenced_filters(rec);
 
-		/* This clears FTRACE_FL_DISABLED */
-		rec->flags = cnt;
+		rec->flags &= ~FTRACE_FL_DISABLED;
+		rec->flags += cnt;
 
 		if (ftrace_start_up && cnt) {
 			int failed = __ftrace_replace_code(rec, 1);
-- 
2.26.2


