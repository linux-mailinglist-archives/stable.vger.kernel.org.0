Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B317859031B
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbiHKQSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237585AbiHKQSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:18:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7D2381;
        Thu, 11 Aug 2022 09:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 209DB60FA0;
        Thu, 11 Aug 2022 16:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68ADBC433D6;
        Thu, 11 Aug 2022 16:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233617;
        bh=wsTmHiDUzkGL2xsjdamRGkdWY24nLy7FdLJ7TQ0P5lA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSSFQqc3O241q/m9Qyd2b0AjV1+uCOGRUR4W1Ent/Me7wNoqw8pRQsMZwfRHCm1ZY
         HnWhU0Z4nk3Gf1VOvzVCu/sJAJ/+HtGs86oS0Xm6Q6LGTe6bCoFhS6Lk8E98pII1Fh
         rvqZsLKYpmYJHuDDJvLsWVGwcU34GlZup2aRfeq8geZdLdbPxLPrMvKYDVhuVLMXsD
         wURsotTfxBSPPHKGe/cBP5cCpkX8YKSm8JFuCVnGlBkbpD0mFwd+bkciQ2blgFUh/K
         2h4Ie+EOd1OKX7RpnRRQWkkim6VN5eHi1xeoKiYrEgLeec2IgwhI1tNMZ3AmgToJTP
         8tWWdU038aUFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Delyan Kratunov <delyank@fb.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rostedt@goodmis.org,
        mingo@redhat.com, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 31/69] uprobe: gate bpf call behind BPF_EVENTS
Date:   Thu, 11 Aug 2022 11:55:40 -0400
Message-Id: <20220811155632.1536867-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
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
index 78ec1c16ccf4..798c99994e2a 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1352,6 +1352,7 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
 	int size, esize;
 	int rctx;
 
+#ifdef CONFIG_BPF_EVENTS
 	if (bpf_prog_array_valid(call)) {
 		u32 ret;
 
@@ -1361,6 +1362,7 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
 		if (!ret)
 			return;
 	}
+#endif /* CONFIG_BPF_EVENTS */
 
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
-- 
2.35.1

