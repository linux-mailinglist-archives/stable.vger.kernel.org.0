Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4194CF6DD
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237649AbiCGJmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241136AbiCGJlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8BE1163;
        Mon,  7 Mar 2022 01:40:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACA936116E;
        Mon,  7 Mar 2022 09:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A28C340E9;
        Mon,  7 Mar 2022 09:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646037;
        bh=1KdZZPBpmda3aO8BSAxIkdeJTjDLQGxFa1W+XSEQcWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYegaNKmYIugdqZLiR06O33mwA2bJG3ZCVEQbTIaS8CftjcOlxqWutq/+rQMLcwdA
         4Kgb6R+rY2T7FgB1XlMUk27dmlkWHF2UK0sL+FMgYr+VIjhVDEnqpXG6gC1UQqaHhe
         /5iC3GhoUWmcTl8xkaMGFKo0R9XBt9DvZVwbFKps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, He Fengqing <hefengqing@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/262] bpf: Fix possible race in inc_misses_counter
Date:   Mon,  7 Mar 2022 10:17:37 +0100
Message-Id: <20220307091705.660001804@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: He Fengqing <hefengqing@huawei.com>

[ Upstream commit 0e3135d3bfa5dfb658145238d2bc723a8e30c3a3 ]

It seems inc_misses_counter() suffers from same issue fixed in
the commit d979617aa84d ("bpf: Fixes possible race in update_prog_stats()
for 32bit arches"):
As it can run while interrupts are enabled, it could
be re-entered and the u64_stats syncp could be mangled.

Fixes: 9ed9e9ba2337 ("bpf: Count the number of times recursion was prevented")
Signed-off-by: He Fengqing <hefengqing@huawei.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20220122102936.1219518-1-hefengqing@huawei.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/trampoline.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 6933a9bfee637..2660fbced9ad4 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -541,11 +541,12 @@ static u64 notrace bpf_prog_start_time(void)
 static void notrace inc_misses_counter(struct bpf_prog *prog)
 {
 	struct bpf_prog_stats *stats;
+	unsigned int flags;
 
 	stats = this_cpu_ptr(prog->stats);
-	u64_stats_update_begin(&stats->syncp);
+	flags = u64_stats_update_begin_irqsave(&stats->syncp);
 	u64_stats_inc(&stats->misses);
-	u64_stats_update_end(&stats->syncp);
+	u64_stats_update_end_irqrestore(&stats->syncp, flags);
 }
 
 /* The logic is similar to bpf_prog_run(), but with an explicit
-- 
2.34.1



