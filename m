Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA4549FDED
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 17:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350060AbiA1QXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 11:23:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59170 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350055AbiA1QXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 11:23:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30E9D61F1F;
        Fri, 28 Jan 2022 16:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981B4C340F1;
        Fri, 28 Jan 2022 16:23:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1nDU2J-00ASz9-PL;
        Fri, 28 Jan 2022 11:23:43 -0500
Message-ID: <20220128162343.618746472@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 28 Jan 2022 11:18:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Xiaoke Wang <xkernel.wang@foxmail.com>
Subject: [for-linus][PATCH 02/10] tracing/histogram: Fix a potential memory leak for kstrdup()
References: <20220128161802.711119424@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

kfree() is missing on an error path to free the memory allocated by
kstrdup():

  p = param = kstrdup(data->params[i], GFP_KERNEL);

So it is better to free it via kfree(p).

Link: https://lkml.kernel.org/r/tencent_C52895FD37802832A3E5B272D05008866F0A@qq.com

Cc: stable@vger.kernel.org
Fixes: d380dcde9a07c ("tracing: Fix now invalid var_ref_vals assumption in trace action")
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_hist.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 5e6a988a8a51..cd9610688ddc 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3935,6 +3935,7 @@ static int trace_action_create(struct hist_trigger_data *hist_data,
 
 			var_ref_idx = find_var_ref_idx(hist_data, var_ref);
 			if (WARN_ON(var_ref_idx < 0)) {
+				kfree(p);
 				ret = var_ref_idx;
 				goto err;
 			}
-- 
2.33.0
