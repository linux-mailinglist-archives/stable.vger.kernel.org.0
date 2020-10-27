Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E637D29B89D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368889AbgJ0PmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800529AbgJ0PgX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:36:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C97322281;
        Tue, 27 Oct 2020 15:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812983;
        bh=WI8PK+tbYowSec5EZ4U/XYvmK+O9IRshW4thhwPSRFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUS40V4fVCAwpN6HGEPWYF521aEGZvYtvmmHyRvKupN/udVhAPu92vyf4JbcDk6+J
         47q0yGpP/1CIqz0B7yk10EkNFtWtVN3M16UYTAcR3WeKrTY+IRPKTb940ZLfSx1k9K
         09QQnJ+uSpgLN+8PvoyWr6UmFJAzpdC/t9TwiO+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 397/757] tracing: Handle synthetic event array field type checking correctly
Date:   Tue, 27 Oct 2020 14:50:47 +0100
Message-Id: <20201027135509.192517767@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Zanussi <zanussi@kernel.org>

[ Upstream commit 10819e25799aae564005b6049a45e9808797b3bb ]

Since synthetic event array types are derived from the field name,
there may be a semicolon at the end of the type which should be
stripped off.

If there are more characters following that, normal type string
checking will result in an invalid type.

Without this patch, you can end up with an invalid field type string
that gets displayed in both the synthetic event description and the
event format:

Before:

  # echo 'myevent char str[16]; int v' >> synthetic_events
  # cat synthetic_events
    myevent	char[16]; str; int v

  name: myevent
  ID: 1936
  format:
  	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
  	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
  	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
  	field:int common_pid;	offset:4;	size:4;	signed:1;

  	field:char str[16];;	offset:8;	size:16;	signed:1;
  	field:int v;	offset:40;	size:4;	signed:1;

  print fmt: "str=%s, v=%d", REC->str, REC->v

After:

  # echo 'myevent char str[16]; int v' >> synthetic_events
  # cat synthetic_events
    myevent	char[16] str; int v

  # cat events/synthetic/myevent/format
  name: myevent
  ID: 1936
  format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;

	field:char str[16];	offset:8;	size:16;	signed:1;
	field:int v;	offset:40;	size:4;	signed:1;

  print fmt: "str=%s, v=%d", REC->str, REC->v

Link: https://lkml.kernel.org/r/6587663b56c2d45ab9d8c8472a2110713cdec97d.1602598160.git.zanussi@kernel.org

[ <rostedt@goodmis.org>: wrote parse_synth_field() snippet. ]
Fixes: 4b147936fa50 (tracing: Add support for 'synthetic' events)
Reported-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_synth.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index 46a96686e93c6..c8892156db341 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -132,7 +132,7 @@ static int synth_field_string_size(char *type)
 	start += sizeof("char[") - 1;
 
 	end = strchr(type, ']');
-	if (!end || end < start)
+	if (!end || end < start || type + strlen(type) > end + 1)
 		return -EINVAL;
 
 	len = end - start;
@@ -502,8 +502,14 @@ static struct synth_field *parse_synth_field(int argc, const char **argv,
 	if (field_type[0] == ';')
 		field_type++;
 	len = strlen(field_type) + 1;
-	if (array)
-		len += strlen(array);
+
+        if (array) {
+                int l = strlen(array);
+
+                if (l && array[l - 1] == ';')
+                        l--;
+                len += l;
+        }
 	if (prefix)
 		len += strlen(prefix);
 
-- 
2.25.1



