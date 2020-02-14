Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4948C15DE86
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389743AbgBNQDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:03:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:51204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389735AbgBNQDp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:03:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19BAC2187F;
        Fri, 14 Feb 2020 16:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696224;
        bh=2DEVYckG1Isw7Gpf1hE/FTwDQ6blhZY+jWLtm5XiNLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQFXnrYNn1wG+rsBPnl1td6JZ/PMr78QKEylmtPNgZjMU2IlxKIE83HqalFDvj1eF
         1CsJbOoEIzaFsOVodLdEeDC+ehWLl2mvJQkdFJI24bFs5upNaXMRRdD6ZWOtG9vnGU
         M8a+3/RuhLm1LHzhbqn9i17JzTESY3hWgEpGlmp4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 087/459] tracing: Fix very unlikely race of registering two stat tracers
Date:   Fri, 14 Feb 2020 10:55:37 -0500
Message-Id: <20200214160149.11681-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

[ Upstream commit dfb6cd1e654315168e36d947471bd2a0ccd834ae ]

Looking through old emails in my INBOX, I came across a patch from Luis
Henriques that attempted to fix a race of two stat tracers registering the
same stat trace (extremely unlikely, as this is done in the kernel, and
probably doesn't even exist). The submitted patch wasn't quite right as it
needed to deal with clean up a bit better (if two stat tracers were the
same, it would have the same files).

But to make the code cleaner, all we needed to do is to keep the
all_stat_sessions_mutex held for most of the registering function.

Link: http://lkml.kernel.org/r/1410299375-20068-1-git-send-email-luis.henriques@canonical.com

Fixes: 002bb86d8d42f ("tracing/ftrace: separate events tracing and stats tracing engine")
Reported-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_stat.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 1257dc6c07796..3c9c17feea333 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -310,7 +310,7 @@ static int init_stat_file(struct stat_session *session)
 int register_stat_tracer(struct tracer_stat *trace)
 {
 	struct stat_session *session, *node;
-	int ret;
+	int ret = -EINVAL;
 
 	if (!trace)
 		return -EINVAL;
@@ -321,17 +321,15 @@ int register_stat_tracer(struct tracer_stat *trace)
 	/* Already registered? */
 	mutex_lock(&all_stat_sessions_mutex);
 	list_for_each_entry(node, &all_stat_sessions, session_list) {
-		if (node->ts == trace) {
-			mutex_unlock(&all_stat_sessions_mutex);
-			return -EINVAL;
-		}
+		if (node->ts == trace)
+			goto out;
 	}
-	mutex_unlock(&all_stat_sessions_mutex);
 
+	ret = -ENOMEM;
 	/* Init the session */
 	session = kzalloc(sizeof(*session), GFP_KERNEL);
 	if (!session)
-		return -ENOMEM;
+		goto out;
 
 	session->ts = trace;
 	INIT_LIST_HEAD(&session->session_list);
@@ -340,15 +338,16 @@ int register_stat_tracer(struct tracer_stat *trace)
 	ret = init_stat_file(session);
 	if (ret) {
 		destroy_session(session);
-		return ret;
+		goto out;
 	}
 
+	ret = 0;
 	/* Register */
-	mutex_lock(&all_stat_sessions_mutex);
 	list_add_tail(&session->session_list, &all_stat_sessions);
+ out:
 	mutex_unlock(&all_stat_sessions_mutex);
 
-	return 0;
+	return ret;
 }
 
 void unregister_stat_tracer(struct tracer_stat *trace)
-- 
2.20.1

