Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFAD36D5369
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 23:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbjDCVWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 17:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbjDCVWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 17:22:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC7A3AB3;
        Mon,  3 Apr 2023 14:22:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B33862C15;
        Mon,  3 Apr 2023 21:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84768C433A7;
        Mon,  3 Apr 2023 21:22:43 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1pjRdS-000FPw-1m;
        Mon, 03 Apr 2023 17:22:42 -0400
Message-ID: <20230403212242.363523650@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 03 Apr 2023 17:21:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>
Subject: [for-linus][PATCH 3/6] ftrace: Mark get_lock_parent_ip() __always_inline
References: <20230403212125.244064799@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-2.0 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Keeping <john@metanate.com>

If the compiler decides not to inline this function then preemption
tracing will always show an IP inside the preemption disabling path and
never the function actually calling preempt_{enable,disable}.

Link: https://lore.kernel.org/linux-trace-kernel/20230327173647.1690849-1-john@metanate.com

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Fixes: f904f58263e1d ("sched/debug: Fix preempt_disable_ip recording for preempt_disable()")
Signed-off-by: John Keeping <john@metanate.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/linux/ftrace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 366c730beaa3..402fc061de75 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -980,7 +980,7 @@ static inline void __ftrace_enabled_restore(int enabled)
 #define CALLER_ADDR5 ((unsigned long)ftrace_return_address(5))
 #define CALLER_ADDR6 ((unsigned long)ftrace_return_address(6))
 
-static inline unsigned long get_lock_parent_ip(void)
+static __always_inline unsigned long get_lock_parent_ip(void)
 {
 	unsigned long addr = CALLER_ADDR0;
 
-- 
2.39.2
