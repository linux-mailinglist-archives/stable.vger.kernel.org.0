Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C99521676B9
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731588AbgBUIET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:04:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:37322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731437AbgBUIES (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:04:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE9CA20801;
        Fri, 21 Feb 2020 08:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272257;
        bh=5dQMOiJmjWlSjouuPG3tiHIvAXM2w5jjgSTdp4ZaJsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvPR/0aVSkR47lZXkRd4uITFDVcRsXM18z+D3teHw6/0iNBEZ4pMA2Ks+L1sJceEM
         jYhad5VoV31GmUI6/0WTxRF43ZXlZS0uMlgT9iVotOwHp5ijFIQXvFkzAXiknCr9Lq
         wOo47uE9xmVDPnlZ3hKgSHRHZdhWOJnD2G848mYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luis Henriques <luis.henriques@canonical.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/344] tracing: Fix very unlikely race of registering two stat tracers
Date:   Fri, 21 Feb 2020 08:37:54 +0100
Message-Id: <20200221072355.801787500@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
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



