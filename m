Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B72A603CEF
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbiJSIzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbiJSIxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:53:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3EB8B2C0;
        Wed, 19 Oct 2022 01:50:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD9256184A;
        Wed, 19 Oct 2022 08:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4025C433C1;
        Wed, 19 Oct 2022 08:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169376;
        bh=1AhSyl1Iu0oUeGTRso51nL9PiaJJ07eaewJREfqxWs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SkohTm/1HCANiblnMzWGMr5VDWyIO4CQTvXnBTf+J2vQlP979t22ckEBej+7aM+K3
         jYodt14gO7a6VAx6XGN/tVQX5AnJ5RG/YqdXEHAgwmhLh9Xitwf8OHbSkt8PKhxR0N
         Jip2vtNyUI4bc2abMLHEpRMe++jCUBcChYL26vIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Luo <haoluo@google.com>,
        Hou Tao <houtao1@huawei.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 253/862] bpf: Disable preemption when increasing per-cpu map_locked
Date:   Wed, 19 Oct 2022 10:25:40 +0200
Message-Id: <20221019083301.226018887@linuxfoundation.org>
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

[ Upstream commit 2775da21628738ce073a3a6a806adcbaada0f091 ]

Per-cpu htab->map_locked is used to prohibit the concurrent accesses
from both NMI and non-NMI contexts. But since commit 74d862b682f5
("sched: Make migrate_disable/enable() independent of RT"),
migrate_disable() is also preemptible under CONFIG_PREEMPT case, so now
map_locked also disallows concurrent updates from normal contexts
(e.g. userspace processes) unexpectedly as shown below:

process A                      process B

htab_map_update_elem()
  htab_lock_bucket()
    migrate_disable()
    /* return 1 */
    __this_cpu_inc_return()
    /* preempted by B */

                               htab_map_update_elem()
                                 /* the same bucket as A */
                                 htab_lock_bucket()
                                   migrate_disable()
                                   /* return 2, so lock fails */
                                   __this_cpu_inc_return()
                                   return -EBUSY

A fix that seems feasible is using in_nmi() in htab_lock_bucket() and
only checking the value of map_locked for nmi context. But it will
re-introduce dead-lock on bucket lock if htab_lock_bucket() is re-entered
through non-tracing program (e.g. fentry program).

One cannot use preempt_disable() to fix this issue as htab_use_raw_lock
being false causes the bucket lock to be a spin lock which can sleep and
does not work with preempt_disable().

Therefore, use migrate_disable() when using the spinlock instead of
preempt_disable() and defer fixing concurrent updates to when the kernel
has its own BPF memory allocator.

Fixes: 74d862b682f5 ("sched: Make migrate_disable/enable() independent of RT")
Reviewed-by: Hao Luo <haoluo@google.com>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20220831042629.130006-2-houtao@huaweicloud.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 6c530a5e560a..ad09da139589 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -162,17 +162,25 @@ static inline int htab_lock_bucket(const struct bpf_htab *htab,
 				   unsigned long *pflags)
 {
 	unsigned long flags;
+	bool use_raw_lock;
 
 	hash = hash & HASHTAB_MAP_LOCK_MASK;
 
-	migrate_disable();
+	use_raw_lock = htab_use_raw_lock(htab);
+	if (use_raw_lock)
+		preempt_disable();
+	else
+		migrate_disable();
 	if (unlikely(__this_cpu_inc_return(*(htab->map_locked[hash])) != 1)) {
 		__this_cpu_dec(*(htab->map_locked[hash]));
-		migrate_enable();
+		if (use_raw_lock)
+			preempt_enable();
+		else
+			migrate_enable();
 		return -EBUSY;
 	}
 
-	if (htab_use_raw_lock(htab))
+	if (use_raw_lock)
 		raw_spin_lock_irqsave(&b->raw_lock, flags);
 	else
 		spin_lock_irqsave(&b->lock, flags);
@@ -185,13 +193,18 @@ static inline void htab_unlock_bucket(const struct bpf_htab *htab,
 				      struct bucket *b, u32 hash,
 				      unsigned long flags)
 {
+	bool use_raw_lock = htab_use_raw_lock(htab);
+
 	hash = hash & HASHTAB_MAP_LOCK_MASK;
-	if (htab_use_raw_lock(htab))
+	if (use_raw_lock)
 		raw_spin_unlock_irqrestore(&b->raw_lock, flags);
 	else
 		spin_unlock_irqrestore(&b->lock, flags);
 	__this_cpu_dec(*(htab->map_locked[hash]));
-	migrate_enable();
+	if (use_raw_lock)
+		preempt_enable();
+	else
+		migrate_enable();
 }
 
 static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node);
-- 
2.35.1



