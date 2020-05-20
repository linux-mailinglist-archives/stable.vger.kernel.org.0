Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015351DB678
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgETOZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:25:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33176 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727065AbgETOW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPby-00037e-Dp; Wed, 20 May 2020 15:22:22 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbw-007DUQ-GN; Wed, 20 May 2020 15:22:20 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        "Luis Henriques" <luis.henriques@canonical.com>
Date:   Wed, 20 May 2020 15:14:37 +0100
Message-ID: <lsq.1589984009.835833982@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 69/99] tracing: Fix very unlikely race of registering
 two stat tracers
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

commit dfb6cd1e654315168e36d947471bd2a0ccd834ae upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/trace_stat.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -302,7 +302,7 @@ static int init_stat_file(struct stat_se
 int register_stat_tracer(struct tracer_stat *trace)
 {
 	struct stat_session *session, *node;
-	int ret;
+	int ret = -EINVAL;
 
 	if (!trace)
 		return -EINVAL;
@@ -313,17 +313,15 @@ int register_stat_tracer(struct tracer_s
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
@@ -332,15 +330,16 @@ int register_stat_tracer(struct tracer_s
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

