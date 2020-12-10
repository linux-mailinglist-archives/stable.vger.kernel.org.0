Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CD82D5DC1
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390276AbgLJOaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:30:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390269AbgLJOaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:30:16 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.9 32/45] ftrace: Fix updating FTRACE_FL_TRAMP
Date:   Thu, 10 Dec 2020 15:26:46 +0100
Message-Id: <20201210142603.939371096@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.361598591@linuxfoundation.org>
References: <20201210142602.361598591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit 4c75b0ff4e4bf7a45b5aef9639799719c28d0073 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1634,6 +1634,8 @@ static bool test_rec_ops_needs_regs(stru
 static struct ftrace_ops *
 ftrace_find_tramp_ops_any(struct dyn_ftrace *rec);
 static struct ftrace_ops *
+ftrace_find_tramp_ops_any_other(struct dyn_ftrace *rec, struct ftrace_ops *op_exclude);
+static struct ftrace_ops *
 ftrace_find_tramp_ops_next(struct dyn_ftrace *rec, struct ftrace_ops *ops);
 
 static bool __ftrace_hash_rec_update(struct ftrace_ops *ops,
@@ -1771,7 +1773,7 @@ static bool __ftrace_hash_rec_update(str
 			 * to it.
 			 */
 			if (ftrace_rec_count(rec) == 1 &&
-			    ftrace_find_tramp_ops_any(rec))
+			    ftrace_find_tramp_ops_any_other(rec, ops))
 				rec->flags |= FTRACE_FL_TRAMP;
 			else
 				rec->flags &= ~FTRACE_FL_TRAMP;
@@ -2193,6 +2195,24 @@ ftrace_find_tramp_ops_any(struct dyn_ftr
 			continue;
 
 		if (hash_contains_ip(ip, op->func_hash))
+			return op;
+	} while_for_each_ftrace_op(op);
+
+	return NULL;
+}
+
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
 			return op;
 	} while_for_each_ftrace_op(op);
 


