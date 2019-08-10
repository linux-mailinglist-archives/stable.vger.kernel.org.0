Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44ACA88D41
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfHJUoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:44:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55006 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726834AbfHJUoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:03 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDY-00053t-Ke; Sat, 10 Aug 2019 21:44:00 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-0003fA-7Q; Sat, 10 Aug 2019 21:43:48 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Rikard Falkeborn" <rikard.falkeborn@gmail.com>,
        "Tzvetomir Stoyanov" <tstoyanov@vmware.com>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.122674765@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 090/157] tools lib traceevent: Fix missing equality
 check for strcmp
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>

commit f32c2877bcb068a718bb70094cd59ccc29d4d082 upstream.

There was a missing comparison with 0 when checking if type is "s64" or
"u64". Therefore, the body of the if-statement was entered if "type" was
"u64" or not "s64", which made the first strcmp() redundant since if
type is "u64", it's not "s64".

If type is "s64", the body of the if-statement is not entered but since
the remainder of the function consists of if-statements which will not
be entered if type is "s64", we will just return "val", which is
correct, albeit at the cost of a few more calls to strcmp(), i.e., it
will behave just as if the if-statement was entered.

If type is neither "s64" or "u64", the body of the if-statement will be
entered incorrectly and "val" returned. This means that any type that is
checked after "s64" and "u64" is handled the same way as "s64" and
"u64", i.e., the limiting of "val" to fit in for example "s8" is never
reached.

This was introduced in the kernel tree when the sources were copied from
trace-cmd in commit f7d82350e597 ("tools/events: Add files to create
libtraceevent.a"), and in the trace-cmd repo in 1cdbae6035cei
("Implement typecasting in parser") when the function was introduced,
i.e., it has always behaved the wrong way.

Detected by cppcheck.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Fixes: f7d82350e597 ("tools/events: Add files to create libtraceevent.a")
Link: http://lkml.kernel.org/r/20190409091529.2686-1-rikard.falkeborn@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/lib/traceevent/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2065,7 +2065,7 @@ eval_type_str(unsigned long long val, co
 		return val & 0xffffffff;
 
 	if (strcmp(type, "u64") == 0 ||
-	    strcmp(type, "s64"))
+	    strcmp(type, "s64") == 0)
 		return val;
 
 	if (strcmp(type, "s8") == 0)

