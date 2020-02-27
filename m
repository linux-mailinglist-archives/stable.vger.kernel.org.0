Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE151720C0
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbgB0Nqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:46:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730571AbgB0Nqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:46:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FA8A20578;
        Thu, 27 Feb 2020 13:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811204;
        bh=MMngjTS2tWGZAVOBbLke4DOA0L+3bxPVtTevO3i2o10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rh2Ogkob40kWNnQfe6AhNoaMqY5v+li8gKkEZbAC1mSnqshDYtCgJN3ZOmBOh3Bmo
         SN40YD9tEKJCJ09qFlVDcarzjrPS7ITWa9+Wp7hGCi0mcDZaVjPPH0XHdp81ZJ8laT
         DLQxjLNV3P2v8tzFD+pkwt/sIONbxndKc99zSMjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luis Henriques <luis.henriques@canonical.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 041/165] tracing: Fix very unlikely race of registering two stat tracers
Date:   Thu, 27 Feb 2020 14:35:15 +0100
Message-Id: <20200227132237.189408865@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

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
index bc97b10e56ccc..d19f2191960ea 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -305,7 +305,7 @@ static int init_stat_file(struct stat_session *session)
 int register_stat_tracer(struct tracer_stat *trace)
 {
 	struct stat_session *session, *node;
-	int ret;
+	int ret = -EINVAL;
 
 	if (!trace)
 		return -EINVAL;
@@ -316,17 +316,15 @@ int register_stat_tracer(struct tracer_stat *trace)
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
@@ -335,15 +333,16 @@ int register_stat_tracer(struct tracer_stat *trace)
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



