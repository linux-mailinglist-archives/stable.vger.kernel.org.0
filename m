Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84CE631626
	for <lists+stable@lfdr.de>; Sun, 20 Nov 2022 21:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiKTUHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Nov 2022 15:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiKTUHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Nov 2022 15:07:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6286C17E1E;
        Sun, 20 Nov 2022 12:07:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F109760D17;
        Sun, 20 Nov 2022 20:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671ADC433B5;
        Sun, 20 Nov 2022 20:07:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1owqbG-00Di6D-1e;
        Sun, 20 Nov 2022 15:07:34 -0500
Message-ID: <20221120200734.299297602@goodmis.org>
User-Agent: quilt/0.66
Date:   Sun, 20 Nov 2022 15:07:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <mark.rutland@arm.com>, stable@vger.kernel.org,
        Wang Wensheng <wangwensheng4@huawei.com>
Subject: [for-linus][PATCH 06/13] ftrace: Optimize the allocation for mcount entries
References: <20221120200700.725968899@goodmis.org>
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

From: Wang Wensheng <wangwensheng4@huawei.com>

If we can't allocate this size, try something smaller with half of the
size. Its order should be decreased by one instead of divided by two.

Link: https://lkml.kernel.org/r/20221109094434.84046-3-wangwensheng4@huawei.com

Cc: <mhiramat@kernel.org>
Cc: <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Fixes: a79008755497d ("ftrace: Allocate the mcount record pages as groups")
Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8b13ce2eae70..56a168121bfc 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3190,7 +3190,7 @@ static int ftrace_allocate_records(struct ftrace_page *pg, int count)
 		/* if we can't allocate this size, try something smaller */
 		if (!order)
 			return -ENOMEM;
-		order >>= 1;
+		order--;
 		goto again;
 	}
 
-- 
2.35.1


