Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81583601E56
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiJRAJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbiJRAIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:08:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E8887F97;
        Mon, 17 Oct 2022 17:08:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 451BCB81B62;
        Tue, 18 Oct 2022 00:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0D6C43140;
        Tue, 18 Oct 2022 00:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051686;
        bh=wTdpOeAuDGCGPzp3QTYS/asW5Xcif0GKVF3qgzx1J68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LCpHoPbjBH9z6GzlP60Nwp1EK7cZjKqyTLRxNAiDNnERQog+G7hg10kQZK4obP8a/
         TgoPh5M5CWgoXWUtbDzNYT72kMZFH5/8CaAlsrxEBJwuuvoR0+x/tdYJatUarZMt7z
         Cm57HmNgaPXeXlna03j3ij6mOTEmOZNw2skfEJsFywGISy2wjsrapz1hOEceoHx1K0
         kzPQSKyZLj60gCLoDVgH3Fxp6pxQ2O3GaHWTqQLN8+mhgxtpOpuatcImEIvJGPf6o9
         YCwlIMqMeIEk5b83qDHJD2mQfK59DZ1FENiv6DfkYh4IVoyMOCnwoKtT/6+DjoLso/
         PErXCLX9FFu9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 6.0 19/32] tracing/user_events: Ensure user provided strings are safely formatted
Date:   Mon, 17 Oct 2022 20:07:16 -0400
Message-Id: <20221018000729.2730519-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000729.2730519-1-sashal@kernel.org>
References: <20221018000729.2730519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Beau Belgrave <beaub@linux.microsoft.com>

[ Upstream commit e6f89a149872ab0e03cfded97983df74dfb0ef21 ]

User processes can provide bad strings that may cause issues or leak
kernel details back out. Don't trust the content of these strings
when formatting strings for matching.

This also moves to a consistent dynamic length string creation model.

Link: https://lkml.kernel.org/r/20220728233309.1896-4-beaub@linux.microsoft.com
Link: https://lore.kernel.org/all/2059213643.196683.1648499088753.JavaMail.zimbra@efficios.com/

Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_user.c | 91 +++++++++++++++++++++-----------
 1 file changed, 59 insertions(+), 32 deletions(-)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index b137e1866fbc..a3ee9a618f48 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -45,7 +45,6 @@
 #define MAX_EVENT_DESC 512
 #define EVENT_NAME(user_event) ((user_event)->tracepoint.name)
 #define MAX_FIELD_ARRAY_SIZE 1024
-#define MAX_FIELD_ARG_NAME 256
 
 static char *register_page_data;
 
@@ -483,6 +482,48 @@ static bool user_field_is_dyn_string(const char *type, const char **str_func)
 }
 
 #define LEN_OR_ZERO (len ? len - pos : 0)
+static int user_dyn_field_set_string(int argc, const char **argv, int *iout,
+				     char *buf, int len, bool *colon)
+{
+	int pos = 0, i = *iout;
+
+	*colon = false;
+
+	for (; i < argc; ++i) {
+		if (i != *iout)
+			pos += snprintf(buf + pos, LEN_OR_ZERO, " ");
+
+		pos += snprintf(buf + pos, LEN_OR_ZERO, "%s", argv[i]);
+
+		if (strchr(argv[i], ';')) {
+			++i;
+			*colon = true;
+			break;
+		}
+	}
+
+	/* Actual set, advance i */
+	if (len != 0)
+		*iout = i;
+
+	return pos + 1;
+}
+
+static int user_field_set_string(struct ftrace_event_field *field,
+				 char *buf, int len, bool colon)
+{
+	int pos = 0;
+
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "%s", field->type);
+	pos += snprintf(buf + pos, LEN_OR_ZERO, " ");
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "%s", field->name);
+
+	if (colon)
+		pos += snprintf(buf + pos, LEN_OR_ZERO, ";");
+
+	return pos + 1;
+}
+
 static int user_event_set_print_fmt(struct user_event *user, char *buf, int len)
 {
 	struct ftrace_event_field *field, *next;
@@ -926,49 +967,35 @@ static int user_event_free(struct dyn_event *ev)
 static bool user_field_match(struct ftrace_event_field *field, int argc,
 			     const char **argv, int *iout)
 {
-	char *field_name, *arg_name;
-	int len, pos, i = *iout;
+	char *field_name = NULL, *dyn_field_name = NULL;
 	bool colon = false, match = false;
+	int dyn_len, len;
 
-	if (i >= argc)
+	if (*iout >= argc)
 		return false;
 
-	len = MAX_FIELD_ARG_NAME;
-	field_name = kmalloc(len, GFP_KERNEL);
-	arg_name = kmalloc(len, GFP_KERNEL);
+	dyn_len = user_dyn_field_set_string(argc, argv, iout, dyn_field_name,
+					    0, &colon);
 
-	if (!arg_name || !field_name)
-		goto out;
-
-	pos = 0;
-
-	for (; i < argc; ++i) {
-		if (i != *iout)
-			pos += snprintf(arg_name + pos, len - pos, " ");
+	len = user_field_set_string(field, field_name, 0, colon);
 
-		pos += snprintf(arg_name + pos, len - pos, argv[i]);
-
-		if (strchr(argv[i], ';')) {
-			++i;
-			colon = true;
-			break;
-		}
-	}
+	if (dyn_len != len)
+		return false;
 
-	pos = 0;
+	dyn_field_name = kmalloc(dyn_len, GFP_KERNEL);
+	field_name = kmalloc(len, GFP_KERNEL);
 
-	pos += snprintf(field_name + pos, len - pos, field->type);
-	pos += snprintf(field_name + pos, len - pos, " ");
-	pos += snprintf(field_name + pos, len - pos, field->name);
+	if (!dyn_field_name || !field_name)
+		goto out;
 
-	if (colon)
-		pos += snprintf(field_name + pos, len - pos, ";");
+	user_dyn_field_set_string(argc, argv, iout, dyn_field_name,
+				  dyn_len, &colon);
 
-	*iout = i;
+	user_field_set_string(field, field_name, len, colon);
 
-	match = strcmp(arg_name, field_name) == 0;
+	match = strcmp(dyn_field_name, field_name) == 0;
 out:
-	kfree(arg_name);
+	kfree(dyn_field_name);
 	kfree(field_name);
 
 	return match;
-- 
2.35.1

