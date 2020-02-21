Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D94D167831
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgBUHr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:47:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728913AbgBUHr1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:47:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98A7720801;
        Fri, 21 Feb 2020 07:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271245;
        bh=y/fHO2NUkuUAl0Ye179CG0J01vFCflv+yegSPsLRYk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JW+EMHOX64XSI7Vu/p2Lcc5U+K3Y2FhC/FLr6Ngb7CJyUlSLjMKu0FJ0fqSoON/VL
         jNuAcP06RTxqEWJiSnH/MzGa8QIM87UMuixkHWge4QY+G4Mlc3zqFlrv6fS580eZgF
         lN3qaTL1SuxImXN/Lwx8bHOq6DwLkdCIiBIeG12g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 093/399] tracing: Simplify assignment parsing for hist triggers
Date:   Fri, 21 Feb 2020 08:36:58 +0100
Message-Id: <20200221072411.383968851@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Zanussi <zanussi@kernel.org>

[ Upstream commit b527b638fd63ba791dc90a0a6e9a3035b10df52b ]

In the process of adding better error messages for sorting, I realized
that strsep was being used incorrectly and some of the error paths I
was expecting to be hit weren't and just fell through to the common
invalid key error case.

It also became obvious that for keyword assignments, it wasn't
necessary to save the full assignment and reparse it later, and having
a common empty-assignment check would also make more sense in terms of
error processing.

Change the code to fix these problems and simplify it for new error
message changes in a subsequent patch.

Link: http://lkml.kernel.org/r/1c3ef0b6655deaf345f6faee2584a0298ac2d743.1561743018.git.zanussi@kernel.org

Fixes: e62347d24534 ("tracing: Add hist trigger support for user-defined sorting ('sort=' param)")
Fixes: 7ef224d1d0e3 ("tracing: Add 'hist' event trigger command")
Fixes: a4072fe85ba3 ("tracing: Add a clock attribute for hist triggers")
Reported-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 70 ++++++++++++--------------------
 1 file changed, 27 insertions(+), 43 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 6ac35b9e195de..48f9075e4fa18 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2035,12 +2035,6 @@ static int parse_map_size(char *str)
 	unsigned long size, map_bits;
 	int ret;
 
-	strsep(&str, "=");
-	if (!str) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	ret = kstrtoul(str, 0, &size);
 	if (ret)
 		goto out;
