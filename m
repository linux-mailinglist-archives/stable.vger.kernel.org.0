Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601814C9607
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbiCAURe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237887AbiCAURV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:17:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFC77DE19;
        Tue,  1 Mar 2022 12:16:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46C89B81CB4;
        Tue,  1 Mar 2022 20:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF610C340F1;
        Tue,  1 Mar 2022 20:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165770;
        bh=itDZCJCGsuOet9/92xys411vuxgygZO2JPt28WPcHd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IeSgeft2TMUyk6IlN8T3tF1bPWcppPGAlQ1HQOEaL8+a2hsnSVF9iPcG61+DLzojU
         moSqysXXr8sKtHQ9mLacTtCnm6PaskBhiw3XufHVcjq2ZDpcSKcIUtV0N2b/QxXeUH
         1fFmRt2ZotR8qtVyXSy0cebWmxfXUy5Kd0sOY83GeTb9OE2YqvnBptdHiGl5fyp8In
         MTMh5hkI3G+5QpALpiQnNR3ayaIMunzWf2gu+qEIMQHvCPL23/o6vKHkcnQyejmYdA
         JMgBS3UZMgHhdhMS1wPyjxKZYWfV5Jtz2fxdqwZh9mxwrdqngjtTQIdJntHKJecCUw
         S3uX6ThV0BOMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 5.16 26/28] tracing: Fix selftest config check for function graph start up test
Date:   Tue,  1 Mar 2022 15:13:31 -0500
Message-Id: <20220301201344.18191-26-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201344.18191-1-sashal@kernel.org>
References: <20220301201344.18191-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit c5229a0bd47814770c895e94fbc97ad21819abfe ]

CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS is required to test
direct tramp.

Link: https://lkml.kernel.org/r/bdc7e594e13b0891c1d61bc8d56c94b1890eaed7.1640017960.git.christophe.leroy@csgroup.eu

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_selftest.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index afd937a46496e..abcadbe933bb7 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -784,9 +784,7 @@ static struct fgraph_ops fgraph_ops __initdata  = {
 	.retfunc		= &trace_graph_return,
 };
 
-#if defined(CONFIG_DYNAMIC_FTRACE) && \
-    defined(CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS)
-#define TEST_DIRECT_TRAMP
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 noinline __noclone static void trace_direct_tramp(void) { }
 #endif
 
@@ -849,7 +847,7 @@ trace_selftest_startup_function_graph(struct tracer *trace,
 		goto out;
 	}
 
-#ifdef TEST_DIRECT_TRAMP
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 	tracing_reset_online_cpus(&tr->array_buffer);
 	set_graph_array(tr);
 
-- 
2.34.1

