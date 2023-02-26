Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712736A2E0D
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 05:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjBZEIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 23:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjBZEIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 23:08:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EBF6A57;
        Sat, 25 Feb 2023 20:08:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FF3CB80B8A;
        Sun, 26 Feb 2023 03:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2BFC433EF;
        Sun, 26 Feb 2023 03:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677383044;
        bh=nXU1mIcE80gCuXpTLG5b3uYjUUQu4yGjMNHvMqJDQyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGLVJjQjHJJRYqoX55ITpKdOqnF+zVdiSt8GSHaCwhO1eV4eyXZm6Shoze2WBzocW
         G4Z9LtZ9+GFNxwFwBh30sV9nYiWb7CgRXlVsnFwkzUr8BLuIOuaWF68m7Rn3ZkQXDj
         C8c+8eeZs9moAiJVyihSMDJ+P8z0g3xC7EJw5mMNEcdIrbTNa1/PR1BW1gzSDi/ztf
         akFw3V4mm/BB9fdP6n5fH/QubIfJT+jlerW21kMDpizmfmHrziLHGtPxjWKXmxEaqQ
         Y+JuXGi3tqjfmFfdiAquEc86U5KrwdW4NTXckjo59kbqUKO22KWq8Ecs/FUcM+K/D0
         6Fh7qfhm/5+xA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Nan <linan122@huawei.com>, Yu Kuai <yukuai3@huawei.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, josef@toxicpanda.com,
        cgroups@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 3/6] blk-iocost: fix divide by 0 error in calc_lcoefs()
Date:   Sat, 25 Feb 2023 22:43:55 -0500
Message-Id: <20230226034359.773806-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226034359.773806-1-sashal@kernel.org>
References: <20230226034359.773806-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Nan <linan122@huawei.com>

[ Upstream commit 984af1e66b4126cf145153661cc24c213e2ec231 ]

echo max of u64 to cost.model can cause divide by 0 error.

  # echo 8:0 rbps=18446744073709551615 > /sys/fs/cgroup/io.cost.model

  divide error: 0000 [#1] PREEMPT SMP
  RIP: 0010:calc_lcoefs+0x4c/0xc0
  Call Trace:
   <TASK>
   ioc_refresh_params+0x2b3/0x4f0
   ioc_cost_model_write+0x3cb/0x4c0
   ? _copy_from_iter+0x6d/0x6c0
   ? kernfs_fop_write_iter+0xfc/0x270
   cgroup_file_write+0xa0/0x200
   kernfs_fop_write_iter+0x17d/0x270
   vfs_write+0x414/0x620
   ksys_write+0x73/0x160
   __x64_sys_write+0x1e/0x30
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

calc_lcoefs() uses the input value of cost.model in DIV_ROUND_UP_ULL,
overflow would happen if bps plus IOC_PAGE_SIZE is greater than
ULLONG_MAX, it can cause divide by 0 error.

Fix the problem by setting basecost

Signed-off-by: Li Nan <linan122@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20230117070806.3857142-5-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 069193dee95b0..bd7e9ffa5d401 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -870,9 +870,14 @@ static void calc_lcoefs(u64 bps, u64 seqiops, u64 randiops,
 
 	*page = *seqio = *randio = 0;
 
-	if (bps)
-		*page = DIV64_U64_ROUND_UP(VTIME_PER_SEC,
-					   DIV_ROUND_UP_ULL(bps, IOC_PAGE_SIZE));
+	if (bps) {
+		u64 bps_pages = DIV_ROUND_UP_ULL(bps, IOC_PAGE_SIZE);
+
+		if (bps_pages)
+			*page = DIV64_U64_ROUND_UP(VTIME_PER_SEC, bps_pages);
+		else
+			*page = 1;
+	}
 
 	if (seqiops) {
 		v = DIV64_U64_ROUND_UP(VTIME_PER_SEC, seqiops);
-- 
2.39.0

