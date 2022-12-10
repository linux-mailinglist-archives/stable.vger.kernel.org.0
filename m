Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3C7648EFE
	for <lists+stable@lfdr.de>; Sat, 10 Dec 2022 14:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiLJN6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Dec 2022 08:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiLJN62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Dec 2022 08:58:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DD4D2F9;
        Sat, 10 Dec 2022 05:58:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88E9360C1A;
        Sat, 10 Dec 2022 13:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CAAC43322;
        Sat, 10 Dec 2022 13:58:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1p40Mz-000krM-1i;
        Sat, 10 Dec 2022 08:58:25 -0500
Message-ID: <20221210135825.396475827@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 10 Dec 2022 08:58:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <zanussi@kernel.org>, stable@vger.kernel.org,
        Zheng Yejian <zhengyejian1@huawei.com>
Subject: [for-next][PATCH 14/25] tracing/hist: Fix wrong return value in parse_action_params()
References: <20221210135750.425719934@goodmis.org>
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

From: Zheng Yejian <zhengyejian1@huawei.com>

When number of synth fields is more than SYNTH_FIELDS_MAX,
parse_action_params() should return -EINVAL.

Link: https://lore.kernel.org/linux-trace-kernel/20221207034635.2253990-1-zhengyejian1@huawei.com

Cc: <mhiramat@kernel.org>
Cc: <zanussi@kernel.org>
Cc: stable@vger.kernel.org
Fixes: c282a386a397 ("tracing: Add 'onmatch' hist trigger action support")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_hist.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index a0cd118af527..b4ad86c22b43 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3609,6 +3609,7 @@ static int parse_action_params(struct trace_array *tr, char *params,
 	while (params) {
 		if (data->n_params >= SYNTH_FIELDS_MAX) {
 			hist_err(tr, HIST_ERR_TOO_MANY_PARAMS, 0);
+			ret = -EINVAL;
 			goto out;
 		}
 
-- 
2.35.1


