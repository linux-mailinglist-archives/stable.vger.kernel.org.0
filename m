Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28BD5EC8E6
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 18:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiI0QCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 12:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiI0QBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 12:01:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB70FD98C2;
        Tue, 27 Sep 2022 09:01:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EAF27CE19D1;
        Tue, 27 Sep 2022 16:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BE2C43470;
        Tue, 27 Sep 2022 16:01:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1odD2p-00G2y1-2g;
        Tue, 27 Sep 2022 12:02:51 -0400
Message-ID: <20220927160251.443413557@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 27 Sep 2022 12:02:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Linyu Yuan <quic_linyyuan@quicinc.com>, stable@vger.kernel.org,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Tao Chen <chentao.kernel@linux.alibaba.com>
Subject: [for-next][PATCH 19/20] tracing/eprobe: Fix alloc event dir failed when event name no set
References: <20220927160216.349640304@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Chen <chentao.kernel@linux.alibaba.com>

The event dir will alloc failed when event name no set, using the
command:
"echo "e:esys/ syscalls/sys_enter_openat file=\$filename:string"
>> dynamic_events"
It seems that dir name="syscalls/sys_enter_openat" is not allowed
in debugfs. So just use the "sys_enter_openat" as the event name.

Link: https://lkml.kernel.org/r/1664028814-45923-1-git-send-email-chentao.kernel@linux.alibaba.com

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Linyu Yuan <quic_linyyuan@quicinc.com>
Cc: Tao Chen <chentao.kernel@linux.alibaba.com
Cc: stable@vger.kernel.org
Fixes: 95c104c378dc ("tracing: Auto generate event name when creating a group of events")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Tao Chen <chentao.kernel@linux.alibaba.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_eprobe.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
index 78299d3724a2..c08bde9871ec 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -1039,8 +1039,7 @@ static int __trace_eprobe_create(int argc, const char *argv[])
 	}
 
 	if (!event) {
-		strscpy(buf1, argv[1], MAX_EVENT_NAME_LEN);
-		sanitize_event_name(buf1);
+		strscpy(buf1, sys_event, MAX_EVENT_NAME_LEN);
 		event = buf1;
 	}
 
-- 
2.35.1
