Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881C44CF916
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239659AbiCGKDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240700AbiCGKBN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FCE60CDC;
        Mon,  7 Mar 2022 01:50:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D268B810DB;
        Mon,  7 Mar 2022 09:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7078FC340F5;
        Mon,  7 Mar 2022 09:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646635;
        bh=H62Pa9TB5DcGbjeRngxOfMiTImh+GHsLdwD6eP3n3iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9dAUsko2aSvOI4wwfcIhzdpUh05G/fjeQ96HWgcuCYy4PchqDJjt/T+ltgRVNrHe
         8pUocZ2N70lAsNXKKkGxjpSWXNiAUcibQ8vWwCRRVGClSoZVdwRA4bpickNpr2gkWB
         AZ8xcbCIkn4+Nf49z640T+tOpij3NTaAoBZ4ms2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 044/186] tracing: Add ustring operation to filtering string pointers
Date:   Mon,  7 Mar 2022 10:18:02 +0100
Message-Id: <20220307091655.327700063@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit f37c3bbc635994eda203a6da4ba0f9d05165a8d6 ]

Since referencing user space pointers is special, if the user wants to
filter on a field that is a pointer to user space, then they need to
specify it.

Add a ".ustring" attribute to the field name for filters to state that the
field is pointing to user space such that the kernel can take the
appropriate action to read that pointer.

Link: https://lore.kernel.org/all/yt9d8rvmt2jq.fsf@linux.ibm.com/

Fixes: 77360f9bbc7e ("tracing: Add test for user space strings when filtering on string pointers")
Tested-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/events.rst     |  9 ++++
 kernel/trace/trace_events_filter.c | 81 +++++++++++++++++++++---------
 2 files changed, 66 insertions(+), 24 deletions(-)

diff --git a/Documentation/trace/events.rst b/Documentation/trace/events.rst
index 45e66a60a816a..c47f381d0c002 100644
--- a/Documentation/trace/events.rst
+++ b/Documentation/trace/events.rst
@@ -198,6 +198,15 @@ The glob (~) accepts a wild card character (\*,?) and character classes
   prev_comm ~ "*sh*"
   prev_comm ~ "ba*sh"
 
+If the field is a pointer that points into user space (for example
+"filename" from sys_enter_openat), then you have to append ".ustring" to the
+field name::
+
+  filename.ustring ~ "password"
+
+As the kernel will have to know how to retrieve the memory that the pointer
+is at from user space.
+
 5.2 Setting filters
 -------------------
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index d3eb3c630f601..06d6318ee5377 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -665,6 +665,23 @@ struct ustring_buffer {
 static __percpu struct ustring_buffer *ustring_per_cpu;
 
 static __always_inline char *test_string(char *str)
+{
+	struct ustring_buffer *ubuf;
+	char *kstr;
+
+	if (!ustring_per_cpu)
+		return NULL;
+
+	ubuf = this_cpu_ptr(ustring_per_cpu);
+	kstr = ubuf->buffer;
+
+	/* For safety, do not trust the string pointer */
+	if (!strncpy_from_kernel_nofault(kstr, str, USTRING_BUF_SIZE))
+		return NULL;
+	return kstr;
+}
+
+static __always_inline char *test_ustring(char *str)
 {
 	struct ustring_buffer *ubuf;
 	char __user *ustr;
@@ -676,23 +693,11 @@ static __always_inline char *test_string(char *str)
 	ubuf = this_cpu_ptr(ustring_per_cpu);
 	kstr = ubuf->buffer;
 
-	/*
-	 * We use TASK_SIZE to denote user or kernel space, but this will
-	 * not work for all architectures. If it picks the wrong one, it may
-	 * just fail the filter (but will not bug).
-	 *
-	 * TODO: Have a way to properly denote which one this is for.
-	 */
-	if (likely((unsigned long)str >= TASK_SIZE)) {
-		/* For safety, do not trust the string pointer */
-		if (!strncpy_from_kernel_nofault(kstr, str, USTRING_BUF_SIZE))
-			return NULL;
-	} else {
-		/* user space address? */
-		ustr = (char __user *)str;
-		if (!strncpy_from_user_nofault(kstr, ustr, USTRING_BUF_SIZE))
-			return NULL;
-	}
+	/* user space address? */
+	ustr = (char __user *)str;
+	if (!strncpy_from_user_nofault(kstr, ustr, USTRING_BUF_SIZE))
+		return NULL;
+
 	return kstr;
 }
 
@@ -709,24 +714,42 @@ static int filter_pred_string(struct filter_pred *pred, void *event)
 	return match;
 }
 
+static __always_inline int filter_pchar(struct filter_pred *pred, char *str)
+{
+	int cmp, match;
+	int len;
+
+	len = strlen(str) + 1;	/* including tailing '\0' */
+	cmp = pred->regex.match(str, &pred->regex, len);
+
+	match = cmp ^ pred->not;
+
+	return match;
+}
 /* Filter predicate for char * pointers */
 static int filter_pred_pchar(struct filter_pred *pred, void *event)
 {
 	char **addr = (char **)(event + pred->offset);
 	char *str;
-	int cmp, match;
-	int len;
 
 	str = test_string(*addr);
 	if (!str)
 		return 0;
 
-	len = strlen(str) + 1;	/* including tailing '\0' */
-	cmp = pred->regex.match(str, &pred->regex, len);
+	return filter_pchar(pred, str);
+}
 
-	match = cmp ^ pred->not;
+/* Filter predicate for char * pointers in user space*/
+static int filter_pred_pchar_user(struct filter_pred *pred, void *event)
+{
+	char **addr = (char **)(event + pred->offset);
+	char *str;
 
-	return match;
+	str = test_ustring(*addr);
+	if (!str)
+		return 0;
+
+	return filter_pchar(pred, str);
 }
 
 /*
@@ -1206,6 +1229,7 @@ static int parse_pred(const char *str, void *data,
 	struct filter_pred *pred = NULL;
 	char num_buf[24];	/* Big enough to hold an address */
 	char *field_name;
+	bool ustring = false;
 	char q;
 	u64 val;
 	int len;
@@ -1240,6 +1264,12 @@ static int parse_pred(const char *str, void *data,
 		return -EINVAL;
 	}
 
+	/* See if the field is a user space string */
+	if ((len = str_has_prefix(str + i, ".ustring"))) {
+		ustring = true;
+		i += len;
+	}
+
 	while (isspace(str[i]))
 		i++;
 
@@ -1377,7 +1407,10 @@ static int parse_pred(const char *str, void *data,
 					goto err_mem;
 			}
 
-			pred->fn = filter_pred_pchar;
+			if (ustring)
+				pred->fn = filter_pred_pchar_user;
+			else
+				pred->fn = filter_pred_pchar;
 		}
 		/* go past the last quote */
 		i++;
-- 
2.34.1



