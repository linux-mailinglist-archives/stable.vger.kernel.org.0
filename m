Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597414D8483
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235669AbiCNMXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243657AbiCNMVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:21:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CFB55202;
        Mon, 14 Mar 2022 05:16:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5288060C71;
        Mon, 14 Mar 2022 12:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9A1C340E9;
        Mon, 14 Mar 2022 12:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260195;
        bh=cwguBtztnNbV8hxATJW/2SnShoO0jpbrx3D/7sf+30I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFrqH8dmHQws33v+rYyDsNlweqxMoq81rhtuVgA2I1KxKkGaPGisGXLMjW9g0PLIT
         SEJLo01gGq2Du0TV6jHeWqWy9oLVS4/nm+uje8a3EAl/EVJoFf1cATZQZgMwetF3xA
         OZkjcIoqbWltbRYrsPnMo9q29w2qiTTwycguOW6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 083/121] tracing: Fix selftest config check for function graph start up test
Date:   Mon, 14 Mar 2022 12:54:26 +0100
Message-Id: <20220314112746.436979608@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index afd937a46496..abcadbe933bb 100644
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



