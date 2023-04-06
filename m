Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4026DA0C1
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 21:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240455AbjDFTMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 15:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240333AbjDFTMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 15:12:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E44A93C9;
        Thu,  6 Apr 2023 12:12:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7622462D38;
        Thu,  6 Apr 2023 19:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACF9C4339B;
        Thu,  6 Apr 2023 19:12:33 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1pkV28-001EY1-39;
        Thu, 06 Apr 2023 15:12:32 -0400
Message-ID: <20230406191232.794410178@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 06 Apr 2023 15:10:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, <ast@kernel.org>, <daniel@iogearbox.net>,
        Zheng Yejian <zhengyejian1@huawei.com>
Subject: [for-linus][PATCH 1/2] ftrace: Fix issue that direct->addr not restored in
 modify_ftrace_direct()
References: <20230406191058.652785135@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.8 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yejian <zhengyejian1@huawei.com>

Syzkaller report a WARNING: "WARN_ON(!direct)" in modify_ftrace_direct().

Root cause is 'direct->addr' was changed from 'old_addr' to 'new_addr' but
not restored if error happened on calling ftrace_modify_direct_caller().
Then it can no longer find 'direct' by that 'old_addr'.

To fix it, restore 'direct->addr' to 'old_addr' explicitly in error path.

Link: https://lore.kernel.org/linux-trace-kernel/20230330025223.1046087-1-zhengyejian1@huawei.com

Cc: stable@vger.kernel.org
Cc: <mhiramat@kernel.org>
Cc: <mark.rutland@arm.com>
Cc: <ast@kernel.org>
Cc: <daniel@iogearbox.net>
Fixes: 8a141dd7f706 ("ftrace: Fix modify_ftrace_direct.")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0feea145bb29..c67bcc89a771 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5667,12 +5667,15 @@ int modify_ftrace_direct(unsigned long ip,
 		ret = 0;
 	}
 
-	if (unlikely(ret && new_direct)) {
-		direct->count++;
-		list_del_rcu(&new_direct->next);
-		synchronize_rcu_tasks();
-		kfree(new_direct);
-		ftrace_direct_func_count--;
+	if (ret) {
+		direct->addr = old_addr;
+		if (unlikely(new_direct)) {
+			direct->count++;
+			list_del_rcu(&new_direct->next);
+			synchronize_rcu_tasks();
+			kfree(new_direct);
+			ftrace_direct_func_count--;
+		}
 	}
 
  out_unlock:
-- 
2.39.2