@@ -2100,25 +2094,25 @@ static int parse_action(char *str, struct hist_trigger_attrs *attrs)
 static int parse_assignment(struct trace_array *tr,
 			    char *str, struct hist_trigger_attrs *attrs)
 {
-	int ret = 0;
+	int len, ret = 0;
 
-	if ((str_has_prefix(str, "key=")) ||
-	    (str_has_prefix(str, "keys="))) {
-		attrs->keys_str = kstrdup(str, GFP_KERNEL);
+	if ((len = str_has_prefix(str, "key=")) ||
+	    (len = str_has_prefix(str, "keys="))) {
+		attrs->keys_str = kstrdup(str + len, GFP_KERNEL);
 		if (!attrs->keys_str) {
 			ret = -ENOMEM;
 			goto out;
 		}
-	} else if ((str_has_prefix(str, "val=")) ||
-		   (str_has_prefix(str, "vals=")) ||
-		   (str_has_prefix(str, "values="))) {
-		attrs->vals_str = kstrdup(str, GFP_KERNEL);
+	} else if ((len = str_has_prefix(str, "val=")) ||
+		   (len = str_has_prefix(str, "vals=")) ||
+		   (len = str_has_prefix(str, "values="))) {
+		attrs->vals_str = kstrdup(str + len, GFP_KERNEL);
 		if (!attrs->vals_str) {
 			ret = -ENOMEM;
 			goto out;
 		}
-	} else if (str_has_prefix(str, "sort=")) {
-		attrs->sort_key_str = kstrdup(str, GFP_KERNEL);
+	} else if ((len = str_has_prefix(str, "sort="))) {
+		attrs->sort_key_str = kstrdup(str + len, GFP_KERNEL);
 		if (!attrs->sort_key_str) {
 			ret = -ENOMEM;
 			goto out;
@@ -2129,12 +2123,8 @@ static int parse_assignment(struct trace_array *tr,
 			ret = -ENOMEM;
 			goto out;
 		}
-	} else if (str_has_prefix(str, "clock=")) {
-		strsep(&str, "=");
-		if (!str) {
-			ret = -EINVAL;
-			goto out;
-		}
+	} else if ((len = str_has_prefix(str, "clock="))) {
+		str += len;
 
 		str = strstrip(str);
 		attrs->clock = kstrdup(str, GFP_KERNEL);
@@ -2142,8 +2132,8 @@ static int parse_assignment(struct trace_array *tr,
 			ret = -ENOMEM;
 			goto out;
 		}
-	} else if (str_has_prefix(str, "size=")) {
-		int map_bits = parse_map_size(str);
+	} else if ((len = str_has_prefix(str, "size="))) {
+		int map_bits = parse_map_size(str + len);
 
 		if (map_bits < 0) {
 			ret = map_bits;
@@ -2183,8 +2173,14 @@ parse_hist_trigger_attrs(struct trace_array *tr, char *trigger_str)
 
 	while (trigger_str) {
 		char *str = strsep(&trigger_str, ":");
+		char *rhs;
 
-		if (strchr(str, '=')) {
+		rhs = strchr(str, '=');
+		if (rhs) {
+			if (!strlen(++rhs)) {
+				ret = -EINVAL;
+				goto free;
+			}
 			ret = parse_assignment(tr, str, attrs);
 			if (ret)
 				goto free;
@@ -4536,10 +4532,6 @@ static int create_val_fields(struct hist_trigger_data *hist_data,
 	if (!fields_str)
 		goto out;
 
-	strsep(&fields_str, "=");
-	if (!fields_str)
-		goto out;
-
 	for (i = 0, j = 1; i < TRACING_MAP_VALS_MAX &&
 		     j < TRACING_MAP_VALS_MAX; i++) {
 		field_str = strsep(&fields_str, ",");
@@ -4634,10 +4626,6 @@ static int create_key_fields(struct hist_trigger_data *hist_data,
 	if (!fields_str)
 		goto out;
 
-	strsep(&fields_str, "=");
-	if (!fields_str)
-		goto out;
-
 	for (i = n_vals; i < n_vals + TRACING_MAP_KEYS_MAX; i++) {
 		field_str = strsep(&fields_str, ",");
 		if (!field_str)
@@ -4795,12 +4783,6 @@ static int create_sort_keys(struct hist_trigger_data *hist_data)
 	if (!fields_str)
 		goto out;
 
-	strsep(&fields_str, "=");
-	if (!fields_str) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	for (i = 0; i < TRACING_MAP_SORT_KEYS_MAX; i++) {
 		struct hist_field *hist_field;
 		char *field_str, *field_name;
@@ -4809,9 +4791,11 @@ static int create_sort_keys(struct hist_trigger_data *hist_data)
 		sort_key = &hist_data->sort_keys[i];
 
 		field_str = strsep(&fields_str, ",");
-		if (!field_str) {
-			if (i == 0)
-				ret = -EINVAL;
+		if (!field_str)
+			break;
+
+		if (!*field_str) {
+			ret = -EINVAL;
 			break;
 		}
 
@@ -4821,7 +4805,7 @@ static int create_sort_keys(struct hist_trigger_data *hist_data)
 		}
 
 		field_name = strsep(&field_str, ".");
-		if (!field_name) {
+		if (!field_name || !*field_name) {
 			ret = -EINVAL;
 			break;
 		}
-- 
2.20.1



