Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB17358FFFA
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbiHKPgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236166AbiHKPft (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:35:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F2495694;
        Thu, 11 Aug 2022 08:33:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D38C6B8215E;
        Thu, 11 Aug 2022 15:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783F5C43143;
        Thu, 11 Aug 2022 15:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231982;
        bh=bWvzs2w/pecxPdGiIW5Iev5BBayKp3/bjEtwqUiA+6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SaoG5AfJj0YPoPZF6niXX/U2N2Guoz+P0zx5THR1Oj82U+7hfuApZKigBzSg8f3Bw
         StkqYa2jrWtPntFh8Qhop/BsCtTVC+vdNSNQyKxutobeZpsseBcsMV8dEQe0rvL6sp
         Zcl4XyodVQgnSwgOKtGtiERZaFsw+2J9T+JER4FM3ObzKHZ4mJwZj9RTRS5YmVdGS1
         PzS6H/vEcBT69Fb4curzV/jxmaUdNV0wVuHdYu7uXDU4npV/Te8gRMcUf+q+4S2Cho
         oYtT+3Rzrshb8xNtNIzAqnNLRwG5YAJ0rcZixqLOiThdxwHbFaqr0JKTl+Y9jVOcYQ
         S6ADdvJ6zzFpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Delyan Kratunov <delyank@fb.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rostedt@goodmis.org,
        mingo@redhat.com, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 039/105] uprobe: gate bpf call behind BPF_EVENTS
Date:   Thu, 11 Aug 2022 11:27:23 -0400
Message-Id: <20220811152851.1520029-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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
index c3dc4f859a6b..687520c675fd 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1342,6 +1342,7 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
 	int size, esize;
 	int rctx;
 
+#ifdef CONFIG_BPF_EVENTS
 	if (bpf_prog_array_valid(call)) {
 		u32 ret;
 
@@ -1351,6 +1352,7 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
 		if (!ret)
 			return;
 	}
+#endif /* CONFIG_BPF_EVENTS */
 
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
-- 
2.35.1

