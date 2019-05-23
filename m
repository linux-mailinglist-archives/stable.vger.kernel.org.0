Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF81E28907
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391634AbfEWTaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392102AbfEWTaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:30:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EA6021855;
        Thu, 23 May 2019 19:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639817;
        bh=s72rLvTOwA5x4B2XRi8yDybv5ixqBUHpoT+rgHvTsdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yBpsTC6760S5NV5fn8XS0xPjTGu3e5RuTigGInIpDS279wdU6GDnLnn1ZB4z/UGb6
         eZStCrX+RVkcgK5lNbRad6eBgGsDTt9bbEXGA/F+wKde3z+WAe4JSwx2b56OIoYnC1
         rwBlHdE8OwUsNd7u41/gnQG+h4pOjv1L7teMt4AY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Ziegler <andreas.ziegler@fau.de>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.1 077/122] tracing: probeevent: Fix to make the type of $comm string
Date:   Thu, 23 May 2019 21:06:39 +0200
Message-Id: <20190523181714.962759068@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 3dd1f7f24f8ceec00bbbc364c2ac3c893f0fdc4c upstream.

Fix to make the type of $comm "string".  If we set the other type to $comm
argument, it shows meaningless value or wrong data. Currently probe events
allow us to set string array type (e.g. ":string[2]"), or other digit types
like x8 on $comm. But since clearly $comm is just a string data, it should
not be fetched by other types including array.

Link: http://lkml.kernel.org/r/155723736241.9149.14582064184468574539.stgit@devnote2

Cc: Andreas Ziegler <andreas.ziegler@fau.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 533059281ee5 ("tracing: probeevent: Introduce new argument fetching code")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_probe.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -420,13 +420,14 @@ static int traceprobe_parse_probe_arg_bo
 				return -E2BIG;
 		}
 	}
-	/*
-	 * The default type of $comm should be "string", and it can't be
-	 * dereferenced.
-	 */
-	if (!t && strcmp(arg, "$comm") == 0)
+
+	/* Since $comm can not be dereferred, we can find $comm by strcmp */
+	if (strcmp(arg, "$comm") == 0) {
+		/* The type of $comm must be "string", and not an array. */
+		if (parg->count || (t && strcmp(t, "string")))
+			return -EINVAL;
 		parg->type = find_fetch_type("string");
-	else
+	} else
 		parg->type = find_fetch_type(t);
 	if (!parg->type) {
 		pr_info("Unsupported type: %s\n", t);


