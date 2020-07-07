Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8063E2170D5
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgGGPVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729642AbgGGPVG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:21:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F044C20663;
        Tue,  7 Jul 2020 15:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135265;
        bh=S3KLbkQ6IOnMwXCM22w0HlZk3j5lz12lCVxAvrXIe6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ar18+ym8s6wuHi8pEAI8mh63UczRORNYzLIwO0gvepwUTzzM3QMchBqess0RFHYhV
         a82oGqZpR0iUeIVsqIMDSa7dr1Dvy2Xf/insnCRscCQUJ1cPiMvnATjAyACdLaGK8Y
         6+tXi0G6hA2L7RpTav1fpSzStmA8Vh6s+wBqKfnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jaewon Lim <jaewon31.kim@samsung.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Kees Kook <keescook@chromium.org>, linux-mm@kvack.org,
        linux-trace-devel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/65] tools lib traceevent: Add append() function helper for appending strings
Date:   Tue,  7 Jul 2020 17:16:49 +0200
Message-Id: <20200707145752.948683510@linuxfoundation.org>
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

[ Upstream commit 27d4d336f2872193e90ee5450559e1699fae0f6d ]

There's several locations that open code realloc and strcat() to append
text to strings. Add an append() function that takes a delimiter and a
string to append to another string.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jaewon Lim <jaewon31.kim@samsung.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kees Kook <keescook@chromium.org>
Cc: linux-mm@kvack.org
Cc: linux-trace-devel@vger.kernel.org
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Link: http://lore.kernel.org/lkml/20200324200956.515118403@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 98 ++++++++++++------------------
 1 file changed, 40 insertions(+), 58 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index d948475585ced..4bc3e1b906652 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1425,6 +1425,19 @@ static unsigned int type_size(const char *name)
 	return 0;
 }
 
+static int append(char **buf, const char *delim, const char *str)
+{
+	char *new_buf;
+
+	new_buf = realloc(*buf, strlen(*buf) + strlen(delim) + strlen(str) + 1);
+	if (!new_buf)
+		return -1;
+	strcat(new_buf, delim);
+	strcat(new_buf, str);
+	*buf = new_buf;
+	return 0;
+}
+
 static int event_read_fields(struct tep_event *event, struct tep_format_field **fields)
 {
 	struct tep_format_field *field = NULL;
@@ -1432,6 +1445,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 	char *token;
 	char *last_token;
 	int count = 0;
+	int ret;
 
 	do {
 		unsigned int size_dynamic = 0;
@@ -1490,24 +1504,15 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 					field->flags |= TEP_FIELD_IS_POINTER;
 
 				if (field->type) {
-					char *new_type;
-					new_type = realloc(field->type,
-							   strlen(field->type) +
-							   strlen(last_token) + 2);
-					if (!new_type) {
-						free(last_token);
-						goto fail;
-					}
-					field->type = new_type;
-					strcat(field->type, " ");
-					strcat(field->type, last_token);
+					ret = append(&field->type, " ", last_token);
 					free(last_token);
+					if (ret < 0)
+						goto fail;
 				} else
 					field->type = last_token;
 				last_token = token;
 				continue;
 			}
-
 			break;
 		}
 
@@ -1523,8 +1528,6 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 		if (strcmp(token, "[") == 0) {
 			enum tep_event_type last_type = type;
 			char *brackets = token;
-			char *new_brackets;
-			int len;
 
 			field->flags |= TEP_FIELD_IS_ARRAY;
 
@@ -1536,29 +1539,27 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 				field->arraylen = 0;
 
 		        while (strcmp(token, "]") != 0) {
+				const char *delim;
+
 				if (last_type == TEP_EVENT_ITEM &&
 				    type == TEP_EVENT_ITEM)
-					len = 2;
+					delim = " ";
 				else
-					len = 1;
+					delim = "";
+
 				last_type = type;
 
-				new_brackets = realloc(brackets,
-						       strlen(brackets) +
-						       strlen(token) + len);
-				if (!new_brackets) {
+				ret = append(&brackets, delim, token);
+				if (ret < 0) {
 					free(brackets);
 					goto fail;
 				}
-				brackets = new_brackets;
-				if (len == 2)
-					strcat(brackets, " ");
-				strcat(brackets, token);
 				/* We only care about the last token */
 				field->arraylen = strtoul(token, NULL, 0);
 				free_token(token);
 				type = read_token(&token);
 				if (type == TEP_EVENT_NONE) {
+					free(brackets);
 					do_warning_event(event, "failed to find token");
 					goto fail;
 				}
@@ -1566,13 +1567,11 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 
 			free_token(token);
 
-			new_brackets = realloc(brackets, strlen(brackets) + 2);
-			if (!new_brackets) {
+			ret = append(&brackets, "", "]");
+			if (ret < 0) {
 				free(brackets);
 				goto fail;
 			}
-			brackets = new_brackets;
-			strcat(brackets, "]");
 
 			/* add brackets to type */
 
@@ -1582,34 +1581,23 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 			 * the format: type [] item;
 			 */
 			if (type == TEP_EVENT_ITEM) {
-				char *new_type;
-				new_type = realloc(field->type,
-						   strlen(field->type) +
-						   strlen(field->name) +
-						   strlen(brackets) + 2);
-				if (!new_type) {
+				ret = append(&field->type, " ", field->name);
+				if (ret < 0) {
 					free(brackets);
 					goto fail;
 				}
-				field->type = new_type;
-				strcat(field->type, " ");
-				strcat(field->type, field->name);
+				ret = append(&field->type, "", brackets);
+
 				size_dynamic = type_size(field->name);
 				free_token(field->name);
-				strcat(field->type, brackets);
 				field->name = field->alias = token;
 				type = read_token(&token);
 			} else {
-				char *new_type;
-				new_type = realloc(field->type,
-						   strlen(field->type) +
-						   strlen(brackets) + 1);
-				if (!new_type) {
+				ret = append(&field->type, "", brackets);
+				if (ret < 0) {
 					free(brackets);
 					goto fail;
 				}
-				field->type = new_type;
-				strcat(field->type, brackets);
 			}
 			free(brackets);
 		}
@@ -2046,19 +2034,16 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 		/* could just be a type pointer */
 		if ((strcmp(arg->op.op, "*") == 0) &&
 		    type == TEP_EVENT_DELIM && (strcmp(token, ")") == 0)) {
-			char *new_atom;
+			int ret;
 
 			if (left->type != TEP_PRINT_ATOM) {
 				do_warning_event(event, "bad pointer type");
 				goto out_free;
 			}
-			new_atom = realloc(left->atom.atom,
-					    strlen(left->atom.atom) + 3);
-			if (!new_atom)
+			ret = append(&left->atom.atom, " ", "*");
+			if (ret < 0)
 				goto out_warn_free;
 
-			left->atom.atom = new_atom;
-			strcat(left->atom.atom, " *");
 			free(arg->op.op);
 			*arg = *left;
 			free(left);
@@ -3151,18 +3136,15 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 		}
 		/* atoms can be more than one token long */
 		while (type == TEP_EVENT_ITEM) {
-			char *new_atom;
-			new_atom = realloc(atom,
-					   strlen(atom) + strlen(token) + 2);
-			if (!new_atom) {
+			int ret;
+
+			ret = append(&atom, " ", token);
+			if (ret < 0) {
 				free(atom);
 				*tok = NULL;
 				free_token(token);
 				return TEP_EVENT_ERROR;
 			}
-			atom = new_atom;
-			strcat(atom, " ");
-			strcat(atom, token);
 			free_token(token);
 			type = read_token_item(&token);
 		}
-- 
2.25.1



