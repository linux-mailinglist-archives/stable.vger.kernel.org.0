Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9251E6086D5
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbiJVHxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiJVHwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:52:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763362C5035;
        Sat, 22 Oct 2022 00:46:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 650F660BAA;
        Sat, 22 Oct 2022 07:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D55C433D6;
        Sat, 22 Oct 2022 07:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424643;
        bh=paWKtYTyYvMynckSb7l/wvrQRez0ic+BTjI/PbHFihA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qte8nB/3jz1qz1zrJvzwWet/4k5Nq7wyJnXVNQ/DV0evldXl1GEtKUmrSmPAgGrnQ
         cwTYDbeA9k8eAWxkCi1gSOT2jzaNHomBtrcSfXZJYlyyS5YMRVtdmzeaQFaeycbCyo
         KmTJrUoQdZDwQaICGVsZkkWFMuId+/hMENr5LSKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 222/717] bpf: Use this_cpu_{inc_return|dec} for prog->active
Date:   Sat, 22 Oct 2022 09:21:41 +0200
Message-Id: <20221022072454.422004579@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit c89e843a11f1075d27684f6b42256213e4592383 ]

Both __this_cpu_inc_return() and __this_cpu_dec() are not preemption
safe and now migrate_disable() doesn't disable preemption, so the update
of prog-active is not atomic and in theory under fully preemptible kernel
recurisve prevention may do not work.

Fixing by using the preemption-safe and IRQ-safe variants.

Fixes: ca06f55b9002 ("bpf: Add per-program recursion prevention mechanism")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20220901061938.3789460-3-houtao@huaweicloud.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/trampoline.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 93c7675f0c9e..fe4f4d9d043b 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -585,7 +585,7 @@ u64 notrace __bpf_prog_enter(struct bpf_prog *prog, struct bpf_tramp_run_ctx *ru
 
 	run_ctx->saved_run_ctx = bpf_set_run_ctx(&run_ctx->run_ctx);
 
-	if (unlikely(__this_cpu_inc_return(*(prog->active)) != 1)) {
+	if (unlikely(this_cpu_inc_return(*(prog->active)) != 1)) {
 		inc_misses_counter(prog);
 		return 0;
 	}
@@ -620,7 +620,7 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start, struct bpf_tramp_
 	bpf_reset_run_ctx(run_ctx->saved_run_ctx);
 
 	update_prog_stats(prog, start);
-	__this_cpu_dec(*(prog->active));
+	this_cpu_dec(*(prog->active));
 	migrate_enable();
 	rcu_read_unlock();
 }
@@ -631,7 +631,7 @@ u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog, struct bpf_tramp_r
 	migrate_disable();
 	might_fault();
 
-	if (unlikely(__this_cpu_inc_return(*(prog->active)) != 1)) {
+	if (unlikely(this_cpu_inc_return(*(prog->active)) != 1)) {
 		inc_misses_counter(prog);
 		return 0;
 	}
@@ -647,7 +647,7 @@ void notrace __bpf_prog_exit_sleepable(struct bpf_prog *prog, u64 start,
 	bpf_reset_run_ctx(run_ctx->saved_run_ctx);
 
 	update_prog_stats(prog, start);
-	__this_cpu_dec(*(prog->active));
+	this_cpu_dec(*(prog->active));
 	migrate_enable();
 	rcu_read_unlock_trace();
 }
-- 
2.35.1



