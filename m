Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5F36E64D5
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbjDRMw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjDRMw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:52:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A414E16DFD
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80E1A63455
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB64C433EF;
        Tue, 18 Apr 2023 12:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822354;
        bh=UwoDSbeHuJo8Pg8Uj7PGuCY/SERMjOSYdwZk01A2qvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4aSs8Oer12xAaqvkOqA5xlU4ms+Xgd2RLbx/cTjRFDi7wjCep9C7L6nuzUqzvX+g
         Nl1joah7dE+wMexCPKRjVn3kQ4PnR9YtywDl1mT5iz92St9gYITWOkvFRiXLyA++IK
         bTj96dWWxB9o/8kX8zrj+wMErzlC8zeaSK44odUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ross Zwisler <zwisler@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 101/139] tracing: Have tracing_snapshot_instance_cond() write errors to the appropriate instance
Date:   Tue, 18 Apr 2023 14:22:46 +0200
Message-Id: <20230418120317.588170046@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 9d52727f8043cfda241ae96896628d92fa9c50bb ]

If a trace instance has a failure with its snapshot code, the error
message is to be written to that instance's buffer. But currently, the
message is written to the top level buffer. Worse yet, it may also disable
the top level buffer and not the instance that had the issue.

Link: https://lkml.kernel.org/r/20230405022341.688730321@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <zwisler@google.com>
Fixes: 2824f50332486 ("tracing: Make the snapshot trigger work with instances")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 13c46787ba5fa..13b324f008256 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1111,22 +1111,22 @@ static void tracing_snapshot_instance_cond(struct trace_array *tr,
 	unsigned long flags;
 
 	if (in_nmi()) {
-		internal_trace_puts("*** SNAPSHOT CALLED FROM NMI CONTEXT ***\n");
-		internal_trace_puts("*** snapshot is being ignored        ***\n");
+		trace_array_puts(tr, "*** SNAPSHOT CALLED FROM NMI CONTEXT ***\n");
+		trace_array_puts(tr, "*** snapshot is being ignored        ***\n");
 		return;
 	}
 
 	if (!tr->allocated_snapshot) {
-		internal_trace_puts("*** SNAPSHOT NOT ALLOCATED ***\n");
-		internal_trace_puts("*** stopping trace here!   ***\n");
-		tracing_off();
+		trace_array_puts(tr, "*** SNAPSHOT NOT ALLOCATED ***\n");
+		trace_array_puts(tr, "*** stopping trace here!   ***\n");
+		tracer_tracing_off(tr);
 		return;
 	}
 
 	/* Note, snapshot can not be used when the tracer uses it */
 	if (tracer->use_max_tr) {
-		internal_trace_puts("*** LATENCY TRACER ACTIVE ***\n");
-		internal_trace_puts("*** Can not use snapshot (sorry) ***\n");
+		trace_array_puts(tr, "*** LATENCY TRACER ACTIVE ***\n");
+		trace_array_puts(tr, "*** Can not use snapshot (sorry) ***\n");
 		return;
 	}
 
-- 
2.39.2



