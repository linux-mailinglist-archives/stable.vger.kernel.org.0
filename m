Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A936F157506
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgBJMiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:38:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:32828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729009AbgBJMiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:05 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94A252467D;
        Mon, 10 Feb 2020 12:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338284;
        bh=N7fkDpqGL4WOrID0bzfvDoQHZ/isoamgPkTjNJUNuqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9ICZVdiEoDVRJZKyhsY+gBZmYNK7DGL3Q62ipF6+ti/bd8cd6b6yXJ2WoreRx1HB
         OPY2tubK512YqGPfs8N6trCMbqii2+BGltELS+X8MrFh8jOzDc14AtsHhNHzrbMEIN
         /mN8G6YKGZ7kMK4gJVnZK0p7ZwY7DEwk9HKnT3Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amol Grover <frextrite@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/309] tracing: Annotate ftrace_graph_notrace_hash pointer with __rcu
Date:   Mon, 10 Feb 2020 04:31:34 -0800
Message-Id: <20200210122419.615601711@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amol Grover <frextrite@gmail.com>

[ Upstream commit fd0e6852c407dd9aefc594f54ddcc21d84803d3b ]

Fix following instances of sparse error
kernel/trace/ftrace.c:5667:29: error: incompatible types in comparison
kernel/trace/ftrace.c:5813:21: error: incompatible types in comparison
kernel/trace/ftrace.c:5868:36: error: incompatible types in comparison
kernel/trace/ftrace.c:5870:25: error: incompatible types in comparison

Use rcu_dereference_protected to dereference the newly annotated pointer.

Link: http://lkml.kernel.org/r/20200205055701.30195-1-frextrite@gmail.com

Signed-off-by: Amol Grover <frextrite@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 2 +-
 kernel/trace/trace.h  | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b38c6af10da5b..d297a8bdc681a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5103,7 +5103,7 @@ static const struct file_operations ftrace_notrace_fops = {
 static DEFINE_MUTEX(graph_lock);
 
 struct ftrace_hash __rcu *ftrace_graph_hash = EMPTY_HASH;
-struct ftrace_hash *ftrace_graph_notrace_hash = EMPTY_HASH;
+struct ftrace_hash __rcu *ftrace_graph_notrace_hash = EMPTY_HASH;
 
 enum graph_filter_type {
 	GRAPH_FILTER_NOTRACE	= 0,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f8fb3786af72a..c4fd5731d6b37 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -933,7 +933,7 @@ extern void __trace_graph_return(struct trace_array *tr,
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 extern struct ftrace_hash __rcu *ftrace_graph_hash;
-extern struct ftrace_hash *ftrace_graph_notrace_hash;
+extern struct ftrace_hash __rcu *ftrace_graph_notrace_hash;
 
 static inline int ftrace_graph_addr(struct ftrace_graph_ent *trace)
 {
@@ -986,10 +986,14 @@ static inline void ftrace_graph_addr_finish(struct ftrace_graph_ret *trace)
 static inline int ftrace_graph_notrace_addr(unsigned long addr)
 {
 	int ret = 0;
+	struct ftrace_hash *notrace_hash;
 
 	preempt_disable_notrace();
 
-	if (ftrace_lookup_ip(ftrace_graph_notrace_hash, addr))
+	notrace_hash = rcu_dereference_protected(ftrace_graph_notrace_hash,
+						 !preemptible());
+
+	if (ftrace_lookup_ip(notrace_hash, addr))
 		ret = 1;
 
 	preempt_enable_notrace();
-- 
2.20.1



