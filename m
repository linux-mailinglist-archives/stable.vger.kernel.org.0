Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F0459037C
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238037AbiHKQ1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237833AbiHKQYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:24:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A638727174;
        Thu, 11 Aug 2022 09:06:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43C38612F4;
        Thu, 11 Aug 2022 16:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA805C433B5;
        Thu, 11 Aug 2022 16:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233987;
        bh=/t+23DdWwxM9jyoCs76D2FiRHmzMiegWHIf2xwQUYjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TyIHZyjwSlRA/L64Ob4Y9MK28rMXPkiOiFxS8TJlmocnepqDbMQTYz7VAbhZotkoZ
         9N7wG4ypmtmnv7HhaXSG/WMWQ2Rt6IQKBU2fx+iJdtkRmAh3LWuU08iJKxsXvPC/SW
         v/ny4qndj5k1cQpEoeBeUJz/HNyYA8nQ9sY3G6c9TB15Z6e/5tbys27x2x6+gtETQ8
         p3uAhRngXpv5l3GUwk4S5TU8EJMiSZpzyxa9PwaFB2UkyYqFVOBb6coIDb1S6h/kke
         gs3Sw5SO6renXmVOnZCLdoLUlCCDm75pMbyb6TAqCIXYK8fb1EeLg/s2Lcq4uhRily
         sogJU6RqXg4Ag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Delyan Kratunov <delyank@fb.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rostedt@goodmis.org,
        mingo@redhat.com, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 23/46] uprobe: gate bpf call behind BPF_EVENTS
Date:   Thu, 11 Aug 2022 12:03:47 -0400
Message-Id: <20220811160421.1539956-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Delyan Kratunov <delyank@fb.com>

[ Upstream commit aca80dd95e20f1fa0daa212afc83c9fa0ad239e5 ]

The call into bpf from uprobes needs to be gated now that it doesn't use
the trace_events.h helpers.

Randy found this as a randconfig build failure on linux-next [1].

  [1]: https://lore.kernel.org/linux-next/2de99180-7d55-2fdf-134d-33198c27cc58@infradead.org/

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Delyan Kratunov <delyank@fb.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/cb8bfbbcde87ed5d811227a393ef4925f2aadb7b.camel@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_uprobe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 9900d4e3808c..4d62342ff970 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1351,6 +1351,7 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
 	int size, esize;
 	int rctx;
 
+#ifdef CONFIG_BPF_EVENTS
 	if (bpf_prog_array_valid(call)) {
 		u32 ret;
 
@@ -1360,6 +1361,7 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
 		if (!ret)
 			return;
 	}
+#endif /* CONFIG_BPF_EVENTS */
 
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
-- 
2.35.1

