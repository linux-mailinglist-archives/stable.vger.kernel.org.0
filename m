Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6471E66CAE2
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjAPRJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234238AbjAPRIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:08:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3739E4523A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:48:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A782FB81092
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39FFC433D2;
        Mon, 16 Jan 2023 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887710;
        bh=f2dxRcOgmnfQ++UO3Tcox+sJLQ52gh2PWTbWy1phYdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQBKfowKqJlaUAMf0ewPSZBJNip1zCKVAlpy9LUYr8/p+1lEZHbXUguXVaD3GoXTL
         /nz2u9Zvn2gIpzCPoguomZQsIUEjU6S0U7GkI+u1mC+i2e2DYSwKVzBDUqVnCxoq+z
         iwNXqd0le4mfNTj2oql+LdaYO2g9w8n0UAjesDFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, mhiramat@kernel.org, zanussi@kernel.org,
        Zheng Yejian <zhengyejian1@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 252/521] tracing/hist: Fix issue of losting command info in error_log
Date:   Mon, 16 Jan 2023 16:48:34 +0100
Message-Id: <20230116154858.400198220@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index 48f85dab9ef1..17b15bd97857 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5807,7 +5807,7 @@ static int event_hist_trigger_func(struct event_command *cmd_ops,
 	/* Just return zero, not the number of registered triggers */
 	ret = 0;
  out:
-	if (ret == 0)
+	if (ret == 0 && glob[0])
 		hist_err_clear();
 
 	return ret;
-- 
2.35.1



