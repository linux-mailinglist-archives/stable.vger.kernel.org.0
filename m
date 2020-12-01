Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BE92CA7AE
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 17:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388395AbgLAQBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 11:01:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391853AbgLAQB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 11:01:28 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8FD622257;
        Tue,  1 Dec 2020 16:00:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kk84U-002R8u-Jq; Tue, 01 Dec 2020 11:00:06 -0500
Message-ID: <20201201160006.488267004@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 01 Dec 2020 10:58:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: [for-linus][PATCH 10/12] ftrace: Fix updating FTRACE_FL_TRAMP
References: <20201201155835.647858317@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

On powerpc, kprobe-direct.tc triggered FTRACE_WARN_ON() in
ftrace_get_addr_new() followed by the below message:
  Bad trampoline accounting at: 000000004222522f (wake_up_process+0xc/0x20) (f0000001)

The set of steps leading to this involved:
- modprobe ftrace-direct-too
- enable_probe
- modprobe ftrace-direct
- rmmod ftrace-direct <-- trigger

The problem turned out to be that we were not updating flags in the
ftrace record properly. From the above message about the trampoline
accounting being bad, it can be seen that the ftrace record still has
FTRACE_FL_TRAMP set though ftrace-direct module is going away. This
happens because we are checking if any ftrace_ops has the
FTRACE_FL_TRAMP flag set _before_ updating the filter hash.

The fix for this is to look for any _other_ ftrace_ops that also needs
FTRACE_FL_TRAMP.

Link: https://lkml.kernel.org/r/56c113aa9c3e10c19144a36d9684c7882bf09af5.1606412433.git.naveen.n.rao@linux.vnet.ibm.com

Cc: stable@vger.kernel.org
Fixes: a124692b698b0 ("ftrace: Enable trampoline when rec count returns back to one")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8185f7240095..9c1bba8cc51b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1629,6 +1629,8 @@ static bool test_rec_ops_needs_regs(struct dyn_ftrace *rec)
 static struct ftrace_ops *
 ftrace_find_tramp_ops_any(struct dyn_ftrace *rec);
 static struct ftrace_ops *
+ftrace_find_tramp_ops_any_other(struct dyn_ftrace *rec, struct ftrace_ops *op_exclude);
+static struct ftrace_ops *
 ftrace_find_tramp_ops_next(struct dyn_ftrace *rec, struct ftrace_ops *ops);
 
 static bool __ftrace_hash_rec_update(struct ftrace_ops *ops,
@@ -1778,7 +1780,7 @@ static bool __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			 * to it.
 			 */
 			if (ftrace_rec_count(rec) == 1 &&
-			    ftrace_find_tramp_ops_any(rec))
+			    ftrace_find_tramp_ops_any_other(rec, ops))
 				rec->flags |= FTRACE_FL_TRAMP;
 			else
 				rec->flags &= ~FTRACE_FL_TRAMP;
@@ -2244,6 +2246,24 @@ ftrace_find_tramp_ops_any(struct dyn_ftrace *rec)
 	return NULL;
 }
 
+static struct ftrace_ops *
+ftrace_find_tramp_ops_any_other(struct dyn_ftrace *rec, struct ftrace_ops *op_exclude)
+{
+	struct ftrace_ops *op;
+	unsigned long ip = rec->ip;
+
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
+
+		if (op == op_exclude || !op->trampoline)
+			continue;
+
+		if (hash_contains_ip(ip, op->func_hash))
+			return op;
+	} while_for_each_ftrace_op(op);
+
+	return NULL;
+}
+
 static struct ftrace_ops *
 ftrace_find_tramp_ops_next(struct dyn_ftrace *rec,
 			   struct ftrace_ops *op)
-- 
2.28.0


