Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4726C5609
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjCVUCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbjCVUCN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:02:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C888F6BC3E;
        Wed, 22 Mar 2023 12:59:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40AA2B81DEA;
        Wed, 22 Mar 2023 19:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9D3C433D2;
        Wed, 22 Mar 2023 19:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515148;
        bh=PdH6MQEXvBfmrP3agymdK4PJRl1ncMElGlUI7c8Xrmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVUPhmhYnzg4b+CatTBfTcr6k/9SEbNo83Cc/joqoPRtm0b78g8D4+UqYMW12ZDk0
         wNQtO0SuasdOLh8VDPQ1Lo6lqbMwmcG5ryKcK+kyXunytqx5LoWk2265BKYL8it9V8
         ElPQFhSKxX3z7GbQGxV1/o+XphAEVDti37eA/EQeC6aooUsumnAqMapNaKg7Z3AlWy
         Z2K02gFacuH3jBdPR3Kd3s3ebrhr3hOV2mkhOdhGT5Tz/IsG3XSmXcCzCMTxhCWLZv
         uzk/N9W8MPbSbPeseo+73KY7vAxRp7JsNcodxIOh/6OnLPhPpBDF6W77DpO1em6rCG
         m1gc4VP6OrhVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Yury Norov <yury.norov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org
Subject: [PATCH AUTOSEL 6.2 34/45] sched_getaffinity: don't assume 'cpumask_size()' is fully initialized
Date:   Wed, 22 Mar 2023 15:56:28 -0400
Message-Id: <20230322195639.1995821-34-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 6015b1aca1a233379625385feb01dd014aca60b5 ]

The getaffinity() system call uses 'cpumask_size()' to decide how big
the CPU mask is - so far so good.  It is indeed the allocation size of a
cpumask.

But the code also assumes that the whole allocation is initialized
without actually doing so itself.  That's wrong, because we might have
fixed-size allocations (making copying and clearing more efficient), but
not all of it is then necessarily used if 'nr_cpu_ids' is smaller.

Having checked other users of 'cpumask_size()', they all seem to be ok,
either using it purely for the allocation size, or explicitly zeroing
the cpumask before using the size in bytes to copy it.

See for example the ublk_ctrl_get_queue_affinity() function that uses
the proper 'zalloc_cpumask_var()' to make sure that the whole mask is
cleared, whether the storage is on the stack or if it was an external
allocation.

Fix this by just zeroing the allocation before using it.  Do the same
for the compat version of sched_getaffinity(), which had the same logic.

Also, for consistency, make sched_getaffinity() use 'cpumask_bits()' to
access the bits.  For a cpumask_var_t, it ends up being a pointer to the
same data either way, but it's just a good idea to treat it like you
would a 'cpumask_t'.  The compat case already did that.

Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Link: https://lore.kernel.org/lkml/7d026744-6bd6-6827-0471-b5e8eae0be3f@arm.com/
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/compat.c     | 2 +-
 kernel/sched/core.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/compat.c b/kernel/compat.c
index 55551989d9da5..fb50f29d9b361 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -152,7 +152,7 @@ COMPAT_SYSCALL_DEFINE3(sched_getaffinity, compat_pid_t,  pid, unsigned int, len,
 	if (len & (sizeof(compat_ulong_t)-1))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
 
 	ret = sched_getaffinity(pid, mask);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2a4918a1faa9e..20a81077a3108 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8401,14 +8401,14 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 	if (len & (sizeof(unsigned long)-1))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
 
 	ret = sched_getaffinity(pid, mask);
 	if (ret == 0) {
 		unsigned int retlen = min(len, cpumask_size());
 
-		if (copy_to_user(user_mask_ptr, mask, retlen))
+		if (copy_to_user(user_mask_ptr, cpumask_bits(mask), retlen))
 			ret = -EFAULT;
 		else
 			ret = retlen;
-- 
2.39.2

