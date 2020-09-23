Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C996F27643A
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 00:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIWW4Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 23 Sep 2020 18:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbgIWW4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Sep 2020 18:56:16 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48908221EB;
        Wed, 23 Sep 2020 22:56:15 +0000 (UTC)
Date:   Wed, 23 Sep 2020 18:56:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     zhouchengming@bytedance.com, songmuchun@bytedance.com,
        <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] ftrace: Setup correct FTRACE_FL_REGS
 flags for module" failed to apply to 4.4-stable tree
Message-ID: <20200923185613.6901e246@oasis.local.home>
In-Reply-To: <159784015193138@kroah.com>
References: <159784015193138@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Aug 2020 14:29:11 +0200
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.


This should be the fix for 4.4.

-- Steve

From 8a224ffb3f52b0027f6b7279854c71a31c48fc97 Mon Sep 17 00:00:00 2001
From: Chengming Zhou <zhouchengming@bytedance.com>
Date: Wed, 29 Jul 2020 02:05:53 +0800
Subject: [PATCH] ftrace: Setup correct FTRACE_FL_REGS flags for module

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

Index: linux-test.git/kernel/trace/ftrace.c
===================================================================
--- linux-test.git.orig/kernel/trace/ftrace.c
+++ linux-test.git/kernel/trace/ftrace.c
@@ -2823,8 +2823,11 @@ static int referenced_filters(struct dyn
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
@@ -2874,7 +2877,7 @@ static int ftrace_update_code(struct mod
 			p = &pg->records[i];
 			if (test)
 				cnt += referenced_filters(p);
-			p->flags = cnt;
+			p->flags += cnt;
 
 			/*
 			 * Do the initial record conversion from mcount jump
