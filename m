Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298D465D52A
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbjADOLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239594AbjADOLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:11:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929B91E3C8
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 880E36172D
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DF0C433EF;
        Wed,  4 Jan 2023 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841410;
        bh=zU3ChEniQXx9Nhjg4VPmKC6FizlFJNQ3YNu0v0SS9ls=;
        h=Subject:To:Cc:From:Date:From;
        b=0o+rOVn2B1CO5dgMRHcCYb78HnXw1f3dnSZcrn7jzAsibN6uAmgSxuWh/ObCUpxt3
         AA917GGqrR9xi/meOEYJJpsk2XWSj3j7KyX0wBX2xoAUxeigOf4uS9m/eBlaJg6pVV
         9LESNr8WS1rpwAASZTkuqTAce5Wc1ztW/tiCNnZ0=
Subject: FAILED: patch "[PATCH] tracing/hist: Fix wrong return value in parse_action_params()" failed to apply to 4.19-stable tree
To:     zhengyejian1@huawei.com, mhiramat@kernel.org, rostedt@goodmis.org,
        zanussi@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:10:06 +0100
Message-ID: <1672841406148243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

2cc6a528882d ("tracing/hist: Fix wrong return value in parse_action_params()")
d0cd871ba0d6 ("tracing: Have histogram code pass around trace_array for error handling")
d566c5e9d1ba ("tracing: Use tracing error_log with hist triggers")
a1a05bb40e22 ("tracing: Save the last hist command's associated event name")
e91eefd731d9 ("tracing: Add alternative synthetic event trace action syntax")
dff81f559285 ("tracing: Add hist trigger onchange() handler")
a3785b7eca8f ("tracing: Add hist trigger snapshot() action")
466f4528fbc6 ("tracing: Generalize hist trigger onmax and save action")
c3e49506a0f4 ("tracing: Split up onmatch action data")
5032b3818913 ("tracing: Make hist trigger Documentation better reflect actions/handlers")
7d18a10c3167 ("tracing: Refactor hist trigger action code")
036876fa5620 ("tracing: Have the historgram use the result of str_has_prefix() for len of prefix")
754481e6954c ("tracing: Use str_has_prefix() helper for histogram code")
05ddb25cb314 ("tracing: Add hist trigger comments for variable-related fields")
de40f033d4e8 ("tracing: Remove open-coding of hist trigger var_ref management")
2f31ed9308cc ("tracing: Change strlen to sizeof for hist trigger static strings")
6801f0d5ca00 ("tracing: Remove unnecessary hist trigger struct field")
0e2b81f7b52a ("tracing: Remove unneeded synth_event_mutex")
7bbab38d07f3 ("tracing: Use dyn_event framework for synthetic events")
faacb361f271 ("tracing: Simplify creation and deletion of synthetic events")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2cc6a528882d0e0ccbc1bca5f95b8c963cedac54 Mon Sep 17 00:00:00 2001
From: Zheng Yejian <zhengyejian1@huawei.com>
Date: Wed, 7 Dec 2022 11:46:35 +0800
Subject: [PATCH] tracing/hist: Fix wrong return value in parse_action_params()

When number of synth fields is more than SYNTH_FIELDS_MAX,
parse_action_params() should return -EINVAL.

Link: https://lore.kernel.org/linux-trace-kernel/20221207034635.2253990-1-zhengyejian1@huawei.com

Cc: <mhiramat@kernel.org>
Cc: <zanussi@kernel.org>
Cc: stable@vger.kernel.org
Fixes: c282a386a397 ("tracing: Add 'onmatch' hist trigger action support")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

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
 

