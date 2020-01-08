Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F13134C04
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbgAHTqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:46:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43480 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730424AbgAHTqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:02 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-0006nn-Fi; Wed, 08 Jan 2020 19:45:57 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-007dku-2N; Wed, 08 Jan 2020 19:45:57 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Masami Hiramatsu" <mhiramat@kernel.org>,
        "Andreas Ziegler" <andreas.ziegler@fau.de>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        "Ingo Molnar" <mingo@redhat.com>
Date:   Wed, 08 Jan 2020 19:43:04 +0000
Message-ID: <lsq.1578512578.490568620@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 06/63] tracing/uprobes: Fix output for multiple
 string arguments
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Ziegler <andreas.ziegler@fau.de>

commit 0722069a5374b904ec1a67f91249f90e1cfae259 upstream.

When printing multiple uprobe arguments as strings the output for the
earlier arguments would also include all later string arguments.

This is best explained in an example:

Consider adding a uprobe to a function receiving two strings as
parameters which is at offset 0xa0 in strlib.so and we want to print
both parameters when the uprobe is hit (on x86_64):

$ echo 'p:func /lib/strlib.so:0xa0 +0(%di):string +0(%si):string' > \
    /sys/kernel/debug/tracing/uprobe_events

When the function is called as func("foo", "bar") and we hit the probe,
the trace file shows a line like the following:

  [...] func: (0x7f7e683706a0) arg1="foobar" arg2="bar"

Note the extra "bar" printed as part of arg1. This behaviour stacks up
for additional string arguments.

The strings are stored in a dynamically growing part of the uprobe
buffer by fetch_store_string() after copying them from userspace via
strncpy_from_user(). The return value of strncpy_from_user() is then
directly used as the required size for the string. However, this does
not take the terminating null byte into account as the documentation
for strncpy_from_user() cleary states that it "[...] returns the
length of the string (not including the trailing NUL)" even though the
null byte will be copied to the destination.

Therefore, subsequent calls to fetch_store_string() will overwrite
the terminating null byte of the most recently fetched string with
the first character of the current string, leading to the
"accumulation" of strings in earlier arguments in the output.

Fix this by incrementing the return value of strncpy_from_user() by
one if we did not hit the maximum buffer size.

Link: http://lkml.kernel.org/r/20190116141629.5752-1-andreas.ziegler@fau.de

Cc: Ingo Molnar <mingo@redhat.com>
Fixes: 5baaa59ef09e ("tracing/probes: Implement 'memory' fetch method for uprobes")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andreas Ziegler <andreas.ziegler@fau.de>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/trace_uprobe.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -151,7 +151,14 @@ static void FETCH_FUNC_NAME(memory, stri
 
 	ret = strncpy_from_user(dst, src, maxlen);
 	if (ret == maxlen)
-		dst[--ret] = '\0';
+		dst[ret - 1] = '\0';
+	else if (ret >= 0)
+		/*
+		 * Include the terminating null byte. In this case it
+		 * was copied by strncpy_from_user but not accounted
+		 * for in ret.
+		 */
+		ret++;
 
 	if (ret < 0) {	/* Failed to fetch string */
 		((u8 *)get_rloc_data(dest))[0] = '\0';

