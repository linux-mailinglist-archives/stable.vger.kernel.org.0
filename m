Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639BA536A4B
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 04:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355591AbiE1Cwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 22:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355585AbiE1Cwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 22:52:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECB312B03D;
        Fri, 27 May 2022 19:52:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43F19B8268B;
        Sat, 28 May 2022 02:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0062FC341C7;
        Sat, 28 May 2022 02:52:50 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1numZO-000LNk-3M;
        Fri, 27 May 2022 22:52:50 -0400
Message-ID: <20220528025249.937888768@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 27 May 2022 22:50:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Baik Song An <bsahn@etri.re.kr>,
        Hong Yeon Kim <kimhy@etri.re.kr>,
        Taeung Song <taeung@reallinux.co.kr>, linuxgeek@linuxgeek.io,
        stable@vger.kernel.org, Wonhyuk Yang <vvghjk1234@gmail.com>
Subject: [for-next][PATCH 07/23] tracing: Fix return value of trace_pid_write()
References: <20220528025028.850906216@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wonhyuk Yang <vvghjk1234@gmail.com>

Setting set_event_pid with trailing whitespace lead to endless write
system calls like below.

    $ strace echo "123 " > /sys/kernel/debug/tracing/set_event_pid
    execve("/usr/bin/echo", ["echo", "123 "], ...) = 0
    ...
    write(1, "123 \n", 5)                   = 4
    write(1, "\n", 1)                       = 0
    write(1, "\n", 1)                       = 0
    write(1, "\n", 1)                       = 0
    write(1, "\n", 1)                       = 0
    write(1, "\n", 1)                       = 0
    ....

This is because, the result of trace_get_user's are not returned when it
read at least one pid. To fix it, update read variable even if
parser->idx == 0.

The result of applied patch is below.

    $ strace echo "123 " > /sys/kernel/debug/tracing/set_event_pid
    execve("/usr/bin/echo", ["echo", "123 "], ...) = 0
    ...
    write(1, "123 \n", 5)                   = 5
    close(1)                                = 0

Link: https://lkml.kernel.org/r/20220503050546.288911-1-vvghjk1234@gmail.com

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Baik Song An <bsahn@etri.re.kr>
Cc: Hong Yeon Kim <kimhy@etri.re.kr>
Cc: Taeung Song <taeung@reallinux.co.kr>
Cc: linuxgeek@linuxgeek.io
Cc: stable@vger.kernel.org
Fixes: 4909010788640 ("tracing: Add set_event_pid directory for future use")
Signed-off-by: Wonhyuk Yang <vvghjk1234@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 498ae22d4ffa..4825883b2ffd 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -721,13 +721,16 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
 		pos = 0;
 
 		ret = trace_get_user(&parser, ubuf, cnt, &pos);
-		if (ret < 0 || !trace_parser_loaded(&parser))
+		if (ret < 0)
 			break;
 
 		read += ret;
 		ubuf += ret;
 		cnt -= ret;
 
+		if (!trace_parser_loaded(&parser))
+			break;
+
 		ret = -EINVAL;
 		if (kstrtoul(parser.buffer, 0, &val))
 			break;
@@ -753,7 +756,6 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
 	if (!nr_pids) {
 		/* Cleared the list of pids */
 		trace_pid_list_free(pid_list);
-		read = ret;
 		pid_list = NULL;
 	}
 
-- 
2.35.1
