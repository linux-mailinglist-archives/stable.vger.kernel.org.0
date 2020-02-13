Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4579C15C5D1
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgBMPZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:25:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728903AbgBMPZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:04 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5C6D246A4;
        Thu, 13 Feb 2020 15:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607503;
        bh=70flgQxNwh5hYgsNI8djhEjl8EqUBmy1+5Jcyh62HQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruIOeIwOyvGMqJpZwCrHDSXYSpooY20GaTJRlhTlXg0Q9Fca//C5USRy7OlABIequ
         YypCGCIkooN9U0CZ9IUNtQwcb4l0T9b5wgLW3JltzeBYSG6s1IlgsLXNQnH+hvmaw9
         RQ48EKdPYFX1T8chNFBZ8KXIUQT0e0Z/iDEuNGqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 060/173] ftrace: Add comment to why rcu_dereference_sched() is open coded
Date:   Thu, 13 Feb 2020 07:19:23 -0800
Message-Id: <20200213151948.956357608@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit 16052dd5bdfa16dbe18d8c1d4cde2ddab9d23177 ]

Because the function graph tracer can execute in sections where RCU is not
"watching", the rcu_dereference_sched() for the has needs to be open coded.
This is fine because the RCU "flavor" of the ftrace hash is protected by
its own RCU handling (it does its own little synchronization on every CPU
and does not rely on RCU sched).

Acked-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 757bb1bffed99..99af95e294d8d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -879,6 +879,11 @@ static inline int ftrace_graph_addr(struct ftrace_graph_ent *trace)
 
 	preempt_disable_notrace();
 
+	/*
+	 * Have to open code "rcu_dereference_sched()" because the
+	 * function graph tracer can be called when RCU is not
+	 * "watching".
+	 */
 	hash = rcu_dereference_protected(ftrace_graph_hash, !preemptible());
 
 	if (ftrace_hash_empty(hash)) {
@@ -926,6 +931,11 @@ static inline int ftrace_graph_notrace_addr(unsigned long addr)
 
 	preempt_disable_notrace();
 
+	/*
+	 * Have to open code "rcu_dereference_sched()" because the
+	 * function graph tracer can be called when RCU is not
+	 * "watching".
+	 */
 	notrace_hash = rcu_dereference_protected(ftrace_graph_notrace_hash,
 						 !preemptible());
 
-- 
2.20.1



