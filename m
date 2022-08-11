Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F8B5901C8
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237080AbiHKP5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237050AbiHKPzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:55:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C54897509;
        Thu, 11 Aug 2022 08:46:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DE0AB82160;
        Thu, 11 Aug 2022 15:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930EDC433D6;
        Thu, 11 Aug 2022 15:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232791;
        bh=M8+2Regi7w11f9Fs6t96nrt3QoC76Pn7bK09bq3NUaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m1+Cl5Ja9fRPv5qdcfiNj772cLsun9n2vfkvuXqLHXnDEPKysUkZA41huzA3XcAZl
         dXSBZo+GObH9dRx0nlLyvr0JRzstZ1wNJ++xdzzF1kqQJ0iLB8ztmxhOLUJ+/lvUkg
         9YohzlJ2LKHPcsIhwIj0Mc8Zta8GOvoBHrB5gU9ox6/xJCxZVQ++w4STmvT9yXr+ct
         s2OE0HJS3MFDtrMONUzaROSnBa97JNsU71y8C3xvL+bNGRCip3uy07i7zExBwrp0bQ
         LSmkqHAPOYyX6sIaFw6/tQ/ZXaGNwprrTZrVDdxetOmfQ3yelnB6c9zYiGhqyaNGIn
         UnKz5p0i9WV3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Delyan Kratunov <delyank@fb.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rostedt@goodmis.org,
        mingo@redhat.com, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 36/93] uprobe: gate bpf call behind BPF_EVENTS
Date:   Thu, 11 Aug 2022 11:41:30 -0400
Message-Id: <20220811154237.1531313-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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
index 9711589273cd..c3937c935239 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1343,6 +1343,7 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
 	int size, esize;
 	int rctx;
 
+#ifdef CONFIG_BPF_EVENTS
 	if (bpf_prog_array_valid(call)) {
 		u32 ret;
 
@@ -1352,6 +1353,7 @@ static void __uprobe_perf_func(struct trace_uprobe *tu,
 		if (!ret)
 			return;
 	}
+#endif /* CONFIG_BPF_EVENTS */
 
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
-- 
2.35.1

