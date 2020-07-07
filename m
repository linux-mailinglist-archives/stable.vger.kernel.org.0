Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8188F2170B6
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbgGGPUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbgGGPTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:19:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF0F52065D;
        Tue,  7 Jul 2020 15:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135194;
        bh=IKRcYbDIFHiIBRV8TpFGBWYGnR6Vj1rFMLD4iE/uvww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/gEFadkt2IeOzhPSikGLfnkNW34+z5L8CsNyGN4ZHMLaz+vuhAAY0y61k7AKs8D4
         2TR0KN2dIKbTXpQuASSfgBNoQDYpVtt8dcH3yv3Qc3CT4yyFp+4lhy1XOOXHNCHzcC
         0IOXulRQJ5E+Oe5uSH9aveAzoRI4zdn/8KXGcNmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jaewon Kim <jaewon31.kim@samsung.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Kees Kook <keescook@chromium.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/65] tools lib traceevent: Handle __attribute__((user)) in field names
Date:   Tue,  7 Jul 2020 17:16:50 +0200
Message-Id: <20200707145752.996517502@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit 74621d929d944529a5e2878a84f48bfa6fb69a66 ]

Commit c61f13eaa1ee1 ("gcc-plugins: Add structleak for more stack
initialization") added "__attribute__((user))" to the user when
stackleak detector is enabled. This now appears in the field format of
system call trace events for system calls that have user buffers. The
"__attribute__((user))" breaks the parsing in libtraceevent. That needs
to be handled.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kees Kook <keescook@chromium.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200324200956.663647256@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 39 +++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 4bc3e1b906652..798284f511f16 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1444,6 +1444,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 	enum tep_event_type type;
 	char *token;
 	char *last_token;
+	char *delim = " ";
 	int count = 0;
 	int ret;
 
@@ -1504,13 +1505,49 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 					field->flags |= TEP_FIELD_IS_POINTER;
 
 				if (field->type) {
-					ret = append(&field->type, " ", last_token);
+					ret = append(&field->type, delim, last_token);
 					free(last_token);
 					if (ret < 0)
 						goto fail;
 				} else
 					field->type = last_token;
 				last_token = token;
+				delim = " ";
+				continue;
+			}
+
+			/* Handle __attribute__((user)) */
+			if ((type == TEP_EVENT_DELIM) &&
+			    strcmp("__attribute__", last_token) == 0 &&
+			    token[0] == '(') {
+				int depth = 1;
+				int ret;
+
+				ret = append(&field->type, " ", last_token);
+				ret |= append(&field->type, "", "(");
+				if (ret < 0)
+					goto fail;
+
+				delim = " ";
+				while ((type = read_token(&token)) != TEP_EVENT_NONE) {
+					if (type == TEP_EVENT_DELIM) {
+						if (token[0] == '(')
+							depth++;
+						else if (token[0] == ')')
+							depth--;
+						if (!depth)
+							break;
+						ret = append(&field->type, "", token);
+						delim = "";
+					} else {
+						ret = append(&field->type, delim, token);
+						delim = " ";
+					}
+					if (ret < 0)
+						goto fail;
+					free(last_token);
+					last_token = token;
+				}
 				continue;
 			}
 			break;
-- 
2.25.1



