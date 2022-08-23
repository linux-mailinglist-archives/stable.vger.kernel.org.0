Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACCE459E099
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243885AbiHWLDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357440AbiHWLCX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:02:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B6DB14F2;
        Tue, 23 Aug 2022 02:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58380B81C85;
        Tue, 23 Aug 2022 09:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9F5C433C1;
        Tue, 23 Aug 2022 09:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246085;
        bh=4wSFBcJWjvWoO4ac098ZRzL0AmRBvAtFIXEj5Kx1D2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8ZCCDZEp5vBsr37rEyLoD75QsrVW0Cg/u2nA4Q1UIUpZ5dZnXhP4nl/oBNxoi+Xd
         W+4LeE3AAG1OZxCZTPbrdFmQ4Q7dtufcekN/hNVmxOFwbeKQjT1GxVZ16vNU28+egi
         chylYkzMKILmuRC/UcsF9K4qdeOWRWsiKy4/hxOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 285/287] tracing/probes: Have kprobes and uprobes use $COMM too
Date:   Tue, 23 Aug 2022 10:27:34 +0200
Message-Id: <20220823080111.120770239@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit ab8384442ee512fc0fc72deeb036110843d0e7ff upstream.

Both $comm and $COMM can be used to get current->comm in eprobes and the
filtering and histogram logic. Make kprobes and uprobes consistent in this
regard and allow both $comm and $COMM as well. Currently kprobes and
uprobes only handle $comm, which is inconsistent with the other utilities,
and can be confusing to users.

Link: https://lkml.kernel.org/r/20220820134401.317014913@goodmis.org
Link: https://lore.kernel.org/all/20220820220442.776e1ddaf8836e82edb34d01@kernel.org/

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Fixes: 533059281ee5 ("tracing: probeevent: Introduce new argument fetching code")
Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -361,7 +361,7 @@ static int parse_probe_vars(char *arg, c
 			}
 		} else
 			ret = -EINVAL;
-	} else if (strcmp(arg, "comm") == 0) {
+	} else if (strcmp(arg, "comm") == 0 || strcmp(arg, "COMM") == 0) {
 		if (strcmp(t->name, "string") != 0 &&
 		    strcmp(t->name, "string_size") != 0)
 			return -EINVAL;
@@ -544,7 +544,7 @@ int traceprobe_parse_probe_arg(char *arg
 	 * The default type of $comm should be "string", and it can't be
 	 * dereferenced.
 	 */
-	if (!t && strcmp(arg, "$comm") == 0)
+	if (!t && (strcmp(arg, "$comm") == 0 || strcmp(arg, "$COMM") == 0))
 		t = "string";
 	parg->type = find_fetch_type(t, ftbl);
 	if (!parg->type) {


