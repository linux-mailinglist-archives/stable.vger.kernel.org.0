Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD6715EE69
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389938AbgBNRjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:39:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:51962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389809AbgBNQEH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:04:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53C65217F4;
        Fri, 14 Feb 2020 16:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696247;
        bh=Bder6H6v+8vZj+HHIqzkVKXYCG1a6QBzUr2WFqJFoAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZK0pgOmOA2m3p/Vlrn10K+pGkMZI03O28G1suOPJYVSJpke90/clbejJV09YZX5vM
         a3NDVVeBdiDUlVVcLBRYfwtzE0jfJSnr3xjvUBR3yKbvRQCOckpjvt5UQmvhCGFWVv
         gdkpzJwzU1J9eLyqTXBgoQ4hzdLuzFDFtEkc9XhA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 104/459] tracing: Simplify assignment parsing for hist triggers
Date:   Fri, 14 Feb 2020 10:55:54 -0500
Message-Id: <20200214160149.11681-104-sashal@kernel.org>
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
index 4be7fc84d6b6a..a31be3fce3e8e 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2037,12 +2037,6 @@ static int parse_map_size(char *str)
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
@@ -2102,25 +2096,25 @@ static int parse_action(char *str, struct hist_trigger_attrs *attrs)
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
@@ -2131,12 +2125,8 @@ static int parse_assignment(struct trace_array *tr,
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
@@ -2144,8 +2134,8 @@ static int parse_assignment(struct trace_array *tr,
 			ret = -ENOMEM;
 			goto out;
 		}
-	} else if (str_has_prefix(str, "size=")) {
-		int map_bits = parse_map_size(str);
+	} else if ((len = str_has_prefix(str, "size="))) {
+		int map_bits = parse_map_size(str + len);
 
 		if (map_bits < 0) {
 			ret = map_bits;
@@ -2185,8 +2175,14 @@ parse_hist_trigger_attrs(struct trace_array *tr, char *trigger_str)
 
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
@@ -4559,10 +4555,6 @@ static int create_val_fields(struct hist_trigger_data *hist_data,
 	if (!fields_str)
 		goto out;
 
-	strsep(&fields_str, "=");
-	if (!fields_str)
-		goto out;
-
 	for (i = 0, j = 1; i < TRACING_MAP_VALS_MAX &&
 		     j < TRACING_MAP_VALS_MAX; i++) {
 		field_str = strsep(&fields_str, ",");
@@ -4657,10 +4649,6 @@ static int create_key_fields(struct hist_trigger_data *hist_data,
 	if (!fields_str)
 		goto out;
 
-	strsep(&fields_str, "=");
-	if (!fields_str)
-		goto out;
-
 	for (i = n_vals; i < n_vals + TRACING_MAP_KEYS_MAX; i++) {
 		field_str = strsep(&fields_str, ",");
 		if (!field_str)
@@ -4818,12 +4806,6 @@ static int create_sort_keys(struct hist_trigger_data *hist_data)
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
@@ -4832,9 +4814,11 @@ static int create_sort_keys(struct hist_trigger_data *hist_data)
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
 
@@ -4844,7 +4828,7 @@ static int create_sort_keys(struct hist_trigger_data *hist_data)
 		}
 
 		field_name = strsep(&field_str, ".");
-		if (!field_name) {
+		if (!field_name || !*field_name) {
 			ret = -EINVAL;
 			break;
 		}
-- 
2.20.1

