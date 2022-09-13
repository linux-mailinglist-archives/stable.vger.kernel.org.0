Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2162F5B71ED
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbiIMOvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbiIMOu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:50:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA467269A;
        Tue, 13 Sep 2022 07:26:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4706B80F62;
        Tue, 13 Sep 2022 14:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA4AC433C1;
        Tue, 13 Sep 2022 14:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079048;
        bh=5/SJ4GartrR0F9VJhARBL3T5rj5VjqOPise/ix6nb2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXW7j2GTQFpGakFZyvSeP5844eSZoCGDPA9vF3PUvxrYivsOF0s4M7AE2ZYbHi1cQ
         ZVvnTtWc1371MbBwMiSLoghaiTZpsHMg85Nrq9mkj7SUSOoMJ6Pe/QDSPxklvTzdgp
         6v7JDE3xH7l4F9x90xiTXpkXZTnOIApHRLl+CmxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 63/79] IB/core: Fix a nested dead lock as part of ODP flow
Date:   Tue, 13 Sep 2022 16:05:08 +0200
Message-Id: <20220913140353.246916334@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 85eaeb5058f0f04dffb124c97c86b4f18db0b833 ]

Fix a nested dead lock as part of ODP flow by using mmput_async().

>From the below call trace [1] can see that calling mmput() once we have
the umem_odp->umem_mutex locked as required by
ib_umem_odp_map_dma_and_lock() might trigger in the same task the
exit_mmap()->__mmu_notifier_release()->mlx5_ib_invalidate_range() which
may dead lock when trying to lock the same mutex.

Moving to use mmput_async() will solve the problem as the above
exit_mmap() flow will be called in other task and will be executed once
the lock will be available.

[1]
[64843.077665] task:kworker/u133:2  state:D stack:    0 pid:80906 ppid:
2 flags:0x00004000
[64843.077672] Workqueue: mlx5_ib_page_fault mlx5_ib_eqe_pf_action [mlx5_ib]
[64843.077719] Call Trace:
[64843.077722]  <TASK>
[64843.077724]  __schedule+0x23d/0x590
[64843.077729]  schedule+0x4e/0xb0
[64843.077735]  schedule_preempt_disabled+0xe/0x10
[64843.077740]  __mutex_lock.constprop.0+0x263/0x490
[64843.077747]  __mutex_lock_slowpath+0x13/0x20
[64843.077752]  mutex_lock+0x34/0x40
[64843.077758]  mlx5_ib_invalidate_range+0x48/0x270 [mlx5_ib]
[64843.077808]  __mmu_notifier_release+0x1a4/0x200
[64843.077816]  exit_mmap+0x1bc/0x200
[64843.077822]  ? walk_page_range+0x9c/0x120
[64843.077828]  ? __cond_resched+0x1a/0x50
[64843.077833]  ? mutex_lock+0x13/0x40
[64843.077839]  ? uprobe_clear_state+0xac/0x120
[64843.077860]  mmput+0x5f/0x140
[64843.077867]  ib_umem_odp_map_dma_and_lock+0x21b/0x580 [ib_core]
[64843.077931]  pagefault_real_mr+0x9a/0x140 [mlx5_ib]
[64843.077962]  pagefault_mr+0xb4/0x550 [mlx5_ib]
[64843.077992]  pagefault_single_data_segment.constprop.0+0x2ac/0x560
[mlx5_ib]
[64843.078022]  mlx5_ib_eqe_pf_action+0x528/0x780 [mlx5_ib]
[64843.078051]  process_one_work+0x22b/0x3d0
[64843.078059]  worker_thread+0x53/0x410
[64843.078065]  ? process_one_work+0x3d0/0x3d0
[64843.078073]  kthread+0x12a/0x150
[64843.078079]  ? set_kthread_struct+0x50/0x50
[64843.078085]  ret_from_fork+0x22/0x30
[64843.078093]  </TASK>

Fixes: 36f30e486dce ("IB/core: Improve ODP to use hmm_range_fault()")
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://lore.kernel.org/r/74d93541ea533ef7daec6f126deb1072500aeb16.1661251841.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem_odp.c | 2 +-
 kernel/fork.c                      | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 323f6cf006824..af4af4789ef27 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -466,7 +466,7 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 		mutex_unlock(&umem_odp->umem_mutex);
 
 out_put_mm:
-	mmput(owning_mm);
+	mmput_async(owning_mm);
 out_put_task:
 	if (owning_process)
 		put_task_struct(owning_process);
diff --git a/kernel/fork.c b/kernel/fork.c
index a78c0b02edd55..b877480c901f0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1127,6 +1127,7 @@ void mmput_async(struct mm_struct *mm)
 		schedule_work(&mm->async_put_work);
 	}
 }
+EXPORT_SYMBOL_GPL(mmput_async);
 #endif
 
 /**
-- 
2.35.1



