Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4893D667622
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237125AbjALO3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236273AbjALO2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:28:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611D458834
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:19:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F25AA62035
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1586C433F0;
        Thu, 12 Jan 2023 14:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533167;
        bh=v+ph/IMDUxZXsYxp6aur90DLLNlNzVPTNOfVPlBA+OM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1dIAT6ow+vgIgFa1kg1cmyMmTbCUfl95P70cNZCNNhRPOHVSdy7mWcXiLAjepYOU
         uUhZNCz1igExwb/b6Au8fXXKKMRu+XbkO1KjbBXL4hRysxZJXY7/zZYAhEg1GmlBbz
         cl3iIBx6wVzOv4JUiD9FaEUEG31vodR70JxFueik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, mhiramat@kernel.org, zanussi@kernel.org,
        Zheng Yejian <zhengyejian1@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 391/783] tracing/hist: Fix issue of losting command info in error_log
Date:   Thu, 12 Jan 2023 14:51:47 +0100
Message-Id: <20230112135542.434902476@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yejian <zhengyejian1@huawei.com>

[ Upstream commit 608c6ed3337850c767ab0dd6c583477922233e29 ]

When input some constructed invalid 'trigger' command, command info
in 'error_log' are lost [1].

The root cause is that there is a path that event_hist_trigger_parse()
is recursely called once and 'last_cmd' which save origin command is
cleared, then later calling of hist_err() will no longer record origin
command info:

  event_hist_trigger_parse() {
    last_cmd_set()  // <1> 'last_cmd' save origin command here at first
    create_actions() {
      onmatch_create() {
        action_create() {
          trace_action_create() {
            trace_action_create_field_var() {
              create_field_var_hist() {
                event_hist_trigger_parse() {  // <2> recursely called once
                  hist_err_clear()  // <3> 'last_cmd' is cleared here
                }
                hist_err()  // <4> No longer find origin command!!!

Since 'glob' is empty string while running into the recurse call, we
can trickly check it and bypass the call of hist_err_clear() to solve it.

[1]
 # cd /sys/kernel/tracing
 # echo "my_synth_event int v1; int v2; int v3;" >> synthetic_events
 # echo 'hist:keys=pid' >> events/sched/sched_waking/trigger
 # echo "hist:keys=next_pid:onmatch(sched.sched_waking).my_synth_event(\
pid,pid1)" >> events/sched/sched_switch/trigger
 # cat error_log
[  8.405018] hist:sched:sched_switch: error: Couldn't find synthetic event
  Command:
hist:keys=next_pid:onmatch(sched.sched_waking).my_synth_event(pid,pid1)
                                                          ^
[  8.816902] hist:sched:sched_switch: error: Couldn't find field
  Command:
hist:keys=next_pid:onmatch(sched.sched_waking).my_synth_event(pid,pid1)
                          ^
[  8.816902] hist:sched:sched_switch: error: Couldn't parse field variable
  Command:
hist:keys=next_pid:onmatch(sched.sched_waking).my_synth_event(pid,pid1)
                          ^
[  8.999880] : error: Couldn't find field
  Command:
           ^
[  8.999880] : error: Couldn't parse field variable
  Command:
           ^
[  8.999880] : error: Couldn't find field
  Command:
           ^
[  8.999880] : error: Couldn't create histogram for field
  Command:
           ^

Link: https://lore.kernel.org/linux-trace-kernel/20221207135326.3483216-1-zhengyejian1@huawei.com

Cc: <mhiramat@kernel.org>
Cc: <zanussi@kernel.org>
Fixes: f404da6e1d46 ("tracing: Add 'last error' error facility for hist triggers")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index fd5416829445..8e01ab49118d 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5827,7 +5827,7 @@ static int event_hist_trigger_func(struct event_command *cmd_ops,
 	/* Just return zero, not the number of registered triggers */
 	ret = 0;
  out:
-	if (ret == 0)
+	if (ret == 0 && glob[0])
 		hist_err_clear();
 
 	return ret;
-- 
2.35.1



