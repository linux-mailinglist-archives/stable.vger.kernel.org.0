Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F22B1577C3
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgBJMk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbgBJMk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:27 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 714AB20838;
        Mon, 10 Feb 2020 12:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338427;
        bh=LS6bO+2ivjG44XY+zOXDTWo7bKb8WeGQ05o1WT4qEzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTNEgAzvJESKZ/cqsdiwc6U+5qT7TSpCEV9t20DfuRAm98wLRpDTpJVFDfwJcELTf
         Lsh3GRjBuf54e8NtAhb01qoUyQ16wOPBFwYuVxU+tPuqb2ItfoPOdc0eoMU8pkrmUk
         qIwQn21nrN9xRc1q+ytHL3Gm1RMiHM/MZBtIGVp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amol Grover <frextrite@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 151/367] tracing: Annotate ftrace_graph_notrace_hash pointer with __rcu
Date:   Mon, 10 Feb 2020 04:31:04 -0800
Message-Id: <20200210122438.777417716@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
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
index 959ded08dc13f..e85668cdd8c73 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5597,7 +5597,7 @@ static const struct file_operations ftrace_notrace_fops = {
 static DEFINE_MUTEX(graph_lock);
 
 struct ftrace_hash __rcu *ftrace_graph_hash = EMPTY_HASH;
-struct ftrace_hash *ftrace_graph_notrace_hash = EMPTY_HASH;
+struct ftrace_hash __rcu *ftrace_graph_notrace_hash = EMPTY_HASH;
 
 enum graph_filter_type {
 	GRAPH_FILTER_NOTRACE	= 0,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 97dad33260208..497defe9ed264 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -951,7 +951,7 @@ extern void __trace_graph_return(struct trace_array *tr,
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 extern struct ftrace_hash __rcu *ftrace_graph_hash;
-extern struct ftrace_hash *ftrace_graph_notrace_hash;
+extern struct ftrace_hash __rcu *ftrace_graph_notrace_hash;
 
 static inline int ftrace_graph_addr(struct ftrace_graph_ent *trace)
 {
@@ -1004,10 +1004,14 @@ static inline void ftrace_graph_addr_finish(struct ftrace_graph_ret *trace)
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



