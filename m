Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17CA60485A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiJSN4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbiJSNyf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:54:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41AC1DDC1D;
        Wed, 19 Oct 2022 06:37:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 081FAB82337;
        Wed, 19 Oct 2022 08:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF7FC433D7;
        Wed, 19 Oct 2022 08:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169386;
        bh=wQ4vvWEZ6w/RYnBZK7uYJgLompeNljXKcXo+SrdSuZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vZJOy68sTzVZ5fdyI9kWgap0R8lusm9AulZ5eG6Y2yMIX+dzLJqA6FYkmXMG0d6pJ
         LZxURLjj4n8MSCe68VqLpWzKbJ+wnGbZv1maBD191kSWxowKyAEV3KqDciBP5C0Jga
         BrE+xmClkyuA+DI3dpwgB5R/B/+IXXzlqr3Ev7u4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 257/862] bpf: Use this_cpu_{inc_return|dec} for prog->active
Date:   Wed, 19 Oct 2022 10:25:44 +0200
Message-Id: <20221019083301.406438627@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index ff87e38af8a7..ad76940b02cc 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -895,7 +895,7 @@ u64 notrace __bpf_prog_enter(struct bpf_prog *prog, struct bpf_tramp_run_ctx *ru
 
 	run_ctx->saved_run_ctx = bpf_set_run_ctx(&run_ctx->run_ctx);
 
-	if (unlikely(__this_cpu_inc_return(*(prog->active)) != 1)) {
+	if (unlikely(this_cpu_inc_return(*(prog->active)) != 1)) {
 		inc_misses_counter(prog);
 		return 0;
 	}
@@ -930,7 +930,7 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start, struct bpf_tramp_
 	bpf_reset_run_ctx(run_ctx->saved_run_ctx);
 
 	update_prog_stats(prog, start);
-	__this_cpu_dec(*(prog->active));
+	this_cpu_dec(*(prog->active));
 	migrate_enable();
 	rcu_read_unlock();
 }
@@ -966,7 +966,7 @@ u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog, struct bpf_tramp_r
 	migrate_disable();
 	might_fault();
 
-	if (unlikely(__this_cpu_inc_return(*(prog->active)) != 1)) {
+	if (unlikely(this_cpu_inc_return(*(prog->active)) != 1)) {
 		inc_misses_counter(prog);
 		return 0;
 	}
@@ -982,7 +982,7 @@ void notrace __bpf_prog_exit_sleepable(struct bpf_prog *prog, u64 start,
 	bpf_reset_run_ctx(run_ctx->saved_run_ctx);
 
 	update_prog_stats(prog, start);
-	__this_cpu_dec(*(prog->active));
+	this_cpu_dec(*(prog->active));
 	migrate_enable();
 	rcu_read_unlock_trace();
 }
-- 
2.35.1



